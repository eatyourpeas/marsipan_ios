//
//  CBSexChoiceCell.m
//  marsipan
//
//  Created by Conrad Bosman on 15/02/2015.
//  Copyright (c) 2015 eatyourpeas. All rights reserved.
//

#import "CBSexChoiceCell.h"

@implementation CBSexChoiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // these cells can show selection colour
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // white background
        self.backgroundColor = [UIColor whiteColor];
        
        // setup images
        UIImage *male = [UIImage imageNamed:@"individualmale.png"];
        UIImage *female = [UIImage imageNamed:@"individualfemale.png"];
        
        // setup SegmentedControl
        self.sexSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[male, female]];
     ///   self.sexSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        self.sexSegmentedControl.frame = CGRectMake(20.0f, 8.0f, 280.0f, 29.0f);
        [self.sexSegmentedControl setSelectedSegmentIndex:0];
        
        self.accessoryView = self.sexSegmentedControl;;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
