//
//  MPGlobalItineraryManager.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPGlobalItineraryManager.h"
#import "MPStopArea.h"

@interface MPGlobalItineraryManager () <SKRoutingDelegate>
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
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setAddress:(MPAddress*)address {
    if (self.startAddress == nil) {
        self.startAddress = address;
    } else if (self.destinationAddress == nil) {
        self.destinationAddress = address;
    } else {
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
            default:
                break;
        }
    }
}

- (void)calculAllItinerary {
    
    if (self.startAddress.stopArea == nil) {
        [self.startAddress findStopAreasAround];
    }
    if (self.destinationAddress.stopArea == nil) {
        [self.destinationAddress findStopAreasAround];
    }
    
    if (self.startAddress.stopAreas.count > 0) {
        MPStopArea *stopArea = [self.startAddress.stopAreas firstObject];
        // [self.startAddress.itineraryToStopAreas addObject:[NSMutableArray array]];
        [self calculItinerarySkobbler:SKRoutePedestrian from:self.startAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
    } else if (self.destinationAddress.stopAreas.count > 0) {
        MPStopArea *stopArea = [self.destinationAddress.stopAreas firstObject];
        // [self.destinationAddress.itineraryToStopAreas addObject:[NSMutableArray array]];
        [self calculItinerarySkobbler:SKRoutePedestrian from:self.destinationAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifItineraryCalculated object:nil];
        NSLog(@"Rien a calculer avec Skobbler");
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

- (void)routingService:(SKRoutingService *)routingService didFinishRouteCalculationWithInfo:(SKRouteInformation *)routeInformation {
    [self traitementOnlyPieton:routeInformation];
}

- (void)traitement:(SKRouteInformation *)routeInformation {
    NSMutableArray *itinerariesStart  = [self.startAddress.itineraryToStopAreas lastObject];
    NSMutableArray *itinerariesDestination  = [self.destinationAddress.itineraryToStopAreas lastObject];
    
    if (self.startAddress.itineraryToStopAreas.count < self.startAddress.stopAreas.count || [itinerariesStart count] < 3) {
        if ([itinerariesStart count] < 3) {
            [[self.startAddress.itineraryToStopAreas lastObject] addObject:routeInformation];
            
            // On calcul avec un nouveau mode de deplacement si on a pas déjà fait les 3
            if ([self.startAddress.itineraryToStopAreas.lastObject count] == 1) {
                MPStopArea *stopArea = [self.startAddress.stopAreas objectAtIndex:self.startAddress.itineraryToStopAreas.count-1];
                [self calculItinerarySkobbler:SKRouteCarFastest from:self.startAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
            } else if ([self.startAddress.itineraryToStopAreas.lastObject count] == 2) {
                MPStopArea *stopArea = [self.startAddress.stopAreas objectAtIndex:self.startAddress.itineraryToStopAreas.count-1];
                [self calculItinerarySkobbler:SKRouteBicycleFastest from:self.startAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
            } else {
                // On repart d'un nouveau StopArea
                if (self.startAddress.itineraryToStopAreas.count < self.startAddress.stopAreas.count) {
                    MPStopArea *stopArea = [self.startAddress.stopAreas objectAtIndex:self.startAddress.itineraryToStopAreas.count];
                    [self calculItinerarySkobbler:SKRoutePedestrian from:self.startAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
                } else if (self.destinationAddress.stopAreas.count > 0) {
                    MPStopArea *stopArea = [self.destinationAddress.stopAreas firstObject];
                    [self.destinationAddress.itineraryToStopAreas addObject:[NSMutableArray array]];
                    [self calculItinerarySkobbler:SKRoutePedestrian from:self.destinationAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifItineraryCalculated object:nil];
                    NSLog(@"C'est fini !");
                }
            }
        } else {
            [self.startAddress.itineraryToStopAreas addObject:[NSMutableArray arrayWithObject:routeInformation]];
            MPStopArea *stopArea = [self.startAddress.stopAreas objectAtIndex:self.startAddress.itineraryToStopAreas.count];
            [self calculItinerarySkobbler:SKRoutePedestrian from:self.startAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
        }
    } else if (self.destinationAddress.itineraryToStopAreas.count < self.destinationAddress.stopAreas.count || [itinerariesDestination count] < 3) {
        if ([itinerariesDestination count] < 3) {
            [[self.destinationAddress.itineraryToStopAreas lastObject] addObject:routeInformation];
            
            
            // On calcul avec un nouveau mode de deplacement si on a pas déjà fait les 3
            if ([self.destinationAddress.itineraryToStopAreas.lastObject count] == 1) {
                MPStopArea *stopArea = [self.destinationAddress.stopAreas objectAtIndex:self.destinationAddress.itineraryToStopAreas.count-1];
                [self calculItinerarySkobbler:SKRouteCarFastest from:self.destinationAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
            } else if ([self.destinationAddress.itineraryToStopAreas.lastObject count] == 2) {
                MPStopArea *stopArea = [self.destinationAddress.stopAreas objectAtIndex:self.destinationAddress.itineraryToStopAreas.count-1];
                [self calculItinerarySkobbler:SKRouteBicycleFastest from:self.destinationAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
            } else {
                // On repart d'un nouveau StopArea
                if (self.destinationAddress.itineraryToStopAreas.count+1 < self.destinationAddress.stopAreas.count) {
                    MPStopArea *stopArea = [self.destinationAddress.stopAreas objectAtIndex:self.destinationAddress.itineraryToStopAreas.count];
                    [self calculItinerarySkobbler:SKRoutePedestrian from:self.destinationAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifItineraryCalculated object:nil];
                    NSLog(@"C'est fini !");
                }
            }
            
        } else {
            [self.destinationAddress.itineraryToStopAreas addObject:[NSMutableArray arrayWithObject:routeInformation]];
            MPStopArea *stopArea = [self.destinationAddress.stopAreas objectAtIndex:self.destinationAddress.itineraryToStopAreas.count];
            [self calculItinerarySkobbler:SKRoutePedestrian from:self.destinationAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifItineraryCalculated object:nil];
        NSLog(@"C'est fini !");
    }
}

- (void)traitementOnlyPieton:(SKRouteInformation *)routeInformation {
    if (self.startAddress.itineraryToStopAreas.count < self.startAddress.stopAreas.count) {
        [self.startAddress.itineraryToStopAreas addObject:routeInformation];
        // On repart d'un nouveau StopArea
        if (self.startAddress.itineraryToStopAreas.count < self.startAddress.stopAreas.count) {
            MPStopArea *stopArea = [self.startAddress.stopAreas objectAtIndex:self.startAddress.itineraryToStopAreas.count];
            [self calculItinerarySkobbler:SKRoutePedestrian from:self.startAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
        } else if (self.destinationAddress.stopAreas.count > 0) {
            MPStopArea *stopArea = [self.destinationAddress.stopAreas firstObject];
            [self calculItinerarySkobbler:SKRoutePedestrian from:self.destinationAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifItineraryCalculated object:nil];
            NSLog(@"C'est fini !");
        }
    } else if (self.destinationAddress.itineraryToStopAreas.count < self.destinationAddress.stopAreas.count) {
        [self.destinationAddress.itineraryToStopAreas addObject:routeInformation];
        
        // On repart d'un nouveau StopArea
        if (self.destinationAddress.itineraryToStopAreas.count < self.destinationAddress.stopAreas.count) {
            MPStopArea *stopArea = [self.destinationAddress.stopAreas objectAtIndex:self.destinationAddress.itineraryToStopAreas.count];
            [self calculItinerarySkobbler:SKRoutePedestrian from:self.destinationAddress.coordinate to:CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue])];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifItineraryCalculated object:nil];
            NSLog(@"C'est fini !");
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifItineraryCalculated object:nil];
        NSLog(@"C'est fini !");
    }
}

- (void)routingService:(SKRoutingService *)routingService didFailWithErrorCode:(SKRoutingErrorCode)errorCode {
    
    NSLog(@"Route calculation failed.");
}

@end
