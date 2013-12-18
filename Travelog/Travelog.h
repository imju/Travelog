//
//  Travelog.h
//  Travelog
//
//  Created by Edo/Imju on 10/29/13.
//  Copyright (c) 2013 Edo/Imju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//MKAnnotation contains coordinate,title, subtitle
@interface Travelog : NSManagedObject <MKAnnotation>

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * travelogNotes;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) CLPlacemark * placemark;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * buinessName;
//@property (nonatomic, retain, readonly) NSArray  * tagSet;

//hasPhoto this is used to determine if location object has a photo assocated
//or not -1 (no) and any poistive number (yes)
- (BOOL)hasPhoto;

//returns the full path of the PNG file
- (NSString *)photoPath;
- (UIImage *)photoImage;
- (void)removePhotoFile;


@end
