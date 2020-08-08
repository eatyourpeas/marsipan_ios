//
//  PhoneDataTableViewController.m
//  marsipan
//
//  Created by Simon Chapman on 07/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import "PhoneDataTableViewController.h"
#import "DateCell.h"
#import "MeasurementCell.h"
#import "SexChoiceCell.h"
#import "CalculateCell.h"
#import "PickerViewCell.h"
#import "AppDelegate.h"
#import "UKAnthropometry.h"

#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99    // view tag identifiying the date picker view

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value

// keep track of which rows have date cells
#define kDateStartRow   0
#define kDateEndRow     1

static NSString *kDOBCellID = @"dOBCell";     // the cells with the start or end date
static NSString *kIOS7DOBCell = @"IOS7DOBCell";
static NSString *kIOS7ClinicCell = @"IOS7ClinicCell";
static NSString *kClinicDateCellID = @"clinicCell";     // the cells with the start or end date
static NSString *kDOBDatePickerID = @"dOBDatePickerCell"; // the cell containing the dob date picker
static NSString *kClinicDatePickerID = @"clinicDatePickerCell"; // the cell containing the clinic date picker
static NSString *kMeasurementCell = @"measurementCell"; // the measurement cells
static NSString *kSexChoiceCell = @"sexChoiceCell"; // the measurement cells
static NSString *kCalculateCell = @"calculateCell"; // the measurement cells
BOOL showDOBDatePicker = false;
BOOL showClinicDatePicker = false;
BOOL male = TRUE;
BOOL heightFull = FALSE;
BOOL weightFull = FALSE;
BOOL clinicFull = FALSE;
BOOL dobFull = FALSE;

@interface PhoneDataTableViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (assign) NSInteger pickerCellRowHeight;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerView;
@property(strong,nonatomic) UIDatePicker *externalDOBPicker;
@property(strong,nonatomic) UIDatePicker *externalClinicPicker;


#define EMBEDDED_DATE_PICKER (DeviceSystemMajorVersion() >= 7)

// this button appears only when the date picker is shown (iOS 6.1.x or earlier)
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation PhoneDataTableViewController

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
 
    // setup our data source
 //  NSMutableDictionary *itemOne = [@{ kTitleKey : @"Tap a cell to change its date:" } mutableCopy];
    NSMutableDictionary *itemTwo = [@{ kTitleKey : @"Date of Birth",
                                       kDateKey : [NSDate date] } mutableCopy];
    NSMutableDictionary *itemThree = [@{ kTitleKey : @"Clinic Date",
                                         kDateKey : [NSDate date] } mutableCopy];
//   NSMutableDictionary *itemFour = [@{ kTitleKey : @"(other item1)" } mutableCopy];
 //   NSMutableDictionary *itemFive = [@{ kTitleKey : @"(other item2)" } mutableCopy];
    self.dataArray = @[itemTwo, itemThree];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDOBDatePickerID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
   
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    self.navigationItem.rightBarButtonItem = nil;
    
    if (!EMBEDDED_DATE_PICKER) {
        self.externalDOBPicker = [[UIDatePicker alloc]init];
        self.externalClinicPicker = [[UIDatePicker alloc]init];
        
    }
   
}

