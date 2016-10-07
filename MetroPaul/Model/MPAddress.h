//
//  MPAddress.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <SKMaps/SKMaps.h>

#import "MPStopArea.h"

@interface MPAddress : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic, strong) MPStopArea *stopArea;
@property(nonatomic, strong) NSArray *stopAreas;
@property(nonatomic, strong) NSMutableArray *itineraryToStopAreas;

- (instancetype)initWithSKSearchResult:(SKSearchResult*)searchResult;
- (void)findStopAreasAround;

@end
