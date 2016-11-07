//
//  MPAddress.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPAddress.h"
#import "SKSearchResult+MPString.h"
#import "MPLine.h"

@interface MPAddress ()
@property(nonatomic) NSInteger nbItineraryToWait;
@end

@implementation MPAddress
@synthesize name = _name;

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
        self.stopAreas = [NSMutableArray array];
        self.nbItineraryToWait = 0;
    }
    return self;
}

- (NSString *)name {
    if ((_name == nil || [_name isEqualToString:@""]) && self.stopArea != nil) {
        return self.stopArea.name;
    } else {
        return _name;
    }
}

-(void)dealloc {
    NSLog(@"Dealloc");
}

- (void)findStopAreasAround {
    if (self.stopArea != nil) {
        self.coordinate = CLLocationCoordinate2DMake([self.stopArea.latitude floatValue], [self.stopArea.longitude floatValue]);
    }
    if (CLLocationCoordinate2DIsValid(self.coordinate)) {
        NSInteger distance = STOP_AREA_DISTANCE_DEFAULT;
        while (self.stopAreas.count < 2) {
            self.stopAreas = [NSMutableArray arrayWithArray:[MPStopArea findByDistanceInMeter:distance fromLatitude:self.coordinate.latitude fromLongitude:self.coordinate.longitude]];
            
            // Retire les stations de la même ligne
            for (MPStopArea *tmpStopArea in [self.stopAreas copy]) {
                for (MPStopArea *tmpStopArea2 in [self.stopAreas copy]) {
                    if (tmpStopArea.id_stop_area != tmpStopArea2.id_stop_area && tmpStopArea.lines.count == 1 && tmpStopArea2.lines.count == 1) {
                        if ([(MPLine*)tmpStopArea.lines.allObjects.firstObject id_line] == [(MPLine*)tmpStopArea2.lines.allObjects.firstObject id_line]) {
                            CLLocation *locA = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
                            CLLocation *locB = [[CLLocation alloc] initWithLatitude:[tmpStopArea.latitude doubleValue] longitude:[tmpStopArea.longitude doubleValue]];
                            CLLocation *locC = [[CLLocation alloc] initWithLatitude:[tmpStopArea2.latitude doubleValue] longitude:[tmpStopArea2.longitude doubleValue]];
                            CLLocationDistance distanceAB = [locA distanceFromLocation:locB];
                            CLLocationDistance distanceAC = [locA distanceFromLocation:locC];
                            if (distanceAB <= distanceAC) {
                                [self.stopAreas removeObject:tmpStopArea2];
                            } else {
                                [self.stopAreas removeObject:tmpStopArea];
                            }
                        }
                    }
                }
            }
            distance +=100;
        }
    }
}

- (BOOL)checkAddressValidity {
    return (self.stopArea != nil || (CLLocationCoordinate2DIsValid(self.coordinate) && self.name != nil));
}

@end
