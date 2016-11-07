//
//  MPHistory.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/11/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPHistory.h"
#import "MPLine.h"
@interface MPHistory () <NSCoding>

@end

@implementation MPHistory

- (instancetype)initWithStopArea:(MPStopArea*)stopArea {
    self = [super init];
    if (self) {
        self.name = [stopArea name];
        
        NSMutableString *text = [NSMutableString stringWithFormat:@"%@\nLigne", [(MPLine*)[stopArea.lines.allObjects firstObject] transport_type]];
        for (MPLine *line in stopArea.lines) {
            [text appendFormat:@" %@,",line.code];
        }
        [text deleteCharactersInRange:NSMakeRange([text length]-1, 1)];
        self.subTitle = text;
        self.coordinate = CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue]);
        self.typeStopArea = YES;
    }
    
    return self;
}
- (instancetype)initWithSearchResult:(SKSearchResult*)searchResult {
    self = [super init];
    if (self) {
        self.name = [searchResult toString];
        self.subTitle = @"";
        self.coordinate = searchResult.coordinate;
        self.typeStopArea = NO;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.subTitle = [aDecoder decodeObjectForKey:@"subTitle"];
        self.coordinate = CLLocationCoordinate2DMake([aDecoder decodeFloatForKey:@"latitude"], [aDecoder decodeFloatForKey:@"longitude"]);
        self.typeStopArea = [aDecoder decodeBoolForKey:@"typeStopArea"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.subTitle forKey:@"subTitle"];
    [aCoder encodeFloat:self.coordinate.latitude forKey:@"latitude"];
    [aCoder encodeFloat:self.coordinate.longitude forKey:@"longitude"];
    [aCoder encodeBool:self.typeStopArea forKey:@"typeStopArea"];
}

@end

@implementation MPHistoryManager

+ (instancetype)sharedManager {
    static MPHistoryManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (void)saveStopArea:(MPStopArea*)stopArea {
    NSDictionary *dict = [self getHistory];
    if (![dict objectForKey:stopArea.name]) {
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:@{stopArea.name : [NSKeyedArchiver archivedDataWithRootObject:[[MPHistory alloc] initWithStopArea:stopArea]]}];
        [array addObjectsFromArray:[pref objectForKey:@"history"]];
        if (array.count > 20) {
            array = [NSMutableArray arrayWithArray:[array subarrayWithRange:NSMakeRange(0, 19)]];
        }
        [pref setObject:array forKey:@"history"];
        [pref synchronize];
    }
}

- (void)saveSearchResult:(SKSearchResult*)searchResult {
    NSDictionary *dict = [self getHistory];
    if (![dict objectForKey:searchResult.toString]) {
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:@{searchResult.toString : [NSKeyedArchiver archivedDataWithRootObject:[[MPHistory alloc] initWithSearchResult:searchResult]]}];
        [array addObjectsFromArray:[pref objectForKey:@"history"]];
        if (array.count > 20) {
            array = [NSMutableArray arrayWithArray:[array subarrayWithRange:NSMakeRange(0, 19)]];
        }
        
        [pref setObject:array forKey:@"history"];
        [pref synchronize];
    }
}

- (NSDictionary*)getHistory {
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
    NSMutableDictionary *dictionnary = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in array) {
        [dictionnary addEntriesFromDictionary:dict];
    }
    
    return dictionnary;
}


@end
