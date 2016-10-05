//
//  MPNetwork.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 04/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPNetwork.h"

@implementation MPNetwork
@dynamic id_network;
@dynamic type;
@dynamic generique_type;
@dynamic last_update;
@dynamic lines;
- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    self = [NSEntityDescription insertNewObjectForEntityForName:@"MPNetwork" inManagedObjectContext:managedObjectContext];
    if (self) {
        if ([dict objectForKey:@"id_network"] != nil) {
            self.id_network = [NSNumber numberWithInteger:[[dict objectForKey:@"id_network"] integerValue]];
        }
        if ([dict objectForKey:@"type"] != nil) {
            self.type = [dict objectForKey:@"type"];
        }
        if ([dict objectForKey:@"generique_type"] != nil) {
            self.generique_type = [dict objectForKey:@"generique_type"];
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
        [arrayMPLine addObject:[[MPNetwork alloc] initWithDictionary:dict managedObjectContext:managedObjectContext]];
    }
    return [NSArray arrayWithArray:arrayMPLine];
}

+ (MPNetwork*)findById:(NSNumber*)id_network {
    
    // Fetching
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
     NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"id_network", id_network];
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
