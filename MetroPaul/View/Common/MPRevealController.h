//
//  MPRevealController.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 29/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <PKRevealController/PKRevealController.h>
#import "LeftViewController.h"

@interface MPRevealController : PKRevealController

+ (MPRevealController *)sharedInstance;

-(void)showLeftController;
- (void)showFrontViewController;

@end
