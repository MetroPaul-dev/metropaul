//
//  MPGlobalItineraryManager.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPGlobalItineraryManager.h"
#import "MPStopArea.h"
#import "MPItinerary.h"
#import "MPGlobalItinerary.h"

#define NB_MAX_ITINERARY 4

@interface MPGlobalItineraryManager () <SKRoutingDelegate>
@property(nonatomic) BOOL itineraryMetroIsFinish;
@property(nonatomic) NSInteger nbItinerarySkobbler;

@end

@implementation MPGlobalItineraryManager

+ (instancetype)sharedManager {
    static MPGlobalItineraryManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
        _sharedManager.addressToReplace = MPAddressToReplaceNull;
    });
    
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [SKRoutingService sharedInstance].routingDelegate = self;
        self.globalItineraryList = [NSMutableArray array];
        self.itineraryMetroIsFinish = NO;
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reset {
    self.startAddress = nil;
    self.destinationAddress = nil;
    self.globalItineraryList = [NSMutableArray array];
}

- (void)setAddress:(MPAddress*)address {
    switch (self.addressToReplace) {
        case MPAddressToReplaceStart: {
            self.addressToReplace = MPAddressToReplaceNull;
            self.startAddress = address;
            break;
        }
        case MPAddressToReplaceDestination: {
            self.destinationAddress = address;
            self.addressToReplace = MPAddressToReplaceNull;
            break;
        }
        case MPAddressToReplaceNull: {
            if (self.startAddress == nil) {
                self.startAddress = address;
            } else if (self.destinationAddress == nil) {
                self.destinationAddress = address;
            }
        default:
            break;
        }
    }
}

- (void)calculAllItinerary {
    self.itineraryMetroIsFinish = NO;
    self.nbItinerarySkobbler = 0;
    
    if (self.startAddress.stopArea == nil) {
        [self.startAddress findStopAreasAround];
        self.startAddress.itineraryToStopAreas = [NSMutableArray array];
    }
    if (self.destinationAddress.stopArea == nil) {
        [self.destinationAddress findStopAreasAround];
        self.destinationAddress.itineraryToStopAreas = [NSMutableArray array];
    }
    
    if (self.startAddress.stopAreas.count > 0) {
        MPStopArea *stopArea = [self.startAddress.stopAreas firstObject];
        //        [self.startAddress.itineraryToStopAreas addObject:[NSMutableArray array]];
        [self calculItinerarySkobbler:SKRoutePedestrian from:self.startAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
    } else if (self.destinationAddress.stopAreas.count > 0) {
        MPStopArea *stopArea = [self.destinationAddress.stopAreas firstObject];
        //        [self.destinationAddress.itineraryToStopAreas addObject:[NSMutableArray array]];
        [self calculItinerarySkobbler:SKRoutePedestrian from:self.destinationAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
    } else {
        [self calculAllMetroItinerary];
        
    }
}

- (void)calculItinerarySkobbler:(SKRouteMode)routeMode from:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to {
    SKRouteSettings* route = [[SKRouteSettings alloc]init];
    route.startCoordinate=from;
    route.destinationCoordinate=to;
    route.shouldBeRendered = YES; // If NO, the route will not be rendered.
    route.maximumReturnedRoutes = 1;
    SKRouteRestrictions routeRestrictions = route.routeRestrictions;
    routeRestrictions.avoidHighways = YES;
    route.routeRestrictions = routeRestrictions;
    
    route.routeMode = routeMode;
    [[SKRoutingService sharedInstance] calculateRoute:route];
}

- (void)traitementCallbackRoutingService:(SKRouteInformation *)routeInformation {
    // Itineraire 100% skobbler
    if (self.itineraryMetroIsFinish) {
        MPGlobalItinerary *globalItinerary = [[MPGlobalItinerary alloc] init];
        globalItinerary.startStopArea = nil;
        globalItinerary.startRouteInformation = routeInformation;
        globalItinerary.destinationRouteInformation = nil;
        globalItinerary.destinationStopArea = nil;
        globalItinerary.itineraryMetro = nil;
        [self.globalItineraryList addObject:globalItinerary];
        self.nbItinerarySkobbler++;
        [self calculItineraryFullSkobbler];
        
    } else {
        if (self.startAddress.itineraryToStopAreas.count < self.startAddress.stopAreas.count) {
            [self.startAddress.itineraryToStopAreas addObject:routeInformation];
            // On repart d'un nouveau StopArea
            if (self.startAddress.itineraryToStopAreas.count < self.startAddress.stopAreas.count) {
                MPStopArea *stopArea = [self.startAddress.stopAreas objectAtIndex:self.startAddress.itineraryToStopAreas.count];
                [self calculItinerarySkobbler:SKRoutePedestrian from:self.startAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
            } else if (self.destinationAddress.stopAreas.count > 0) {
                MPStopArea *stopArea = [self.destinationAddress.stopAreas firstObject];
                [self calculItinerarySkobbler:SKRoutePedestrian from:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue]) to:self.destinationAddress.coordinate];
            } else {
                [self calculAllMetroItinerary];
            }
        } else if (self.destinationAddress.itineraryToStopAreas.count < self.destinationAddress.stopAreas.count) {
            [self.destinationAddress.itineraryToStopAreas addObject:routeInformation];
            
            // On repart d'un nouveau StopArea
            if (self.destinationAddress.itineraryToStopAreas.count < self.destinationAddress.stopAreas.count) {
                MPStopArea *stopArea = [self.destinationAddress.stopAreas objectAtIndex:self.destinationAddress.itineraryToStopAreas.count];
                [self calculItinerarySkobbler:SKRoutePedestrian from:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue]) to:self.destinationAddress.coordinate];
            } else {
                [self calculAllMetroItinerary];
                
            }
        } else {
            [self calculAllMetroItinerary];
            
        }
    }
}

