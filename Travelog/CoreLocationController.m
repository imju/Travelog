//
//  CoreLocationController.m
//  TravelLog
//
//  Created by Edo/Imju on 10/29/13.
//  Copyright (c) 2013 MyTravel. All rights reserved.
//

#import "CoreLocationController.h"
#import "CoreLocation/CoreLocation.h"

@interface CoreLocationController()

@property (weak, nonatomic)CLLocation          *prevLocation;


- (void)stopLocationManager;

@end


@implementation CoreLocationController

- (id)init {
    self = [super init];
	if(self != nil) {
		self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
		self.locationManager.delegate = self;
        self.isUpdating = NO;
	}
	return self;
}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    CLLocation *oldLocation;
    
    if (!self.isUpdating)
        return;

    if (locations.count > 1) {
        oldLocation = [locations objectAtIndex:locations.count-2];
    } else {
        oldLocation = nil;
    }

    //if the time the location is determined is gerater than 5secs
    double interval = [newLocation.timestamp timeIntervalSinceNow];
    if (interval < -5.0) {

        //then this is a cached object so dont run a new location fix
        return;
    }


    if (newLocation.horizontalAccuracy < 0) {
        return;
    }
    
    //Calculate the distance btw the new and old readings, if there is one then set to MAXFLOAT
    CLLocationDistance distance = MAXFLOAT;
    if (self.prevLocation != nil) {
        distance = [newLocation distanceFromLocation:self.prevLocation];
    }
    
    
    //determine if the new reading is more accurate than the old reading and check if we already have a location reading
    if ( self.prevLocation == nil || self.prevLocation.horizontalAccuracy >= newLocation.horizontalAccuracy) {
        
       //this clear out the old error state, if we recieve a valid coordinate and keep looking for accurate location
//        lastLocationError = nil;
        self.prevLocation = newLocation;
        [self.delegate update:newLocation];

        //if the new location is better than the old location then stop looking
        if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
            
            [self stopLocationManager];
        }
        
        if (distance < 1.0) //reading could be 0.00000176 so we do a less than 1.0 instead
        {
            NSTimeInterval timeInterval = [newLocation.timestamp timeIntervalSinceDate:self.prevLocation.timestamp];
            if (timeInterval > 10) {
                [self stopLocationManager];
            }
        }
    }
}


- (void)stopLocationManager
{
        
        //check to see if its a YES or NO
        //if NO then the location manager is not active, so dont stop it
        if (self.isUpdating) {
            [self.delegate fetchData];
            [self.locationManager stopUpdatingLocation];
            //self.locationManager.delegate = nil;
            self.isUpdating = NO;
        }
}


#pragma mark - CLLocationManagerDelegate

//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    if (status == kCLAuthorizationStatusAuthorized) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"kCLAuthorizationStatusAuthorized" object:self.locationManager.delegate];
//    }
//}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.delegate locationError:error];
}

@end