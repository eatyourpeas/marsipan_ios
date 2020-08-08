//
//  CBPhoneDataTableViewController.m
//  marsipan
//
//  Created by Conrad Bosman on 15/02/2015.
//  Copyright (c) 2015 eatyourpeas. All rights reserved.
//

#import "CBPhoneDataTableViewController.h"
#import "CBMeasurementCell.h"
#import "CBSexChoiceCell.h"
#import "CBCalculateCell.h"
#import "UKAnthropometry.h"
#import "AppDelegate.h"

@interface CBPhoneDataTableViewController () <UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIBarButtonItem *doneButtonItem;
@property (nonatomic, strong) UIDatePicker *clinicDatePicker;
@property (nonatomic, strong) UIDatePicker *birthDatePicker;

@end

@implementation CBPhoneDataTableViewController
{
    BOOL showBirthDateCell;
    BOOL showClinicDateCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set defaults
    AppDelegate *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDateFormatter *myFormatter = [NSDateFormatter new];
    myFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    theDelegate.resultClinicDate = [NSDate date];
    theDelegate.resultClinicDateString = [myFormatter stringFromDate:theDelegate.resultClinicDate];

    theDelegate.maleFemale = @"Female";
    
    // setup Done button
    self.doneButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Done", @"Done as in finish")
                                                          style:UIBarButtonItemStyleDone
                                                         target:self
                                                         action:@selector(doneButtonPressed)];
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    
    // instantiate date pickers
    if (!self.birthDatePicker)
    {
        self.birthDatePicker = [UIDatePicker new];
        self.birthDatePicker.datePickerMode = UIDatePickerModeDate;
        self.birthDatePicker.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.birthDatePicker addTarget:self
                                 action:@selector(datePickerValueChanged:)
                       forControlEvents:UIControlEventValueChanged];
    }
    
    if (!self.clinicDatePicker)
    {
        self.clinicDatePicker = [UIDatePicker new];
        self.clinicDatePicker.datePickerMode = UIDatePickerModeDate;
        self.clinicDatePicker.translatesAutoresizingMaskIntoConstraints = NO;
        self.clinicDatePicker.date = [NSDate date];
        
        [self.clinicDatePicker addTarget:self
                                  action:@selector(datePickerValueChanged:)
                        forControlEvents:UIControlEventValueChanged];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateCalculateButton];
}

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    AppDelegate *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDateFormatter *myFormatter = [NSDateFormatter new];
    myFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    if ([sender isEqual:self.birthDatePicker])
    {
        theDelegate.resultDOBDate = sender.date;
        theDelegate.resultDOBDateString = [myFormatter stringFromDate:sender.date];
        
        // update table
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([sender isEqual:self.clinicDatePicker])
    {
        theDelegate.resultClinicDate = sender.date;
        theDelegate.resultClinicDateString = [myFormatter stringFromDate:sender.date];
        
        // update table
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self updateCalculateButton];
}

- (void)sexChange:(UISegmentedControl *)sender
{
    AppDelegate *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (sender.selectedSegmentIndex == 0)
    {
        theDelegate.maleFemale = @"Male";
    }
    else
    {
        theDelegate.maleFemale = @"Female";
    }
    
    [self updateCalculateButton];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // alternative way to dismiss DecimalPad
    [self doneButtonPressed];
}

- (void)doneButtonPressed
{
    [self dismissDecimalPadKeyboard];
    
    // get rid of 'Done' button
    self.navigationItem.rightBarButtonItem = Nil;
    
    [self updateCalculateButton];
}

- (void)dismissDecimalPadKeyboard
{
    // resignFirstResponder in UITextFields if user drags UITableView
    CBMeasurementCell *measurementCell;
    
    for (NSInteger row = 0; row < 2; row ++)
    {
        // determine path
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:1];
        
        // get cell
        measurementCell = (CBMeasurementCell *)[self.tableView cellForRowAtIndexPath:path];
        
        // exit editing
        [measurementCell.measurementTextField resignFirstResponder];
    }
}

