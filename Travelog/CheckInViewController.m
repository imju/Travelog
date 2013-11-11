//
//  LocationDetailsViewController.m
//  Travelog
//
//  Created by Edo williams on 10/28/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import "CheckInViewController.h"
#import "HudView.h"
#import "Travelog.h" //Core Data
#import "UIImage+Resize.h"


@interface CheckInViewController ()
@property (strong, nonatomic)CLGeocoder * geocoder;

@end

//create Ivars
NSString *travelogNote;
UIActionSheet *actionSheet;
UIImagePickerController *imagePicker;


@implementation CheckInViewController {
    NSString *travelNote;
    NSString *tagName;
    NSDate *date;
    UIImage *image;
    NSString *title;
}


@synthesize managedObjectContext, travelogToEdit;

//set the initial value of travelogNote
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        travelNote = @"";
        tagName = @"Other";
        date = [NSDate date];
        
        //this dismisses the alert view when the app is put in teh background or closed
        //this instructs the app to stop listening to the notification
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(applicationDidEnterBackground)
         name:UIApplicationDidEnterBackgroundNotification
         object:nil];
    }
    
    return self;
}

//remove the notification observer
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
}

//beacause photos take a huge amount of memory, so we need to handle this
//by freeing up the memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    //free up all the labels and outlets
    if (![self isViewLoaded]) {
        self.travelnotesTextView = nil;
        self.tagsLabel = nil;
        self.addressLabel = nil;
        self.dateLabel = nil;
        self.imageView = nil;
        self.photoLabel = nil;
        self.geocoder = nil;
    }
}

//if there is an active image picker or action sheet, we dismiss it
- (void)applicationDidEnterBackground
{
    if (imagePicker != nil) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        imagePicker = nil;
    }
    
    if (actionSheet != nil) {
        [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:NO];
        actionSheet = nil;
    }
    
    [self.travelnotesTextView resignFirstResponder];
}


//used to format string
//by adding a regular string to a mutable string with an optional separator
- (void)addText:(NSString *)text toLine:(NSMutableString *)line withSeparator:(NSString *)separator
{
    if (text != Nil) {
        if ([line length] > 0) {
            [line appendString:separator];
        }
        
        [line appendString:text];
    }
}

- (NSString *)stringFromPlacemark:(CLPlacemark *)thePlacemark
{
    //subThoroughfare - house number
    //thoroughfare - street name
    //locality - city
    //administrativeArea - state/province
    
    return [NSString stringWithFormat:@"%@ %@, %@, %@ %@, %@",
            self.placemark.subThoroughfare, self.placemark.thoroughfare,
            self.placemark.locality, self.placemark.administrativeArea,
            self.placemark.postalCode, self.placemark.country];
    
    /*NSMutableString *line1 = [NSMutableString stringWithCapacity:100];
    [self addText:thePlacemark.subThoroughfare toLine:line1 withSeparator:@" "];
    [self addText:thePlacemark.thoroughfare toLine:line1 withSeparator:@" "];
    
    NSMutableString *line2 = [NSMutableString stringWithCapacity:100];
    [self addText:thePlacemark.locality toLine:line2 withSeparator:@" "];
    [self addText:thePlacemark.administrativeArea toLine:line2 withSeparator:@" "];
    [self addText:thePlacemark.postalCode toLine:line2 withSeparator:@" "];
    
    
    [line1 appendString:@"\n"];
    [line1 appendString:line2];
    
    return line1;*/

}

- (NSString *)formatDate:(NSDate *)theDate
{
    //lazy loading of NSFormatter to avoid battery drain as its expensive object to create
    static NSDateFormatter *formatter = nil;
    
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateStyle:NSDateFormatterMediumStyle];
        //[formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"hh:mm a MMM dd,yyyy"];
    }
    
    return [formatter stringFromDate:theDate];
}

