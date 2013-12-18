//
//  CurrentLocationMapVC.h
//  TravelLog
//
//  Created by Edo/Imju on 10/26/13.
//  Copyright (c) 2013 MyTravel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"



@interface CurrentLocationMapVC : UITableViewController<CoreLocationControllerDelegate, UITextFieldDelegate, MKMapViewDelegate>
//Core Data
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)updateLocationButton:(id)sender;

@end