-(void)viewWillAppear:(BOOL)animated{
    
    // Simon, this code has no purpose as the SexChoiceCell that is instantiated does not correspond to the SexChoiceCell in the storyboard.
    
    
    AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    
    if ([theDelegate.maleFemale isEqualToString: @"Male"]) {
        male = TRUE;

    }
    else if ([theDelegate.maleFemale isEqualToString:@"Female"]){
     male = false;

    }
    
    
    
    SexChoiceCell *sexCell = [[SexChoiceCell alloc]init];
    
    if (male) {
        sexCell.sexSegmentedControl.selectedSegmentIndex = 0;
    }
    else if(!male){

        [sexCell.sexSegmentedControl setSelectedSegmentIndex:1];
    }
    
    
    
    if ([self testTheFlags]) {
        CalculateCell *cell = [[CalculateCell alloc]init];
        cell.calculateButton.enabled = TRUE;
        
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utilities

/*! Returns the major version of iOS, (i.e. for iOS 6.1.3 it returns 6)
 */
NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    
    return _deviceSystemMajorVersion;
}



-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //  CBTableViewSectionData *sectionData = tableData[section];
  //  int rows = [sectionData.rowData count];
    
    int rows = 2;
    
    switch (section)
    {
            // date and time
        case 0:
            
            if (showDOBDatePicker || showClinicDatePicker) rows = 3;
            else rows = 2;
            break;
         case 1:
            rows = 2;
            break;
        case 2:
            rows = 1;
            break;
        case 3:
            rows = 1;
            break;
        default:
            rows = 0;
            break;
    }
    return rows;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Dates";
    }
    
    if (section == 1) {
        return @"Measurements";
    }
    if (section == 2) {
        return @"Sex";
    }
    
    if (section == 3) {
        return @"Calculate";
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    if (indexPath.section == 0 && ((indexPath.row == 1 && showDOBDatePicker) || (indexPath.row == 2 && showClinicDatePicker)))
    {
        height = 216.0f;
    }
    
    if (indexPath.section == 2 && !EMBEDDED_DATE_PICKER) {
        
        height = 60.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            
            if (EMBEDDED_DATE_PICKER) {
                
                UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:kIOS7DOBCell];
                
                cell.textLabel.text = NSLocalizedString(@"Date of Birth", nil);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.detailTextLabel.text = theDelegate.resultDOBDateString;
                
                return cell;
            }
            
            
            else if (!EMBEDDED_DATE_PICKER) {
               
                DateCell *cell = (DateCell*)[tableView dequeueReusableCellWithIdentifier:kDOBCellID];
                
                [self.externalDOBPicker setDate:[NSDate date] animated:TRUE];
                [self.externalDOBPicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
                [self.externalDOBPicker setDatePickerMode:UIDatePickerModeDate];
                [self.externalDOBPicker setTag:1];
                
         
                cell.iOS6DOBTextField.inputView = self.externalDOBPicker;
                cell.iOS6DOBTextField.delegate = self;
                cell.iOS6DOBTextField.tag = 5;
                
                NSCalendar *myCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                
             //   NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                
                
                [self.externalDOBPicker setDate:[NSDate date] animated:TRUE];
                
                if (theDelegate.resultDOBDate !=nil) {
                    
                    
                    [self.externalDOBPicker setDate:theDelegate.resultDOBDate animated:TRUE];
                    cell.iOS6DOBTextField.text = theDelegate.resultDOBDateString;
                    
                }
                
                
                
                if (theDelegate.resultClinicDate !=nil) {
                    //set the minimum date to 18y before clinic date
                    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                    [dateComponents setYear:-18];
                    NSDate *targetDate = [myCalendar dateByAddingComponents:dateComponents toDate:self.clinicResultDate  options:0];
                    [self.externalDOBPicker setMinimumDate:targetDate];
                }
               return cell;
            }
            
           // return cell;
        }
        
        
        else if (indexPath.row == 1 )
        {
            if (showDOBDatePicker)
            {
                
               PickerViewCell *cell = (PickerViewCell*)[tableView dequeueReusableCellWithIdentifier:kDOBDatePickerID];
                
                if (theDelegate.resultClinicDate != nil) {
                    

                        NSCalendar *myCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                        [dateComponents setYear:-18];
                        NSDate *targetDate = [myCalendar dateByAddingComponents:dateComponents toDate:self.clinicResultDate  options:0];
                        
                    cell.dobPicker.minimumDate = targetDate;
                    
                    cell.dobPicker.maximumDate = self.clinicResultDate;
                }
                else{
                    /* this line sets clinic to today
                    self.clinicResultDate = [NSDate date];
                    NSDateFormatter *myFormatter = [[NSDateFormatter alloc]init];
                    [myFormatter setDateStyle:NSDateFormatterMediumStyle];
                    self.clinicResultDateString = [myFormatter stringFromDate:[NSDate date]];
                     */
                }
                
                return cell;
            } 
            
            else
            { 
                
                if (EMBEDDED_DATE_PICKER) {
                    
                    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:kIOS7ClinicCell];
                    
                    cell.textLabel.text = NSLocalizedString(@"Clinic Date", nil);
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = theDelegate.resultClinicDateString;
                    return cell;
                }
                
                
               else if (!EMBEDDED_DATE_PICKER) {
                   
                    
                    DateCell *cell = (DateCell*)[tableView dequeueReusableCellWithIdentifier:kClinicDateCellID];
                  
                    [self.externalClinicPicker setDate:[NSDate date] animated:TRUE];
                    [self.externalClinicPicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
                    [self.externalClinicPicker setDatePickerMode:UIDatePickerModeDate];
                    [self.externalClinicPicker setTag:2];
                
                    cell.iOS6ClinicTextField.inputView = self.externalClinicPicker;
                    cell.iOS6ClinicTextField.delegate = self;
                    cell.iOS6ClinicTextField.tag = 6;
                    
                    
                    NSCalendar *myCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                   
                    
                    [self.externalClinicPicker setDate:[NSDate date] animated:TRUE];
                   
                   if (theDelegate.resultClinicDate !=nil) {
                        
                        cell.iOS6ClinicTextField.text = self.clinicResultDateString;
                        [self.externalClinicPicker setDate:self.clinicResultDate animated:TRUE];
                    }
                    if (theDelegate.resultDOBDate !=nil) {
                        //set the minimum date to 18y before clinic date
                        [dateComponents setYear:+18];
                        NSDate *targetDate = [myCalendar dateByAddingComponents:dateComponents toDate:self.dobResultDate  options:0];
                        [self.externalClinicPicker setMaximumDate:targetDate];
                    }
                   
                   
                   return cell;
                }
                
               
            } 
            
            
        }
        else if (indexPath.row == 2)
        {
            if (showClinicDatePicker)
            {
                
                PickerViewCell *cell = (PickerViewCell*)[tableView dequeueReusableCellWithIdentifier:kClinicDatePickerID];
                
                
                
                if (theDelegate.resultDOBDate !=nil) {
                    

                        
                        NSCalendar *myCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                        [dateComponents setYear:18];
                        NSDate *targetDate = [myCalendar dateByAddingComponents:dateComponents toDate:self.dobResultDate  options:0];
                        
                    cell.clinicPicker.maximumDate = targetDate;
                    
                    
                    cell.clinicPicker.minimumDate = self.dobResultDate;
                }
                
                
                 return cell;
            }
            if (showDOBDatePicker) {
                UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:kIOS7ClinicCell];
                
                 cell.detailTextLabel.text = theDelegate.resultClinicDateString;
                cell.textLabel.text = NSLocalizedString(@"Clinic date", nil);
                
                
                    return cell;
            }
           
        
            }
    }
    
    if (indexPath.section == 1) {
        
        AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        MeasurementCell *cell = (MeasurementCell*)[tableView dequeueReusableCellWithIdentifier:kMeasurementCell];
    
        if (indexPath.row == 0) {
         
            cell.measurementLabel.text = NSLocalizedString(@"Height", Nil);
            cell.measurementTextField.placeholder = @"cm";
            cell.measurementTextField.delegate = self;
            
            cell.measurementTextField.tag = 10;
            
            if (theDelegate.resultHeight != nil) {
                cell.measurementTextField.text = [NSString stringWithFormat:@"%@ cm",theDelegate.resultHeight];
            }
            
            return cell;
            
        }
        else if (indexPath.row == 1){
            MeasurementCell *cell = (MeasurementCell*)[tableView dequeueReusableCellWithIdentifier:kMeasurementCell];
            
            cell.measurementLabel.text = NSLocalizedString(@"Weight", Nil);
            cell.measurementTextField.placeholder = @"kg";
            
            if (theDelegate.resultWeight != nil) {
                cell.measurementTextField.text = [NSString stringWithFormat:@"%@ kg",theDelegate.resultWeight];
            }
            
            cell.measurementTextField.delegate = self;
            
            cell.measurementTextField.tag = 20;

            
            return cell;
        }
        
    }
    
    else if (indexPath.section == 2){
        
        

        SexChoiceCell *cell = (SexChoiceCell*)[tableView dequeueReusableCellWithIdentifier:kSexChoiceCell];
        
        if (male) {
            [cell.sexSegmentedControl setSelectedSegmentIndex:0];
        }
        else [cell.sexSegmentedControl setSelectedSegmentIndex:1];
        
       return cell;
    }

    else if (indexPath.section == 3){
        
        CalculateCell *cell = (CalculateCell*)[tableView dequeueReusableCellWithIdentifier:kCalculateCell];
        cell.calculateButton.titleLabel.text = @"Calculate";
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.calculateButton.enabled = false;
        
        if ([self testTheFlags]) {
            cell.calculateButton.enabled = TRUE;
        }
        
        
        
        return cell;
    }
    
    
    return nil;
        
    
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
   AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    /// methods for IOS - 7

            if (indexPath.section == 0 && indexPath.row == 0 )
            {
                
                showDOBDatePicker = !showDOBDatePicker;
                
                //if no date has been selected set to today's date
                
                if (theDelegate.resultDOBDate == nil) {
                   
                    self.dobResultDate = [NSDate date];
                    NSDateFormatter *myFormatter = [[NSDateFormatter alloc]init];
                    [myFormatter setDateStyle:NSDateFormatterMediumStyle];
                    self.dobResultDateString = [myFormatter stringFromDate:[NSDate date]];
                    theDelegate.resultDOBDate = self.dobResultDate;
                    theDelegate.resultDOBDateString = self.dobResultDateString;
                    
                }
                dobFull = TRUE;
                
                // update table
                UITableViewCell *dc= [tableView cellForRowAtIndexPath:indexPath];
                dc.detailTextLabel.text = theDelegate.resultDOBDateString;
                
                
                NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
               NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];

                [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }
            else if (indexPath.section == 0 && indexPath.row == 1 && showDOBDatePicker == false ) {
                showClinicDatePicker = !showClinicDatePicker;
                
                /// if no date has been selected, set to today's date

                if (theDelegate.resultClinicDate == nil) {
                    
                    self.clinicResultDate = [NSDate date];
                    NSDateFormatter *myFormatter = [[NSDateFormatter alloc]init];
                    [myFormatter setDateStyle:NSDateFormatterMediumStyle];
                    self.clinicResultDateString = [myFormatter stringFromDate:[NSDate date]];
                    theDelegate.resultClinicDate = self.clinicResultDate;
                    theDelegate.resultClinicDateString = self.clinicResultDateString;
                }
                clinicFull = TRUE;
                
                // update table
                
                UITableViewCell *dc= [tableView cellForRowAtIndexPath:indexPath];
                dc.detailTextLabel.text = theDelegate.resultClinicDateString;
                
                
                NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
                NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
                
                [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }
   
            else 
            { 
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; 
            }


}


