//
//  MPGlobalItineraryManager.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 07/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPAddress.h"

#define KEY_COORDINATE @"KEY_COORDINATE"
#define KEY_TITLE @"KEY_TITLE"

#define kNotifItineraryCalculated @"kNotifItineraryCalculated"
#define kNotifItineraryCalculFailed @"kNotifItineraryCalculFailed"


typedef NS_ENUM(NSInteger, MPAddressToReplace) {
    MPAddressToReplaceNull = 0,
    MPAddressToReplaceStart = 1,
    MPAddressToReplaceDestination = 2,
};

@interface MPGlobalItineraryManager : NSObject

@property(nonatomic, strong) MPAddress *startAddress;
@property(nonatomic, strong) MPAddress *destinationAddress;
@property(nonatomic) MPAddressToReplace addressToReplace;
@property(nonatomic, strong) NSMutableArray *globalItineraryList;

+ (instancetype)sharedManager;
- (void)calculAllItinerary;
- (void)reset;
- (void)setAddress:(MPAddress*)address;

@end
