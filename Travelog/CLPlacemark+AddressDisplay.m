//
//  CLPlacemark+AddressDisplay.m
//  Travelog
//
//  Created by Edo/Imju on 11/30/13.
//  Copyright (c) 2013 Edo Imju. All rights reserved.
//

#import "CLPlacemark+AddressDisplay.h"

@implementation CLPlacemark (AddressDisplay)

- (NSString *)addressDisplay{

        //subThoroughfare - house number
        //thoroughfare - street name
        //locality - city
        //administrativeArea - state/province

    NSString *address = @"";
    
    if (self.subThoroughfare){
        NSString *addr = [address stringByAppendingString:self.subThoroughfare];
        NSLog(@"addr:%@",addr);
        address = addr;
    }
    if (self.thoroughfare){
        if ([address length]>0)
            address = [NSString stringWithFormat:@"%@ %@", address, self.thoroughfare];
        else
            address = self.thoroughfare;
    }
    if (self.locality){
        if ([address length]>0)
            address = [NSString stringWithFormat:@"%@ %@", address, self.locality];
        else
            address = self.locality;
    }
    if (self.administrativeArea){
        if ([address length]>0)
            address = [NSString stringWithFormat:@"%@ %@", address, self.administrativeArea];
        else
            address = self.administrativeArea;
    }
//    if (self.country){
//        if ([address length]>0)
//            address = [NSString stringWithFormat:@"%@ %@", address, self.country];
//        else
//            address = self.country;
//    }
    return address;
}

@end
