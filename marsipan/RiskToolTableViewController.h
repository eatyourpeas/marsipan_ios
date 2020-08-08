//
//  RiskToolTableViewController.h
//  marsipan
//
//  Created by Simon Chapman on 11/02/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiskToolDetailViewController.h"
#import "Risk.h"


@interface RiskToolTableViewController : UITableViewController <RiskToolTableViewDelegate>
@property(strong,nonatomic) NSArray *marsipanCategories;
@property(strong, nonatomic) NSArray *marsipanCriteria;
//@property(strong, nonatomic) NSMutableArray *chosenRisks;
@end