- (IBAction)datePickerValueChanged:(id)sender {
   
            UIDatePicker *thisPicker = [[UIDatePicker alloc]init];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc]init];
    [myFormatter setDateStyle:NSDateFormatterMediumStyle];
    thisPicker = sender;
    NSDate *dateRead = thisPicker.date;
   
    AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    if ([sender tag]==1) {
        
        if (EMBEDDED_DATE_PICKER) {
            self.dobPicker = thisPicker;
            self.dobResultDate = dateRead;
            self.dobResultDateString = [myFormatter stringFromDate:dateRead];
            theDelegate.resultDOBDate = self.dobResultDate;
            theDelegate.resultDOBDateString = self.dobResultDateString;
        }
        else{

            self.externalDOBPicker = thisPicker;
            self.dobResultDate = dateRead;
            self.dobResultDateString = [myFormatter stringFromDate:dateRead];
            theDelegate.resultDOBDate = self.dobResultDate;
            theDelegate.resultDOBDateString = self.dobResultDateString;
        }
        
    }
    else if ([sender tag]== 2){
       
        if (EMBEDDED_DATE_PICKER) {
            self.clinicPicker = thisPicker;
            self.clinicResultDate = dateRead;
            self.clinicResultDateString = [myFormatter stringFromDate:dateRead];
            theDelegate.resultClinicDate = self.clinicResultDate;
            theDelegate.resultClinicDateString = self.clinicResultDateString;
        }
        else{
            self.externalClinicPicker = thisPicker;
            self.clinicResultDate = dateRead;
            self.clinicResultDateString = [myFormatter stringFromDate:dateRead];
            theDelegate.resultClinicDate = self.clinicResultDate;
            theDelegate.resultClinicDateString = self.clinicResultDateString;
        }
        
    }
    [self.tableView reloadData];
}

