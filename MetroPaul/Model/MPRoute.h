//
//  MPRoute.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MPLine.h"

@interface MPRoute : NSManagedObject
@property(nonatomic, strong) NSNumber *id_route;
@property(nonatomic, strong) NSNumber *id_line;
@property(nonatomic, strong) MPLine *line;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *destination;
@property(nonatomic, strong) NSNumber *opening_time;
@property(nonatomic, strong) NSNumber *closing_time;
@property(nonatomic, strong) NSString *last_update;
@property(nonatomic, strong) NSMutableSet *stop_areas;
@property(nonatomic, strong) NSMutableSet *stop_points;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSArray*)initWithArray:(NSArray *)array managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (MPRoute*)findById:(NSNumber*)id_route;

@end
