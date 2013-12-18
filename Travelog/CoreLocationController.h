//
//  CoreLocationController.h
//  TravelLog
//
//  Created by Edo/Imju on 10/29/13.
//  Copyright (c) 2013 MyTravel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@protocol CoreLocationControllerDelegate
@required
- (void)update:(CLLocation *)location;
- (void)locationError:(NSError *)error;
- (void)fetchData;
@end

@interface CoreLocationController : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic)BOOL                         isUpdating;
@property (nonatomic, retain) id delegate;

@end