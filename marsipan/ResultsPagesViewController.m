//
//  ResultsPagesViewController.m
//  marsipan
//
//  Created by Simon Chapman on 16/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import "ResultsPagesViewController.h"
#import "PhoneResultsViewController.h"
#import "AppDelegate.h"
#import "UKAnthropometry.h"

@interface ResultsPagesViewController (){
    NSArray *resultsData;
}

@end

@implementation ResultsPagesViewController

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
            self.resultsArray = [[NSArray alloc]init];
    }
    return self;
}
 */

-(id)initWithResultsData:(NSArray *)data {
    if (self = [super init]) {
        resultsData = [[NSArray alloc]initWithArray:data];
        
        self.resultsArray = [[NSArray alloc]initWithArray:data];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([theDelegate.maleFemale isEqualToString:@"Male"]) {
        
        UIImage *maleImage = [UIImage imageNamed:@"measuremale.png"];
        self.tabBarItem.image = maleImage;
       
        
    }
    else if([theDelegate.maleFemale isEqualToString:@"Female"]){
        UIImage *femaleImage = [UIImage imageNamed:@"measurefemale.png"];
    //    self.tabBarItem.image = femaleImage;
        UITabBarItem *sexItem = [self.tabBarController.tabBar.items objectAtIndex:0];
        [sexItem setImage:femaleImage];
    }
    
    self.heightWeightAgeResultLabels = [[NSArray alloc]initWithObjects:self.sexResultLabel, self.calendarAgeResultLabel, self.decimalAgeResultLabel, self.heightResultLabel, self.heightCentileResultLabel, self.heightSDSResultLabel, self.weightResultLabel, self.weightCentileResultLabel, self.weightSDSResultLabel, self.IOTFResultLabel, nil];
    
        
    [self AddResults:theDelegate.resultArray toLabelArray:self.heightWeightAgeResultLabels];
    

    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel*)setText:(NSString*)result ToLabel:(UILabel*)labelToChange{
    
    
    labelToChange.text = result;
    
    
    return labelToChange;
    
}

-(void)AddResults:(NSArray*)results toLabelArray:(NSArray*)arrayOfLabels{
    
    AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UKAnthropometry *MathsMethods = [[UKAnthropometry alloc]init];
    
    /*
     NSDictionary *dictionaryOfResults = [[NSDictionary alloc]initWithObjectsAndKeys:SDS, @"BMISDS", centile, @"BMICentile", pctBMI, @"pctBMI",ninthCentile, @"WtFor9thCentileBMI", fiftiethCentile, @"WtFor50thCentileBMI", ninetyFirstCentile, @"WtFor91stCentileBMI", weightAt85, @"weightAt85", weightAt90, @"weightAt90", weightAt95, @"weightAt95", heightSDS, @"heightSDS", heightCentile, @"heightCentile", weightSDS, @"weightSDS", weightCentile, @"weightCentile", nil];
     
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
     
     // order of labels
     0 -self.sexResultLabel
     1 - self.calendarAgeResultLabel
     2 - self.decimalAgeResultLabel
     3 - self.heightResultLabel
     4 - self.heightCentileResultLabel
     5 - self.heightSDSResultLabel
     6 - self.weightResultLabel
     7 - self.weightCentileResultLabel
     8 - self.weightSDSResultLabel
     9 - self.IOTFResultLabel
    
     */
    
    [self setText:[NSString stringWithFormat:@"%.f %%", [[theDelegate.resultArray objectAtIndex:10]doubleValue]] ToLabel: [arrayOfLabels objectAtIndex:4]] ;
    
    [self setText:[NSString stringWithFormat:@"%.f %%", [[theDelegate.resultArray objectAtIndex:11]doubleValue]] ToLabel: [arrayOfLabels objectAtIndex:7]] ; //weight centile result label
    
    //if the centile values are out of range, state threshold:
    
    if ([[theDelegate.resultArray objectAtIndex:10]doubleValue]>99.6) {
        [self setText:@">99.6 %" ToLabel: [arrayOfLabels objectAtIndex:4]];
    }
    
    if ([[theDelegate.resultArray objectAtIndex:10]doubleValue]<0.04) {
        [self setText:@"<0.4 %" ToLabel: [arrayOfLabels objectAtIndex:4]];
    }
    
    if ([[theDelegate.resultArray objectAtIndex:11]doubleValue]>99.6) {
    [self setText:@">99.6 %" ToLabel: [arrayOfLabels objectAtIndex:7]] ;
    }
    
    if ([[theDelegate.resultArray objectAtIndex:11]doubleValue]<0.04) {
        [self setText:@"<0.4 %" ToLabel: [arrayOfLabels objectAtIndex:7]];
    }
    
    // fill out the rest of the labels
    
    [self setText:[NSString stringWithFormat:@"%@", theDelegate.maleFemale] ToLabel:[arrayOfLabels objectAtIndex:0]];

    [self setText:[NSString stringWithFormat:@"%@", theDelegate.resultCalendarAge] ToLabel:[arrayOfLabels objectAtIndex:1]];
        
    [self setText:[NSString stringWithFormat:@"%.1f y", [theDelegate.resultDecimalAge doubleValue]] ToLabel:[arrayOfLabels objectAtIndex:2]];
    
    
    [self setText:[NSString stringWithFormat:@"%.1f cm", [theDelegate.resultHeight doubleValue]] ToLabel:[arrayOfLabels objectAtIndex:3]];
    
    
    
    
    [self setText:[NSString stringWithFormat:@"%.2f", [[theDelegate.resultArray objectAtIndex:9]doubleValue]] ToLabel: [arrayOfLabels objectAtIndex:5]] ;
    [self setText:[NSString stringWithFormat:@"%.1f kg", [theDelegate.resultWeight doubleValue]] ToLabel: [arrayOfLabels objectAtIndex:6]] ;
    [self setText:[NSString stringWithFormat:@"%.2f", [[theDelegate.resultArray objectAtIndex:12]doubleValue]] ToLabel: [arrayOfLabels objectAtIndex:8]] ;
    
        
    [self setText: [[MathsMethods returnGradeOfThinnessOrObesityCuttOffFromReferenceDataUsingSex:theDelegate.maleFemale andAge:theDelegate.resultDecimalAge andBMI:theDelegate.bmi]objectAtIndex:0] ToLabel:[arrayOfLabels objectAtIndex:9]];
    
}

@end
