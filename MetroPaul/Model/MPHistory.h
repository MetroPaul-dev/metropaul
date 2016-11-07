//
//  MPHistory.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/11/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPStopArea.h"
#import "SKSearchResult+MPString.h"

@interface MPHistory : NSObject

@property(nonatomic) BOOL typeStopArea;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *subTitle;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

- (instancetype)initWithStopArea:(MPStopArea*)stopArea;
- (instancetype)initWithSearchResult:(SKSearchResult*)searchResult;

@end

@interface MPHistoryManager : NSObject
+ (instancetype)sharedManager;
- (void)saveStopArea:(MPStopArea*)stopArea;
- (void)saveSearchResult:(SKSearchResult*)searchResult;
- (NSDictionary*)getHistory;
@end
