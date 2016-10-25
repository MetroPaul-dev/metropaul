//
//  MPLine.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 03/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPLine.h"

@implementation MPLine
@dynamic id_line;
@dynamic code;
@dynamic color;
@dynamic last_update;
@dynamic opening_time;
@dynamic closing_time;
@dynamic transport_type;
@dynamic name;
@dynamic id_network;
@dynamic network;
@dynamic stop_areas;
@dynamic routes;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    self = [NSEntityDescription insertNewObjectForEntityForName:@"MPLine" inManagedObjectContext:managedObjectContext];
    if (self) {
        if ([dict objectForKey:@"id_line"] != nil) {
            self.id_line = [NSNumber numberWithInteger:[[dict objectForKey:@"id_line"] integerValue]];
        }
        if ([dict objectForKey:@"code"] != nil) {
            self.code = [dict objectForKey:@"code"];
        }
        if ([dict objectForKey:@"color"] != nil) {
            self.color = [dict objectForKey:@"color"];
        }
        if ([dict objectForKey:@"last_update"] != nil) {
            self.last_update = [dict objectForKey:@"last_update"];
        }
        if ([dict objectForKey:@"opening_time"] != nil) {
            self.opening_time = [NSNumber numberWithInteger:[[dict objectForKey:@"opening_time"] integerValue]];
        }
        if ([dict objectForKey:@"closing_time"] != nil) {
            self.closing_time = [NSNumber numberWithInteger:[[dict objectForKey:@"closing_time"] integerValue]];
        }
        if ([dict objectForKey:@"transport_type"] != nil) {
            self.transport_type = [dict objectForKey:@"transport_type"];
        }
        if ([dict objectForKey:@"name"] != nil) {
            self.name = [dict objectForKey:@"name"];
        }
        if ([dict objectForKey:@"id_network"] != nil) {
            self.id_network = [NSNumber numberWithInteger:[[dict objectForKey:@"id_network"] integerValue]];
            self.network = [MPNetwork findById:self.id_network];
        }
    }
    return self;
}

+ (NSArray*)initWithArray:(NSArray *)array managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    NSMutableArray *arrayMPLine = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayMPLine addObject:[[MPLine alloc] initWithDictionary:dict managedObjectContext:managedObjectContext]];
    }
    return [NSArray arrayWithArray:arrayMPLine];
}

+ (MPLine *)findById:(NSNumber *)id_line {
    // Fetching
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"id_line", id_line];
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

+ (MPLine *)findByCode:(NSString *)code {
    // Fetching
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"code", code];
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


+ (NSArray *)findByStopAreaId:(NSNumber *)id_stop_area {
    // Fetching
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stop_areas.id_stop_area == %@", id_stop_area];
    [fetchRequest setPredicate:predicate];
    
    
    NSError *error;
    NSArray *results = [[AppDelegate sharedAppDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        NSLog(@"Failed to retrieve record: \(e!.localizedDescription)");
    } else {
        return results;
    }
    
    return nil;
}

+ (NSArray *)findAll {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    
    NSError *error;
    NSArray *results = [[AppDelegate sharedAppDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        NSLog(@"Failed to retrieve record: \(e!.localizedDescription)");
    }
    
    return results;
}

@end
