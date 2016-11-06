//
//  MapVisibleRegion.m
//  FrameworkIOSDemo
//
//  Copyright (c) 2016 Skobbler. All rights reserved.
//

#import "MapVisibleRegion.h"

@implementation MapVisibleRegion

+ (instancetype)mapVisibleRegionWithName:(NSString *)name andRegion:(SKCoordinateRegion)region {
    MapVisibleRegion *visibleRegion = [MapVisibleRegion new];
    visibleRegion.name = name;
    visibleRegion.region = region;
    
    return visibleRegion;
}

@end
