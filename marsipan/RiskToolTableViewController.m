//
//  RiskToolTableViewController.m
//  marsipan
//
//  Created by Simon Chapman on 11/02/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import "RiskToolTableViewController.h"
#import "RiskToolDetailViewController.h"
#import "StoredRisksSingleton.h"

@interface RiskToolTableViewController ()
{
    NSInteger chosenRow;
}

@property (nonatomic, strong) UIBarButtonItem *clearButtonItem;

@end

@implementation RiskToolTableViewController

#define StoredRisks (StoredRisksSingleton *)[StoredRisksSingleton getInstance]


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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Risk Assessment";
    
    self.clearButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Clear", @"Clear the risks")
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(clearButtonPressed:)];
    
    // default
    self.clearButtonItem.enabled = FALSE;
    
    for (int i = 0; i < 14; i++)
    {
        if ([[StoredRisks returnChosenColourForCategory:[NSNumber numberWithInteger:i] ]intValue] < 4)
        {
            self.clearButtonItem.enabled = TRUE;
        }
    }
    
    self.navigationItem.rightBarButtonItem = self.clearButtonItem;
    
    Risk *risksForTable = [[Risk alloc]init];
    self.marsipanCategories = risksForTable.marsipanCategories;
}

- (void)clearButtonPressed:(UIBarButtonItem *)sender
{
    for (int i = 0; i < 14; i++)
    {
        NSNumber *index = [NSNumber numberWithInt:i];
        
        [StoredRisks saveInStoredRisksSingletonAtCategoryIndex:index SavedColour:[NSNumber numberWithInt:4]];
    }
    
    self.clearButtonItem.enabled = FALSE;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Marsipan Risk Categories";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.marsipanCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"marsipanRiskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
   // int chosenColour = [[self.chosenRisks objectAtIndex:indexPath.row]intValue];
    
    int chosenColour = [[StoredRisks returnChosenColourForCategory:[NSNumber numberWithInteger: indexPath.row] ]intValue];
    
    
    if (chosenColour==0) {
        cell.contentView.backgroundColor = [UIColor redColor];
    }
    else if (chosenColour ==1){
        cell.contentView.backgroundColor = [UIColor orangeColor];
    }
    else if (chosenColour==2){
        cell.contentView.backgroundColor = [UIColor greenColor];
    }
    else if (chosenColour==3){
        cell.contentView.backgroundColor = [UIColor blueColor];
    }
    else if (chosenColour==4){
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.marsipanCategories objectAtIndex:indexPath.row];
    [cell sizeToFit];
    [cell.textLabel setNumberOfLines:0];
    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

//In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"riskDetailSegue"]) {
        
     //   UITableViewCell *myCell = [[UITableViewCell alloc]init];
        NSIndexPath *newIndex = [[NSIndexPath alloc]init];
        newIndex = [self.tableView indexPathForSelectedRow];
       
        chosenRow = newIndex.row;
        
        RiskToolDetailViewController *rtdvc = [segue destinationViewController];
        rtdvc.rowSelected = chosenRow;
        
        rtdvc.title = [self.marsipanCategories objectAtIndex:chosenRow];
        
        rtdvc.delegate = self;
        
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


-(void) setTableViewCellBackgroundColourToRiskColour:(UIColor *)riskColour{
    
}

-(void)addRiskColourToArray:(NSNumber *)riskColour forRiskCategory:(NSNumber *)category{
    
    //update the data model with the selection
    
    [StoredRisks saveInStoredRisksSingletonAtCategoryIndex:category SavedColour:riskColour];
    
  //  [self.chosenRisks replaceObjectAtIndex:category withObject:riskColour];
    
    self.clearButtonItem.enabled = TRUE;
    
    [self.tableView reloadData];
}

- (IBAction)didSelectRisk:(id)sender {
    
}


@end
