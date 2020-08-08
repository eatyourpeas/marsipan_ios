//
//  DateCell.m
//  marsipan
//
//  Created by Simon Chapman on 16/02/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import "DateCell.h"

@implementation DateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.iOS6DOBTextField = [[UITextField alloc]init];
        self.iOS6ClinicTextField = [[UITextField alloc]init];
  //      [self.iOS6DOBTextField setFrame:CGRectMake(200, 15, 200, 44) ];
 //       [self.window addSubview:self.iOS6DOBTextField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
