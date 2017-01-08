//
//  MPGPSViewController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 08/01/2017.
//  Copyright © 2017 Antoine Cointepas. All rights reserved.
//

#import "MPGPSViewController.h"
//#import <SKTNavigationManager.h>
#import <SDKTools/Navigation/SKTNavigationManager.h>

@interface MPGPSViewController ()
@property (nonatomic, strong) SKTNavigationManager *navigationManager;
@end

@implementation MPGPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKMapView *mapView = [[SKMapView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f,  CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) )];
    [self.view addSubview:mapView];
    self.navigationManager = [[SKTNavigationManager alloc] initWithMapView:mapView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    SKTNavigationConfiguration *config = [SKTNavigationConfiguration defaultConfiguration];
    config.destination = CLLocationCoordinate2DMake(47.0, 2.3);
    config.navigationType = SKNavigationTypeReal;
    config.routeType = SKRouteCarFastest;
    config.numberOfRoutes = 1;
    config.distanceFormat = SKDistanceFormatMetric;
    config.allowBackgroundNavigation = NO;
    config.destination = self.destination;

    [self.navigationManager startFreeDriveWithConfiguration:config];
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
