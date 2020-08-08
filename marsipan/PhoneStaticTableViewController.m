//
//  PhoneStaticTableViewController.m
//  marsipan
//
//  Created by Simon Chapman on 15/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import "PhoneStaticTableViewController.h"
#import "PhoneResultsViewController.h"
#import "AppDelegate.h"
#import "UKAnthropometry.h"

@interface PhoneStaticTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *dOBDate;
@property (nonatomic, strong) NSDate *clinicDate;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *weight;


@end

@implementation PhoneStaticTableViewController

#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view

bool editingDOB = FALSE;
bool editingClinic = FALSE;
//BOOL male = FALSE;
bool fieldsAreFull = FALSE;

//! Returns the major version of iOS, (i.e. for iOS 6.1.3 it returns 6)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set the dates to today
    self.clinicDate = [NSDate date];
    self.dOBDate = [NSDate date];
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [self setPickers];
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = nil;
    self.weightTextField.delegate = self;
    self.heightTextField.delegate = self;
    self.calculateButton.enabled = fieldsAreFull;
    self.dateOfBirthLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
    self.clinicDateLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
    self.externalPicker = [[UIDatePicker alloc]init];
    [self.externalPicker setDate:[NSDate date]];
    [self.externalPicker setDatePickerMode:UIDatePickerModeDate];
    [self.externalPicker addTarget:self action:@selector(dateAction:) forControlEvents:UIControlEventValueChanged];
  
    //set sex to female
  /*
    NSString *malePath = [[NSBundle mainBundle] pathForResource:@"individualmale" ofType:@"png"];
    NSString *femalePath = [[NSBundle mainBundle] pathForResource:@"individualfemale" ofType:@"png"];
    UIImage *maleImage = [[UIImage alloc]initWithContentsOfFile:malePath];
    UIImage *femaleImage = [[UIImage alloc]initWithContentsOfFile:femalePath];
    [self.sexChoiceSegmentedControl setImage:femaleImage forSegmentAtIndex:1];
    [self.sexChoiceSegmentedControl setImage:maleImage forSegmentAtIndex:1];

    NSLog(@"male is %d", male);
*/
    self.sexChoiceSegmentedControl.selectedSegmentIndex = 1;
    
/*    if (male) {
        self.sexChoiceSegmentedControl.selectedSegmentIndex = 0;
        
    }
    

*/
    
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.dobPicker.hidden = TRUE;
        self.clinicPicker.hidden = TRUE;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = self.tableView.rowHeight;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
    
    if (indexPath.section == 0 && indexPath.row == 1) { // this is my picker cell
        if (editingDOB) {

            rowHeight = 219;
        }
        else {
           
            rowHeight =  0;
        }
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        //this is my picker cell
        if (editingClinic) {
            
            rowHeight = 219;
        } else {
            rowHeight = 0;
        }
    }
    
    }
    else { // this is below ios 7

        if (indexPath.section == 0 && indexPath.row == 1) {
            rowHeight = 0.0;


        }
        if (indexPath.section == 0 && indexPath.row == 3) {
            rowHeight = 0.0;
          

        }
        if (indexPath.section == 2 && indexPath.row == 0) {
            rowHeight = 60.0;
        }
        
    }

    
    return rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && !SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        //set the min and max dates of external picker
        NSCalendar *myCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        
        if (indexPath.row == 0) { //this is dob picker
            [dateComponents setYear:-17];
            NSDate *targetDate = [myCalendar dateByAddingComponents:dateComponents toDate:self.clinicDate  options:0];
            self.externalPicker.maximumDate = self.clinicDate;
            self.externalPicker.minimumDate = targetDate;
        }
        else if(indexPath.row == 2){ //this is clinic picker
            [dateComponents setYear:17];
            NSDate *targetDate = [myCalendar dateByAddingComponents:dateComponents toDate:self.dOBDate  options:0];
            self.externalPicker.minimumDate = self.dOBDate;
            self.externalPicker.maximumDate = targetDate;
        }
        [self displayExternalDatePickerForRowAtIndexPath:indexPath];
        return;
    }
    else
    

    if (indexPath.section == 0 && indexPath.row == 0) { // this is my date cell above or below the picker cell
        editingDOB = !editingDOB;
 
        
        

        if (editingDOB == TRUE) { //if clinicpicker open, close it
            
            editingClinic = FALSE;
            [UIView animateWithDuration:.4 animations:^{
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView reloadData];
            }];
        }
        
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
        }];
    }
    if (indexPath.section == 0 && indexPath.row == 2) { // this is my date cell above or below the picker cell
        editingClinic = !editingClinic;
        
        if (editingClinic == TRUE) { //if dobpicker open close it
            editingDOB = FALSE;
            [UIView animateWithDuration:.4 animations:^{
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView reloadData];
            }];
        }
        
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
        }];
    }
         
    
}

- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}



