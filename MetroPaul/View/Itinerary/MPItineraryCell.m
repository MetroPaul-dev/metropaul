//
//  MPItineraryCell.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 06/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPItineraryCell.h"

@interface MPItineraryCell ()
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *itineraryLabel;
@end

@implementation MPItineraryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGlobalItinerary:(MPGlobalItinerary *)globalItinerary {
    _globalItinerary = globalItinerary;
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@""];
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIFont fontWithName:FONT_REGULAR size:15.f], NSFontAttributeName,
                                 [UIColor blackColor], NSForegroundColorAttributeName, nil];
    NSAttributedString * subString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i", (int)(globalItinerary.duration/60)] attributes:attributes];
    [string appendAttributedString:subString];
    
    NSDictionary * attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont fontWithName:FONT_REGULAR size:12.f],NSFontAttributeName,
                                  [UIColor blackColor], NSForegroundColorAttributeName, nil];
    NSAttributedString * subString2 = [[NSAttributedString alloc] initWithString:@"MIN" attributes:attributes2];
    [string appendAttributedString:subString2];
                                      
    [self.durationLabel setAttributedText:string];
    
    NSMutableString *itineraryString = [NSMutableString string];
    switch (globalItinerary.startRouteInformation.routeMode) {
        case SKRouteCarFastest: {
            [itineraryString appendFormat:@"%imin voiture - Metro %@", (int)(globalItinerary.startRouteInformation.estimatedTime/60), [globalItinerary.startStopArea name]];
            break;
        }
        case SKRouteBicycleFastest: {
            [itineraryString appendFormat:@"%imin vélo - Metro %@", (int)(globalItinerary.startRouteInformation.estimatedTime/60), [globalItinerary.startStopArea name]];
            break;
        }
        case SKRoutePedestrian: {
            [itineraryString appendFormat:@"%imin piéton - Metro %@", (int)(globalItinerary.startRouteInformation.estimatedTime/60), [globalItinerary.startStopArea name]];
            break;
        }
        default:
            break;
    }
    
    [itineraryString appendString:@"\n"];
    
    switch (globalItinerary.destinationRouteInformation.routeMode) {
        case SKRouteCarFastest: {
            [itineraryString appendFormat:@"%imin voiture - Metro %@", (int)(globalItinerary.destinationRouteInformation.estimatedTime/60), [globalItinerary.destinationStopArea name]];
            break;
        }
        case SKRouteBicycleFastest: {
            [itineraryString appendFormat:@"%imin vélo - Metro %@", (int)(globalItinerary.destinationRouteInformation.estimatedTime/60), [globalItinerary.destinationStopArea name]];
            break;
        }
        case SKRoutePedestrian: {
            [itineraryString appendFormat:@"%imin piéton - Metro %@", (int)(globalItinerary.destinationRouteInformation.estimatedTime/60), [globalItinerary.destinationStopArea name]];
            break;
        }
        default:
            break;
    }
    
    self.itineraryLabel.text = itineraryString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
