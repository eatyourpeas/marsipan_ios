//
//  PhoneResultsViewController.h
//  marsipan
//
//  Created by Simon Chapman on 16/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneResultsViewController : UITabBarController


@property(nonatomic,strong) NSNumber *resultHeight;
@property(nonatomic,strong) NSNumber *resultWeight;
@property(nonatomic, strong) NSDate *resultClinicDate;
@property(nonatomic, strong) NSDate *resultDOBDate;
@property(assign) BOOL resultMale;
@property(nonatomic, strong) NSArray *measurementCentileAndSDSArray;



@end
