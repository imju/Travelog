//
//  TagPickerViewController.h
//  Travelog
//
//  Created by Edo/Imju on 10/28/13.
//  Copyright (c) 2013 Edo/Imju. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagPickerViewController;

//create delegate
@protocol TagPickerViewControllerDelegate <NSObject>

//this lets us know the category was picked
- (void)tagPicker:(TagPickerViewController *)picker didPickTag:(NSString *)TagName;

@end



@interface TagPickerViewController : UITableViewController

//methods to override
@property (nonatomic, weak) id <TagPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *selectedTagName; //used to select the tag when table loads

@end
