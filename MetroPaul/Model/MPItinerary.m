//
//  MPItinerary.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPItinerary.h"

@implementation MPItinerary
@dynamic id_stop_area_from;
@dynamic id_stop_area_to;
@dynamic itineraire;
//@dynamic stopAreaFrom;
//@dynamic stopAreaTo;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    self = [NSEntityDescription insertNewObjectForEntityForName:@"MPItinerary" inManagedObjectContext:managedObjectContext];
    if (self) {
        if ([dict objectForKey:@"id_stop_area_from"] != nil) {
            self.id_stop_area_from = [NSNumber numberWithInteger:[[dict objectForKey:@"id_stop_area_from"] integerValue]];
           // self.stopAreaFrom = [MPStopArea findById:self.id_stop_area_from];
        }
        if ([dict objectForKey:@"id_stop_area_to"] != nil) {
            self.id_stop_area_to = [NSNumber numberWithInteger:[[dict objectForKey:@"id_stop_area_to"] integerValue]];
           // self.stopAreaTo = [MPStopArea findById:self.id_stop_area_to];
        }
        if ([dict objectForKey:@"itineraire"] != nil) {
            self.itineraire = [dict objectForKey:@"itineraire"];
        }
    }
    return self;
}

+ (NSArray*)initWithArray:(NSArray *)array managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
//    int i = 0;
    NSMutableArray *arrayMPItinerary = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayMPItinerary addObject:[[MPItinerary alloc] initWithDictionary:dict managedObjectContext:managedObjectContext]];
//        i++;
//        NSLog(@"itinerary : %i", i);
    }
    return [NSArray arrayWithArray:arrayMPItinerary];
}
@end
