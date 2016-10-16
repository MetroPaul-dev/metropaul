//
//  MPMapsCell.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 16/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPMapsCell.h"

@interface MPMapsCell ()
@property (weak, nonatomic) IBOutlet UIView *background;

@end

@implementation MPMapsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.font = [UIFont fontWithName:FONT_BOLD size:16.0];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.background.backgroundColor = [Constantes blueBackGround];
    // Initialization code
}

- (void)layoutSubviews {
    self.imageView.frame = CGRectMake(0, CGRectGetHeight(self.frame)/5, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2);
    self.textLabel.frame = CGRectMake(0, [self.imageView endOffY], CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-[self.imageView endOffY]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
