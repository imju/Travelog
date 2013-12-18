//
//  UIImage+Resize.m
//  Travelog
//
//  Created by Edo/Imju on 10/30/13.
//  Copyright (c) 2013 Edo/Imju. Apache licensed.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)resizedImageWithBounds:(CGSize)bounds
{
    //calculate how big teh image is
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    
    //then creat a new image context and draw the image into that
    CGFloat ratio = MIN(horizontalRatio, verticalRatio);
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    //CGSize newSize = CGSizeMake(66, 66);
    
    
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return newImage;
     
    
    
    /*
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;*/
    
}

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    /*UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(10,10,newSize.height,newSize.width)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     
    return newImage; */
    
    /*
    float lScale = newSize.width / image.size.width;
    CGImageRef cgImage = image.CGImage;
    UIImage   *lResult = [UIImage imageWithCGImage:cgImage scale:lScale
                                       orientation:UIImageOrientationLeft];
    return lResult;
     */
    
    
    
    
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(10, 10, width, height);
    /*
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    //indent in case of width or height difference
    float offset = (width - height) / 5;
    if (offset > 0) {
        rect.origin.y = offset;
    }
    else {
        rect.origin.x = -offset;
    }*/
    
    rect = CGRectMake((image.size.width-640)/2.0f, (image.size.height-320)/2.0f, 640, 320);
    
    [image drawInRect: rect];
    
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;

    
    
    
   
}


- (UIImage *)crop:(CGRect)rect {
    
    rect = CGRectMake(rect.origin.x*self.scale,
                      rect.origin.y*self.scale,
                      rect.size.width*self.scale,
                      rect.size.height*self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}



@end
