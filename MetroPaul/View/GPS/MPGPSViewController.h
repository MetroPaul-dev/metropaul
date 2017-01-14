//
//  MPGPSViewController.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 08/01/2017.
//  Copyright © 2017 Antoine Cointepas. All rights reserved.
//

#import "MPBaseViewController.h"
#import <SKMaps/SKMaps.h>


@interface MPGPSViewController : MPBaseViewController
@property(nonatomic) CLLocationCoordinate2D start;
@property(nonatomic) CLLocationCoordinate2D destination;
@property(nonatomic) SKRouteMode routeMode;
@end
