//
//  MPSectionView.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 14/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SKMaps/SKMaps.h>
#import "MPSectionItinerary.h"

@interface MPSectionView : UIView
@property(nonatomic, strong) SKRouteInformation *routeInformation;
@property(nonatomic, strong) MPSectionItinerary *sectionItinerary;
- (void)reinit;
- (void)isLastSection:(BOOL)last;
- (void)addDuration:(NSInteger)durationToAdd;
@end
