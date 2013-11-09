//
//  Venue.h
//  TravelLog
//
//  Created by bgbb on 10/29/13.
//  Copyright (c) 2013 MyTravel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : RestObject <MKAnnotation>

@property (nonatomic, strong) NSString *venueId;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSNumber *index;

+ (NSMutableArray *)venuesWithArray:(NSArray *)array;


@end