//makes the image visible and gives proper dimensions
- (void)showImage:(UIImage *)Myimage
{
    self.imageView.image = Myimage;
    self.imageView.hidden = NO;
    self.imageView.frame = CGRectMake(10, 10, 250, 250);
    self.photoLabel.hidden = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //if travelogToEdit is not null, then we are editing teh travelog object
    //set the titile
    if (self.travelogToEdit != nil)
    {
        self.title = @"Edit Travel Notes";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(done:)];
        //if the travelog notes we are ediying has a photo
        if ([self.travelogToEdit hasPhoto] && image == nil) {
            //display the image in the photo cell
            UIImage *existingImage = [self.travelogToEdit photoImage];
            
            if (existingImage != nil) {
                [self showImage:existingImage];
            }
        }
        
    }
    
    
    //because we freed the memorey for the photo,
    //we need to check to see if the image ivar is not nil
    if (image != nil) {
        [self showImage:image];
    }
    
    
    self.travelnotesTextView.text = @"";
    self.tagsLabel.text = @"";
    
    self.travelnotesTextView.text = travelogNote;
    self.tagsLabel.text = tagName;
    self.titleTextField.text = title;
    
    
    //tag Images
    if ([tagName  isEqual: @"Events"]) {
        self.tagImageView.image  = [UIImage imageNamed:@"events.png"];
    }
    else if ([tagName  isEqual: @"House"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"house.png"];
    }
    
    else if ([tagName  isEqual: @"Restaurant"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"restaurant.png"];
    }
    
    else if ([tagName  isEqual: @"Travel"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"travel.png"];
    }
    
    else if ([tagName  isEqual: @"Office"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"office.png"];
    }
    
    else if ([tagName  isEqual: @"People"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"people.png"];
    }
    
    else if ([tagName  isEqual: @"Nature"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"nature.png"];
    }
    
    else if ([tagName  isEqual: @"Shopping"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"shopping.png"];
    }
    
    else
    {
        self.tagImageView.image  = [UIImage imageNamed:@"other.png"];
    }

    
    
    
    
    //get the long lat
    //[NSString stringWithFormat:@"%.8f", self.coordinate.latitude];
    //[NSString stringWithFormat:@"%.8f", self.coordinate.longitude];
    
    if (self.placemark)
    {
        self.addressLabel.text = [self stringFromPlacemark:self.placemark];
    }
    else if (self.location )
    {
        //using block instead of delegates: inform CLGeocoder that we want to reverse geocode the location
        //excecute the compleion Handler when the geocoding is complete
        //if not found set the message to the error handler
        if(!self.geocoder)
        {
            self.geocoder = [[CLGeocoder alloc] init];
        }
        [self.geocoder reverseGeocodeLocation:self.location
                            completionHandler:^(NSArray * placemarksArray, NSError *error)
         {
             NSLog(@"GeoCode Called: %@, error: %@", placemarksArray, error);
             
             if (error){
                 NSLog(@"Geocode failed with error: %@", error);
                 return;
                 
             }
             //reverse geocode found and set into placemark array object
             if (error == nil && [placemarksArray count] > 0) {
                 self.placemark = [placemarksArray lastObject];
                 NSLog(@"placemark address: %@", [self stringFromPlacemark:self.placemark]);
                 self.addressLabel.text = [self stringFromPlacemark:self.placemark];
             }
             //if there is an error
             else{
                 self.placemark = nil;
             }
             
         }];
        
        // for creation flow, we have venue object
        if (self.venue && self.venue.address ){
            self.addressLabel.text = self.venue.address;
            self.titleTextField.text = self.venue.name;
        }
        
    }else{
        self.addressLabel.text = @"No Address Found";
        self.titleTextField.text = @"Enter yout title";
    }
    
    //self.titleLabel
//    if (self.venue && self.venue.title){
//        self.titleField.text = self.venue.title;
//    }
    
    self.dateLabel.text = [self formatDate: date];
    
    
    //we are editing the page, remove all values
    if (self.travelogToEdit == nil) {
        self.travelnotesTextView.text = nil;
        
        //show keyboard when page first loads only when we adding a new checkin
        [_travelnotesTextView becomeFirstResponder];
    }
    
    
    //remove keyboard when textfied is not in focus
    UITapGestureRecognizer *gestureRecognizer =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
}



//we override the set property
- (void)setTravelogToEdit:(Travelog *)newtravelogToEdit
{
    //if edit values not empty
    if (travelogToEdit != newtravelogToEdit) {
        travelogToEdit = newtravelogToEdit;
        
        //set the values we want to edit
        travelogNote = travelogToEdit.travelogNotes;
        tagName = travelogToEdit.tag;
        
        //combine the long and lat to one coordinate
        self.coordinate = CLLocationCoordinate2DMake([travelogToEdit.latitude doubleValue], [travelogToEdit.longitude doubleValue]);
        
        self.placemark = travelogToEdit.placemark;
        date = travelogToEdit.date;
        title = travelogToEdit.buinessName;
    }
}

- (int)nextPhotoId
{
    //this generates unique ID for each treavelog object
    //ie photo-0, photo-1 and so forth
    //then saves it into the NSuserdefault data dircetory
    int photoId = [[NSUserDefaults standardUserDefaults] integerForKey:@"PhotoId"];
    [[NSUserDefaults standardUserDefaults] setInteger:photoId+1 forKey:@"PhotoId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return photoId;
}



- (IBAction)getDirections:(id)sender
{
    
    NSDictionary *address = @{
                              (NSString *)kABPersonAddressStreetKey: self.placemark.thoroughfare,
                              (NSString *)kABPersonAddressCityKey: self.placemark.locality,
                              (NSString *)kABPersonAddressStateKey: self.placemark.administrativeArea,
                              (NSString *)kABPersonAddressZIPKey: self.placemark.postalCode
                              };
    
    MKPlacemark *place = [[MKPlacemark alloc]
                          initWithCoordinate:self.coordinate
                          addressDictionary:address];
    
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:place];
    
    NSDictionary *options = @{
                              MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving
                              };
    
    [mapItem openInMapsWithLaunchOptions:options];
}