- (void)closeAllDatePickers
{
    if (showBirthDateCell)
    {
        showBirthDateCell = NO;
        [self updateDOBDatePickerCell];
    }
    else if (showClinicDateCell)
    {
        showClinicDateCell = NO;
        [self updateClinicDatePickerCell];
    }
}

- (void)updateCalculateButton
{
    // get path to calculate button cell
    NSIndexPath *myIndex = [NSIndexPath indexPathForRow:0 inSection:3];
    CBCalculateCell *cell = (CBCalculateCell *)[self.tableView cellForRowAtIndexPath:myIndex];
    
    // cell.calculateButton.enabled = FALSE;
    
    // update button
    cell.calculateButton.enabled = [self testTheFlags];
    
    cell.clearButton.enabled = [self anotherFlagTest];
    
}

- (BOOL)testTheFlags
{
    AppDelegate *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // return TRUE if all variables have been set, otherwise FALSE
    return (theDelegate.resultDOBDate && theDelegate.resultClinicDate && theDelegate.resultHeight && theDelegate.resultWeight);
}

- (BOOL)anotherFlagTest
{
    AppDelegate *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // return TRUE if all variables have been set, otherwise FALSE
    return (theDelegate.resultDOBDate || theDelegate.resultHeight || theDelegate.resultWeight);
}

- (void)calculateResults
{
    [self performSegueWithIdentifier:@"calculateResults" sender:self];
}

- (void)clearValues
{
    AppDelegate *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    theDelegate.resultDOBDate = nil;
    theDelegate.resultDOBDateString = nil;
    theDelegate.resultHeight = nil;
    theDelegate.resultWeight = nil;
    
    [self.tableView reloadData];
    
    [self updateCalculateButton];
}

- (void)showGuideline
{
    [self performSegueWithIdentifier:@"showGuideline" sender:self];
}

- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 4;
            break;
            
        case 1:
            return 2;
            break;
            
        case 2:
            return 1;
            break;
            
        case 3:
            return 1;
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            if (showBirthDateCell)
            {
                height = 300.0f;
            }
            else
            {
                height = 0.0f;
            }
        }
        else if (indexPath.row == 3)
        {
            if (showClinicDateCell)
            {
                height = 300.0f; //216
            }
            else
            {
                height = 0.0f;
            }
        }
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return NSLocalizedString(@"Dates", @"as in calendar dates");
            break;
            
        case 1:
            return NSLocalizedString(@"Measurements", @"as in height, weight");
            break;
            
        case 2:
            return NSLocalizedString(@"Sex", @"as in male or female");
            break;
            
        case 3:
            return NSLocalizedString(@"Calculate", @"calculate the results");
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UITableViewCell *returnCell = nil;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"birthDate";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = @"Date of Birth";
            cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
            
            cell.detailTextLabel.text = theDelegate.resultDOBDateString;
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"birthDatePicker";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            if (showBirthDateCell)
            {
                self.birthDatePicker.frame = CGRectMake((screenWidth - 320)/2, 0.0f, 320.0f, 300.0f);
                
                if (theDelegate.resultClinicDate)
                {
                    // set the minimum date to 18y before clinic date
                    NSCalendar *myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                    NSDateComponents *dateComponents = [NSDateComponents new];
                    
                    [dateComponents setYear:-18];
                    NSDate *targetDate = [myCalendar dateByAddingComponents:dateComponents toDate:theDelegate.resultClinicDate options:0];
                    self.birthDatePicker.minimumDate = targetDate;
                    
                    // set maximum
                    self.birthDatePicker.maximumDate = theDelegate.resultClinicDate;
                }
                
                [cell.contentView addSubview:self.birthDatePicker];
            }
            
            returnCell = cell;
        }
        else if (indexPath.row == 2)
        {
            static NSString *CellIdentifier = @"ClinicDate";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = NSLocalizedString(@"Clinic Date", @"Date of the clinic");
            cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
            
            cell.detailTextLabel.text = theDelegate.resultClinicDateString;
            
            returnCell = cell;
        }
        else if (indexPath.row == 3)
        {
            static NSString *CellIdentifier = @"ClinicDatePicker";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            if (showClinicDateCell)
            {
                self.clinicDatePicker.frame = CGRectMake((screenWidth - 320)/2, 0.0f, 320.0f, 300.0f);
                
                // set maximum date
                self.clinicDatePicker.maximumDate = [NSDate date];
                
                [cell.contentView addSubview:self.clinicDatePicker];
            }
            
            returnCell = cell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"HeightCell";
            CBMeasurementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[CBMeasurementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.text = NSLocalizedString(@"Height", @"Height of the patient");
            cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
            
            cell.measurementTextField.placeholder = @"cm";
            cell.measurementTextField.delegate = self;
            cell.measurementTextField.tag = 10;
            
            if (theDelegate.resultHeight)
            {
                cell.measurementTextField.text = [NSString stringWithFormat:@"%@ cm",theDelegate.resultHeight];
            }
            else cell.measurementTextField.text = @"";
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"WeightCell";
            CBMeasurementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[CBMeasurementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.text = NSLocalizedString(@"Weight", @"Weight of the patient");
            cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
            
            cell.measurementTextField.placeholder = @"kg";
            cell.measurementTextField.delegate = self;
            cell.measurementTextField.tag = 20;
            
            if (theDelegate.resultWeight)
            {
                cell.measurementTextField.text = [NSString stringWithFormat:@"%@ kg",theDelegate.resultWeight];
            }
            else cell.measurementTextField.text = @"";
            
            returnCell = cell;
        }
    }
    else if (indexPath.section == 2)
    {
        static NSString *CellIdentifier = @"SexCell";
        CBSexChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[CBSexChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        AppDelegate *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if ([theDelegate.maleFemale isEqualToString:@"Male"])
        {
            // male = TRUE;
            cell.sexSegmentedControl.selectedSegmentIndex = 0;
        }
        else if ([theDelegate.maleFemale isEqualToString:@"Female"])
        {
            // male = FALSE;
            cell.sexSegmentedControl.selectedSegmentIndex = 1;
        }
        
        [cell.sexSegmentedControl addTarget:self
                                     action:@selector(sexChange:)
                           forControlEvents:UIControlEventValueChanged];
        
        returnCell = cell;
    }
    else if (indexPath.section == 3)
    {
        static NSString *CellIdentifier = @"CalculateCell";
        CBCalculateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[CBCalculateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            [cell.calculateButton addTarget:self
                                     action:@selector(calculateResults)
                           forControlEvents:UIControlEventTouchUpInside];
            
            [cell.clearButton addTarget:self
                                 action:@selector(clearValues)
                       forControlEvents:UIControlEventTouchUpInside];
            
            [cell.infoButton addTarget:self
                                action:@selector(showGuideline)
                      forControlEvents:UIControlEventTouchUpInside];
        }
        
        returnCell = cell;
    }
    
    return returnCell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ensure that only the date cells can be selected
    
    NSIndexPath *path = nil;
    
    if (indexPath.section == 0)
        path = indexPath;
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // dismiss keyboard, if active
    [self dismissDecimalPadKeyboard];
    
    // code to update the UITableView to display the DatePickers in a nice way
    if (indexPath.section == 0) // should only be able to select section 0, but just in case...
    {
        if (indexPath.row == 0)
        {
            // first check if ClinicDate picker is showing
            if (showClinicDateCell)
            {
                // if it is, then close it by setting toggle to 'NO'
                showClinicDateCell = NO;
                
                // and updating fade from table
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
                [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            }
            
            // toggle birthdate
            showBirthDateCell = !showBirthDateCell;
            
            // and load onto screen
            [self updateDOBDatePickerCell];
        }
        else if (indexPath.row == 2)
        {
            // same as above
            if (showBirthDateCell)
            {
                showBirthDateCell = NO;
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
                [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            }
            
            showClinicDateCell = !showClinicDateCell;
            
            // update ClinicDatePicker cell
            [self updateClinicDatePickerCell];
        }
    }
    
    [self updateCalculateButton];
}

- (void)updateDOBDatePickerCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)updateClinicDatePickerCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // close any UIDatePickers that are displayed
    [self closeAllDatePickers];
    
    // this code simply clears both the UITextField text and global variables
    
    AppDelegate *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.navigationItem.rightBarButtonItem = self.doneButtonItem;
    
    NSIndexPath *heightIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *weightIndex = [NSIndexPath indexPathForRow:1 inSection:1];
    
    if (textField.tag == 10)
    {
        // this is height
        CBMeasurementCell *measurementCell = (CBMeasurementCell *)[self.tableView cellForRowAtIndexPath:heightIndex];
        
        // clear text in memory and on screen
        theDelegate.resultHeight =  nil;
        measurementCell.measurementTextField.text = [NSString stringWithFormat:@""];
    }
    else if (textField.tag == 20)
    {
        // this is weight
        CBMeasurementCell *measurementCell = (CBMeasurementCell *)[self.tableView cellForRowAtIndexPath:weightIndex];
        
        theDelegate.resultWeight = nil;
        measurementCell.measurementTextField.text = [NSString stringWithFormat:@""];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (newText.length > 6) // ensure not longer than 6 digits
    {
        return NO;
    }
    else if (newText.length == 1)
    {
        // ensure user in not entering a decimal place first
        if ([string isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
        {
            return NO;
        }
    }
    else
    {
        // count number of decimal points in value
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setLocale:[NSLocale currentLocale]];
        
        NSArray  *arrayOfString = [newText componentsSeparatedByString:numberFormatter.decimalSeparator];
        
        if ([arrayOfString count] > 2)
            return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // this code...
    
    AppDelegate *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSIndexPath *heightIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *weightIndex = [NSIndexPath indexPathForRow:1 inSection:1];
    
    if (textField.tag == 10)
    {
        // this is height
        CBMeasurementCell *measurementCell = (CBMeasurementCell *)[self.tableView cellForRowAtIndexPath:heightIndex];
        
        if (![measurementCell.measurementTextField.text isEqualToString:@""])
        {
            theDelegate.resultHeight =  (NSNumber *)measurementCell.measurementTextField.text;
            
            measurementCell.measurementTextField.text = [NSString stringWithFormat:@"%@ cm", theDelegate.resultHeight];
        }
        
    }
    else if (textField.tag == 20)
    {
        // this is weight
        CBMeasurementCell *measurementCell = (CBMeasurementCell *)[self.tableView cellForRowAtIndexPath:weightIndex];
        
        if (![measurementCell.measurementTextField.text isEqualToString:@""])
        {
            theDelegate.resultWeight = (NSNumber *)measurementCell.measurementTextField.text;
            
            measurementCell.measurementTextField.text = [NSString stringWithFormat:@"%@ kg", theDelegate.resultWeight];
        }
    }
    
    [self updateCalculateButton];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"calculateResults"])
    {
        AppDelegate *theDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UKAnthropometry *mathsMethods = [UKAnthropometry new];
        
        // perform calculations
        theDelegate.resultDecimalAge = [mathsMethods calculateDecimalAgeFromDOB:theDelegate.resultDOBDate
                                                                usingClinicDate:theDelegate.resultClinicDate];
        
        theDelegate.resultCalendarAge = [mathsMethods calendarAgeFromDOB:theDelegate.resultDOBDate
                                                         usingClinicDate: theDelegate.resultClinicDate];
        
        
        theDelegate.bmi = [mathsMethods calculateBMIFromHeight:theDelegate.resultHeight
                                                     andWeight:theDelegate.resultWeight];
        
        theDelegate.resultArray = [mathsMethods calculateSDSandCentileAndPctmBMIandExpectedWeightsFromDecimalAge:theDelegate.resultDecimalAge
                                                                                                          andSex:theDelegate.maleFemale
                                                                                                       andHeight:theDelegate.resultHeight
                                                                                                       andWeight:theDelegate.resultWeight
                                                                                                          andBMI:theDelegate.bmi];
    }
}

@end
