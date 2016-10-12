//
//  AppDelegate.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 28/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "MPRevealController.h"
#import <SKMaps/SKMaps.h>
#import "XMLParser.h"
#import "MPDataLoader.h"
#import <SKTDownloadAPI.h>

@import SKMaps;

@interface AppDelegate () <PKRevealing, SKMapVersioningDelegate>
@property (nonatomic, strong, readwrite) MPRevealController *revealController;

@end

@implementation AppDelegate

#pragma mark - Singleton

+ (AppDelegate *)sharedAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    SKMapsInitSettings *settings = [SKMapsInitSettings mapsInitSettings];
    [[SKMapsService sharedInstance] initializeSKMapsWithAPIKey:@"5a738a0ca4d8138a7e826ecff13dac6cce1e22192280a54ee92dcc5236a7e85c" settings:settings];
    [[SKPositionerService sharedInstance] startLocationUpdate];
    [SKMapsService sharedInstance].mapsVersioningManager.delegate= self;
    
    [Fabric with:@[[Crashlytics class]]];
    
    self.revealController = [MPRevealController sharedInstance];
    self.window.rootViewController = self.revealController;
    
    //  [self.window makeKeyAndVisible];
    
    [SKTDownloadManager sharedInstance];
    self.cachedMapRegions = [NSMutableArray array];
    
//    NSLog(@"path +++++ %@", self.applicationDocumentsDirectory.path);
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    if (![userDefault boolForKey:@"isPreloaded"]) {
//        [[[MPDataLoader alloc] init] preloadData];
//        [userDefault setBool:YES forKey:@"isPreloaded"];
//        [userDefault synchronize];
//    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveContext];
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - PKRevealController

-(void)showLeftController {
    [self.revealController showViewController:self.revealController.leftViewController animated:YES completion:nil];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            [self loadExistingSQLite];
            
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"MetroPaul"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data stack iOS < 10

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
//    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
//        return self.persistentContainer.viewContext;
//    } else {
        if (_managedObjectContext != nil) {
            return _managedObjectContext;
        }
        
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
        return _managedObjectContext;
//    }
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
//    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
//        return self.persistentContainer.managedObjectModel;
//    } else {
        if (_managedObjectModel != nil) {
            return _managedObjectModel;
        }
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MetroPaul" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        return _managedObjectModel;
//    }
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
//    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
//        return self.persistentContainer.persistentStoreCoordinator;
//    } else {
        if (_persistentStoreCoordinator != nil) {
            return _persistentStoreCoordinator;
        }
        
        [self loadExistingSQLite];
        
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MetroPaul.sqlite"];
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
        [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
        [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:options
                                                               error:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             
             Typical reasons for an error here include:
             * The persistent store is not accessible;
             * The schema for the persistent store is incompatible with current managed object model.
             Check the error message to determine what the actual problem was.
             
             
             If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
             
             If you encounter schema incompatibility errors during development, you can reduce their frequency by:
             * Simply deleting the existing store:
             [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
             
             * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
             @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
             
             Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
             
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        return _persistentStoreCoordinator;
//    }
}

- (void)loadExistingSQLite {
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MetroPaul.sqlite"];
    // Load the existing database
    if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]) {
        NSArray *sourceSqliteURLs = @[[[NSBundle mainBundle] URLForResource:@"MetroPaul" withExtension:@"sqlite"],
                                      [[NSBundle mainBundle] URLForResource:@"MetroPaul" withExtension:@"sqlite-wal"],
                                      [[NSBundle mainBundle] URLForResource:@"MetroPaul" withExtension:@"sqlite-shm"]
                                      ];
        NSArray *destSqliteURLs = @[[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MetroPaul.sqlite"],
                                    [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MetroPaul.sqlite-wal"],
                                    [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MetroPaul.sqlite-shm"]
                                    ];
        
        for (int index = 0; index < sourceSqliteURLs.count; index++) {
            NSError *error = nil;
            @try {
                [[NSFileManager defaultManager] copyItemAtURL:sourceSqliteURLs[index] toURL:destSqliteURLs[index] error:&error];
            } @catch (NSException *exception) {
                NSLog(@"%@", error);
            } @finally {
                
            }
        }
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.managedObjectContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)mapsVersioningManagerLoadedMetadata:(SKMapsVersioningManager *)versioningManager {
    NSLog(@"Loaded metadata");
}

- (void)mapsVersioningManager:(SKMapsVersioningManager *)versioningManager loadedWithMapVersion:(NSString *)currentMapVersion
{
    NSLog(@"Map version file download finished.\n");
    //needs to be updated for a new map version
    [[XMLParser sharedInstance] downloadAndParseJSON];
}

- (void)mapsVersioningManager:(SKMapsVersioningManager *)versioningManager loadedWithOfflinePackages:(NSArray *)packages updatablePackages:(NSArray *)updatablePackages
{
    NSLog(@"%lu updatable packages",(unsigned long)updatablePackages.count);
    for (SKMapPackage *package in updatablePackages)
    {
        NSLog(@"%@",package.name);
    }
}

- (void)mapsVersioningManager:(SKMapsVersioningManager *)versioningManager detectedNewAvailableMapVersion:(NSString *)latestMapVersion currentMapVersion:(NSString *)currentMapVersion
{
    NSLog(@"Current map version: %@ \n Latest map version: %@",currentMapVersion, latestMapVersion);
    
    NSString* message = [NSString stringWithFormat:@"A new map version is available on the server: %@ \n Current map version: %@",latestMapVersion,currentMapVersion];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New map version available" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Update", nil];
        [alert show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSArray *availableVersions = [[SKMapsService sharedInstance].mapsVersioningManager availableMapVersions];
        SKVersionInformation *latestVersion = availableVersions[0];
        [[SKMapsService sharedInstance].mapsVersioningManager updateToVersion:latestVersion.version];
    }
}




@end
