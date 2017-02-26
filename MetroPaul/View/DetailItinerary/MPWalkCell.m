//
//  MPWalkCell.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 26/12/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPWalkCell.h"

@interface MPWalkCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *durationImageView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *distanceImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation MPWalkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    _durationImageView.tintColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:128/255.0];
    _distanceImageView.tintColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:128/255.0];
    _iconImageView.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];

    // Initialization code
}

-(void)setRouteInformation:(SKRouteInformation *)routeInformation {
    _routeInformation = routeInformation;
    
    switch (routeInformation.routeMode) {
        case SKRoutePedestrian: {
            _titleLabel.text = @"MARCHEZ À PIED";
            _iconImageView.image = [UIImage imageNamed:@"icon-pieton"];
            break;
        }
        case SKRouteBicycleFastest: {
            _titleLabel.text = @"EN VÉLO";
            _iconImageView.image = [UIImage imageNamed:@"icon-velo"];
            break;
        }
        case SKRouteCarFastest: {
            _titleLabel.text = @"EN VOITURE";
            _iconImageView.image = [UIImage imageNamed:@"icon-car"];
            break;
        }
        default: {
            _titleLabel.text = @"MARCHEZ À PIED";
            _iconImageView.image = [UIImage imageNamed:@"icon-pieton"];
            break;
        }
    }
    
    _durationLabel.text = [NSString stringWithFormat:@"%imin", routeInformation.estimatedTime/60];
    _distanceLabel.text = [NSString stringWithFormat:@"%im",routeInformation.distance];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
