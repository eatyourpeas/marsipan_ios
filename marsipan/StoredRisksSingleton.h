//
//  storedRisksSingleton.h
//  marsipan
//
//  Created by Simon Chapman on 05/04/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoredRisksSingleton : NSObject

@property(nonatomic,strong) NSMutableArray *storedRisksArray;

+ (StoredRisksSingleton *)getInstance;

- (void)saveInStoredRisksSingletonAtCategoryIndex:(NSNumber *)categoryIndex SavedColour:(NSNumber *)colour;
- (NSMutableArray *)getStoredRisksArray;
- (NSNumber *)returnChosenColourForCategory:(NSNumber*)category;


@end
