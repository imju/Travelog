//
//  User.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : NSObject  

+ (User *)currentUser;
//+ (void)setCurrentUser:(User *)currentUser;
+ (void)setCurrentUser:(NSString *)authResponse;

@end
