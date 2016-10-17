//
//  MPAddress.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPAddress.h"
#import "SKSearchResult+MPString.h"

@interface MPAddress ()
@property(nonatomic) NSInteger nbItineraryToWait;
@end

@implementation MPAddress

- (instancetype)initWithSKSearchResult:(SKSearchResult*)searchResult {
    self = [self init];
    if (self) {
        self.name = [searchResult toString];
        self.coordinate = searchResult.coordinate;
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.itineraryToStopAreas = [NSMutableArray array];
        self.stopAreas = [NSArray array];
        self.nbItineraryToWait = 0;
    }
    return self;
}

-(void)dealloc {
    NSLog(@"Dealloc");
}

- (void)findStopAreasAround {
    if (self.stopArea == nil && CLLocationCoordinate2DIsValid(self.coordinate)) {
        NSInteger distance = STOP_AREA_DISTANCE_DEFAULT;
        while (self.stopAreas.count < 2) {
            self.stopAreas = [MPStopArea findByDistanceInMeter:distance fromLatitude:self.coordinate.latitude fromLongitude:self.coordinate.longitude];
            distance +=100;
        }
    }
}

- (BOOL)checkAddressValidity {
    return (self.stopArea != nil || (CLLocationCoordinate2DIsValid(self.coordinate) && self.name != nil));
}

@end
