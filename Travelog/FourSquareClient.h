//
//  FourSquareClient.h
//  TravelLog
//
//  Created by Edo/Imju on 10/21/13.
//  Copyright (c) 2013 MyTravel. All rights reserved.
//

#import "AFNetworking.h"

@interface FourSquareClient :AFHTTPClient

+ (FourSquareClient *)instance;

// venue/search API

- (void)venueSearchWithLatitude:(float)latitude
                      longitude:(float)longitude
                        success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
