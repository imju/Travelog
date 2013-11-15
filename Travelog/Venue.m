//
//  Venue.m
//  TravelLog
//
//  Created by bgbb on 10/29/13.
//  Copyright (c) 2013 MyTravel. All rights reserved.
//

#import "Venue.h"
#define METERS_PER_MILE 1609.344


@implementation Venue : RestObject

@synthesize venueId,title,subtitle,address,latitude,longitude,distance,coordinate;


//- (NSString *)venueId {
//    if (self.venueId)
//        return self.venueId;
//    self.venueId = [self.data valueOrNilForKeyPath:@"id"];
//    return self.venueId;
//}

- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle {
    return self.address;
}

//-(void)setaddress(NSString *addressTxt) {
//    //
//}

//-(NSString *)address {
//    NSDictionary *location = (NSDictionary *)[self.data valueOrNilForKeyPath:@"location"];
//    NSString *addressdata = [location objectForKey:@"address"];
//    NSString *city = [location objectForKey:@"city"];
//    self.address = [NSString stringWithFormat:@"%@ %@", addressdata, city ];
//    return self.address;
//
//}

//-(NSNumber *)latitude {
//    //NSDictionary *location = (NSDictionary *)[self.data valueOrNilForKeyPath:@"location"];
//    //self.latitude = (NSNumber *)[location objectForKey:@"lat"];
//    return self.latitude;
//}
//
//-(NSNumber *)longitude {
//    //NSDictionary *location = (NSDictionary *)[self.data valueOrNilForKeyPath:@"location"];
//    //self.longitude = (NSNumber *)[location objectForKey:@"lng"];
//    return self.longitude;
//}

//- (CLLocationCoordinate2D)coordinate
//{
//    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
//}

//-(NSNumber *)distance {
//    NSDictionary *location = (NSDictionary *)[self.data valueOrNilForKeyPath:@"location"];
//    self.distance = [location objectForKey:@"distance"];
//    return self.distance;
//    
//}
//
//-(NSString *)url{
//    self.url = [self.data valueOrNilForKeyPath:@"url"];
//    return self.url;
//}

//-(NSString *)description{
//    self.description = [self.data valueOrNilForKeyPath:@"description"];
//    return self.description;
//}


+ (NSMutableArray *)venuesWithArray:(NSArray *)array
{
   NSMutableArray *venues = [[NSMutableArray alloc] init];
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
        
        if ([location objectForKey:@"address"]){
          venue.address = [NSString stringWithFormat:@"%@ %@", [location objectForKey:@"address"], [location objectForKey:@"city"]];
        }else{
          venue.address = [location objectForKey:@"city"];
        }
        venue.coordinate = CLLocationCoordinate2DMake([venue.latitude doubleValue], [venue.longitude doubleValue]);
        venue.index = [[NSNumber alloc ] initWithInt:++index];
 

        [venues addObject:venue];
    }
    return venues;
}


@end
