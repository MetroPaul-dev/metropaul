//
//  MPMetroCellCompressStepView.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 26/02/2017.
//  Copyright © 2017 Antoine Cointepas. All rights reserved.
//

#import "MPMetroCellCompressStepView.h"
#import "MPLanguageManager.h"

@interface MPMetroCellCompressStepView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *crossImageView;
@property (weak, nonatomic) IBOutlet UILabel *waitStationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *waitDurationImageView;
@property (weak, nonatomic) IBOutlet UILabel *waitDurationLabel;
@end

@implementation MPMetroCellCompressStepView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [[UINib nibWithNibName:@"MPMetroCellCompressStepView" bundle:nil] instantiateWithOwner:self options:nil];
        [self addSubview:_view];
        _view.frame = self.bounds;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _waitDurationImageView.tintColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:128/255.0];
}

- (void)setInformations:(UIColor*)color nbStation:(NSInteger)nbStation duration:(NSInteger)duration {
    self.crossImageView.tintColor = color;
    self.waitStationLabel.text = [NSString stringWithFormat:[[MPLanguageManager sharedManager] getStringWithKey:@"detail.wait.station"], nbStation];
    self.waitDurationLabel.text = [NSString stringWithFormat:@"%limin", duration];
}

@end
