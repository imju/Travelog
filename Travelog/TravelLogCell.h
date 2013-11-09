//
//  TagsCell.h
//  Travelog
//
//  Created by Edo williams on 10/29/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelLogCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *travelLogNotes;
@property (nonatomic, strong) IBOutlet UILabel *addresslabel;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIView* feedContainer;
@property (strong, nonatomic) IBOutlet UIImageView *tagImageView;


@end
