//
//  BMIResultsViewController.m
//  marsipan
//
//  Created by Simon Chapman on 16/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import "BMIResultsViewController.h"
#import "AppDelegate.h"
#import "UKAnthropometry.h"

@interface BMIResultsViewController ()

@end

@implementation BMIResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.bmiArrayLabels = [[NSArray alloc] initWithObjects:self.bmiResultLabel, self.bmiCentileResultLabel, self.bmiSDSResultLabel, self.pctMedianBMIResultLabel, self.weightFor9thBMIResultLabel, self.weightFor50thBMIResultLabel, self.weightFor91stBMIResultLabel, self.weightFor85pctResultLabel, self.weightFor90pctResultLabel, self.weightFor95pctResultLabel, nil];
    
    
    
    AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self AddResults:theDelegate.resultArray toLabelArray:self.bmiArrayLabels];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)AddResults:(NSArray*)results toLabelArray:(NSArray*)arrayOfLabels{
    
    AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
if (arrayOfLabels == self.bmiArrayLabels) {
  /*
   0 - BMISDS
   1 - BMICentile
   2 - pctBMI
   3 - wtFor9thCentileBMI
   4 - wtFor50thCentileBMI
   5 - wtFor91stCentileBMI
   6 - weightAt85
   7 - weightAt90
   8 - weightAt95
   
   9 - heightSDS
   10 - heightCentile
   11 - weightCentile
   12 - weightSDS

   */
    
    //set thresholds for bmi centile
    
    [self setText:[NSString stringWithFormat:@"%.f %%", [[theDelegate.resultArray objectAtIndex:1]doubleValue]] ToLabel: [arrayOfLabels objectAtIndex:1]] ;
    if ([[theDelegate.resultArray objectAtIndex:1]doubleValue]>99.6) {
        [self setText:@">99.6 %" ToLabel: [arrayOfLabels objectAtIndex:1]] ;
    }
    if ([[theDelegate.resultArray objectAtIndex:1]doubleValue]<0.04) {
        [self setText:@"<0.4 %" ToLabel: [arrayOfLabels objectAtIndex:1]] ;
    }
    
    //change the colour of the %mbmi label based on risk
    
    UIColor *myColour = [UIColor blackColor];
    
    if (([[theDelegate.resultArray objectAtIndex:2]doubleValue] <= 115) && ([[theDelegate.resultArray objectAtIndex:2]doubleValue] >= 85)) {
        myColour = [UIColor blueColor];
    }
    
    if (([[theDelegate.resultArray objectAtIndex:2]doubleValue] <= 85) && ([[theDelegate.resultArray objectAtIndex:2]doubleValue] >= 80)) {
        myColour = [UIColor greenColor];
    }
    if (([[theDelegate.resultArray objectAtIndex:2]doubleValue] < 80) && ([[theDelegate.resultArray objectAtIndex:2]doubleValue] >= 70)) {
        myColour = [UIColor orangeColor];
    }
    if (([[theDelegate.resultArray objectAtIndex:2]doubleValue] < 70)) {
        myColour = [UIColor redColor];
    }
    
    [[arrayOfLabels objectAtIndex:3] setColor:myColour];
    
    // populate the other labels
    
    [self setText:[NSString stringWithFormat:@"%.f kg/m\u00b2",  [theDelegate.bmi doubleValue]] ToLabel:(UILabel*)[arrayOfLabels objectAtIndex:0]];
    
    [self setText:[NSString stringWithFormat:@"%.2f", [[theDelegate.resultArray objectAtIndex:0]doubleValue]] ToLabel:[arrayOfLabels objectAtIndex:2]];
    
    [self setText:[NSString stringWithFormat:@"%.1f %%", [[theDelegate.resultArray objectAtIndex:2]doubleValue]] ToLabel:[arrayOfLabels objectAtIndex:3]];
    
    [self setText:[NSString stringWithFormat:@"%.1f kg", [[theDelegate.resultArray objectAtIndex:3]doubleValue]] ToLabel:[arrayOfLabels objectAtIndex:4]];
    [self setText:[NSString stringWithFormat:@"%.1f kg", [[theDelegate.resultArray objectAtIndex:4]doubleValue]] ToLabel:[arrayOfLabels objectAtIndex:5]];
    [self setText:[NSString stringWithFormat:@"%.1f kg", [[theDelegate.resultArray objectAtIndex:5]doubleValue]] ToLabel:[arrayOfLabels objectAtIndex:6]];
    [self setText:[NSString stringWithFormat:@"%.1f kg", [[theDelegate.resultArray objectAtIndex:6]doubleValue]] ToLabel:[arrayOfLabels objectAtIndex:7]];
    [self setText:[NSString stringWithFormat:@"%.1f kg", [[theDelegate.resultArray objectAtIndex:7]doubleValue]] ToLabel:[arrayOfLabels objectAtIndex:8]];
    [self setText:[NSString stringWithFormat:@"%.1f kg", [[theDelegate.resultArray objectAtIndex:8]doubleValue]] ToLabel:[arrayOfLabels objectAtIndex:9]];
}
    
}
-(UILabel*)setText:(NSString*)result ToLabel:(UILabel*)labelToChange{
    
    
    labelToChange.text = result;
    
    
    return labelToChange;
    
}

@end
