//
//  RiskToolDetailViewController.m
//  marsipan
//
//  Created by Simon Chapman on 12/02/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import "RiskToolDetailViewController.h"
#import "AppDelegate.h"
#import "PhoneDataTableViewController.h"
#import "StoredRisksSingleton.h"



@interface RiskToolDetailViewController ()

@end

@implementation RiskToolDetailViewController

#define StoredRisks (StoredRisksSingleton *)[StoredRisksSingleton getInstance]


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

    Risk *riskInstance = [[Risk alloc]init];
    
    self.riskColourPicker.delegate = self;
    
    self.textArray = riskInstance.textArray;
    
    self.riskDictionary = riskInstance.riskDictionary;
    
    self.riskColours = riskInstance.riskColours;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    

    
 //   int colourChosen = [[self.selectedColoursArray objectAtIndex:self.rowSelected]intValue];
    
    int colourChosen = [[StoredRisks returnChosenColourForCategory:[NSNumber numberWithInteger:self.rowSelected]]intValue];
    
    self.navigationItem.rightBarButtonItem = Nil;
 
 /*
       AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (self.rowSelected == 0) {
        self.navigationItem.rightBarButtonItem = self.calculatemBMIButton;
        
         //if bmi is chosen and risk has been selected, change the picker and risk selection
        
        if ([theDelegate.resultArray count] > 0) {
            if ([[theDelegate.resultArray objectAtIndex:2]doubleValue] < 70) {
                colourChosen = 0;
                [self.delegate addRiskColourToArray:[NSNumber numberWithInt:3]forRiskCategory:[NSNumber numberWithInteger:self.rowSelected]];
            }
            else if ([[theDelegate.resultArray objectAtIndex:2]doubleValue] < 80) {
                colourChosen = 1;
                [self.delegate addRiskColourToArray:[NSNumber numberWithInt:2]forRiskCategory:[NSNumber numberWithInteger:self.rowSelected]];
            }
            else if ([[theDelegate.resultArray objectAtIndex:2]doubleValue] <= 85) {
                colourChosen = 2;
                [self.delegate addRiskColourToArray:[NSNumber numberWithInt:1]forRiskCategory:[NSNumber numberWithInteger:self.rowSelected]];
            }
            
            else  {

                colourChosen = 3;
                [self.delegate addRiskColourToArray:[NSNumber numberWithInt:0]forRiskCategory:[NSNumber numberWithInteger:self.rowSelected]];
            }
            
        }
  
        
    }
  */
   
    NSString *riskText;
    NSArray *riskTextArray = [[NSArray alloc]init];
    
    NSString *cssStyle = @"<span style = \"background-color:transparent; font-family:HelveticaNeue-Light; font-size:14;\">";
    
    NSString *endText = @"</span>";
    
  
    if (colourChosen == 4 ) {
        
        //if no colour yet chosen, pick blue and text, update data model and delegate
        colourChosen = 3;
        
        [self.riskColourPicker selectRow:3 inComponent:0 animated:TRUE];
        [self.delegate addRiskColourToArray:[NSNumber numberWithInt:3]forRiskCategory:[NSNumber numberWithInteger:self.rowSelected]];
        
        riskTextArray = [self.textArray objectAtIndex:3];
        
        NSString *textFromArray = [riskTextArray objectAtIndex: self.rowSelected];
        riskText = [cssStyle stringByAppendingString:textFromArray];
        
      //  [self.riskTextView setText:riskText];
        [self.riskTextWebView loadHTMLString:[riskText stringByAppendingString:endText] baseURL:nil];
        

    }
    else{
        
        //set picker and text to current selection
        
        [self.riskColourPicker selectRow:colourChosen inComponent:0 animated:TRUE];
        self.colourRowSelected = colourChosen;
        
        riskTextArray = [self.textArray objectAtIndex:colourChosen];
        riskText = [cssStyle stringByAppendingString:[riskTextArray objectAtIndex: self.rowSelected]];
        
   [self.riskTextWebView loadHTMLString:[riskText stringByAppendingString:endText] baseURL:nil];
    }
   
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.colourRowSelected = row;
    
    NSString *riskText;
    NSArray *riskTextArray = [[NSArray alloc]init];
    
    NSString *cssStyle = @"<span style = \"background-color:transparent; font-family:HelveticaNeue-Light; font-size:14;\">";
    
    riskTextArray = [self.textArray objectAtIndex:row];
    riskText = [cssStyle stringByAppendingString:[riskTextArray objectAtIndex: self.rowSelected]];
    
    NSString *endText = @"</span>";
    
[self.riskTextWebView loadHTMLString:[riskText stringByAppendingString:endText] baseURL:nil];
    
    NSNumber *colourAddress = [NSNumber numberWithInteger:row];
    
    // update the data model
    
    
    //update the risk tool table via the delegate
    
    [self.delegate addRiskColourToArray:colourAddress forRiskCategory:[NSNumber numberWithInteger:self.rowSelected]];
    
    
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 4;
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.riskColours objectAtIndex:row];
}


-(NSAttributedString*) pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *colourTitle = [self.riskColours objectAtIndex:row];
    
    UIColor *colourChosen = [[UIColor alloc]init];
    
    switch (row) {
        case 0:
            colourChosen = [UIColor redColor];
            break;
        case 1:
            colourChosen = [UIColor orangeColor];
            break;
        case 2:
            colourChosen = [UIColor greenColor];
            break;
        case 3:
            colourChosen = [UIColor blueColor];
            break;
            
            break;
        default:
            colourChosen = [UIColor blackColor];
            break;
    }

    
    NSAttributedString *attString = [[NSAttributedString alloc]initWithString:colourTitle attributes:@{NSForegroundColorAttributeName:colourChosen}];
    
    return attString;
}

- (IBAction)didSelectRisk:(id)sender {
    

    [self dismissViewControllerAnimated:TRUE completion:Nil];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"bmiCalculateSegue"]) {
        
        AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        PhoneDataTableViewController *pdtvc = [[PhoneDataTableViewController alloc] init];
        pdtvc = segue.destinationViewController;
        pdtvc.sexInTheDelegate = theDelegate.maleFemale;
        
        
        
    }
}
@end
