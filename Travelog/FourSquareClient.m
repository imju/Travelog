//
//  FourSquareClient.m
//  TravelLog
//
//  Created by Edo/Imju on 10/21/13.
//  Copyright (c) 2013 MyTravel. All rights reserved.
//

#import "FourSquareClient.h"
#import "AFNetworking.h"

#define FOURSQUARE_BASE_URL [NSURL URLWithString:@"https://api.foursquare.com/v2/"]
#define FOURSQUARE_CLIENT_ID @"PL5T1UVUSEHIOS1FSSQBYNIKGUHGIS3ENOJWT1PA2VP0IRDJ"
#define FOURSQUARE_CLIENT_SECRET @"IEZZ0VS1JPPXMXIJCJ3YY4N4HV00HHGRIIZOVKKZQ1FAXW4Q"

static NSString * const kAccessTokenKey = @"access_token";


@implementation FourSquareClient

+ (FourSquareClient *)instance {
    static dispatch_once_t once;
    static FourSquareClient *instance;
    
    dispatch_once(&once, ^{
        instance = [[FourSquareClient alloc] initWithBaseURL:FOURSQUARE_BASE_URL];
    });
    
    return instance;
}

- (id)initWithBaseURL:(NSURL *)url{

    self = [super initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", url]]];
    
      if (self != nil) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
      }
    return self;
}



#pragma mark - FourSqaure API

// venue/search API

- (void)venueSearchWithLatitude:(float)latitude
                        longitude:(float)longitude
                         success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (latitude!= 0.0 || longitude!=0.0){
        self.parameterEncoding = AFJSONParameterEncoding;

        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"ll":[NSString stringWithFormat:@"%f,%f",latitude,longitude] } ];
        [params setObject:@(5) forKey:@"limit"];
        [params setObject:@"20131030" forKey:@"v"];

        [params setObject:FOURSQUARE_CLIENT_ID forKey:@"client_id"];
        [params setObject:FOURSQUARE_CLIENT_SECRET forKey:@"client_secret"];
        
        [self getPath:@"venues/search" parameters:params success:success failure:failure];
    }
}



@end
