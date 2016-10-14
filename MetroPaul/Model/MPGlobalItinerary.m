//
//  MPGlobalItinerary.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 13/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPGlobalItinerary.h"

@implementation MPGlobalItinerary

- (NSInteger)getDuration {
    NSInteger duration = 0;
    duration += self.startRouteInformation.estimatedTime;
    //duration += self.itineraryMetro
    duration += self.destinationRouteInformation.estimatedTime;
    
    return duration;
}

- (NSInteger)duration {
    NSInteger duration = 0;
    duration += self.startRouteInformation.estimatedTime;
    //duration += self.itineraryMetro
    duration += self.destinationRouteInformation.estimatedTime;
    
    return duration;
}

@end
