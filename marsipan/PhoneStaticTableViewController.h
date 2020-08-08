//
//  PhoneStaticTableViewController.h
//  marsipan
//
//  Created by Simon Chapman on 15/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneStaticTableViewController : UITableViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (strong, nonatomic) IBOutlet UILabel *clinicDateLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *dobPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *clinicPicker;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nowDoneButton;
@property (strong, nonatomic) IBOutlet UITextField *heightTextField;
@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sexChoiceSegmentedControl;
@property (strong, nonatomic) IBOutlet UIButton *calculateButton;

@property (strong, nonatomic) IBOutlet UIDatePicker *externalPicker;


-(IBAction)doneButtonPressed:(id)sender;
- (IBAction)sexChange:(id)sender;



@end