-(IBAction)dateAction:(id)sender{
    if (sender == self.externalPicker) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath.row == 0) {
            //this is dob
            self.dOBDate = self.externalPicker.date;
            self.dateOfBirthLabel.text = [self.dateFormatter stringFromDate:self.dOBDate];
        }
        else if (indexPath.row == 1){
            // this is clinic
            self.clinicDate = self.externalPicker.date;
            self.clinicDateLabel.text = [self.dateFormatter stringFromDate:self.clinicDate];
        }
        return;
    }
    
    if (sender==_clinicPicker) {
        
        //update data model
        
         self.clinicDate = _clinicPicker.date;
        
        //update table cell
        _clinicDateLabel.text = [self.dateFormatter stringFromDate:self.clinicDate];
        
        
    }
    else if (sender == _dobPicker){
       
        //update data model
        self.dOBDate = _dobPicker.date;
        
        //update tablecell
        self.dateOfBirthLabel.text = [self.dateFormatter stringFromDate:self.dOBDate];
        
    }
    [self setPickers]; //update the min and max dates of pickers
}

-(IBAction)doneButtonPressed:(id)sender{
    
    if (self.externalPicker.superview !=nil) {
        {
            CGRect pickerFrame = self.externalPicker.frame;
            pickerFrame.origin.y = self.view.frame.size.height;
            
            // animate the date picker out of view
            [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.externalPicker.frame = pickerFrame; }
                             completion:^(BOOL finished) {
                                 [self.externalPicker removeFromSuperview];
                             }];
            
            // remove the "Done" button in the navigation bar
            self.navigationItem.rightBarButtonItem = nil;
            
            // deselect the current table cell
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    else{
    
    self.navigationItem.rightBarButtonItem = nil;
    [self.heightTextField resignFirstResponder];
     [self.weightTextField resignFirstResponder];
    self.calculateButton.enabled = fieldsAreFull;
    }
}

- (IBAction)sexChange:(id)sender {
 //   male = !male;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField.text = @"";
    
    self.navigationItem.rightBarButtonItem = self.nowDoneButton;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *result = textField.text;
    if (textField == self.weightTextField && ![self.weightTextField.text isEqualToString:@""]) {
        
        //store in data model
        self.weight = [NSNumber numberWithDouble:[result doubleValue]];
        //update ui
        textField.text = [NSString stringWithFormat:@"%@ kg", result];
    }
    else if (textField == self.heightTextField && ![self.heightTextField.text isEqualToString:@""]){
        
        //store in data model
        self.height = [NSNumber numberWithDouble:[result doubleValue]];
        
        //update ui
        textField.text = [NSString stringWithFormat:@"%@ cm", result];
    }
    
    if ([self.weightTextField.text isEqualToString: @""] ||[self.heightTextField.text isEqualToString:@""]) {
        fieldsAreFull = FALSE;
    }
    else{
        fieldsAreFull = TRUE;
    }
    self.calculateButton.enabled = fieldsAreFull;
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   /*
    if ([segue.identifier isEqualToString:@"ResultsSegue" ]) {
        
        AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        UKAnthropometry *mathsMethods = [[UKAnthropometry alloc]init];
        
       if (male) {
            theDelegate.maleFemale = @"Male";
//        }
//        else{
            theDelegate.maleFemale = @"Female";
//        }
        
        
        theDelegate.resultDecimalAge = [mathsMethods calculateDecimalAgeFromDOB:self.dOBDate usingClinicDate:self.clinicDate];
        theDelegate.resultCalendarAge = [mathsMethods calendarAgeFromDOB:self.dOBDate usingClinicDate:self.clinicDate];
        theDelegate.bmi = [mathsMethods calculateBMIFromHeight:self.height andWeight:self.weight];
        theDelegate.resultArray = [mathsMethods calculateSDSandCentileAndPctmBMIandExpectedWeightsFromDecimalAge:theDelegate.resultDecimalAge andSex:theDelegate.maleFemale andHeight:self.height andWeight:self.weight andBMI:theDelegate.bmi];
        theDelegate.resultHeight = self.height;
        theDelegate.resultWeight = self.weight;

    }
  */
    
}
-(void) setPickers{
    // set the datepickers min and max dates
    
    NSCalendar *myCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:17];
    NSDate *targetDate = [myCalendar dateByAddingComponents:dateComponents toDate:self.dOBDate  options:0];
    
    self.clinicPicker.minimumDate = self.dobPicker.date;
    self.clinicPicker.maximumDate = targetDate;
    
    [dateComponents setYear:-17];
    targetDate = [myCalendar dateByAddingComponents:dateComponents toDate:self.clinicDate  options:0];
    
    self.dobPicker.maximumDate = self.clinicPicker.date;
    self.dobPicker.minimumDate = targetDate;
}

- (void)displayExternalDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // first update the date picker's date value according to our model
    if (indexPath.section != 0) {
        return;
    }
    
    if (indexPath.row == 0) {
        // this is the DOB
        
        [self.externalPicker setDate:self.dOBDate];
        
    }
    else if (indexPath.row == 1){
        //this is the clinic date
        [self.externalPicker setDate:self.clinicDate];
        
    }
    
    
    // the date picker might already be showing, so don't add it to our view
    if (self.externalPicker.superview == nil)
    {
        CGRect startFrame = self.externalPicker.frame;
        CGRect endFrame = self.externalPicker.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = self.view.frame.size.height;
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        
        self.externalPicker.frame = startFrame;
        
        [self.view addSubview:self.externalPicker];
        
        // animate the date picker into view
        [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.externalPicker.frame = endFrame; }
                         completion:^(BOOL finished) {
                             // add the "Done" button to the nav bar
                            self.navigationItem.rightBarButtonItem = self.nowDoneButton;

                         }];
    }
    
    
}

 
@end
