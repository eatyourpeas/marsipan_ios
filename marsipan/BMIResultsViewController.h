//
//  BMIResultsViewController.h
//  marsipan
//
//  Created by Simon Chapman on 16/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMIResultsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *bmiResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *bmiCentileResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *bmiSDSResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *IOTFResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightFor50thBMIResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *pctMedianBMIResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightFor9thBMIResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightFor91stBMIResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightFor85pctResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightFor90pctResultLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightFor95pctResultLabel;

@property(strong,nonatomic) IBOutletCollection(UILabel) NSArray *bmiArrayLabels;


@end
