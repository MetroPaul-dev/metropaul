//
//  MPStopAreaLine.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 03/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPStopAreaLine.h"
#import "MPStopArea.h"
#import "MPLine.h"


@implementation MPStopAreaLine
@dynamic id_stop_area;
@dynamic id_line;
@dynamic last_update;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    self = [NSEntityDescription insertNewObjectForEntityForName:@"MPStopAreaLine" inManagedObjectContext:managedObjectContext];
    if (self) {
        if ([dict objectForKey:@"id_stop_area"] != nil) {
            self.id_stop_area = [NSNumber numberWithInteger:[[dict objectForKey:@"id_stop_area"] integerValue]];
        }
        if ([dict objectForKey:@"id_line"] != nil) {
            self.id_line = [NSNumber numberWithInteger:[[dict objectForKey:@"id_line"] integerValue]];
        }
        if ([dict objectForKey:@"last_update"] != nil) {
            self.last_update = [dict objectForKey:@"last_update"];
        }
        MPStopArea *stopArea = [MPStopArea findById:self.id_stop_area];
        MPLine *line = [MPLine findById:self.id_line];
        if (stopArea != nil && line != nil) {
            [line.stop_areas addObject:stopArea];
            [stopArea.lines addObject:line];
        }

    }
    return self;
}

+ (NSArray*)initWithArray:(NSArray *)array managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    NSMutableArray *arrayMPLine = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayMPLine addObject:[[MPStopAreaLine alloc] initWithDictionary:dict managedObjectContext:managedObjectContext]];
    }
    return [NSArray arrayWithArray:arrayMPLine];
}
@end
