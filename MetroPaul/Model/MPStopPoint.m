//
//  MPStopPoint.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPStopPoint.h"

@implementation MPStopPoint
@dynamic id_stop_point;
@dynamic id_stop_area;
@dynamic id_route;
@dynamic id_stop_point_navitia;
@dynamic latitude;
@dynamic longitude;
@dynamic last_update;
@dynamic name;
@dynamic stop_area;
@dynamic route;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    self = [NSEntityDescription insertNewObjectForEntityForName:@"MPStopPoint" inManagedObjectContext:managedObjectContext];
    if (self) {
        if ([dict objectForKey:@"id_route"] != nil) {
            self.id_route = [NSNumber numberWithInteger:[[dict objectForKey:@"id_route"] integerValue]];
            MPRoute *route = [MPRoute findById:self.id_route];
            self.route = route;
            [route.stop_points addObject:self];
        }
        if ([dict objectForKey:@"id_stop_area"] != nil) {
            self.id_stop_area = [NSNumber numberWithInteger:[[dict objectForKey:@"id_stop_area"] integerValue]];
            MPStopArea *stopArea = [MPStopArea findById:self.id_stop_area];
            self.stop_area = stopArea;
            [stopArea.stop_points addObject:self];
        }
        if ([dict objectForKey:@"id_stop_point"] != nil) {
            self.id_stop_point = [NSNumber numberWithInteger:[[dict objectForKey:@"id_stop_point"] integerValue]];
        }
        if ([dict objectForKey:@"id_stop_point_navitia"] != nil) {
            self.id_stop_point_navitia = [dict objectForKey:@"id_stop_point_navitia"];
        }
        if ([dict objectForKey:@"name"] != nil) {
            self.name = [dict objectForKey:@"name"];
        }
        if ([dict objectForKey:@"latitude"] != nil) {
            self.latitude = [NSNumber numberWithFloat:[[dict objectForKey:@"latitude"] floatValue]];
        }
        if ([dict objectForKey:@"longitude"] != nil) {
            self.longitude = [NSNumber numberWithFloat:[[dict objectForKey:@"longitude"] floatValue]];
        }
        if ([dict objectForKey:@"last_update"] != nil) {
            self.last_update = [dict objectForKey:@"last_update"];
        }
    }
    return self;
}

+ (NSArray*)initWithArray:(NSArray *)array managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    NSMutableArray *arrayMPLine = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayMPLine addObject:[[MPStopPoint alloc] initWithDictionary:dict managedObjectContext:managedObjectContext]];
    }
    return [NSArray arrayWithArray:arrayMPLine];
}

@end
