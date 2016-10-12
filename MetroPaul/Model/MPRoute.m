//
//  MPRoute.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPRoute.h"

@implementation MPRoute
@dynamic id_line;
@dynamic id_route;
@dynamic name;
@dynamic destination;
@dynamic opening_time;
@dynamic closing_time;
@dynamic last_update;
@dynamic stop_areas;
@dynamic line;
@dynamic stop_points;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    self = [NSEntityDescription insertNewObjectForEntityForName:@"MPRoute" inManagedObjectContext:managedObjectContext];
    if (self) {
        if ([dict objectForKey:@"id_route"] != nil) {
            self.id_route = [NSNumber numberWithInteger:[[dict objectForKey:@"id_route"] integerValue]];
        }
        if ([dict objectForKey:@"id_line"] != nil) {
            self.id_line = [NSNumber numberWithInteger:[[dict objectForKey:@"id_line"] integerValue]];
            self.line = [MPLine findById:self.id_line];
        }
        if ([dict objectForKey:@"name"] != nil) {
            self.name = [dict objectForKey:@"name"];
        }
        if ([dict objectForKey:@"destination"] != nil) {
            self.destination = [dict objectForKey:@"destination"];
        }
        if ([dict objectForKey:@"opening_time"] != nil) {
            self.opening_time = [NSNumber numberWithInteger:[[dict objectForKey:@"opening_time"] integerValue]];
        }
        if ([dict objectForKey:@"closing_time"] != nil) {
            self.closing_time = [NSNumber numberWithInteger:[[dict objectForKey:@"closing_time"] integerValue]];
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
        [arrayMPLine addObject:[[MPRoute alloc] initWithDictionary:dict managedObjectContext:managedObjectContext]];
    }
    return [NSArray arrayWithArray:arrayMPLine];
}

+ (MPRoute*)findById:(NSNumber*)id_route {
//    NSLog(@"MPRoute request findById : %@", id_route);
    
    // Fetching
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"id_route", id_route];
    [fetchRequest setPredicate:predicate];
    
    
    NSError *error;
    NSArray *results = [[AppDelegate sharedAppDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        NSLog(@"Failed to retrieve record: \(e!.localizedDescription)");
    } else {
        if (results.count == 1) {
            return [results firstObject];
        }
    }
    
    return nil;
}

@end
