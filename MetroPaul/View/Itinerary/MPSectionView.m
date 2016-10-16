//
//  MPSectionView.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 14/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPSectionView.h"

@interface MPSectionView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorWidthConstraint;
@end

@implementation MPSectionView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [[UINib nibWithNibName:@"MPSectionView" bundle:nil] instantiateWithOwner:self options:nil];
        [self addSubview:_view];
        _view.frame = self.bounds;
    }
    return self;
}

- (void)setRouteInformation:(SKRouteInformation *)routeInformation {
    _routeInformation = routeInformation;
    
    switch (routeInformation.routeMode) {
        case SKRouteCarFastest: {
            self.label.text = [NSString stringWithFormat:@"%imin voiture", (int)(routeInformation.estimatedTime/60)];
            self.firstImageView.image = [UIImage imageNamed:@"icon-car"];
            break;
        }
        case SKRouteBicycleFastest: {
            self.label.text = [NSString stringWithFormat:@"%imin", (int)(routeInformation.estimatedTime/60)];
            self.firstImageView.image = [UIImage imageNamed:@"icon-velo"];
            break;
        }
        case SKRoutePedestrian: {
            self.label.text = [NSString stringWithFormat:@"%imin", (int)(routeInformation.estimatedTime/60)];
            self.firstImageView.image = [UIImage imageNamed:@"icon-pieton"];
            break;
        }
        default:
            break;
    }
}

- (void)setSectionItinerary:(MPSectionItinerary *)sectionItinerary {
    _sectionItinerary = sectionItinerary;
    self.label.text = [NSString stringWithFormat:@"%imin", (int)(_sectionItinerary.duration/60)];
    self.firstImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ligne%@", _sectionItinerary.codeLine]];
}

@end
