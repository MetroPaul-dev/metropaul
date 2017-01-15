//
//  MPGPSViewController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 08/01/2017.
//  Copyright © 2017 Antoine Cointepas. All rights reserved.
//

#import "MPGPSViewController.h"
#import <SKMaps/SKMapView.h>
#import <SKMaps/SKMapScaleView.h>
#import <SKMaps/SKAnnotation.h>
#import <SKMaps/SKPositionerService.h>
#import <SKMaps/SKRoutingService.h>
#import <SKMaps/SKAnimationSettings.h>
#import <SKMaps/SKViaPoint.h>

#import <SDKTools/Navigation/SKTNavigationManager+Styles.h>
#import <SDKTools/Navigation/SKTNavigationManager+Settings.h>
#import <SDKTools/Navigation/SKTNavigationManager.h>
#import <SDKTools/Navigation/SKTNavigationUtils.h>

const int kStartAnnotationId = 0;
const int kEndAnnotationId = 1;
const int kViapointAnnotationId = 2;

@interface MPGPSViewController () <SKMapViewDelegate, SKRoutingDelegate, SKTNavigationManagerDelegate>

@property (nonatomic, strong) IBOutlet  SKMapView *mapView;
@property (nonatomic, strong) SKTNavigationManager *navigationManager;
@property (nonatomic, strong) SKTNavigationConfiguration *configuration;

@end

@implementation MPGPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.configuration = [SKTNavigationConfiguration defaultConfiguration];
    self.configuration.navigationType = SKNavigationTypeSimulation;
    self.configuration.simulationLogPath = [[NSBundle mainBundle] pathForResource:@"Seattle" ofType:@"log"];
    self.configuration.startCoordinate = self.start;
    self.configuration.destination = self.destination;
    
    [self addMapView];
    
    [self updateAnnotations];
    
    self.navigationManager = [[SKTNavigationManager alloc] initWithMapView:self.mapView];
    [self.view addSubview:self.navigationManager.mainView];
    self.navigationManager.mainView.hidden = YES;
    self.navigationManager.delegate = self;
    self.navigationManager.prefferedDisplayMode = SKMapDisplayMode3D;
    self.navigationController.navigationBar.translucent = NO;
    
//    [SKRoutingService sharedInstance].routingDelegate = self; // set for receiving routing callbacks
//    [SKRoutingService sharedInstance].navigationDelegate = self;// set for receiving navigation callbacks
//    [SKRoutingService sharedInstance].mapView = self.mapView; // use the map view for route rendering
//    
//    SKRouteSettings* route = [[SKRouteSettings alloc]init];
//    route.startCoordinate = self.start;
//    route.destinationCoordinate = self.destination;
//    route.shouldBeRendered = YES; // If NO, the route will not be rendered.
//    route.maximumReturnedRoutes = 1;
//    SKRouteRestrictions routeRestrictions = route.routeRestrictions;
//    routeRestrictions.avoidHighways = YES;
//    route.routeRestrictions = routeRestrictions;
//    route.requestAdvices = YES;
//    
//    route.routeMode = self.routeMode;
//    [[SKRoutingService sharedInstance] calculateRoute:route];
    


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
    
    //    [self.navigationManager startNavigationWithConfiguration:self.configuration];
    [self.navigationManager startFreeDriveWithConfiguration:self.configuration];
    self.navigationManager.mainView.hidden = NO;
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

- (void)addMapView {
    self.mapView.delegate = self;
    self.mapView.mapScaleView.hidden = YES;
    self.mapView.settings.rotationEnabled = NO;
    self.mapView.settings.showCurrentPosition = YES;
    SKCoordinateRegion region;
    region.center = self.start;
    region.zoomLevel = 12.0;
    self.mapView.visibleRegion = region;
}

- (void)updateAnnotations {
    if (![SKTNavigationUtils locationIsZero:_configuration.startCoordinate]) {
        SKAnnotation *annotation = [SKAnnotation annotation];
        annotation.location = _configuration.startCoordinate;
        annotation.identifier = kStartAnnotationId;
        annotation.annotationType = SKAnnotationTypeGreen;
        [self.mapView addAnnotation:annotation withAnimationSettings:[SKAnimationSettings animationSettings]];
    } else {
        [self.mapView removeAnnotationWithID:kStartAnnotationId];
    }
    
    if (![SKTNavigationUtils locationIsZero:_configuration.destination]) {
        SKAnnotation *annotation = [SKAnnotation annotation];
        annotation.location = _configuration.destination;
        annotation.identifier = kEndAnnotationId;
        annotation.annotationType = SKAnnotationTypeRed;
        [self.mapView addAnnotation:annotation withAnimationSettings:[SKAnimationSettings animationSettings]];
    } else {
        [self.mapView removeAnnotationWithID:kEndAnnotationId];
    }
    
    if (self.configuration.viaPoints.count > 0) {
        SKViaPoint *point = _configuration.viaPoints[0];
        SKAnnotation *annotation = [SKAnnotation annotation];
        annotation.location = point.coordinate;
        annotation.identifier = kViapointAnnotationId;
        annotation.annotationType = SKAnnotationTypePurple;
        [self.mapView addAnnotation:annotation withAnimationSettings:[SKAnimationSettings animationSettings]];
    } else {
        [self.mapView removeAnnotationWithID:kViapointAnnotationId];
    }
}

- (void)removeAnnotations {
    [self.mapView removeAnnotationWithID:kStartAnnotationId];
    [self.mapView removeAnnotationWithID:kEndAnnotationId];
}

- (void)navigationManagerDidStopNavigation:(SKTNavigationManager *)manager withReason:(SKTNavigationStopReason)reason {
    if (reason == SKTNavigationStopReasonRoutingFailed) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Route calculation failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }
    _mapView.delegate = self;
//    _menu.navigationStyle = NO;
//    _centerButton.hidden = NO;
//    _menu.frameY = 40 * kSizeMultiplier;
    [self updateAnnotations];
}

@end
