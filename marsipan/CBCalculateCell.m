//
//  CBCalculateCell.m
//  marsipan
//
//  Created by Conrad Bosman on 22/02/2015.
//  Copyright (c) 2015 eatyourpeas. All rights reserved.
//

#import "CBCalculateCell.h"

@implementation CBCalculateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // these cells do not show any selection colour
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // white background
        self.backgroundColor = [UIColor whiteColor];
        
        // setup button
        self.calculateButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.calculateButton.frame = CGRectMake(119.0f, 7.0f, 83.0f, 30.0f);
        
        [self.calculateButton setTitle:NSLocalizedString(@"Calculate", @"Calculates the result")
                              forState:UIControlStateNormal];
        
        self.calculateButton.enabled = FALSE; // default state
        
        [self.contentView addSubview:self.calculateButton];
        
        // clear button
        self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.clearButton.frame = CGRectMake(240.0f, 7.0f, 83.0f, 30.0f);
        
        [self.clearButton setTitle:NSLocalizedString(@"Clear", @"Clear the values")
                          forState:UIControlStateNormal];
        
        self.clearButton.enabled = FALSE; // default state
        
        [self.contentView addSubview:self.clearButton];
        
        
        // setup info button
        self.infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        self.infoButton.frame = CGRectMake(20.0f, 11.0f, 22.0f, 22.0f);
        
        [self.contentView addSubview:self.infoButton];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
