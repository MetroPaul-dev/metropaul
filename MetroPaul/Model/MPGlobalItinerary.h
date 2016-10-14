//
//  MPGlobalItinerary.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 13/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SKMaps/SKMaps.h>
#import "MPStopArea.h"
#import "MPItinerary.h"

@interface MPGlobalItinerary : NSObject
@property(nonatomic, strong) SKRouteInformation *startRouteInformation;
@property(nonatomic, strong) MPStopArea *startStopArea;
@property(nonatomic, strong) MPItinerary *itineraryMetro;
@property(nonatomic, strong) MPStopArea *destinationStopArea;
@property(nonatomic, strong) SKRouteInformation *destinationRouteInformation;

- (NSInteger)duration;
@end
