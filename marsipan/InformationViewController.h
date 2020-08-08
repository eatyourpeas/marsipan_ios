//
//  InformationViewController.h
//  marsipan
//
//  Created by Simon Chapman on 23/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *infoWebView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeInfoButton;
-(IBAction)closeInfo:(id)sender;

@end
