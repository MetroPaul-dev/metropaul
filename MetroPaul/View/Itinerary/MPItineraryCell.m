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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstSectionviewWidthConstraint;
@property (weak, nonatomic) IBOutlet MPSectionView *secondSectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondSectionviewWidthConstraint;
@property (weak, nonatomic) IBOutlet MPSectionView *thirdSectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdSectionviewWidthConstraint;
@property (weak, nonatomic) IBOutlet MPSectionView *fourthSectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthSectionviewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@end

@implementation MPItineraryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.durationLabel.font = [UIFont fontWithName:FONT_MEDIUM size:16.0];
    self.durationLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotLine"]];
}

- (void)setGlobalItinerary:(MPGlobalItinerary *)globalItinerary {
    _globalItinerary = globalItinerary;
    [self reinitSectionView];
    [self.durationLabel setText:[NSString stringWithFormat:@"%imin", (int)(globalItinerary.duration/60)]];
    
    if (globalItinerary.startRouteInformation != nil && globalItinerary.startStopArea == nil && globalItinerary.itineraryMetro == nil && globalItinerary.destinationStopArea == nil && globalItinerary.destinationRouteInformation == nil) {
        [self itineraryFullSkobbler];
    } else {
        NSArray *sectionsItinerary = [globalItinerary.itineraryMetro readItinerary];
        
        [self.firstSectionView setRouteInformation:globalItinerary.startRouteInformation];
        [self.fourthSectionView setRouteInformation:globalItinerary.destinationRouteInformation];
        
        if (sectionsItinerary.count > 2) {
            MPSectionItinerary *section = [sectionsItinerary firstObject];
            if ([section type] == MPStepItineraryStreet) {
                [self.firstSectionView addDuration:section.duration];
            }
            section = [sectionsItinerary lastObject];
            if ([section type] == MPStepItineraryStreet) {
                [self.fourthSectionView addDuration:section.duration];
            }
        }
        
        for (MPSectionItinerary *sectionItinerary in sectionsItinerary) {
            if (sectionItinerary.type == MPStepItineraryTransport) {
                if (self.secondSectionView.sectionItinerary == nil) {
                    [self.secondSectionView setSectionItinerary:sectionItinerary];
                } else
                    //                if (self.thirdSectionView.sectionItinerary == nil)
                {
                    [self.thirdSectionView setSectionItinerary:sectionItinerary];
                }
                //            else {
                //                break;
                //            }
            }
        }
        [self sectionDisposition];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)sectionDisposition {
    NSArray *sectionsItinerary = [self.globalItinerary.itineraryMetro readItinerary];
    NSInteger nbSection = 0;
    
    if (self.globalItinerary.startRouteInformation != nil) {
        nbSection = nbSection + 1;
    } else {
        if (sectionsItinerary.count > 2) {
            MPSectionItinerary *section = [sectionsItinerary firstObject];
            if ([section type] == MPStepItineraryStreet) {
                nbSection = nbSection + 1;
            }
        }
    }
    if (self.globalItinerary.destinationRouteInformation != nil ) {
        nbSection = nbSection + 1;

    } else {
        if (sectionsItinerary.count > 2) {
            MPSectionItinerary *section = [sectionsItinerary lastObject];
            if ([section type] == MPStepItineraryStreet) {
                nbSection = nbSection + 1;
            }
        }
    }
    NSInteger nbSectionItinerary = 0;
    for (MPSectionItinerary *sectionItinerary in sectionsItinerary) {
        if (sectionItinerary.type == MPStepItineraryTransport) {
            nbSectionItinerary++;
        }
    }
    nbSection = nbSection + (nbSectionItinerary > 2 ? 2 : nbSectionItinerary);
    
    CGFloat totalSize = self.frame.size.width-50;
    switch (nbSection) {
        case 1:{
            self.firstSectionviewWidthConstraint.constant = totalSize;
            self.secondSectionviewWidthConstraint.constant = 0;
            self.thirdSectionviewWidthConstraint.constant = 0;
            self.fourthSectionviewWidthConstraint.constant = 0;
            [self.firstSectionView isLastSection:YES];
            [self.secondSectionView isLastSection:NO];
            [self.thirdSectionView isLastSection:NO];
            [self.fourthSectionView isLastSection:NO];
            self.secondSectionView.hidden = self.thirdSectionView.hidden = self.fourthSectionView.hidden = YES;
            break;
        }
        case 2:{
            self.firstSectionviewWidthConstraint.constant = totalSize/2;
            self.secondSectionviewWidthConstraint.constant = totalSize/2;
            self.thirdSectionviewWidthConstraint.constant = 0;
            self.fourthSectionviewWidthConstraint.constant = 0;
            [self.firstSectionView isLastSection:NO];
            [self.secondSectionView isLastSection:YES];
            [self.thirdSectionView isLastSection:NO];
            [self.fourthSectionView isLastSection:NO];
            self.secondSectionView.hidden = NO;
            self.thirdSectionView.hidden = self.fourthSectionView.hidden = YES;
            break;
        }
        case 3:{
            self.firstSectionviewWidthConstraint.constant = totalSize/3;
            self.secondSectionviewWidthConstraint.constant = totalSize/3;
            self.thirdSectionviewWidthConstraint.constant = 0;
            self.fourthSectionviewWidthConstraint.constant = totalSize/3;
            [self.firstSectionView isLastSection:NO];
            [self.secondSectionView isLastSection:NO];
            [self.thirdSectionView isLastSection:NO];
            [self.fourthSectionView isLastSection:YES];
            self.thirdSectionView.hidden = YES;
            self.secondSectionView.hidden = self.fourthSectionView.hidden = NO;
            break;
        }
        case 4:{
            self.firstSectionviewWidthConstraint.constant = totalSize/4;
            self.secondSectionviewWidthConstraint.constant = totalSize/4;
            self.thirdSectionviewWidthConstraint.constant = totalSize/4;
            self.fourthSectionviewWidthConstraint.constant = totalSize/4;
            [self.firstSectionView isLastSection:NO];
            [self.secondSectionView isLastSection:NO];
            [self.thirdSectionView isLastSection:NO];
            [self.fourthSectionView isLastSection:YES];
            self.secondSectionView.hidden = self.thirdSectionView.hidden = self.fourthSectionView.hidden = NO;
            break;
        }
        default:
            break;
    }
    [self layoutIfNeeded];
}

- (void)itineraryFullSkobbler {
    [self.firstSectionView setRouteInformation:self.globalItinerary.startRouteInformation];
    [self sectionDisposition];
}

- (void)reinitSectionView {
    [self.firstSectionView reinit];
    [self.secondSectionView reinit];
    [self.thirdSectionView reinit];
    [self.fourthSectionView reinit];
}


@end
