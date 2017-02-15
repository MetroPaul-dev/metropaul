//
//  MPStopArea.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 03/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPStopArea.h"
#import "MPLine.h"
#import <CoreLocation/CoreLocation.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface MPStopArea () <NSCoding>

@end

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
            self.latitude = [NSNumber numberWithFloat:[[dict objectForKey:@"latitude"] doubleValue]];
        }
        if ([dict objectForKey:@"longitude"] != nil) {
            self.longitude = [NSNumber numberWithFloat:[[dict objectForKey:@"longitude"] doubleValue]];
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
    NSArray *words = [name componentsSeparatedByString:@" "];
    NSMutableString *request = [NSMutableString stringWithString:@""];
    for (NSString *word in words) {
        [request appendString:@"name CONTAINS[cd] %@ &&"];
    }
    
    NSString *requestString = [request substringToIndex:[request length]-3];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:requestString argumentArray:words];
    

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

+ (NSArray *)getBoundingBox:(NSInteger)distanceInMeter fromLatitude:(double)latitude fromLongitude:(double)longitude {
    double R = 6371.0;
    double radius = distanceInMeter/1000.0;
    double maxLat = latitude + RADIANS_TO_DEGREES(radius/R);
    double minLat = latitude - RADIANS_TO_DEGREES(radius/R);
    double maxLong = longitude + RADIANS_TO_DEGREES(asin(radius/R) / cos(DEGREES_TO_RADIANS(latitude)));
    double minLong = longitude - RADIANS_TO_DEGREES(asin(radius/R) / cos(DEGREES_TO_RADIANS(latitude)));
    
    NSArray *result = [NSArray arrayWithObjects:[NSNumber numberWithDouble:minLat], [NSNumber numberWithDouble:minLong], [NSNumber numberWithDouble:maxLat], [NSNumber numberWithDouble:maxLong], nil];

    return result;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
            self.id_stop_area = [aDecoder decodeObjectForKey:@"id_stop_area"];
            self.name = [aDecoder decodeObjectForKey:@"name"];
            self.id_navitia = [aDecoder decodeObjectForKey:@"id_navitia"];
            self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
            self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
            self.last_update = [aDecoder decodeObjectForKey:@"last_update"];
            self.calculated = [aDecoder decodeObjectForKey:@"calculated"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.id_stop_area forKey:@"id_stop_area"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.id_navitia forKey:@"id_navitia"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.last_update forKey:@"last_update"];
    [aCoder encodeObject:self.calculated forKey:@"calculated"];
}

- (NSMutableString*)linesToString {
    
    NSMutableString *text = [NSMutableString stringWithFormat:[[MPLanguageManager sharedManager] getStringWithKey:@"home.ligne_nb"], self.name, [(MPLine*)[self.lines.allObjects firstObject] transport_type]];
    
    NSArray *sortedArray;
    sortedArray = [[self.lines allObjects] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger first = [[(MPLine*)a code] integerValue];
        NSInteger second = [[(MPLine*)b code] integerValue];
        return first > second;
    }];
    
    for (MPLine *line in sortedArray) {
        if ([line.transport_type isEqualToString:@"Metro"]) {
            [text appendFormat:@" %@,",line.code];
        }
    }
    
    sortedArray = [[self.lines allObjects] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(MPLine*)a code];
        NSString *second = [(MPLine*)b code];
        return [first compare:second];
    }];
    
    for (MPLine *line in sortedArray) {
        if ([line.transport_type isEqualToString:@"RapidTransit"]) {
            [text appendFormat:@" %@,",line.code];
        }
    }
    for (MPLine *line in sortedArray) {
        if ([line.transport_type isEqualToString:@"Tramway"]) {
            [text appendFormat:@" %@,",line.code];
        }
    }
    [text deleteCharactersInRange:NSMakeRange([text length]-1, 1)];
    
    return text;
}


@end
