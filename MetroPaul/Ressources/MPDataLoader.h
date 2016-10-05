//
//  MPDataLoader.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 04/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPDataLoader : NSObject
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)preloadData;

@end
