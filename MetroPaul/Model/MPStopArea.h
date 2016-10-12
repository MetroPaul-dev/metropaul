//
//  MPStopArea.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 03/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MPStopArea : NSManagedObject
@property(nonatomic, strong) NSNumber *id_stop_area;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *id_navitia;
@property(nonatomic, strong) NSNumber *latitude;
@property(nonatomic, strong) NSNumber *longitude;
@property(nonatomic, strong) NSString *last_update;
@property(nonatomic, strong) NSNumber *calculated;
@property(nonatomic, strong) NSMutableSet *lines;
@property(nonatomic, strong) NSMutableSet *routes;
@property(nonatomic, strong) NSMutableSet *stop_points;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSArray*)initWithArray:(NSArray *)array managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (MPStopArea*)findById:(NSNumber*)id_stop_area;
+ (NSArray *)findByName:(NSString *)name;
+ (NSArray *)findAll;
+ (NSArray *)findByDistanceInMeter:(NSInteger)distanceInMeter fromLatitude:(CGFloat)latitude fromLongitude:(CGFloat)longitude;

@end
