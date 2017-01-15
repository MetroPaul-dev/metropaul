//
//  MPItineraryCell2.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 06/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPItineraryCell2.h"
#import "MPSectionView.h"
#import "MPSectionItinerary.h"

@interface MPItineraryCell2 ()
@property (weak, nonatomic) IBOutlet MPSectionView *firstSectionView;
@property (weak, nonatomic) IBOutlet MPSectionView *secondSectionView;
@property (weak, nonatomic) IBOutlet MPSectionView *thirdSectionView;
@property (weak, nonatomic) IBOutlet MPSectionView *fourthSectionView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@end

@implementation MPItineraryCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.durationLabel.font = [UIFont fontWithName:FONT_MEDIUM size:16.0];
    self.durationLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dotLine"]];
}

- (void)setGlobalItinerary:(MPGlobalItinerary *)globalItinerary {
    _globalItinerary = globalItinerary;
    [self reinitSectionView];
    [self.durationLabel setText:[NSString stringWithFormat:@"%imin", (int)(_globalItinerary.duration/60)]];
    
    if (_globalItinerary.startRouteInformation != nil && _globalItinerary.startStopArea == nil && _globalItinerary.itineraryMetro == nil && _globalItinerary.destinationStopArea == nil && _globalItinerary.destinationRouteInformation == nil) {
        [self itineraryFullSkobbler];
    } else {
        NSArray *sectionsItinerary = [_globalItinerary.itineraryMetro readItinerary];
        
        [self.firstSectionView setRouteInformation:_globalItinerary.startRouteInformation];
        [self.fourthSectionView setRouteInformation:_globalItinerary.destinationRouteInformation];
        
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
                } else if (sectionItinerary.type != MPStepItineraryOther)
                    //                if (self.thirdSectionView.sectionItinerary == nil)
                {
                    [self.thirdSectionView setSectionItinerary:sectionItinerary];
                }
                //            else {
                //                break;
                //            }
            }
        }
    }
    [self sectionDisposition];
    
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
            self.firstSectionView.hidden = NO;
            self.secondSectionView.hidden = self.thirdSectionView.hidden = self.fourthSectionView.hidden = YES;
            
            [self.firstSectionView isLastSection:YES];
            [self.secondSectionView isLastSection:NO];
            [self.thirdSectionView isLastSection:NO];
            [self.fourthSectionView isLastSection:NO];
            break;
        }
        case 2:{
            self.firstSectionView.hidden = self.secondSectionView.hidden = NO;
            self.thirdSectionView.hidden = self.fourthSectionView.hidden = YES;
            
            [self.firstSectionView isLastSection:NO];
            [self.secondSectionView isLastSection:YES];
            [self.thirdSectionView isLastSection:NO];
            [self.fourthSectionView isLastSection:NO];
            
            break;
        }
        case 3:{
            self.thirdSectionView.hidden = YES;
            self.firstSectionView.hidden = self.secondSectionView.hidden = self.fourthSectionView.hidden = NO;
            
            [self.firstSectionView isLastSection:NO];
            [self.secondSectionView isLastSection:NO];
            [self.thirdSectionView isLastSection:NO];
            [self.fourthSectionView isLastSection:YES];
            
            break;
        }
        case 4:{
            self.firstSectionView.hidden = self.secondSectionView.hidden = self.thirdSectionView.hidden = self.fourthSectionView.hidden = NO;
            
            [self.firstSectionView isLastSection:NO];
            [self.secondSectionView isLastSection:NO];
            [self.thirdSectionView isLastSection:NO];
            [self.fourthSectionView isLastSection:YES];
            break;
        }
        default:
            break;
    }
    
    // Si il n'y a pas de temps de marche ni de transport alors on cache
    if (nbSection >= 2 && [self.firstSectionView durationIsNull]) {
        self.firstSectionView.hidden = YES;
        switch (nbSection) {
            case 2:{
                [self.secondSectionView isLastSection:YES];
                break;
            }
            case 3:{
                [self.fourthSectionView isLastSection:YES];
                
                break;
            }
            case 4:{
                break;
            }
            default:
                break;
        }
        
    }
    if (nbSection >= 3 && [self.fourthSectionView durationIsNull]) {
        self.fourthSectionView.hidden = YES;
        if (nbSection == 3) {
            [self.secondSectionView isLastSection:YES];
        } else if (nbSection == 4) {
            [self.thirdSectionView isLastSection:YES];
        }
    }
    
    [self layoutIfNeeded];
}

- (void)itineraryFullSkobbler {
    [self.firstSectionView setRouteInformation:self.globalItinerary.startRouteInformation];
}

- (void)reinitSectionView {
    [self.firstSectionView reinit];
    [self.secondSectionView reinit];
    [self.thirdSectionView reinit];
    [self.fourthSectionView reinit];
}


@end
