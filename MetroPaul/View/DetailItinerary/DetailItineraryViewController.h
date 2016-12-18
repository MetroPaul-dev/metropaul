//
//  DetailItineraryViewController.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 18/12/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPBaseViewController.h"
#import "MPGlobalItinerary.h"

@interface DetailItineraryViewController : MPBaseViewController
@property(nonatomic, strong) MPGlobalItinerary *itinerary;
@end
