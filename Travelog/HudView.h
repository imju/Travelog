//
//  HudView.h
//  Travelog
//
//  Created by Edo williams on 10/28/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import <UIKit/UIKit.h>


//this inherits from UIVIew and used to create your own subview in this case we creating a HUD
//Heads up ddisplay
@interface HudView : UIView

//method signature using a "convenience" constructor
+ (HudView *)hudInView:(UIView *)View animated:(BOOL)animated;

@property (nonatomic, strong) NSString *text;

@end
