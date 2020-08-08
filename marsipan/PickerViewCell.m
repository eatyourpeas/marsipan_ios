//
//  PickerViewCell.m
//  marsipan
//
//  Created by Simon Chapman on 09/02/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import "PickerViewCell.h"

@implementation PickerViewCell

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
