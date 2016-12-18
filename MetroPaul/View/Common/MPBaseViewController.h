//
//  MPBaseViewController.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 18/12/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPLoadOverlay.h"
#import "MPRevealController.h"

@interface MPBaseViewController : UIViewController
@property (nonatomic, strong) MPLoadOverlay *loadOverlay;
@property(nonatomic, getter=isLoading) BOOL loading;
@end
