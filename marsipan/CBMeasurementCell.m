//
//  CBMeasurementCell.m
//  marsipan
//
//  Created by Conrad Bosman on 22/02/2015.
//  Copyright (c) 2015 eatyourpeas. All rights reserved.
//

#import "CBMeasurementCell.h"

@implementation CBMeasurementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // these cells do not show selection colour
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // white background
        self.backgroundColor = [UIColor whiteColor];
        
        // setup TextField
        self.measurementTextField = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 146.0f, 30.0f)];
        self.measurementTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.measurementTextField.clearButtonMode = UITextFieldViewModeNever;
        self.measurementTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.measurementTextField.keyboardType = UIKeyboardTypeDecimalPad;
        self.measurementTextField.adjustsFontSizeToFitWidth = YES;
        self.measurementTextField.userInteractionEnabled = YES;
        
        self.accessoryView = self.measurementTextField;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
