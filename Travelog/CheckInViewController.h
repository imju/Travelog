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

@property (nonatomic, assign) CLLocationCoordinate2D coordinate; //struct that contains double of Long/Lat
@property (nonatomic, strong) CLPlacemark *placemark; //address
@property (nonatomic, strong) Venue *venue;
@property (nonatomic, assign) CLLocation *location;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Travelog *travelogToEdit;


@end
