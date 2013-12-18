//
//  TagsViewController.m
//  Travelog
//
//  Created by Edo/Imju on 10/29/13.
//  Copyright (c) 2013 Edo/Imju. All rights reserved.
//

#import "TravelLogsViewController.h"
#import "Travelog.h"
#import "TravelLogCell.h"
#import "CheckInViewController.h"
#import "UIImage+Resize.h"

@interface TravelLogsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) NSFetchedResultsController *allFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *funFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *foodFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *peopleFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *placesFetchedResultsController;

@end


@implementation TravelLogsViewController {
     NSFetchedResultsController *fetchedResultsController;
    //NSArray *travelogs;
    NSDate *date;
}

@synthesize managedObjectContext;


- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setSegmentedControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)dealloc
{
    fetchedResultsController.delegate = nil;
    _allFetchedResultsController.delegate = nil;
    _funFetchedResultsController.delegate = nil;
    _foodFetchedResultsController.delegate = nil;
    _peopleFetchedResultsController.delegate = nil;
    _placesFetchedResultsController.delegate = nil;
}



//this is used to get the data from CoreData
- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController == nil) {
        
        
        //asked the managed object for a list of all the object context of travelog sorted by date
        //what are we fetching
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        //describe the fecth parameters
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Travelog" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
         //sort the request by date in ascending order and group the date by tags
        NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];
        
        
        //get only 20 at a time
        [fetchRequest setFetchBatchSize:20];
        
        fetchedResultsController = [[NSFetchedResultsController alloc]
                                    initWithFetchRequest:fetchRequest
                                    managedObjectContext:self.managedObjectContext
                                    sectionNameKeyPath:@"tag"
                                    cacheName:nil];
        
        fetchedResultsController.delegate = self;
    }
    
    return fetchedResultsController;
}


- (void)performFetch
{
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }

}


