//
//  UIImage+Resize.h
//  Travelog
//
//  Created by Edo williams on 10/30/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)resizedImageWithBounds:(CGSize)bounds;

- (UIImage *)crop:(CGRect)rect;

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
