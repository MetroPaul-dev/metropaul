//
//  MPItinerary.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MPStopArea.h"

@interface MPItinerary : NSManagedObject
@property(nonatomic, strong) NSNumber *id_stop_area_from;
@property(nonatomic, strong) NSNumber *id_stop_area_to;
@property(nonatomic, strong) NSString *itineraire;
//@property(nonatomic, strong) MPStopArea *stopAreaFrom;
//@property(nonatomic, strong) MPStopArea *stopAreaTo;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSArray*)initWithArray:(NSArray *)array managedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (MPItinerary *)findByStartStopAreaId:(NSNumber *)startId destinationId:(NSNumber *)destinationId;
@end
