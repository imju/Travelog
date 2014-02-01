//
//  Venue.m
//  TravelLog
//
//  Created by Edo/Imju on 10/29/13.
//  Copyright (c) 2013 MyTravel. All rights reserved.
//

#import "Venue.h"


@implementation Venue

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id":@"id",
             @"name":@"name",
             @"distance":@"location.distance",
             @"latitude":@"location.lat",
             @"longitude":@"location.lng",
             @"address":@"location.address",
             @"city":@"location.city",
             @"state":@"location.state"
             };
}


- (id)initWithPlaceName:(NSString *)pname
           address:(NSString *)paddress
          latitude:(NSNumber *)platitude
         longitude:(NSNumber *)plongitude
          distance:(NSNumber *)pdistance
         placemark:(CLPlacemark *)pplacemark
{
    if (self = [super init]) {
        self.name = pname;
        self.addressDisplay = paddress;
        self.latitude = platitude;
        self.longitude = plongitude;
        self.distance = pdistance;
        self.coordinate = CLLocationCoordinate2DMake([platitude doubleValue], [plongitude doubleValue]);
        self.placemark = pplacemark;
    }
  
    return self;
}

- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle {
    return self.address;
}

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);

}

- (NSString *)addressDisplay{
    
    //subThoroughfare - house number
    //thoroughfare - street name
    //locality - city
    //administrativeArea - state/province
    
    NSString *addressTemp = @"";
    
    if (self.address){
        addressTemp = [addressTemp stringByAppendingString:self.address];
    }
    if (self.city){
        if ([addressTemp length]>0)
        addressTemp = [NSString stringWithFormat:@"%@ %@", addressTemp, self.city];
        else
        addressTemp = self.city;
    }
    if (self.state){
        if ([addressTemp length]>0)
        addressTemp = [NSString stringWithFormat:@"%@ %@", addressTemp, self.state];
        else
        addressTemp = self.state;
    }
    return addressTemp;
}


@end
