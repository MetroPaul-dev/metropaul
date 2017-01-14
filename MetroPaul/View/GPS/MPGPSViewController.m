//
//  MPGPSViewController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 08/01/2017.
//  Copyright © 2017 Antoine Cointepas. All rights reserved.
//

#import "MPGPSViewController.h"
//#import <SKTNavigationManager.h>
#import <SKMaps/SKMaps.h>
#import <SKMaps/SKRouteInformation.h>
#import <SDKTools/Navigation/SKTNavigationManager.h>

@interface MPGPSViewController () <SKRoutingDelegate,SKNavigationDelegate>
@property (nonatomic, strong) SKTNavigationManager *navigationManager;
@end

@implementation MPGPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKMapView *mapView = [[SKMapView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f,  CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) )];
    [self.view addSubview:mapView];
    
    [SKRoutingService sharedInstance].routingDelegate = self; // set for receiving routing callbacks
    [SKRoutingService sharedInstance].navigationDelegate = self;// set for receiving navigation callbacks
    [SKRoutingService sharedInstance].mapView = mapView; // use the map view for route rendering
    
    SKRouteSettings* route = [[SKRouteSettings alloc]init];
    route.startCoordinate = self.start;
    route.destinationCoordinate = self.destination;
    route.shouldBeRendered = YES; // If NO, the route will not be rendered.
    route.maximumReturnedRoutes = 1;
    SKRouteRestrictions routeRestrictions = route.routeRestrictions;
    routeRestrictions.avoidHighways = YES;
    route.routeRestrictions = routeRestrictions;
    route.requestAdvices = YES;
    
    route.routeMode = self.routeMode;
    [[SKRoutingService sharedInstance] calculateRoute:route];
    
    self.navigationManager = [[SKTNavigationManager alloc] initWithMapView:mapView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    SKTNavigationConfiguration *config = [SKTNavigationConfiguration defaultConfiguration];
//    config.destination = CLLocationCoordinate2DMake(47.0, 2.3);
//    config.navigationType = SKNavigationTypeReal;
//    config.routeType = SKRouteCarFastest;
//    config.numberOfRoutes = 1;
//    config.distanceFormat = SKDistanceFormatMetric;
//    config.allowBackgroundNavigation = NO;
//    config.destination = self.destination;
//
//    [self.navigationManager startFreeDriveWithConfiguration:config];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SKRoutingService sharedInstance] stopNavigation];
}
- (void)routingService:(SKRoutingService *)routingService didFinishRouteCalculationWithInfo:(SKRouteInformation *)routeInformation {
    NSLog(@"Route is calculated.");
    [routingService zoomToRouteWithInsets:UIEdgeInsetsZero duration:1]; // zooming to currrent route
    
    SKNavigationSettings* navSettings = [SKNavigationSettings navigationSettings];
    navSettings.navigationType=SKNavigationTypeReal;
    navSettings.distanceFormat=SKDistanceFormatMetric;
    navSettings.showStreetNamePopUpsOnRoute=YES;
    [SKRoutingService sharedInstance].mapView.settings.displayMode = SKMapDisplayMode3D;
    [[SKRoutingService sharedInstance]startNavigationWithSettings:navSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
