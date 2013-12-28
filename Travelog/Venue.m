//
//  Venue.m
//  TravelLog
//
//  Created by Edo/Imju on 10/29/13.
//  Copyright (c) 2013 MyTravel. All rights reserved.
//

#import "Venue.h"
#define METERS_PER_MILE 1609.344


@implementation Venue : RestObject



- (id)initWithPlaceName:(NSString *)pname
           address:(NSString *)paddress
          latitude:(NSNumber *)platitude
         longitude:(NSNumber *)plongitude
          distance:(NSNumber *)pdistance
         placemark:(CLPlacemark *)pplacemark
{
    if (self = [super init]) {
        self.name = pname;
        self.address = paddress;
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

+ (NSMutableArray *)venuesWithArray:(NSArray *)array
{
   NSMutableArray *venues = [[NSMutableArray alloc] init];
   NSString *city = @"";
   NSString *state = @"";
    int index =0;
    for (NSDictionary *params in array) {
        NSDictionary *venueDic = params;
        Venue *venue = [[Venue alloc] initWithDictionary:params];
        venue.venueId = [venueDic valueOrNilForKeyPath:@"id"];
        venue.name = [venueDic valueOrNilForKeyPath:@"name"];
        venue.url = [venueDic valueOrNilForKeyPath:@"url"];
        venue.description = [venueDic valueOrNilForKeyPath:@"description"];
        NSDictionary *location = (NSDictionary *)[venueDic valueOrNilForKeyPath:@"location"];
        venue.latitude = (NSNumber *)[location objectForKey:@"lat"];
        venue.longitude =(NSNumber *)[location objectForKey:@"lng"];
        venue.distance = [NSNumber numberWithDouble:[(NSNumber *)[location objectForKey:@"distance"] doubleValue]/METERS_PER_MILE];
        venue.address = @"";
        
        if ([location objectForKey:@"address"]){
            NSString *addr = [venue.address stringByAppendingString:[location objectForKey:@"address"]];
            NSLog(@"addr:%@",addr);
            venue.address = addr;
        }
        if ([location objectForKey:@"city"]){
            city = [location objectForKey:@"city"];
            if ([venue.address length]>0)
               venue.address = [NSString stringWithFormat:@"%@ %@", venue.address, [location objectForKey:@"city"]];
            else
               venue.address = [location objectForKey:@"city"];
        }
        if ([location objectForKey:@"state"]){
            state = [location objectForKey:@"state"];
            if ([venue.address length]>0)
               venue.address = [NSString stringWithFormat:@"%@ %@", venue.address, [location objectForKey:@"state"]];
            else
               venue.address = [location objectForKey:@"state"];
        }

//        if ([location objectForKey:@"country"]){
//            if ([venue.address length]>0)
//                venue.address = [NSString stringWithFormat:@"%@ %@", venue.address, [location objectForKey:@"country"]];
//            else // add cached city and state with country
//                venue.address = [NSString stringWithFormat:@"%@ %@ %@", city, state,[location objectForKey:@"country"]];
//        }

        venue.coordinate = CLLocationCoordinate2DMake([venue.latitude doubleValue], [venue.longitude doubleValue]);
        venue.index = [[NSNumber alloc ] initWithInt:++index];
 

        [venues addObject:venue];
    }
    return venues;
}


@end
