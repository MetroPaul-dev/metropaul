//
//  MapVisibleRegion.h
//  FrameworkIOSDemo
//
//  Copyright (c) 2016 Skobbler. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SKMaps;

@interface MapVisibleRegion : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) SKCoordinateRegion region;

+ (instancetype)mapVisibleRegionWithName:(NSString *)name andRegion:(SKCoordinateRegion)region;

@end
