//
//  HudView.m
//  Travelog
//
//  Created by Edo williams on 10/28/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import "HudView.h"

@implementation HudView

- (void)showAnimated:(BOOL)animated
{
    if (animated) {
        //set the intial state before animation begins
        self.alpha = 0.0f;
        self.transform = CGAffineTransformMakeScale(1.3f, 1.3f); //scale by a factor of 1.3
        
        [UIView animateWithDuration:0.4
                         animations:^{
                             //set the alpha fully opaque
                             self.alpha = 1.0f;
                             self.transform = CGAffineTransformIdentity; //scale back to normal when done
                         }
                         completion:^(BOOL finished) {
                             [self.superview setUserInteractionEnabled:YES];
                             [self removeFromSuperview];
                         }];
        
        
        //set time of how animation will take
        [UIView beginAnimations:nil context:NULL];
        
        [UIView commitAnimations];
    }else {
        [self.superview setUserInteractionEnabled:YES];
        [self removeFromSuperview];
    }}

+ (HudView *)hudInView:(UIView *)view animated:(BOOL)animated
{
    HudView *hudView = [[HudView alloc] initWithFrame:view.bounds];
    hudView.opaque = NO;
    
    //here we add the subview which is the HudView on the tableview controller to cover the entire screen
    [view addSubview:hudView];
    view.userInteractionEnabled = NO;
    
    //hudView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    
    //Animation
    [hudView showAnimated:animated];
    
    return hudView;
}

- (void)drawRect:(CGRect)rect
{
    const CGFloat boxWidth = 150.0f;
    const CGFloat boxHeight = 150.0f;
    
    //fill in the rectangle with rounded corners in the center of screen
    //self.bounds.size is teh size of the hudView
    CGRect boxRect = CGRectMake(roundf(self.bounds.size.width - boxHeight) / 2.0f,
                                roundf(self.bounds.size.height - boxHeight) / 2.0f,
                                boxWidth, boxHeight);
    
    //UIBexierpath tells hosw large the rectangle is and how round the corners should be
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:boxRect cornerRadius:5.0f];
    
    //[[UIColor colorWithWhite:0.5f alpha:0.4] setFill];
    [[UIColor colorWithRed:231.0f/255.0f green:0.0f/255.0f blue:141.0f/255.0f alpha:1.0f] setFill];
    [roundedRect fill];
    
    
    
    //load the image and then calculate the position for the image based on the
    //cordinates of the HudView (self.center)
    UIImage *image = [UIImage imageNamed:@"CheckInImage"];
    
    CGPoint imagePoint = CGPointMake(self.center.x - roundf(image.size.width / 2.0f),
                                     self.center.y - roundf(image.size.height / 2.0f) - boxHeight / 8.0f);
    [image drawAtPoint:imagePoint];

    //Now add the label text to teh HudView
    [[UIColor whiteColor] set];
    
    //UIFont *font = [UIFont boldSystemFontOfSize:16.0f];
    CGSize textsize = [self.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
    
    NSDictionary * attributes = @{
                                  NSFontAttributeName : [UIFont fontWithName:@"Helvetica-bold" size:16],
                                  NSForegroundColorAttributeName : [UIColor whiteColor]
                                  };
    
    CGPoint textPoint = CGPointMake(self.center.x - roundf(textsize.width / 2.0f),
                                    self.center.y - roundf(textsize.height / 2.0f) + boxHeight / 4.0f);

    [self.text drawAtPoint:textPoint withAttributes:attributes];
}


@end