#pragma mark - SKRoutingDelegate

- (void)routingService:(SKRoutingService *)routingService didFinishRouteCalculationWithInfo:(SKRouteInformation *)routeInformation {
    [self traitementCallbackRoutingService:routeInformation];
}

- (void)routingService:(SKRoutingService *)routingService didFailWithErrorCode:(SKRoutingErrorCode)errorCode {
    NSLog(@"Route calculation failed.");
    
    if (self.itineraryMetroIsFinish) {
        self.nbItinerarySkobbler++;
        [self calculItineraryFullSkobbler];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifItineraryCalculFailed object:nil];
        [self traitementCallbackRoutingService:[[SKRouteInformation alloc] init]];
    }
}

- (void)calculAllMetroItinerary {
    self.globalItineraryList = [NSMutableArray array];
    if (self.startAddress.stopArea == nil) {
        for (int i = 0; i < self.startAddress.stopAreas.count; i++) {
            if ([[self.startAddress.itineraryToStopAreas objectAtIndex:i] routeID] == 0) {
                continue;
            }
            MPStopArea *startStopArea = [self.startAddress.stopAreas objectAtIndex:i];
            if (self.destinationAddress.stopArea == nil) {
                for (int j = 0; j < self.destinationAddress.stopAreas.count; j++) {
                    if ([[self.destinationAddress.itineraryToStopAreas objectAtIndex:j] routeID] == 0) {
                        continue;
                    }
                    MPStopArea *destinationStopArea = [self.destinationAddress.stopAreas objectAtIndex:j];
                    MPItinerary *itineraire = [MPItinerary findByStartStopAreaId:startStopArea.id_stop_area destinationId:destinationStopArea.id_stop_area];
                    if (itineraire != nil && [itineraire containsPublicTransport]) {
                        MPGlobalItinerary *globalItinerary = [[MPGlobalItinerary alloc] init];
                        globalItinerary.startStopArea = startStopArea;
                        globalItinerary.startRouteInformation = [self.startAddress.itineraryToStopAreas objectAtIndex:i];
                        globalItinerary.destinationRouteInformation = [self.destinationAddress.itineraryToStopAreas objectAtIndex:j];
                        globalItinerary.destinationStopArea = destinationStopArea;
                        globalItinerary.itineraryMetro = itineraire;
                        [self.globalItineraryList addObject:globalItinerary];
                    }
                }
            } else {
                MPItinerary *itineraire = [MPItinerary findByStartStopAreaId:startStopArea.id_stop_area destinationId:self.destinationAddress.stopArea.id_stop_area];
                if (itineraire != nil && [itineraire containsPublicTransport]) {
                    MPGlobalItinerary *globalItinerary = [[MPGlobalItinerary alloc] init];
                    globalItinerary.startStopArea = startStopArea;
                    globalItinerary.startRouteInformation = [self.startAddress.itineraryToStopAreas objectAtIndex:i];
                    globalItinerary.destinationRouteInformation = nil;
                    globalItinerary.destinationStopArea = self.destinationAddress.stopArea;
                    globalItinerary.itineraryMetro = itineraire;
                    [self.globalItineraryList addObject:globalItinerary];
                }
            }
        }
    } else {
        if (self.destinationAddress.stopArea == nil) {
            for (int j = 0; j < self.destinationAddress.stopAreas.count; j++) {
                if ([[self.destinationAddress.itineraryToStopAreas objectAtIndex:j] routeID] == 0) {
                    continue;
                }
                MPStopArea *destinationStopArea = [self.destinationAddress.stopAreas objectAtIndex:j];
                MPItinerary *itineraire = [MPItinerary findByStartStopAreaId:self.startAddress.stopArea.id_stop_area destinationId:destinationStopArea.id_stop_area];
                if (itineraire != nil && [itineraire containsPublicTransport]) {
                    MPGlobalItinerary *globalItinerary = [[MPGlobalItinerary alloc] init];
                    globalItinerary.startStopArea = self.startAddress.stopArea;
                    globalItinerary.startRouteInformation = nil;
                    globalItinerary.destinationRouteInformation = [self.destinationAddress.itineraryToStopAreas objectAtIndex:j];
                    globalItinerary.destinationStopArea = destinationStopArea;
                    globalItinerary.itineraryMetro = itineraire;
                    [self.globalItineraryList addObject:globalItinerary];
                }
            }
        } else {
            MPItinerary *itineraire = [MPItinerary findByStartStopAreaId:self.startAddress.stopArea.id_stop_area destinationId:self.destinationAddress.stopArea.id_stop_area];
            if (itineraire != nil && [itineraire containsPublicTransport]) {
                MPGlobalItinerary *globalItinerary = [[MPGlobalItinerary alloc] init];
                globalItinerary.startStopArea = self.startAddress.stopArea;
                globalItinerary.startRouteInformation = nil;
                globalItinerary.destinationRouteInformation = nil;
                globalItinerary.destinationStopArea = self.destinationAddress.stopArea;
                globalItinerary.itineraryMetro = itineraire;
                [self.globalItineraryList addObject:globalItinerary];
            }
        }
    }
    
    
    
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"duration" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.globalItineraryList = [NSMutableArray arrayWithArray:[self.globalItineraryList sortedArrayUsingDescriptors:sortDescriptors]];
    
    if (self.globalItineraryList.count > NB_MAX_ITINERARY) {
        self.globalItineraryList = [NSMutableArray arrayWithArray:[self.globalItineraryList subarrayWithRange:NSMakeRange(0, NB_MAX_ITINERARY)]];
    }
    
    self.itineraryMetroIsFinish = YES;
    [self calculItineraryFullSkobbler];
}

