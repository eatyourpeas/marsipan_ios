//
//  PhoneDataTableViewController.h
//  marsipan
//
//  Created by Simon Chapman on 07/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultsPagesViewController.h"

@interface PhoneDataTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButtonItem;
//@property(assign) BOOL showDatePicker;
@property(strong,nonatomic) NSString *dobResultDateString;
@property(strong,nonatomic) NSString *clinicResultDateString;
@property(strong,nonatomic) NSDate *dobResultDate;
@property(strong,nonatomic) NSDate *clinicResultDate;
@property(strong,nonatomic) UIDatePicker *dobPicker;
@property(strong,nonatomic) UIDatePicker *clinicPicker;
@property(strong, nonatomic) NSString *sexInTheDelegate;

- (IBAction)datePickerValueChanged:(id)sender;
- (IBAction)sexChange:(id)sender;
- (IBAction)heightWeightEditingStarted:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)didEndEditing:(id)sender;




@end
