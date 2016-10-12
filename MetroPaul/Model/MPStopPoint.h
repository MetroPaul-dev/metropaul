//
//  MPStopPoint.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MPStopArea.h"
#import "MPRoute.h"

@interface MPStopPoint : NSManagedObject
@property(nonatomic, strong) NSNumber *id_stop_point;
@property(nonatomic, strong) NSNumber *id_stop_area;
@property(nonatomic, strong) MPStopArea *stop_area;
@property(nonatomic, strong) NSNumber *id_route;
@property(nonatomic, strong) MPRoute *route;
@property(nonatomic, strong) NSNumber *latitude;
@property(nonatomic, strong) NSNumber *longitude;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *last_update;
@property(nonatomic, strong) NSString *id_stop_point_navitia;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSArray*)initWithArray:(NSArray *)array managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
