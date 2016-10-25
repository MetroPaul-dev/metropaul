//
//  MPSectionView.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 14/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPSectionView.h"
#import "MPLine.h"

#define kFirstImageHrozontalAlignment -13.0

@interface MPSectionView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *separatorImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageHrozontalAlignmentConstraint;

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
    
    if (routeInformation != nil) {
        self.firstImageHrozontalAlignmentConstraint.constant = 0.0;
        self.secondImageWidthConstraint.constant = 0.0;
        
        switch (routeInformation.routeMode) {
            case SKRouteCarFastest: {
                self.label.text = [NSString stringWithFormat:@"%imin", (int)(routeInformation.estimatedTime/60)];
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
    } else {
        
    }
}

- (void)setSectionItinerary:(MPSectionItinerary *)sectionItinerary {
    _sectionItinerary = sectionItinerary;
    if (sectionItinerary != nil) {
    self.firstImageHrozontalAlignmentConstraint.constant = kFirstImageHrozontalAlignment;
    self.secondImageWidthConstraint.constant = 25.0;
    
    self.label.text = [NSString stringWithFormat:@"%imin", (int)(_sectionItinerary.duration/60)];
    MPLine *line = [MPLine findByCode:_sectionItinerary.codeLine];
    if (line != nil) {
        self.firstImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@", [[line.transport_type substringToIndex:1] uppercaseString]]];
    }
    self.secondImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ligne%@", _sectionItinerary.codeLine]];
    } else {
        
    }
}

- (void)isLastSection:(BOOL)last {
    if (last) {
        self.backgroundColor = self.view.backgroundColor = [UIColor clearColor];
        //        self.separatorImageView.image = [UIImage imageNamed:@"itinerarySectionSeparatorClear"];
    } else {
        self.backgroundColor = self.view.backgroundColor = [UIColor whiteColor];
        //        self.separatorImageView.image = [UIImage imageNamed:@"itinerarySectionSeparator"];
    }
}

@end
