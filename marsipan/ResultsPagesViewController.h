//
//  ResultsPagesViewController.h
//  marsipan
//
//  Created by Simon Chapman on 16/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsPagesViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *sexResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *calendarAgeResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *decimalAgeResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *heightResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *heightCentileResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *heightSDSResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightCentileResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightSDSResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *IOTFResultLabel;

@property(strong,nonatomic) IBOutletCollection(UILabel) NSArray *heightWeightAgeResultLabels;


@property(strong, nonatomic) NSArray *resultsArray;

-(id) initWithResultsData:(NSArray*)data;

@end
