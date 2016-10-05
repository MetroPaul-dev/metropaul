//
//  MPNetwork.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 04/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MPNetwork : NSManagedObject
@property(nonatomic, strong) NSNumber *id_network;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *generique_type;
@property(nonatomic, strong) NSString *last_update;
@property(nonatomic, strong) NSMutableSet *lines;

- (id)initWithDictionary:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSArray*)initWithArray:(NSArray *)array managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (MPNetwork*)findById:(NSNumber*)id_network;

@end
