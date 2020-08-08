//
//  RiskToolDetailViewController.h
//  marsipan
//
//  Created by Simon Chapman on 12/02/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Risk.h"

@class RiskToolTableViewController;

@protocol RiskToolTableViewDelegate <NSObject>

-(void) addRiskColourToArray:(NSNumber*)riskColour forRiskCategory:(NSNumber*) category;


-(void) setTableViewCellBackgroundColourToRiskColour:(UIColor*)riskColour;



@end


@interface RiskToolDetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic,assign) id <RiskToolTableViewDelegate> delegate;

@property(strong,nonatomic) NSArray *riskColours;
@property(strong, nonatomic) NSArray *textArray;
@property(strong, nonatomic) NSArray *red;
@property(strong, nonatomic) NSArray *amber;
@property(strong, nonatomic) NSArray *green;
@property(strong, nonatomic) NSArray *blue;
@property (strong, nonatomic) IBOutlet UITextView *riskTextView;
@property (strong, nonatomic) IBOutlet UIWebView *riskTextWebView;
//@property (strong, nonatomic) NSMutableArray *selectedColoursArray;
@property(strong,nonatomic) NSDictionary *riskDictionary;
@property (strong, nonatomic) IBOutlet UIPickerView *riskColourPicker;
@property NSInteger rowSelected;
@property NSInteger colourRowSelected;

- (IBAction)didSelectRisk:(id)sender;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *calculatemBMIButton;
@end
