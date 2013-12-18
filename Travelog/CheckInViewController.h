//
//  LocationDetailsViewController.h
//  Travelog
//
//  Created by Edo/Imju on 10/28/13.
//  Copyright (c) 2013 Edo/Imju. All rights reserved.
//

@class Travelog;

#import <UIKit/UIKit.h>
#import "TagPickerViewController.h"

@interface CheckInViewController : UITableViewController <UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, TagPickerViewControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>


@property (nonatomic, strong) IBOutlet UITextView *travelnotesTextView;
@property (nonatomic, strong) IBOutlet UILabel *tagsLabel;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *tagImageView;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

//for photo
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *photoLabel;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate; //struct that contains double of Long/Lat
@property (nonatomic, strong) CLPlacemark *placemark; //address
@property (nonatomic, strong) Venue *venue;
@property (nonatomic, assign) CLLocation *location;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Travelog *travelogToEdit;

@property (strong, nonatomic) IBOutlet UIButton *sendMailButton;
@property (strong, nonatomic) IBOutlet UIButton *sendTextButton;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)getDirections:(id)sender;
- (IBAction)openMail:(id)sender;
- (IBAction)openText:(id)sender;
- (IBAction)postFacebookStatus:(id)sender;
- (IBAction)twitMsg:(id)sender;


@end