- (IBAction)done:(id)sender
{
    
    //NSLog(@"Notes '%@'", travelogNote);
    //[self closeScreen];
    
    
    HudView *hudView = [HudView hudInView:self.navigationController.view animated:YES];
    
    Travelog *travelog = nil;
    if (self.travelogToEdit != nil) {
        hudView.text = @"Updated";
        travelog = self.travelogToEdit;
    }
    else{
        hudView.text = @"Checked In!";
        travelog = [NSEntityDescription insertNewObjectForEntityForName:@"Travelog" inManagedObjectContext:self.managedObjectContext];
        
        //set the location of photo id to -1 to avoid an overite of the image file
        travelog.photoId = [NSNumber numberWithInt:-1];
    }
    
    //passs the data from view to Core Data
    travelog.travelogNotes = travelogNote;
    travelog.tag = tagName;
    travelog.latitude = [NSNumber numberWithDouble:self.coordinate.latitude];
    travelog.longitude = [NSNumber numberWithDouble:self.coordinate.longitude];
    travelog.date = date;
    travelog.placemark = self.placemark;
    travelog.buinessName = self.titleTextField.text;
    
    //Load photos if the image is not nil, when the user picks an image
    if (image != nil) {
        //get new ID and assign to travelog photid propertyy
        if (![travelog hasPhoto]) {
            travelog.photoId = [NSNumber numberWithInt:[self nextPhotoId]];
        }
        
        UIImage *imageToCrop = image;
        CGRect cropRect = CGRectMake(0,0,640, 480);
        
        UIImage *croppedImage = [imageToCrop crop:cropRect];
        
        //if the photo exsit we keep the same ID and ovverite the exsiting file
        //convert the file to PNG
        //NSData *data = UIImagePNGRepresentation(image);
        NSData *data = UIImagePNGRepresentation(croppedImage);
        NSError *error;
        if (![data writeToFile:[travelog photoPath] options:NSDataWritingAtomic error:&error]) {
            NSLog(@"Error writing file: %@", error);
        }
    }
    
    //save the travelog context to core date
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }
    
    /*
    //adding a head up display HUD
    HudView *hudView = [HudView hudInView:self.navigationController.view animated:YES];
    hudView.text = @"Checked In!";
    */
    
    
    //close the screen after animating for .6secs
    [self performSelector:@selector(closeScreen) withObject:nil afterDelay:0.6];
}

- (IBAction)cancel:(id)sender
{
    [self closeScreen];
}

//Actin that pop up the tags
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TagIt"]) {
        TagPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.selectedTagName = tagName;
        
        //NSLog(@"%@", tagName);
    }
}

- (void)hideKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //get where the tap happened ans sent to indexPath
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    if (indexPath != nil && indexPath.section == 0 && indexPath.row == 0)
    {
        return;
    }
    
    [self.travelnotesTextView resignFirstResponder];
}

- (void)closeScreen
{
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)takePhoto
{
    //this UIImagePickerController is a view controller delegate that control image taking and saving
    //UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

//allows to choose from camera roll
- (void)choosePhotoFromLibrary
{
    
    //UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showPhotoMenu
{
    //if (YES) {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //UIActionSheet *actionSheet = [[UIActionSheet alloc]
        actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Take Photo",
                                      @"Choose From Library", nil];
        
        [actionSheet showInView:self.view];
    }
    
    else
    {
        [self choosePhotoFromLibrary];
    }
}


#pragma mark - UITableViewDelegate

//sizing of the Cell Column when table view loads
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //set the top cell to 88 height + date 12 for travelog notes
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 130;
    }
    //the addresslabel cell expands based on the text
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        //get rectangle of x, y, width and height
        CGRect rect = CGRectMake(100, 10, 190, 1000);
        self.addressLabel.frame = rect; //if the inital rect is too high, we resize teh label
        [self.addressLabel sizeToFit];
        
        //this removes any spare space to teh right and bootom of the label
        rect.size.height = self.addressLabel.frame.size.height;
        self.addressLabel.frame = rect;
        
        //now that we know how high the label is, we add a margin of 10 points to top and 10 to bottom
        return self.addressLabel.frame.size.height + 20;
        
    }
    //this is teh section that has the photos
    else if (indexPath.section == 0 && indexPath.row == 4)
    {
        //if this section has no image, make it regular size of 44
        if (self.imageView.hidden) {
            return 44;
        }
        //esle make the cell bigger plus a 10point margin on top and below
        else{
            return 240;
        }
    }
    //the rest of the cells are set to 44 height
    else
    {
        return 44;
    }
}

