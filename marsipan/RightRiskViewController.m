//
//  RightRiskViewController.m
//  marsipan
//
//  Created by Simon Chapman on 05/04/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import "RightRiskViewController.h"
#import "StoredRisksSingleton.h"

@interface RightRiskViewController ()

@end

@implementation RightRiskViewController

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
    // Do any additional setup after loading the view.
    self.risk = [[Risk alloc]init];
    self.riskColourPicker.delegate = self;
    [self.riskColourPicker selectRow:3 inComponent:0 animated:TRUE];
    [self.delegate selectedColour:[NSNumber numberWithInt:3] forCategory:0];
    [self populateRiskTextForSelectedColour:[NSNumber numberWithInteger:3] andRiskCategory:0];
       
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Risk Selection Delegate

-(void) selectedRiskCategory:(NSNumber*)newRisk{
    self.titleLabel.text = [self.risk getRiskTitle:newRisk];
    NSNumber *chosenColour = [StoredRisks returnChosenColourForCategory:newRisk];
    self.riskScrollView.text = [self.risk getRiskTextForRiskColour:chosenColour andCategory:newRisk ];
    self.storedCategory = newRisk;
    
    if ([chosenColour integerValue]==4) {
        [self.riskColourPicker selectRow:3 inComponent:0 animated:TRUE];
                [self populateRiskTextForSelectedColour:[NSNumber numberWithInteger:3] andRiskCategory:newRisk];
    }
    else
    {
        [self.riskColourPicker selectRow:[chosenColour integerValue] inComponent:0 animated:TRUE];
    
        [self populateRiskTextForSelectedColour:chosenColour andRiskCategory:newRisk];
    }
    
   /*
    
    if (_popover != nil) {
        NSLog(@"cheerio!");
        [_popover dismissPopoverAnimated:YES];
    }
    */
    
}

-(void) populateRiskTextForSelectedColour:(NSNumber*)colour andRiskCategory:(NSNumber*)riskCategory
{
    
    
    NSString *textFromArray = [self.risk getRiskTextForRiskColour:colour andCategory:riskCategory];
    
    
    NSString *cssStyle = @"<span style = \"background-color:transparent; font-family:HelveticaNeue-Light; font-size:14;\">";
    
    
    NSString *riskText = [cssStyle stringByAppendingString:textFromArray];
    
    NSString *endText = @"</span>";
    
    [self.riskWebView loadHTMLString:[riskText stringByAppendingString:endText] baseURL:nil];
}

#pragma mark Picker View delegate methods

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //update UI
    
    [ self populateRiskTextForSelectedColour:[NSNumber numberWithInteger:row] andRiskCategory:self.storedCategory];
    
    //update data model
    
    [StoredRisks saveInStoredRisksSingletonAtCategoryIndex:self.storedCategory SavedColour:[NSNumber numberWithInteger:row]];
    
    // pass selected colour back to tableview to update cell
    
    [self.delegate selectedColour:[NSNumber numberWithInteger:row] forCategory:self.storedCategory];
    
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
        return [self.risk.riskColours count];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.risk.riskColours objectAtIndex:row];
}


-(NSAttributedString*) pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *colourTitle = [self.risk.riskColours objectAtIndex:row];
    
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

/*
#pragma mark Split View Controller delegate methods

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*) barButtonItem forPopoverController:(UIPopoverController *)pc
{
    //Grab a reference to the popover
    self.popover = pc;
    
    
    //Set the title of the bar button item
    barButtonItem.title = @"Risks";
    
    //Set the bar button item as the Nav Bar's leftBarButtonItem
    [_navBarItem setLeftBarButtonItem:barButtonItem animated:YES];
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //Remove the barButtonItem.
    [_navBarItem setLeftBarButtonItem:nil animated:YES];
    
    
    //Nil out the pointer to the popover.
 //   _popover = nil;
    NSLog(@"Will show left side");
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
