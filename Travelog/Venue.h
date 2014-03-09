//
//  Venue.h
//  TravelLog
//
//  Created by Edo/Imju on 10/29/13.
//  Copyright (c) 2013 MyTravel. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Venue : MTLModel <MTLJSONSerializing, MKAnnotation>


@property (nonatomic, readonly) NSString *id;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, readonly) NSString *url;
//@property (nonatomic, readonly) NSString *description;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) CLPlacemark *placemark; //address
@property (nonatomic, strong) NSString *addressDisplay;


- (id)initWithPlaceName:(NSString *)pname
                address:(NSString *)paddress
               latitude:(NSNumber *)platitude
              longitude:(NSNumber *)plongitude
               distance:(NSNumber *)pdistance
              placemark:(CLPlacemark *)pplacemark;

@end
