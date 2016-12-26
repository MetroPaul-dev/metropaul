//
//  DetailItineraryViewController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 18/12/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "DetailItineraryViewController.h"
#import <SKMaps/SKMaps.h>
#import "MPGlobalItineraryManager.h"
#import "MPWalkCell.h"
#import "MPMetroCell.h"
#import "MPMetroChangeCell.h"

@interface DetailItineraryViewController () <SKMapViewDelegate, SKSearchServiceDelegate, SKRoutingDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet SKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DetailItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.mapView.mapScaleView.hidden = YES;
    
    [SKRoutingService sharedInstance].routingDelegate = self; // set for receiving routing callbacks
    [SKRoutingService sharedInstance].mapView = self.mapView;
    
//    SKRouteSettings* route = [[SKRouteSettings alloc]init];
//    
//    route.startCoordinate = [MPGlobalItineraryManager sharedManager].startAddress.coordinate;
//    route.destinationCoordinate = [MPGlobalItineraryManager sharedManager].destinationAddress.coordinate;
//    route.shouldBeRendered = YES; // If NO, the route will not be rendered.
//    route.routeMode = SKRouteCarFastest;
//    route.maximumReturnedRoutes = 3;
//    SKRouteRestrictions routeRestrictions = route.routeRestrictions;
//    routeRestrictions.avoidHighways = YES;
//    route.routeRestrictions = routeRestrictions;
//    [[SKRoutingService sharedInstance] calculateRoute:route];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [((MPNavigationController*)self.navigationController) prepareNavigationTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"title.youritinerary"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self centerOnCoordinate:[[SKPositionerService sharedInstance] currentCoordinate]];
    
//    SKPolygon *rhombus = [SKPolygon polygon];
//    rhombus.identifier = 2;
//    NSInteger routeId = self.itinerary.startRouteInformation.routeID;
    NSArray *coordinates = [[SKRoutingService sharedInstance] routeCoordinatesForRouteWithId:self.itinerary.startRouteInformation.routeID];
//    rhombus.coordinates = coordinates;
//    rhombus.fillColor = [UIColor redColor];
//    rhombus.strokeColor = [UIColor greenColor];
//    rhombus.borderWidth = 5;
//    rhombus.borderDotsSize = 20;
//    rhombus.borderDotsSpacingSize = 10;
//    rhombus.isMask = NO;
//    [self.mapView addPolygon:rhombus];
    
    //adding a polyline with the same coordinates as the polygon
    SKPolyline *polyline = [SKPolyline polyline];
    polyline.identifier = 3;
    polyline.coordinates = coordinates;
    polyline.fillColor = [UIColor redColor];
    polyline.strokeColor = [UIColor greenColor];
    polyline.lineWidth = 10;
    polyline.backgroundLineWidth = 2;
    polyline.borderDotsSize = 20;
    polyline.borderDotsSpacingSize = 5;
    [self.mapView addPolyline:polyline];
}

- (void)centerOnCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.mapView animateToZoomLevel:15];
    [self.mapView animateToBearing:0.0];
    [self.mapView animateToLocation:coordinate withPadding:CGPointZero duration:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            MPWalkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPWalkCell"];
            return cell;
            break;
        }
        case 1: {
            MPMetroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPMetroCell"];
            return cell;
            break;
        }
        case 2: {
            MPMetroChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPMetroChangeCell"];
            return cell;
            break;
        }
        default: {
            MPMetroChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPMetroChangeCell"];
            return cell;
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            return 76;
            break;
        }
        case 1: {
            return 67;
            break;
        }
        case 2: {
            return 92;
            break;
        }
        default: {
            return 92;
            break;
        }
    }
}

- (void)routingService:(SKRoutingService *)routingService didFinishRouteCalculationWithInfo:(SKRouteInformation*)routeInformation{
    NSLog(@"Route is calculated.");
    [routingService zoomToRouteWithInsets:UIEdgeInsetsZero duration:1]; // zoom to current route
}

- (void)routingServiceDidFailRouteCalculation:(SKRoutingService *)routingService{
    NSLog(@"Route calculation failed.");
}

@end
