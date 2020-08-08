//
//  Risk.h
//  marsipan
//
//  Created by Simon Chapman on 05/04/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Risk : NSObject

@property(strong,nonatomic) NSArray *marsipanCategories;
@property(strong,nonatomic) NSArray *red;
@property(strong,nonatomic) NSArray *amber;
@property(strong,nonatomic) NSArray *green;
@property(strong,nonatomic) NSArray *blue;
@property(strong,nonatomic) NSArray *textArray;
@property(strong,nonatomic) NSArray *riskColours;
@property(strong,nonatomic) NSDictionary *riskDictionary;
@property(strong,nonatomic) NSMutableArray *chosenRisks;

@property(strong,nonatomic) NSString *riskCategory;
@property(strong, nonatomic)NSString *riskColourAsText;
@property(strong, nonatomic)UIColor *riskColour;
@property(strong, nonatomic)NSString *riskText;

-(NSString*) getRiskTitle: (NSNumber*)riskSelected;
-(NSString*) getRiskTextForRiskColour: (NSNumber*)colour andCategory:(NSNumber*)category;

@end
