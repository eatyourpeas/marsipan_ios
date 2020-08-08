//
//  storedRisksSingleton.m
//  marsipan
//
//  Created by Simon Chapman on 05/04/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import "StoredRisksSingleton.h"

@implementation StoredRisksSingleton

static StoredRisksSingleton *storedRisksSingletonInstance;


+ (StoredRisksSingleton *)getInstance
{
    if (storedRisksSingletonInstance == nil)
    {
        storedRisksSingletonInstance = [[StoredRisksSingleton alloc] init];
        
        /// fill the storedRisksArray with Blue risks
        
        storedRisksSingletonInstance.storedRisksArray = [[NSMutableArray alloc]init];
        
        for (int i=0; i < 14; i++)
        {
            [storedRisksSingletonInstance.storedRisksArray addObject:[NSNumber numberWithInt:4]];
        }
    }
    return storedRisksSingletonInstance;
}

-(void)saveInStoredRisksSingletonAtCategoryIndex:(NSNumber *)categoryIndex SavedColour:(NSNumber *) colour
{
    [self.storedRisksArray replaceObjectAtIndex:[categoryIndex intValue] withObject:colour];
}

-(NSMutableArray *)getStoredRisksArray
{
    return self.storedRisksArray;
}

-(NSNumber*)returnChosenColourForCategory:(NSNumber*)category
{
    NSNumber *chosenColour;
    chosenColour = [self.storedRisksArray objectAtIndex:[category intValue]];
    
    return chosenColour;
}

@end
