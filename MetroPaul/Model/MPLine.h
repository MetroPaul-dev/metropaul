//
//  MPLine.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 03/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MPNetwork.h"

@interface MPLine : NSManagedObject
@property(nonatomic, strong) NSNumber *id_line;
@property(nonatomic, strong) NSString *code;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *id_network;
@property(nonatomic, strong) NSNumber *opening_time;
@property(nonatomic, strong) NSNumber *closing_time;
@property(nonatomic, strong) NSString *color;
@property(nonatomic, strong) NSString *transport_type;
@property(nonatomic, strong) NSString *last_update;
@property(nonatomic, strong) MPNetwork *network;
@property(nonatomic, strong) NSMutableSet *stop_areas;
@property(nonatomic, strong) NSMutableSet *routes;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSArray*)initWithArray:(NSArray *)array managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (MPLine*)findById:(NSNumber*)id_line;
+ (MPLine *)findByCode:(NSString *)code;
+ (NSArray *)findByStopAreaId:(NSNumber *)id_stop_area;
+ (NSArray *)findAll;

- (NSInteger)codeToInt;

@end
