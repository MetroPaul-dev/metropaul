//
//  MPMetroCell.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 26/12/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPMetroCell.h"
#import "MPLine.h"
#import "MPStopArea.h"
#import "Utilities.h"

@interface MPMetroCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *transportImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ligneImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itineraryImageView;
@property (weak, nonatomic) IBOutlet UILabel *startStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNextTransportLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNextTransportLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitStationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *waitDurationImageView;
@property (weak, nonatomic) IBOutlet UILabel *waitDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopStationLabel;

@end

@implementation MPMetroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _waitDurationImageView.tintColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:128/255.0];
    _iconImageView.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
}

- (void)setSectionItinerary:(MPSectionItinerary *)sectionItinerary {
    _sectionItinerary = sectionItinerary;
    
    MPLine *line = [MPLine findByCode:_sectionItinerary.codeLine];
    if (line != nil) {
        self.transportImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@", [[line.transport_type substringToIndex:1] uppercaseString]]];
    }
    self.ligneImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ligne%@", _sectionItinerary.codeLine]];
    
    self.itineraryImageView.tintColor = [Utilities UIColorFromRGB:line.color];
    
    MPStopArea *firstStopArea = [self.sectionItinerary.stopAreas firstObject];
    self.startStationLabel.text = [firstStopArea.name uppercaseString];
    
    self.waitStationLabel.text = [NSString stringWithFormat:@"ATTENDEZ %lu STATIONS", sectionItinerary.stopAreas.count-2];
    self.waitDurationLabel.text = [NSString stringWithFormat:@"%limin", sectionItinerary.duration/60];
    
    MPStopArea *lastStopArea = [self.sectionItinerary.stopAreas lastObject];
    self.stopStationLabel.text = [lastStopArea.name uppercaseString];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
