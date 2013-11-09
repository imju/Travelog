//
//  TagsCell.m
//  Travelog
//
//  Created by Edo williams on 10/29/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import "TravelLogCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TravelLogCell

@synthesize travelLogNotes, addresslabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
