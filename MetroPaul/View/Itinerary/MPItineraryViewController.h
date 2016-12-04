//
//  MPItineraryViewController.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 06/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPLoadOverlay.h"

@interface MPItineraryViewController : UIViewController
@property (nonatomic, strong) MPLoadOverlay *loadOverlay;

@property(nonatomic, getter=isLoading) BOOL loading;

@end
