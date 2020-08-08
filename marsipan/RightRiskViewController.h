//
//  RightRiskViewController.h
//  marsipan
//
//  Created by Simon Chapman on 05/04/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Risk.h"
#import "RiskSelectionDelegate.h"
#import "ColourSelectionDelegate.h"

@interface RightRiskViewController : UIViewController <RiskSelectionDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UISplitViewControllerDelegate>

@property(nonatomic,assign) id<ColourSelectionDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *riskScrollView;
@property (strong, nonatomic) IBOutlet UIWebView *riskWebView;
@property (strong, nonatomic) Risk *risk;
@property (strong, nonatomic) IBOutlet UIPickerView *riskColourPicker;

@property(strong,nonatomic) NSNumber *storedCategory;

@property (nonatomic, weak) IBOutlet UINavigationItem *navBarItem;
@property (nonatomic, strong) UIPopoverController *popover;

@end