- (IBAction)sexChange:(id)sender {
    
    
    
    male = !male;
    AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (male) {
        theDelegate.maleFemale = @"Male";
    }
    else{
        theDelegate.maleFemale = @"Female";
    }
    
    NSIndexPath *myIndex = [NSIndexPath indexPathForRow:0 inSection:3];
    CalculateCell *cell = (CalculateCell*)[self.tableView cellForRowAtIndexPath:myIndex];
    
    cell.calculateButton.enabled = false;
    
    if ([self testTheFlags]) {
        
        cell.calculateButton.enabled = TRUE;
    }
}

- (IBAction)heightWeightEditingStarted:(id)sender {
    
    self.navigationItem.rightBarButtonItem = self.doneButtonItem;
    
    NSIndexPath *heightIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *weightIndex = [NSIndexPath indexPathForRow:1 inSection:1];
    
    AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([sender tag] == 10) {
        // this is height
        MeasurementCell *measurementCell = (MeasurementCell*)[self.tableView cellForRowAtIndexPath:heightIndex];
        
        theDelegate.resultHeight =  nil;
        
        measurementCell.measurementTextField.text = [NSString stringWithFormat:@""];
        
    }
    
    else if ([sender tag] == 20){
        // this is weight
        MeasurementCell *measurementCell = (MeasurementCell*)[self.tableView cellForRowAtIndexPath:weightIndex];
        
        theDelegate.resultWeight = nil;
        
        measurementCell.measurementTextField.text = [NSString stringWithFormat:@""];
    }
    
}

