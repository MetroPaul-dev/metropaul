//
//  AppDelegate.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 28/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class SKTMapsObject;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//iOS > 10
@property (readonly, strong) NSPersistentContainer *persistentContainer;
//iOS < 10
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(nonatomic,strong) NSMutableArray *cachedMapRegions;
@property (nonatomic, strong) SKTMapsObject *skMapsObject;

+ (AppDelegate *)sharedAppDelegate;
- (void)saveContext;


@end

