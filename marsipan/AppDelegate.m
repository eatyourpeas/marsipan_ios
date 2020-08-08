//
//  AppDelegate.m
//  marsipan
//
//  Created by Simon Chapman on 07/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import "AppDelegate.h"
#import "RightRiskViewController.h"
#import "iPadLeftRiskTableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.resultArray = [[NSMutableArray alloc]init];
    self.maleFemale = @"Male";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        // Place iPhone/iPod specific code here...
    } else {
        // Place iPad-specific code here...
        /*
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *leftNavController = [splitViewController.viewControllers objectAtIndex:0];
        iPadLeftRiskTableViewController *leftViewController = (iPadLeftRiskTableViewController *)[leftNavController topViewController];
        RightRiskViewController *rightViewController = [splitViewController.viewControllers objectAtIndex:1];
        
        leftViewController.delegate = rightViewController;
        rightViewController.delegate = leftViewController;
        splitViewController.delegate = rightViewController;
         */
    }
    
    static NSString* const hasRunAppOnceKey = @"hasRunAppOnceKey";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:hasRunAppOnceKey] == NO)
    {
        // Some code you want to run on first use...
        NSLog(@"This is first run");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Junior Marsipan" message:@"This resource is strictly for the use of health care professionals. You will need an Unlock Code to gain access. Please register with an NHS email online at www.marsipan.org.uk and then navigate to the Clinicians' area for further details." preferredStyle:UIAlertControllerStyleAlert]; // 7
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.keyboardType = UIKeyboardTypeNamePhonePad;
        }];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

            UITextField *theTextView = alert.textFields.firstObject;
            NSString *code = theTextView.text;
            theTextView.placeholder = @"Enter the Unlock Code from the Clinician's area ";
            
            if ([code  isEqual: @"DrFrasierCrane"]) {
                
                [defaults setBool:YES forKey:hasRunAppOnceKey];
            } else {
                UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                alertWindow.rootViewController = [[UIViewController alloc] init];
                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                [alertWindow makeKeyAndVisible];
                [alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            }
            
        }]; // 8
        
        [alert addAction:defaultAction]; // 9
        
    //    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
      //      textField.placeholder = @"Lock Code";
       // }]; // 10
        
        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [[UIViewController alloc] init];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
