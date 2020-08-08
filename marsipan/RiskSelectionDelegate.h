//
//  RiskSelectedProtocol.h
//  marsipan
//
//  Created by Simon Chapman on 05/04/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol RiskSelectionDelegate <NSObject>

@required

-(void) selectedRiskCategory: (NSNumber*)riskCategory;

@end
