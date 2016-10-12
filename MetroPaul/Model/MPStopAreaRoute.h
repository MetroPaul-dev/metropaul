//
//  MPStopAreaRoute.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MPStopAreaRoute : NSManagedObject
@property(nonatomic, strong) NSNumber *id_stop_area;
@property(nonatomic, strong) NSNumber *id_route;
@property(nonatomic, strong) NSString *last_update;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSArray*)initWithArray:(NSArray *)array managedObjectContext:(NSManagedObjectContext*)managedObjectContext;
@end
