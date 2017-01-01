//
//  MPSectionItinerary.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 15/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPSectionItinerary.h"
#import "MPStopArea.h"

@implementation MPSectionItinerary

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        NSArray *stepStrings = [string componentsSeparatedByString:@"#"];

        if ([[stepStrings objectAtIndex:0] isEqualToString:@"s_n"]) {
            self.type = MPStepItineraryStreet;
        } else if([[stepStrings objectAtIndex:0] isEqualToString:@"p_t"]) {
            self.type = MPStepItineraryTransport;
        } else if([[stepStrings objectAtIndex:0] isEqualToString:@"t_r"]) {
            self.type = MPStepItineraryTransfert;
        } else if([[stepStrings objectAtIndex:0] isEqualToString:@"w_t"]) {
            self.type = MPStepItineraryOther;
        }
        
        self.openWeek = [[stepStrings objectAtIndex:1] integerValue];
        self.openWeekend = [[stepStrings objectAtIndex:2] integerValue];
        self.closeWeek = [[stepStrings objectAtIndex:3] integerValue];
        self.closeWeekend = [[stepStrings objectAtIndex:4] integerValue];
        self.codeLine = [stepStrings objectAtIndex:5];
        self.duration = [[stepStrings objectAtIndex:6] integerValue];
        NSArray *stopAreaStrings = [[stepStrings objectAtIndex:7] componentsSeparatedByString:@"%"];
        self.stopAreas = [NSMutableArray array];
        for (NSString *stopAreaString in stopAreaStrings) {
            if (stopAreaString != nil && ![stopAreaString isEqualToString:@""]) {
                MPStopArea *stopArea = [MPStopArea findById:[NSNumber numberWithInteger:[stopAreaString integerValue]]];
                if (stopArea != nil) {
                    [self.stopAreas addObject:stopArea];

                }
            }
        }
    }
    
    return self;
}

@end
