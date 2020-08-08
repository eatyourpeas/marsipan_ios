//
//  AppDelegate.h
//  marsipan
//
//  Created by Simon Chapman on 07/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong) NSMutableArray *resultArray;
@property(nonatomic,strong) NSNumber *bmi;
@property(nonatomic,strong) NSNumber *resultHeight;
@property(nonatomic,strong) NSNumber *resultWeight;
@property(nonatomic,strong) NSNumber *resultDecimalAge;
@property(nonatomic,strong) NSString *resultCalendarAge;
@property(nonatomic, strong) NSDate *resultClinicDate;
@property(nonatomic, strong) NSString *resultClinicDateString;
@property(nonatomic, strong) NSDate *resultDOBDate;
@property(nonatomic, strong) NSString *resultDOBDateString;
@property(nonatomic, strong) NSString *maleFemale;
@property(assign) BOOL resultMale;


@end
