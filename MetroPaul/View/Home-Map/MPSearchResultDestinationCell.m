//
//  MPSearchResultDestinationCell.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 06/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPSearchResultDestinationCell.h"

@implementation MPSearchResultDestinationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [Constantes blueBackGround];
    self.imageView.tintColor = self.textLabel.textColor = self.button.tintColor = [UIColor whiteColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.textLabel.font = [UIFont fontWithName:FONT_MEDIUM size:13.0];
    self.textLabel.numberOfLines = 2;
    
    self.button.titleLabel.font = [UIFont fontWithName:FONT_MEDIUM size:16.0];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    self.imageView.frame = CGRectMake(0.0, [self getHeight]/4, [self getHeight], [self getHeight]/2);
    self.textLabel.frame = CGRectMake([self.imageView endOffX], 0, [self getWidth]-([self.imageView endOffX]+[self.button getWidth]), [self getHeight]);
}

- (IBAction)tapOnButton:(id)sender {
}

@end
