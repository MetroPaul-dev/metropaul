//
//  MPStopArea.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 03/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPStopArea.h"
#import <CoreLocation/CoreLocation.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@implementation MPStopArea

@dynamic id_stop_area;
@dynamic name;
@dynamic id_navitia;
@dynamic latitude;
@dynamic longitude;
@dynamic last_update;
@dynamic calculated;
@dynamic lines;
@dynamic routes;
@dynamic stop_points;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    self = [NSEntityDescription insertNewObjectForEntityForName:@"MPStopArea" inManagedObjectContext:managedObjectContext];
    if (self) {
        if ([dict objectForKey:@"id_stop_area"] != nil) {
            self.id_stop_area = [NSNumber numberWithInteger:[[dict objectForKey:@"id_stop_area"] integerValue]];
        }
        if ([dict objectForKey:@"name"] != nil) {
            self.name = [dict objectForKey:@"name"];
        }
        if ([dict objectForKey:@"id_navitia"] != nil) {
            self.id_navitia = [NSNumber numberWithInteger:[[dict objectForKey:@"id_navitia"] integerValue]];
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
        if ([dict objectForKey:@"calculated"] != nil) {
            self.calculated = [NSNumber numberWithInteger:[[dict objectForKey:@"calculated"] integerValue]];
        }
    }
    return self;
}

+ (NSArray*)initWithArray:(NSArray *)array managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    NSMutableArray *arrayMPLine = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayMPLine addObject:[[MPStopArea alloc] initWithDictionary:dict managedObjectContext:managedObjectContext]];
    }
    return [NSArray arrayWithArray:arrayMPLine];
}

+ (MPStopArea *)findById:(NSNumber *)id_stop_area {
   // NSLog(@"MPStopArea request findById : %@", id_stop_area);

    // Fetching
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"id_stop_area", id_stop_area];
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

+ (NSArray *)findByName:(NSString *)name {
    NSLog(@"MPStopArea request findByName : %@", name);

    // Fetching
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"name", name];
    [fetchRequest setPredicate:predicate];
    
    
    NSError *error;
    NSArray *results = [[AppDelegate sharedAppDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        NSLog(@"Failed to retrieve record: \(e!.localizedDescription)");
    }
    
    return results;
}

+ (NSArray *)findAll {
    NSLog(@"MPStopArea request findAll");

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    
    NSError *error;
    NSArray *results = [[AppDelegate sharedAppDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        NSLog(@"Failed to retrieve record: \(e!.localizedDescription)");
    }
    
    return results;
}


+ (NSArray *)findByDistanceInMeter:(NSInteger)distanceInMeter fromLatitude:(CGFloat)latitude fromLongitude:(CGFloat)longitude {
    NSLog(@"MPStopArea request findByDistanceInMeter : %li", (long)distanceInMeter);
    NSArray *boundingBox = [MPStopArea getBoundingBox:distanceInMeter fromLatitude:latitude fromLongitude:longitude];
    // Fetching
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"latitude >= %@ AND latitude <= %@ AND longitude >= %@ AND longitude <= %@", [boundingBox objectAtIndex:0], [boundingBox objectAtIndex:2], [boundingBox objectAtIndex:1], [boundingBox objectAtIndex:3]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [[AppDelegate sharedAppDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        NSLog(@"Failed to retrieve record: \(e!.localizedDescription)");
    }
    
    return results;
}

+ (NSArray *)getBoundingBox:(NSInteger)distanceInMeter fromLatitude:(CGFloat)latitude fromLongitude:(CGFloat)longitude {
    CGFloat R = 6371.0;
    CGFloat radius = distanceInMeter/1000.0;
    CGFloat maxLat = latitude + RADIANS_TO_DEGREES(radius/R);
    CGFloat minLat = latitude - RADIANS_TO_DEGREES(radius/R);
    CGFloat maxLong = longitude + RADIANS_TO_DEGREES(asin(radius/R) / cos(DEGREES_TO_RADIANS(latitude)));
    CGFloat minLong = longitude - RADIANS_TO_DEGREES(asin(radius/R) / cos(DEGREES_TO_RADIANS(latitude)));
    
    NSArray *result = [NSArray arrayWithObjects:[NSNumber numberWithFloat:minLat], [NSNumber numberWithFloat:minLong], [NSNumber numberWithFloat:maxLat], [NSNumber numberWithFloat:maxLong], nil];

    return result;
}


@end
