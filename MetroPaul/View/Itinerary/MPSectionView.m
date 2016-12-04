//
//  MPSectionView.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 14/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPSectionView.h"
#import "MPLine.h"

@interface MPSectionView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *separatorImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageHrozontalAlignmentConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorWidthConstraint;

@property(nonatomic) NSInteger duration;

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

- (void)reinit {
    self.routeInformation = nil;
    self.sectionItinerary = nil;
}

- (void)setRouteInformation:(SKRouteInformation *)routeInformation {
    _routeInformation = routeInformation;
    self.duration = 0;
    if (routeInformation != nil) {
        self.firstImageHrozontalAlignmentConstraint.constant = 0.0;
        self.secondImageWidthConstraint.constant = 0.0;
        self.duration = routeInformation.estimatedTime;
        
        switch (routeInformation.routeMode) {
            case SKRouteCarFastest: {
                self.firstImageView.image = [UIImage imageNamed:@"icon-car"];
                break;
            }
            case SKRouteBicycleFastest: {
                self.firstImageView.image = [UIImage imageNamed:@"icon-velo"];
                break;
            }
            case SKRoutePedestrian: {
                self.firstImageView.image = [UIImage imageNamed:@"icon-pieton"];
                break;
            }
            default:
                self.firstImageView.image = [UIImage imageNamed:@"icon-pieton"];
                break;
        }
    } else {
        self.firstImageView.image = [UIImage imageNamed:@"icon-pieton"];
    }
    
    self.label.text = [NSString stringWithFormat:@"%limin", self.duration/60];
}

- (void)setSectionItinerary:(MPSectionItinerary *)sectionItinerary {
    _sectionItinerary = sectionItinerary;
    self.duration = 0;
    if (sectionItinerary != nil) {
        self.duration = sectionItinerary.duration;
        MPLine *line = [MPLine findByCode:_sectionItinerary.codeLine];
        if (line != nil) {
            self.firstImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@", [[line.transport_type substringToIndex:1] uppercaseString]]];
        }
        self.secondImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ligne%@", _sectionItinerary.codeLine]];
    } else {
        self.duration = 0;
    }
    
    self.label.text = [NSString stringWithFormat:@"%limin", self.duration/60];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.sectionItinerary != nil) {
        CGFloat globalWidth = [self.view getWidth];
        CGFloat width = globalWidth*0.3 > 25 ? 25 : globalWidth*0.3;
        self.firstImageHrozontalAlignmentConstraint.constant = -(width/2);
        self.firstImageWidthConstraint.constant = self.secondImageWidthConstraint.constant = width;
    }
    [self layoutIfNeeded];

}

- (void)isLastSection:(BOOL)last {
    if (last) {
        //        self.backgroundColor = self.view.backgroundColor = [UIColor clearColor];
        self.separatorImageView.hidden = YES;
        self.separatorWidthConstraint.constant = 0.0;
        //        self.separatorImageView.image = [UIImage imageNamed:@"itinerarySectionSeparatorClear"];
    } else {
        //        self.backgroundColor = self.view.backgroundColor = [UIColor whiteColor];
        self.separatorImageView.hidden = NO;
        self.separatorWidthConstraint.constant = 11.0;
        //        self.separatorImageView.image = [UIImage imageNamed:@"itinerarySectionSeparator"];
    }
}

- (void)addDuration:(NSInteger)durationToAdd {
    self.duration +=durationToAdd;
    self.label.text = [NSString stringWithFormat:@"%limin", self.duration/60];
}

@end
