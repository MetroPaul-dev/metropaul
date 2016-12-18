//
//  MPLoadOverlay.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 04/12/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPLoadOverlay.h"

@interface MPLoadOverlay ()
@property (weak, nonatomic) IBOutlet UIImageView *imageAnimation;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation MPLoadOverlay


- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageAnimation.animationImages = @[[UIImage imageNamed:@"load-animation1"], [UIImage imageNamed:@"load-animation2"], [UIImage imageNamed:@"load-animation3"]];
    self.imageAnimation.animationDuration = 1.0;
    [self.imageAnimation startAnimating];
}

- (void)dealloc {
    [self.imageAnimation stopAnimating];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
