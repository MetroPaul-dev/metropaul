//
//  MPGlobalItinerary.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 13/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPGlobalItinerary.h"
#import "MPSectionItinerary.h"

@implementation MPGlobalItinerary

- (NSInteger)duration {
    NSInteger duration = 0;
    duration += self.startRouteInformation.estimatedTime;
    for (MPSectionItinerary *section in [self.itineraryMetro readItinerary]) {
        duration += section.duration;
    }
    //duration += self.itineraryMetro
    duration += self.destinationRouteInformation.estimatedTime;
    
    return duration;
}

@end
