//
//  MPDataLoader.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 04/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPDataLoader.h"

#import "AppDelegate.h"
#import "MPLine.h"
#import "MPStopArea.h"
#import "MPStopAreaLine.h"
#import "MPNetwork.h"
#import "MPItinerary.h"
#import "MPRoute.h"
#import "MPStopAreaRoute.h"
#import "MPStopPoint.h"

@implementation MPDataLoader

- (instancetype)init {
    self = [super init];
    if (self) {
        self.managedObjectContext = [AppDelegate sharedAppDelegate].managedObjectContext;
    }
    
    return self;
}

- (void)preloadData {
    
    // Remove all the menu items before preloading
    [self removeAllData];
    
    // Retrieve data from the source file
    NSString* networkDataPath = [[NSBundle mainBundle] pathForResource:@"T_NETWORK" ofType:@"json"];
    if (networkDataPath != nil) {
        NSArray *datas = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:networkDataPath] options:kNilOptions error:nil];
        if (datas != nil) {
            // Preload the menu items
            [MPNetwork initWithArray:datas managedObjectContext:self.managedObjectContext];
            [self saveContext];
        }
    }
    
    NSString* stopAreaDataPath = [[NSBundle mainBundle] pathForResource:@"T_STOP_AREA" ofType:@"json"];
    if (stopAreaDataPath != nil) {
        NSArray *datas = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:stopAreaDataPath] options:kNilOptions error:nil];
        if (datas != nil) {
            // Preload the menu items
            [MPStopArea initWithArray:datas managedObjectContext:self.managedObjectContext];
            [self saveContext];
        }
    }
    
    NSString* lineDataPath = [[NSBundle mainBundle] pathForResource:@"T_LINE" ofType:@"json"];
    if (lineDataPath != nil) {
        NSArray *datas = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:lineDataPath] options:kNilOptions error:nil];
        if (datas != nil) {
            // Preload the menu items
            [MPLine initWithArray:datas managedObjectContext:self.managedObjectContext];
            [self saveContext];
        }
    }
    NSString* stopAreaLineDataPath = [[NSBundle mainBundle] pathForResource:@"T_STOP_AREA_LINE" ofType:@"json"];
    if (stopAreaLineDataPath != nil) {
        NSArray *datas = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:stopAreaLineDataPath] options:kNilOptions error:nil];
        if (datas != nil) {
            // Preload the menu items
            [MPStopAreaLine initWithArray:datas managedObjectContext:self.managedObjectContext];
            [self saveContext];
        }
    }
    
    NSString* routeDataPath = [[NSBundle mainBundle] pathForResource:@"T_ROUTE" ofType:@"json"];
    if (routeDataPath != nil) {
        NSArray *datas = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:routeDataPath] options:kNilOptions error:nil];
        if (datas != nil) {
            // Preload the menu items
            [MPRoute initWithArray:datas managedObjectContext:self.managedObjectContext];
            [self saveContext];
        }
    }

    NSString *stopAreaRouteDataPath = [[NSBundle mainBundle] pathForResource:@"T_STOP_AREA_ROUTE" ofType:@"json"];
    if (stopAreaRouteDataPath != nil) {
        NSArray *datas = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:stopAreaRouteDataPath] options:kNilOptions error:nil];
        if (datas != nil) {
            // Preload the menu items
            [MPStopAreaRoute initWithArray:datas managedObjectContext:self.managedObjectContext];
            [self saveContext];
        }
    }
    
    NSString *stopPointDataPath = [[NSBundle mainBundle] pathForResource:@"T_STOP_POINT" ofType:@"json"];
    if (stopPointDataPath != nil) {
        NSArray *datas = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:stopPointDataPath] options:kNilOptions error:nil];
        if (datas != nil) {
            // Preload the menu items
            [MPStopPoint initWithArray:datas managedObjectContext:self.managedObjectContext];
            [self saveContext];
        }
    }
    
    NSString* itineraryDataPath = [[NSBundle mainBundle] pathForResource:@"T_ITINERAIRES" ofType:@"json"];
    if (stopAreaLineDataPath != nil) {
        NSArray *datas = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:itineraryDataPath] options:kNilOptions error:nil];
        if (datas != nil) {
            // Preload the menu items
            [MPItinerary initWithArray:datas managedObjectContext:self.managedObjectContext];
            [self saveContext];
        }
    }
   
    
    NSLog(@"Data Preload finish");
}

- (void)removeAllData {
    NSLog(@"Start Cleaning Database");

    // Remove all items before preloading
    [self removeData:NSStringFromClass([MPItinerary class])];
    [self removeData:NSStringFromClass([MPStopPoint class])];    
    [self removeData:NSStringFromClass([MPStopAreaRoute class])];
    [self removeData:NSStringFromClass([MPRoute class])];
    [self removeData:NSStringFromClass([MPStopAreaLine class])];
    [self removeData:NSStringFromClass([MPLine class])];
    [self removeData:NSStringFromClass([MPStopArea class])];
    [self removeData:NSStringFromClass([MPNetwork class])];

    NSLog(@"Cleaning finish");

}


- (void)removeData:(NSString*)className {
    // Remove the existing items
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
    NSError *error;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if (error != nil) {
        NSLog(@"Failed to retrieve record: \(e!.localizedDescription)");
        
    } else {
        
        for (NSManagedObject *result in results) {
            [managedObjectContext deleteObject:result];
        }
    }
}

- (void)saveContext {
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

@end
