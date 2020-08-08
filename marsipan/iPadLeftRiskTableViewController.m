//
//  iPadLeftRiskTableViewController.m
//  marsipan
//
//  Created by Simon Chapman on 05/04/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import "iPadLeftRiskTableViewController.h"
#import "StoredRisksSingleton.h"
#import "RightRiskViewController.h"


@interface iPadLeftRiskTableViewController ()

#define StoredRisks (StoredRisksSingleton *)[StoredRisksSingleton getInstance]

@end

@implementation iPadLeftRiskTableViewController



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
    
    self.risk = [[Risk alloc]init];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    //set selection to top of table
    
    NSIndexPath *myPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell = [self.tableView cellForRowAtIndexPath:myPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [self.delegate selectedRiskCategory:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.risk.marsipanCategories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarsipanRiskIdentifier" forIndexPath:indexPath];
    
    NSNumber *chosenColour = [StoredRisks returnChosenColourForCategory:[NSNumber numberWithInteger:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    // change background color of selected cell
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectedBackgroundView:bgColorView];

    
    if ([chosenColour integerValue] == 0) {
        cell.contentView.backgroundColor = [UIColor redColor];
    }
    else if ([chosenColour integerValue] ==1){
        cell.contentView.backgroundColor = [UIColor orangeColor];
    }
    else if ([chosenColour integerValue] ==2){
        cell.contentView.backgroundColor = [UIColor greenColor];
    }
    else if ([chosenColour integerValue] ==3){
        cell.contentView.backgroundColor = [UIColor blueColor];
    }
    else if ([chosenColour integerValue]==4){
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.risk.marsipanCategories objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate) {
        
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell = [tableView cellForRowAtIndexPath:indexPath];
        
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [self.delegate selectedRiskCategory:[NSNumber numberWithInteger: indexPath.row]];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
}

#pragma mark Colour Selection Delegate Methods

-(void)selectedColour:(NSNumber *)colour forCategory:(NSNumber *)category{
    
    NSIndexPath *myPath = [NSIndexPath indexPathForRow:[category integerValue] inSection:0];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell = [self.tableView cellForRowAtIndexPath:myPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [self.tableView reloadData];
    
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
