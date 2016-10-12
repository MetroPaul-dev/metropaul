//
//  MPStopAreaRoute.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPStopAreaRoute.h"
#import "MPStopArea.h"
#import "MPRoute.h"

@implementation MPStopAreaRoute
@dynamic id_stop_area;
@dynamic id_route;
@dynamic last_update;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    self = [NSEntityDescription insertNewObjectForEntityForName:@"MPStopAreaRoute" inManagedObjectContext:managedObjectContext];
    if (self) {
        if ([dict objectForKey:@"id_stop_area"] != nil) {
            self.id_stop_area = [NSNumber numberWithInteger:[[dict objectForKey:@"id_stop_area"] integerValue]];
        }
        if ([dict objectForKey:@"id_route"] != nil) {
            self.id_route = [NSNumber numberWithInteger:[[dict objectForKey:@"id_route"] integerValue]];
        }
        if ([dict objectForKey:@"last_update"] != nil) {
            self.last_update = [dict objectForKey:@"last_update"];
        }
        MPStopArea *stopArea = [MPStopArea findById:self.id_stop_area];
        MPRoute *route = [MPRoute findById:self.id_route];
        if (stopArea != nil && route != nil) {
            [route.stop_areas addObject:stopArea];
            [stopArea.routes addObject:route];
        }
        
    }
    return self;
}

+ (NSArray*)initWithArray:(NSArray *)array managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    NSMutableArray *arrayMPLine = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayMPLine addObject:[[MPStopAreaRoute alloc] initWithDictionary:dict managedObjectContext:managedObjectContext]];
    }
    return [NSArray arrayWithArray:arrayMPLine];
}
@end