- (IBAction)doneButtonPressed:(id)sender {
    
    if (!EMBEDDED_DATE_PICKER) {
        
        //done button resigns external date picker in ios 6.1 and below
        
        NSIndexPath *dobIndex = [NSIndexPath indexPathForItem:0 inSection:0];
        NSIndexPath *clinicIndex = [NSIndexPath indexPathForItem:1 inSection:0];
        
        DateCell *cellToResign = (DateCell*)[self.tableView cellForRowAtIndexPath:dobIndex];
        [cellToResign.iOS6DOBTextField resignFirstResponder];
        DateCell *anotherCellToResign = (DateCell*)[self.tableView cellForRowAtIndexPath:clinicIndex];
        [anotherCellToResign.iOS6ClinicTextField resignFirstResponder];
        
      
        
        [self.tableView reloadData];
    }
    
    NSIndexPath *heightIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *weightIndex = [NSIndexPath indexPathForRow:1 inSection:1];
    
    MeasurementCell *measurementCell = (MeasurementCell*)[self.tableView cellForRowAtIndexPath:heightIndex];
    [measurementCell.measurementTextField resignFirstResponder];
    measurementCell = (MeasurementCell*)[self.tableView cellForRowAtIndexPath:weightIndex];
    [measurementCell.measurementTextField resignFirstResponder];
    
    self.navigationItem.rightBarButtonItem = Nil;
    
    NSIndexPath *myIndex = [NSIndexPath indexPathForRow:0 inSection:3];
    CalculateCell *cell = (CalculateCell*)[self.tableView cellForRowAtIndexPath:myIndex];
    
    cell.calculateButton.enabled = false;
    
    if ([self testTheFlags]) {
        
        cell.calculateButton.enabled = TRUE;
    }
    
    
}

