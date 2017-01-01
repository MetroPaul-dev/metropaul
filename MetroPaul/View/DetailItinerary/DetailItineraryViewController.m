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
#import "MPSectionItinerary.h"

@interface DetailItineraryViewController () <SKMapViewDelegate, SKSearchServiceDelegate, SKRoutingDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet SKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *actualHourLbael;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationHourLabel;

@property(nonatomic, strong) NSMutableArray *openedCell;
@property(nonatomic) NSInteger lastIndex;
@property(nonatomic, strong) NSMutableArray *sectionsItinerary;

@end

@implementation DetailItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.mapView.mapScaleView.hidden = YES;
    
    [SKRoutingService sharedInstance].routingDelegate = self; // set for receiving routing callbacks
    [SKRoutingService sharedInstance].mapView = self.mapView;
    
    self.openedCell = [NSMutableArray array];
    self.lastIndex = 0;
    
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
    self.sectionsItinerary = [NSMutableArray array];
    for (MPSectionItinerary *section in [self.itinerary.itineraryMetro readItinerary]) {
        if (section.type != MPStepItineraryOther && section.type != MPStepItineraryStreet) {
            [self.sectionsItinerary addObject:section];
        }
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH'h'mm"];
    
    self.actualHourLbael.text = [formatter stringFromDate:[NSDate date]];
    self.durationLabel.text = [NSString stringWithFormat:@"%limin", self.itinerary.duration/60];
    self.destinationHourLabel.text = [formatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:self.itinerary.duration]];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return self.itinerary.startRouteInformation == nil ? 0 : 1;
            break;
        }
        case 1: {
            return self.sectionsItinerary.count;
            break;
        }
        case 2: {
            return self.itinerary.destinationRouteInformation == nil ? 0 : 1;
            break;
        }
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            MPWalkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPWalkCell"];
            cell.routeInformation = self.itinerary.startRouteInformation;
            return cell;
            break;
        }
        case 1: {
                MPSectionItinerary *section = self.sectionsItinerary[indexPath.row];
                if (section.type == MPStepItineraryTransport) {
                    MPMetroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPMetroCell"];
                    cell.sectionItinerary = section;
                    return cell;
                } else if (section.type == MPStepItineraryTransfert) {
                    MPMetroChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPMetroChangeCell"];
                    cell.sectionItinerary = section;
                    return cell;
                }
            break;
        }
        case 2: {
            MPWalkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPWalkCell"];
            cell.routeInformation = self.itinerary.destinationRouteInformation;
            return cell;
            break;
        }
        default:
            return [[UITableViewCell alloc] init];
            break;
    }
    return [[UITableViewCell alloc] init];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            // GoToGPS
            break;
        }
        case 1: {
            MPSectionItinerary *section = self.sectionsItinerary[indexPath.row];
            if (section.type == MPStepItineraryTransport) {
                if ([self.openedCell containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
                    [self.openedCell removeObject:[NSNumber numberWithInteger:indexPath.row]];
                    
                } else {
                    [self.openedCell addObject:[NSNumber numberWithInteger:indexPath.row]];
                }
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
        }
        case 2: {
            // GoToGPS
            break;
        }
        default: {
            // GoToGPS
            break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            return 76;
            break;
        }
        case 1: {
            MPSectionItinerary *section = self.sectionsItinerary[indexPath.row];
            if (section.type == MPStepItineraryTransport) {
                if ([self.openedCell containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
                    return 245;
                } else {
                    return 65;
                }
            } else if (section.type == MPStepItineraryTransfert) {
                return 92;
            }
            break;
        }
        case 2: {
            return 76;
            break;
        }
        default:
            return 92;
            break;
    }
    
    return 0;
}

- (void)routingService:(SKRoutingService *)routingService didFinishRouteCalculationWithInfo:(SKRouteInformation*)routeInformation{
    NSLog(@"Route is calculated.");
    [routingService zoomToRouteWithInsets:UIEdgeInsetsZero duration:1]; // zoom to current route
}

- (void)routingServiceDidFailRouteCalculation:(SKRoutingService *)routingService{
    NSLog(@"Route calculation failed.");
}

@end
