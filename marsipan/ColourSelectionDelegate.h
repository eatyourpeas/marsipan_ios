//
//  ColourSelectionDelegate.h
//  marsipan
//
//  Created by Simon Chapman on 06/04/2014.
//  Copyright (c) 2014 eatyourpeas. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ColourSelectionDelegate <NSObject>

@required

-(void)selectedColour:(NSNumber *)colour forCategory:(NSNumber *)category;

@end