- (IBAction)didEndEditing:(id)sender {
    
    NSIndexPath *heightIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *weightIndex = [NSIndexPath indexPathForRow:1 inSection:1];
    
    AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([sender tag] == 10) {
        // this is height
        MeasurementCell *measurementCell = (MeasurementCell*)[self.tableView cellForRowAtIndexPath:heightIndex];

        if (![measurementCell.measurementTextField.text isEqualToString:@""]) {
            
            theDelegate.resultHeight =  (NSNumber*)measurementCell.measurementTextField.text;
            measurementCell.measurementTextField.text = [NSString stringWithFormat:@"%@ cm", theDelegate.resultHeight];
            heightFull = TRUE;
        }
        else heightFull = FALSE;
        
    }
    
    else if ([sender tag] == 20){
        // this is weight
        MeasurementCell *measurementCell = (MeasurementCell*)[self.tableView cellForRowAtIndexPath:weightIndex];
        
        if (![measurementCell.measurementTextField.text isEqualToString:@""]) {
            
            theDelegate.resultWeight = (NSNumber*)measurementCell.measurementTextField.text;
            
            measurementCell.measurementTextField.text = [NSString stringWithFormat:@"%@ kg", theDelegate.resultWeight];

            
            weightFull = TRUE;
        }
        else weightFull = FALSE;
        
    }
    
    
    
    NSIndexPath *myIndex = [NSIndexPath indexPathForRow:0 inSection:3];
    CalculateCell *cell = (CalculateCell*)[self.tableView cellForRowAtIndexPath:myIndex];
    
    cell.calculateButton.enabled = false;
    
    if ([self testTheFlags]) {
        
               cell.calculateButton.enabled = TRUE;
    }
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"calculateSegue"]) {

            AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            UKAnthropometry *mathsMethods = [[UKAnthropometry alloc]init];
        
        
            
            theDelegate.resultDecimalAge = [mathsMethods calculateDecimalAgeFromDOB:theDelegate.resultDOBDate usingClinicDate: theDelegate.resultClinicDate];
            theDelegate.resultCalendarAge = [mathsMethods calendarAgeFromDOB:theDelegate.resultDOBDate usingClinicDate: theDelegate.resultClinicDate ];
            theDelegate.bmi = [mathsMethods calculateBMIFromHeight:theDelegate.resultHeight andWeight:theDelegate.resultWeight];
            theDelegate.resultArray = [mathsMethods calculateSDSandCentileAndPctmBMIandExpectedWeightsFromDecimalAge:theDelegate.resultDecimalAge andSex:theDelegate.maleFemale andHeight:theDelegate.resultHeight andWeight:theDelegate.resultWeight andBMI:theDelegate.bmi];
        
    }
}

-(BOOL)testTheFlags{
    BOOL passed = FALSE;
    /*
    if (dobFull && clinicFull && weightFull && heightFull) {
        passed = TRUE;
    }
     */
    AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (theDelegate.resultDOBDate !=nil && theDelegate.resultClinicDate != nil && theDelegate.resultHeight != nil && theDelegate.resultWeight != nil) {
        passed = TRUE;
    }
    
    return passed;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 5) {
        // this is ios 6 dob field
        self.navigationItem.rightBarButtonItem = self.doneButtonItem;
    }
    if (textField.tag == 6) {
        // this is ios 6 clinic field
        self.navigationItem.rightBarButtonItem = self.doneButtonItem;
    }
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    AppDelegate *theDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (textField.tag == 5) {
        //this the dob textfield closing
        if (self.dobResultDate == nil) {

            NSDateFormatter *myFormatter = [[NSDateFormatter alloc]init];
            [myFormatter setDateStyle:NSDateFormatterMediumStyle];
            self.dobResultDate = [NSDate date];
            self.dobResultDateString = [myFormatter stringFromDate:[NSDate date]];
            
            theDelegate.resultDOBDate = self.dobResultDate;
            theDelegate.resultDOBDateString = self.dobResultDateString;
        }
    }
    if (textField.tag == 6) {
        //this it the clinic textfield closing

        if (self.clinicResultDate == nil) {
            NSDateFormatter *myFormatter = [[NSDateFormatter alloc]init];
            [myFormatter setDateStyle:NSDateFormatterMediumStyle];
            self.clinicResultDate = [NSDate date];
            self.clinicResultDateString = [myFormatter stringFromDate:[NSDate date]];
            theDelegate.resultClinicDate = self.clinicResultDate;
            theDelegate.resultClinicDateString = self.clinicResultDateString;
        }
        [self.tableView reloadData];
    }
}

@end
