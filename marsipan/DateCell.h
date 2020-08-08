//
//  DateCell.h
//  marsipan
//
//  Created by Simon Chapman on 16/02/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateCell : UITableViewCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *iOS6DOBTextField;
@property (strong, nonatomic) IBOutlet UITextField *iOS6ClinicTextField;
@end
