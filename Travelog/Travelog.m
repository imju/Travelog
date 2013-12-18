//
//  Travelog.m
//  Travelog
//
//  Created by Edo/Imju on 10/29/13.
//  Copyright (c) 2013 Edo/Imju. All rights reserved.
//

#import "Travelog.h"


@implementation Travelog

@dynamic latitude;
@dynamic longitude;
@dynamic travelogNotes;
@dynamic tag;
@dynamic date;
@dynamic placemark;
@dynamic photoId;
@dynamic url;
@dynamic phone;
@dynamic buinessName;
//@dynamic tagSet;

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}


//set the MKAnnotations properties
- (NSString *)title
{
    if ([self.travelogNotes length] > 0) {
        return self.travelogNotes;
    }
    
    else{
        return @"(No TravelNotes)";
    }
}

- (NSString *)subtitle
{
    return self.tag;
}




//Photos

//puts it into the documents  directory of the phone
- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

//-1 for no photo and tve for yes photo
- (BOOL)hasPhoto
{
    return (self.photoId != nil) && ([self.photoId intValue] != -1);
}

//return the full path of file wile appending a number to it
- (NSString *)photoPath
{
    NSString *filename = [NSString stringWithFormat:@"Photo-%d.png", [self.photoId intValue]];
    return [[self documentsDirectory] stringByAppendingPathComponent:filename];
}

//returns a UI iamge by loading the image file from the app's deocument directory
- (UIImage *)photoImage
{
    NSAssert(self.photoId != nil, @"No photo ID set");
    NSAssert([self.photoId intValue] != -1, @"Photo ID is -1");
    
    return [UIImage imageWithContentsOfFile:[self photoPath]];
}

- (void)removePhotoFile
{
    NSString *path = [self photoPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error;
        
        if (![fileManager removeItemAtPath:path error:&error]) {
            NSLog(@"Error Remiving file : %@", error);
        }
    }
}



@end
