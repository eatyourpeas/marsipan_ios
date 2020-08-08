//
//  PickerViewCell.h
//  marsipan
//
//  Created by Simon Chapman on 09/02/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIDatePicker *dobPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *clinicPicker;

@end
