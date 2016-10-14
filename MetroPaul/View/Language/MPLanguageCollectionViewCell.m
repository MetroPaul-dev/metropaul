//
//  MPLanguageCollectionViewCell.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 29/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPLanguageCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface MPLanguageCollectionViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCenterConstraint;
@property(nonatomic, strong) CAShapeLayer *border;
@end

@implementation MPLanguageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.tintColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    self.label.font = [UIFont fontWithName:FONT_LIGHT size:16.0f];
    self.label.textColor = [Constantes blueBackGround];
    self.imageView.image = nil;
    self.labelCenterConstraint.constant = 0.0;
    
    _border = [CAShapeLayer layer];
    _border.strokeColor = [UIColor colorWithRed:55/255.0f green:106/255.0f blue:178/255.0f alpha:1].CGColor;
    _border.fillColor = [UIColor clearColor].CGColor;
    _border.lineDashPattern = @[@2, @4];
    _border.lineWidth = 2.0f;
}


- (void)layoutSubviews {
    [super layoutSubviews];

    [_border removeFromSuperlayer];
    [self.layer addSublayer:_border];
    _border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    _border.frame = self.bounds;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [Constantes blueBackGround];
        self.label.font = [UIFont fontWithName:FONT_BOLD size:16.0f];
        self.label.textColor = [UIColor whiteColor];
        self.imageView.image = [UIImage imageNamed:@"icon-valid"];
        self.labelCenterConstraint.constant = 10.0;
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.label.font = [UIFont fontWithName:FONT_LIGHT size:16.0f];
        self.label.textColor = [Constantes blueBackGround];
        self.imageView.image = nil;
        self.labelCenterConstraint.constant = 0.0;
    }
}

@end
