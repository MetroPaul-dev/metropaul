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
#import "MPHistory.h"

@interface MPAddress : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic, strong) MPStopArea *stopArea;
@property(nonatomic, strong) NSMutableArray *stopAreas;
@property(nonatomic, strong) NSMutableArray *itineraryToStopAreas;

- (instancetype)initWithSKSearchResult:(SKSearchResult*)searchResult;
- (instancetype)initWithHistory:(MPHistory*)history;
- (void)findStopAreasAround;
- (BOOL)checkAddressValidity;
@end
