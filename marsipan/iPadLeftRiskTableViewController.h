//
//  iPadLeftRiskTableViewController.h
//  marsipan
//
//  Created by Simon Chapman on 05/04/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Risk.h"
#import "RiskSelectionDelegate.h"
#import "ColourSelectionDelegate.h"

@interface iPadLeftRiskTableViewController : UITableViewController<ColourSelectionDelegate>

@property(strong,nonatomic) Risk *risk;
@property(nonatomic,assign) id<RiskSelectionDelegate> delegate;

@end
