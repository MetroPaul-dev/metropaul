//
//  PedestrianNavigationViewController.h
//  FrameworkIOSDemo
//
//  Copyright (c) 2016 Skobbler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SKMaps/SKMaps.h>

@interface PedestrianNavigationViewController : UIViewController
@property(nonatomic) CLLocationCoordinate2D start;
@property(nonatomic) CLLocationCoordinate2D destination;
@property(nonatomic) SKRouteMode routeMode;

@end
