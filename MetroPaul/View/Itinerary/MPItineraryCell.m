//
//  MPItineraryCell.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 06/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPItineraryCell.h"
#import "MPSectionView.h"
#import "MPSectionItinerary.h"

@interface MPItineraryCell ()
@property (weak, nonatomic) IBOutlet MPSectionView *firstSectionView;
@property (weak, nonatomic) IBOutlet MPSectionView *secondSectionView;
@property (weak, nonatomic) IBOutlet MPSectionView *thirdSectionView;
@property (weak, nonatomic) IBOutlet MPSectionView *fourthSectionView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@end

@implementation MPItineraryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.durationLabel.font = [UIFont fontWithName:FONT_MEDIUM size:16.0];
}

- (void)setGlobalItinerary:(MPGlobalItinerary *)globalItinerary {
    _globalItinerary = globalItinerary;
    
    [self.durationLabel setText:[NSString stringWithFormat:@"%imin", (int)(globalItinerary.duration/60)]];
    
    [self.firstSectionView setRouteInformation:globalItinerary.startRouteInformation];
    [self.fourthSectionView setRouteInformation:globalItinerary.destinationRouteInformation];
    
    for (MPSectionItinerary *sectionItinerary in [globalItinerary.itineraryMetro readItinerary]) {
        if (sectionItinerary.type == MPStepItineraryTransport) {
            if (self.secondSectionView.sectionItinerary == nil) {
                [self.secondSectionView setSectionItinerary:sectionItinerary];
            } else if (self.thirdSectionView.sectionItinerary == nil) {
                [self.thirdSectionView setSectionItinerary:sectionItinerary];
            } else {
                break;
            }
        }
    }

    NSMutableString *itineraryString = [NSMutableString string];
    [itineraryString appendFormat:@" - Metro %@\nMetro %@ - ", [globalItinerary.startStopArea name],  [globalItinerary.destinationStopArea name]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