//filter by fun segment UI
- (NSFetchedResultsController *)allFetchedResultsController
{
    if (_allFetchedResultsController != nil) {
        return _allFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Travelog" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:@"tag"
                                                             cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    self.allFetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.allFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _allFetchedResultsController;
}




//filter by fun segment UI
- (NSFetchedResultsController *)funFetchedResultsController
{
    if (_funFetchedResultsController != nil) {
        return _funFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Travelog" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];
    
    //filter
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tag ==[c] %@ OR tag ==[c] %@ OR tag ==[c] %@)", @"Travel",@"Nature",@"Events"];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:@"tag"
                                                             cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    self.funFetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.funFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _funFetchedResultsController;
}

//filter by food segment UI
- (NSFetchedResultsController *)foodFetchedResultsController
{
    if (_foodFetchedResultsController != nil) {
        return _foodFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Travelog" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];
    
    //filter
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tag ==[c] %@ OR tag ==[c] %@)", @"Restaurant",@"Shopping"];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:@"tag"
                                                             cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    self.foodFetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.foodFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _foodFetchedResultsController;
}


//filter by people segment UI
- (NSFetchedResultsController *)peopleFetchedResultsController
{
    if (_peopleFetchedResultsController != nil) {
        return _peopleFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Travelog" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];
    
    //filter
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tag ==[c] %@ OR tag ==[c] %@)", @"People",@"Other"];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:@"tag"
                                                             cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    self.peopleFetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.peopleFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _peopleFetchedResultsController;
}



//filter by places segment UI
- (NSFetchedResultsController *)placesFetchedResultsController
{
    if (_placesFetchedResultsController != nil) {
        return _placesFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Travelog" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];
    
    //filter
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tag ==[c] %@ OR tag ==[c] %@)", @"House",@"Office"];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:@"tag"
                                                             cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    self.placesFetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.placesFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _placesFetchedResultsController;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //show the edit button on table
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //self.feedTableView.dataSource = self;
    
    self.feedTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.feedTableView.separatorColor = [UIColor clearColor];
    
    
    //performe insert and update to coredata usin teh delegates
    [self performFetch];
    
    
    /*
    //asked the managed object for a list of all the object context of travelog sorted by date
    
    //what are we fetching
    NSFetchRequest *fetchrequest = [[NSFetchRequest alloc] init];
    
    //describe the fecth parameters
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Travelog" inManagedObjectContext:self.managedObjectContext];
    
    [fetchrequest setEntity:entity];
    
    //sort the request by date in ascending order
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    
    [fetchrequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    //execute the query and store in array
    NSError *error;
    NSArray *foundObjects = [self.managedObjectContext executeFetchRequest:fetchrequest error:&error];
    
    if (foundObjects == nil) {
        NSLog(@"Error: %@", error);
        abort();
        return;
    }
    
    //now assign all contents to teh tags variable
    travelogs = foundObjects;
    
    */
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //fetchedResultsController = nil;
    
    //self.segmentedControl.selectedSegmentIndex = 0;
    //[self.tableView reloadData];
    //[self performFetch];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    fetchedResultsController = nil;
    
    _allFetchedResultsController = nil;
    _funFetchedResultsController = nil;
    _foodFetchedResultsController = nil;
    _peopleFetchedResultsController = nil;
    _placesFetchedResultsController = nil;
    self.segmentedControl.selectedSegmentIndex = 0;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Travelog" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:@"tag"
                                                             cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    
    
    
    /*
    
    if (self.segmentedControl.selectedSegmentIndex > 0) {
        fetchedResultsController = self.allFetchedResultsController;
    }
    
    
    [self performFetch];*/
    [self.tableView reloadData];
    
}


- (IBAction)valueChanged:(UISegmentedControl *)sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            fetchedResultsController = self.allFetchedResultsController;
            break;
        case 1:
            fetchedResultsController = self.funFetchedResultsController;
            break;
        case 2:
            fetchedResultsController = self.peopleFetchedResultsController;
            break;
        case 3:
            fetchedResultsController = self.placesFetchedResultsController;
            break;
        case 4:
            fetchedResultsController = self.foodFetchedResultsController;
            break;
        default:
            break;
            
    }
    [self.tableView reloadData];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //when a user taps in teh row, it fgures out which TravelLog Object
    //it belongs to and puts it into travelogToEdit property
    
    if ([segue.identifier isEqualToString:@"EditTravelog"]) {
        CheckInViewController *controller = segue.destinationViewController;
                
        controller.managedObjectContext = self.managedObjectContext;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        //Travelog *travelog = [travelogs objectAtIndex:indexPath.row];
        Travelog *travelog = [self.fetchedResultsController objectAtIndexPath:indexPath];
        controller.travelogToEdit = travelog;
    }
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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //TravelLogCell *travelogCell = (TravelLogCell *)cell;
    //Travelog *travelog = [travelogs objectAtIndex:indexPath.row];
    
    TravelLogCell *travelogCell = (TravelLogCell *)cell;
    Travelog *travelog = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //get the notes and pass to TravelCell
    if ([travelog.travelogNotes length] > 0) {
        travelogCell.travelLogNotes.text = travelog.travelogNotes;
    }
    else
    {
        travelogCell.travelLogNotes.text = @"(No Travel Notes)";
    }
    
    
    //get the address and pass to TravelCell
    if (travelog.placemark != nil) {
        //subThoroughfare - house number
        //thoroughfare - street name
        //locality - city
        //administrativeArea - state/province
        travelogCell.addresslabel.text = [NSString stringWithFormat:@"%@ %@, %@, %@",
                                          travelog.placemark.subThoroughfare,
                                          travelog.placemark.thoroughfare,
                                          travelog.placemark.locality,
                                          travelog.placemark.country];
    }
    else
    {
        travelogCell.addresslabel.text = @"(No Address)";
    }
    
    
    //tags Imags
    if ([travelog.tag  isEqual: @"Events"]) {
        travelogCell.tagImageView.image  = [UIImage imageNamed:@"events.png"];
    }
    else if ([travelog.tag  isEqual: @"House"])
    {
        travelogCell.tagImageView.image  = [UIImage imageNamed:@"house.png"];
    }
    
    else if ([travelog.tag  isEqual: @"Restaurant"])
    {
        travelogCell.tagImageView.image  = [UIImage imageNamed:@"restaurant.png"];
    }
    
    else if ([travelog.tag  isEqual: @"Travel"])
    {
        travelogCell.tagImageView.image  = [UIImage imageNamed:@"travel.png"];
    }
    
    else if ([travelog.tag  isEqual: @"Office"])
    {
        travelogCell.tagImageView.image  = [UIImage imageNamed:@"office.png"];
    }
    
    else if ([travelog.tag  isEqual: @"People"])
    {
        travelogCell.tagImageView.image  = [UIImage imageNamed:@"people.png"];
    }
    
    else if ([travelog.tag  isEqual: @"Nature"])
    {
        travelogCell.tagImageView.image  = [UIImage imageNamed:@"nature.png"];
    }
    
    else if ([travelog.tag  isEqual: @"Shopping"])
    {
        travelogCell.tagImageView.image  = [UIImage imageNamed:@"shopping.png"];
    }
    
    else
    {
        travelogCell.tagImageView.image  = [UIImage imageNamed:@"other.png"];
    }

    
    
    //date
    if (travelog.date != nil) {
        travelogCell.dateLabel.text = [self formatDate: travelog.date];
    }
    else
    {
        travelogCell.dateLabel.text = @"(No Date)";
    }
    
    //set teh image size here and load into teh travellog cell
    UIImage *image = nil;
    if ([travelog hasPhoto]) {
        image = [travelog photoImage];
        
        if (image != nil) {
            
            //travelogCell.imageView.frame = CGRectMake(2, 2, 10, 10);
            image = [UIImage imageWithImage:[travelog photoImage] scaledToSize:CGSizeMake(580, 500)];
            [travelogCell addSubview:travelogCell.imageView];
            [travelogCell sendSubviewToBack:travelogCell.imageView];
            travelogCell.contentMode = UIViewContentModeScaleAspectFill;
            //image   = [image resizedImageWithBounds:CGSizeMake(200, 300)];
        }
        
        travelogCell.imageView.image = image;
        
    }
    
    else
    {
        travelogCell.imageView.image  = [UIImage imageNamed:@"camera-select.png"];
        [travelogCell addSubview:travelogCell.imageView];
        [travelogCell sendSubviewToBack:travelogCell.imageView];
        travelogCell.contentMode = UIViewContentModeScaleAspectFill;
    }
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [travelogs count];
    
    //get the total number of results from NSFetch and return to the table
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Tag"];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

//this will delete the travelog object and propagate to the CoreData using teh delegates
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Travelog *travelog  = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        //remove the image file
        [travelog removePhotoFile];
        [self.managedObjectContext deleteObject:travelog];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error: %@", error);
            abort();
        }
        
    }
}

//this creates the sections needed for coredata
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo name];
}

//sizing of the Cell Column when table view loads
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 256;
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }

}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}




@end