- (void)calculItineraryFullSkobbler {
    CLLocationCoordinate2D startCoordinate;
    if (self.startAddress.stopArea == nil) {
        startCoordinate = self.startAddress.coordinate;
    } else {
        startCoordinate = CLLocationCoordinate2DMake([self.startAddress.stopArea.latitude floatValue], [self.startAddress.stopArea.longitude floatValue]);
    }
    
    CLLocationCoordinate2D destinationCoordinate;
    if (self.destinationAddress.stopArea == nil) {
        destinationCoordinate = self.destinationAddress.coordinate;
    } else {
        destinationCoordinate = CLLocationCoordinate2DMake([self.destinationAddress.stopArea.latitude floatValue], [self.destinationAddress.stopArea.longitude floatValue]);
    }
    switch (self.nbItinerarySkobbler) {
        case 0:
            [self calculItinerarySkobbler:SKRoutePedestrian from:startCoordinate to:destinationCoordinate];
            break;
        case 1:
            [self calculItinerarySkobbler:SKRouteCarFastest from:startCoordinate to:destinationCoordinate];
            break;
        case 2:
            [self calculItinerarySkobbler:SKRouteBicycleFastest from:startCoordinate to:destinationCoordinate];
            break;
        case 3: {
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"duration" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            self.globalItineraryList = [NSMutableArray arrayWithArray:[self.globalItineraryList sortedArrayUsingDescriptors:sortDescriptors]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifItineraryCalculated object:nil];
            NSLog(@"Calcul itinéraire terminé !");
            break;
        }
        default:
            break;
    }
}


@end
