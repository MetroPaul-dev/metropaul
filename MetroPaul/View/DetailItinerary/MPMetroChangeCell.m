//
//  MPMetroChangeCell.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 26/12/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPMetroChangeCell.h"
#import "MPLine.h"

@interface MPMetroChangeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *transportImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ligneImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *durationImageView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *distanceImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation MPMetroChangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _durationImageView.tintColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:128/255.0];
    _distanceImageView.tintColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:128/255.0];
    _iconImageView.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
}

- (void)setSectionItinerary:(MPSectionItinerary *)sectionItinerary {
    _sectionItinerary = sectionItinerary;
    
    MPLine *line = [MPLine findByCode:_sectionItinerary.codeLine];
    if (line != nil) {
        self.transportImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@", [[line.transport_type substringToIndex:1] uppercaseString]]];
    }
    self.ligneImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ligne%@", _sectionItinerary.codeLine]];
    
    _durationLabel.text = [NSString stringWithFormat:@"%limin", sectionItinerary.duration/60];
    
    self.distanceLabel.hidden = YES;
    self.distanceImageView.hidden = YES;
    _distanceLabel.text = [NSString stringWithFormat:@"%im", 0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
