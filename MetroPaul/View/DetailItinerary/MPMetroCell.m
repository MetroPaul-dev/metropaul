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
#import "MPMetroCellCompressStepView.h"
#import "MPMetroCellExpandStepView.h"

@interface MPMetroCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *transportImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ligneImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@property (weak, nonatomic) IBOutlet UIImageView *startStationImageView;
@property (weak, nonatomic) IBOutlet UILabel *startStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNextTransportLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNextTransportLabel;
@property (weak, nonatomic) IBOutlet UIStackView *stepStackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stepStackViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *switchDimensionButton;

@property (weak, nonatomic) IBOutlet UIImageView *stopStationImageView;
@property (weak, nonatomic) IBOutlet UILabel *stopStationLabel;

@property(nonatomic, strong) IBOutlet MPMetroCellCompressStepView *compressStepView;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep1;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep2;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep3;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep4;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep5;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep6;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep7;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep8;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep9;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep10;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep11;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep12;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep13;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep14;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep15;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep16;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep17;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep18;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep19;
@property (weak, nonatomic) IBOutlet MPMetroCellExpandStepView *expandStep20;
@property(nonatomic, strong) NSArray *arrayExpandView;

@end

@implementation MPMetroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _iconImageView.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.arrayExpandView = @[_expandStep1, _expandStep2, _expandStep3, _expandStep4, _expandStep5, _expandStep6, _expandStep7, _expandStep8, _expandStep9, _expandStep10, _expandStep11, _expandStep12, _expandStep13, _expandStep14, _expandStep15, _expandStep16, _expandStep17, _expandStep18, _expandStep19, _expandStep20];
}

- (void)setSectionItinerary:(MPSectionItinerary *)sectionItinerary {
    _sectionItinerary = sectionItinerary;
    
    MPLine *line = [MPLine findByCode:_sectionItinerary.codeLine];
    if (line != nil) {
        self.transportImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%@", [[line.transport_type substringToIndex:1] uppercaseString]]];
    }
    self.ligneImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ligne%@", _sectionItinerary.codeLine]];
    
    self.iconImageView.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.startStationImageView.tintColor = [Utilities UIColorFromRGB:line.color];
    self.lineImageView.tintColor = [Utilities UIColorFromRGB:line.color];
    self.stopStationImageView.tintColor = [Utilities UIColorFromRGB:line.color];
    
    
    MPStopArea *firstStopArea = [self.sectionItinerary.stopAreas firstObject];
    self.startStationLabel.text = [firstStopArea.name uppercaseString];
    
    [self.compressStepView setInformations:[Utilities UIColorFromRGB:line.color] nbStation:sectionItinerary.stopAreas.count-2 duration:sectionItinerary.duration/60];
    
    [self.stepStackView addArrangedSubview:self.compressStepView];
    
    MPStopArea *lastStopArea = [self.sectionItinerary.stopAreas lastObject];
    self.stopStationLabel.text = [lastStopArea.name uppercaseString];
    for (int i = 0; i < self.sectionItinerary.stopAreas.count-1 ; i++) {
        MPMetroCellExpandStepView *view = [self.arrayExpandView objectAtIndex:i];
        MPStopArea *stopArea = [self.sectionItinerary.stopAreas objectAtIndex:i];
        [view setInformations:[Utilities UIColorFromRGB:line.color] title:stopArea.name];
    }
    
    self.titleLabel.text = [[NSString stringWithFormat:[[MPLanguageManager sharedManager] getStringWithKey:@"detail.direction"], lastStopArea.name] uppercaseString];
}

- (void)setExpensionType:(MPMetroCellExpensionType)expensionType {
    _expensionType = expensionType;
    switch (expensionType) {
        case MPMetroCellExpensionNil:
            self.lineImageView.hidden = true;
            self.compressStepView.hidden = true;
            self.startStationImageView.hidden = true;
            self.startStationLabel.hidden = true;
            self.stopStationImageView.hidden = true;
            self.stopStationLabel.hidden = true;
            for (MPMetroCellExpandStepView *view in self.arrayExpandView) {
                view.hidden = true;
            }

            break;
        case MPMetroCellExpensionNormal:
            self.lineImageView.hidden = false;
            self.compressStepView.hidden = false;
            self.startStationImageView.hidden = false;
            self.startStationLabel.hidden = false;
            self.stopStationImageView.hidden = false;
            self.stopStationLabel.hidden = false;
            for (MPMetroCellExpandStepView *view in self.arrayExpandView) {
                view.hidden = true;
            }
            
            self.stepStackViewHeightConstraint.constant = NORMAL_SIZE;

            break;
        case MPMetroCellExpensionFull:
            self.lineImageView.hidden = false;
            self.compressStepView.hidden = true;
            self.startStationImageView.hidden = false;
            self.startStationLabel.hidden = false;
            self.stopStationImageView.hidden = false;
            self.stopStationLabel.hidden = false;
            
            for (int i = 0; i < self.sectionItinerary.stopAreas.count-1 ; i++) {
                MPMetroCellExpandStepView *view = [self.arrayExpandView objectAtIndex:i];
                view.hidden = false;
            }
            
            self.stepStackViewHeightConstraint.constant = FULL_SIZE * (self.sectionItinerary.stopAreas.count-1);

            break;

            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)tapOnSwitchDimensionButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapOnSwitchDimension:)]) {
        [self.delegate tapOnSwitchDimension:self];
    }
}


@end
