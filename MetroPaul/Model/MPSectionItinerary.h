//
//  MPSectionItinerary.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 15/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MPStepItineraryType) {
    MPStepItineraryStreet = 0,
    MPStepItineraryTransport = 1,
    MPStepItineraryTransfert = 2,
};

@interface MPSectionItinerary : NSObject
@property(nonatomic) MPStepItineraryType type;
@property(nonatomic) NSInteger openWeek;
@property(nonatomic) NSInteger openWeekend;
@property(nonatomic) NSInteger closeWeek;
@property(nonatomic) NSInteger closeWeekend;
@property(nonatomic, strong) NSString *codeLine;
@property(nonatomic) NSInteger duration;
@property(nonatomic, strong) NSMutableArray *stopAreas;

- (instancetype)initWithString:(NSString *)string;

@end
