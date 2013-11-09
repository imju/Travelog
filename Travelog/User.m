//
//  User.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "User.h"
#import "FourSquareClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";
NSString * const kCurrentUserKey = @"access_token";

@implementation User

static User *_currentUser;

+ (User *)currentUser {
    if (!_currentUser) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if (![defaults objectForKey:kCurrentUserKey]) {
            _currentUser = [defaults objectForKey:kCurrentUserKey];
        }
    }
    
    return _currentUser;
}

//+ (void)setCurrentUser:(User *)currentUser {
//    if (currentUser) {
//        NSData *userData = [NSJSONSerialization dataWithJSONObject:currentUser.data options:NSJSONWritingPrettyPrinted error:nil];
//        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:kCurrentUserKey];
//    } else {
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUserKey];
//        [FourSquareClient instance].accessToken = nil;
//    }
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    if (!_currentUser && currentUser) {
//        _currentUser = currentUser; // Needs to be set before firing the notification
//        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
//    } else if (_currentUser && !currentUser) {
//        _currentUser = currentUser; // Needs to be set before firing the notification
//        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
//    }
//}

+ (void)setCurrentUser:(NSString *)authResponse{
    NSString *accessToken;
    if (authResponse) {
                accessToken = [[authResponse componentsSeparatedByString:@"="] lastObject];
                NSLog(@"accessToken:%@",accessToken);
                [[NSUserDefaults standardUserDefaults]  setObject:accessToken forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!_currentUser && authResponse) {
        _currentUser =(id)accessToken;
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
    } else if (_currentUser && !authResponse) {
        _currentUser = nil; // Needs to be set before firing the notification
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
    }
    
}



@end