//this limits taps on rows to just cells from the first sections of travel notes
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return indexPath;
    }
    else
    {
        return nil;
    }
}

//this triggers events when a row is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"section: %ld", (long)indexPath.section);
    //NSLog(@"row: %ld", (long)indexPath.row);
    
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [self.travelnotesTextView becomeFirstResponder];
    }
    else if (indexPath.section == 0 && indexPath.row == 4)//photo row
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES]; //this deselects the row Photo
        [self showPhotoMenu];
    }
}


//update the contents of TraveNotes Ivar
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    travelogNote = [textView.text stringByReplacingCharactersInRange:range withString:text];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    travelogNote = textView.text;
}


#pragma mark - TagPickerViewControllerDelegate

- (void)tagPicker:(TagPickerViewController *)picker didPickTag:(NSString *)TagName
{
    //get the name of choosen tag and put into the label
    tagName = TagName;
    self.tagsLabel.text = tagName;
    
    
    
    //Refracor code Very Inneficent
    //tag Images
    if ([tagName  isEqual: @"Events"]) {
        self.tagImageView.image  = [UIImage imageNamed:@"events.png"];
    }
    else if ([tagName  isEqual: @"House"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"house.png"];
    }
    
    else if ([tagName  isEqual: @"Restaurant"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"restaurant.png"];
    }
    
    else if ([tagName  isEqual: @"Travel"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"travel.png"];
    }
    
    else if ([tagName  isEqual: @"Office"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"office.png"];
    }
    
    else if ([tagName  isEqual: @"People"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"people.png"];
    }
    
    else if ([tagName  isEqual: @"Nature"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"nature.png"];
    }
    
    else if ([tagName  isEqual: @"Shopping"])
    {
        self.tagImageView.image  = [UIImage imageNamed:@"shopping.png"];
    }
    
    else
    {
        self.tagImageView.image  = [UIImage imageNamed:@"other.png"];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

//this gets called when a user has selected a photo in teh image picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //info dictionary contains a variety of data describing the image that the user picked
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //checking to see if the view is still there and update the screen if it is
    if ([self isViewLoaded]) {
        //showImage will put the imahe in the add photo Cell
        [self showImage:image];
        //this will refresh the tableview and set teh photo row to proper height
        [self.tableView reloadData];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    imagePicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
    imagePicker = nil;
}

#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{   //if it still has default title then clear
    if (textField == self.titleTextField){
        if ([textField.text isEqualToString:@"Enter title here"]){
            textField.text = nil;
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //button at the index 0 is take photo
    if (buttonIndex == 0) {
        [self takePhoto];
    }
    //button at index 1 is Choose from library
    else if (buttonIndex == 1)
    {
        [self choosePhotoFromLibrary];
    }
    
    actionSheet = nil;
}


#pragma mark - send message
- (IBAction)openMail:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        [picker setSubject:@"Hello from Travelog!"];
        
        // Fill out the email body text
        NSMutableString *emailBody =[NSMutableString stringWithString: @"My TravelsNotes!!\n\n"];
        
        NSString *travelnotes=[NSString stringWithFormat:@"\nNotes: %@",self.travelnotesTextView.text];
        NSString *tag=[NSString stringWithFormat:@"\n\nTag: %@",self.tagsLabel.text];
        NSString *address=[NSString stringWithFormat:@"\n\n%@",self.addressLabel.text];
        NSString *datemail=[NSString stringWithFormat:@"\n\n%@",self.dateLabel.text];
        NSString *dataString=[NSString stringWithFormat:@"%@%@%@%@",travelnotes,tag,address,datemail];
            [emailBody appendString:dataString];
        
        NSString *lastTable=@"\n";
        [emailBody appendString:lastTable];
        NSLog(@"%@",emailBody);
        [picker setMessageBody:emailBody isHTML:NO];
        
        [self presentViewController:picker animated:YES completion:NULL];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(IBAction)openText:(id)sender
{
    if ([MFMessageComposeViewController canSendText]) {
        
        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
        messageVC.messageComposeDelegate = self;
        
        NSMutableString *smsString =[NSMutableString stringWithString: @"My TravelsNotes!!\n\n"];
        NSString *travelnotes=[NSString stringWithFormat:@"Notes: %@",self.travelnotesTextView.text];
        NSString *address=[NSString stringWithFormat:@"\n\n%@",self.addressLabel.text];
        NSString *dataString=[NSString stringWithFormat:@"%@%@",travelnotes,address];
        [smsString appendString:dataString];
        
        NSString *lastTable=@"\n";
        [smsString appendString:lastTable];
        NSLog(@"%@",smsString);
        
        
        messageVC.body = smsString;
        [self presentViewController:messageVC animated:YES completion:nil];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
