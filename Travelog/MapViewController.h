//
//  MapViewController.h
//  Travelog
//
//  Created by Edo williams on 10/29/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)IBOutlet MKMapView *mapView;


- (IBAction)WhereAmI;
- (IBAction)showTags;


@end
