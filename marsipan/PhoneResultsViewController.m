//
//  PhoneResultsViewController.m
//  marsipan
//
//  Created by Simon Chapman on 16/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import "PhoneResultsViewController.h"
#import "UKAnthropometry.h"
#import "AppDelegate.h"

@interface PhoneResultsViewController ()
    

@end

@implementation PhoneResultsViewController

{
    NSNumber *decimalAge;
    NSNumber *bmi;
    NSString *calendarAge;
    NSNumber *heightCentile, *heightSDS;
    NSNumber *weightCentile, *weightSDS;
    NSNumber *bmiCentile, *BMISDS;
    
    NSString *maleFemale;
    
}



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
    
 //   self.navigationItem.hidesBackButton = YES; // Important
//	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(myCustomBack)];
                                             
  // self.navigationController.navigationBar.topItem.title = @"";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) myCustomBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
