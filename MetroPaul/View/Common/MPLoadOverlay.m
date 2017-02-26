//
//  MPLoadOverlay.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 04/12/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPLoadOverlay.h"
#import "Constantes.h"

@interface MPLoadOverlay ()
@property (weak, nonatomic) IBOutlet UIImageView *imageAnimation;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *centralImage;

@end

@implementation MPLoadOverlay


- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageAnimation.animationImages = @[[UIImage imageNamed:@"load-animation1"], [UIImage imageNamed:@"load-animation2"], [UIImage imageNamed:@"load-animation3"]];
    self.imageAnimation.animationDuration = 1.0;
    [self.imageAnimation startAnimating];
}

- (void)randomLoadView {
    NSUInteger random = arc4random_uniform(4);
    [self loadViewConfiguration:random];
}

- (void)loadViewConfiguration:(NSInteger)configuration {
    MPLanguageManager *languageManager = [MPLanguageManager sharedManager];

    switch (configuration) {
        case 0: {
            self.backgroundColor = [Constantes purpleLoading];
            self.centralImage.image = [UIImage imageNamed:@"image-load1"];
            self.messageLabel.text = [languageManager getStringWithKey:@"load.message.1"];
            break;
        }
        case 1: {
            self.backgroundColor = [Constantes orangeLoading];
            self.centralImage.image = [UIImage imageNamed:@"image-load2"];
            self.messageLabel.text = [languageManager getStringWithKey:@"load.message.2"];
            break;
        }
        case 2: {
            self.backgroundColor = [Constantes blueLoading];
            self.centralImage.image = [UIImage imageNamed:@"image-load3"];
            self.messageLabel.text = [languageManager getStringWithKey:@"load.message.3"];
            break;
        }
        case 3: {
            self.backgroundColor = [Constantes greenLoading];
            self.centralImage.image = [UIImage imageNamed:@"image-load4"];
            self.messageLabel.text = [languageManager getStringWithKey:@"load.message.4"];
            break;
        }
        case 4: {
            self.backgroundColor = [Constantes redLoading];
            self.centralImage.image = [UIImage imageNamed:@"image-load5"];
            self.messageLabel.text = [languageManager getStringWithKey:@"load.message.5"];
            break;
        }
        default:{
            self.backgroundColor = [Constantes purpleLoading];
            self.centralImage.image = [UIImage imageNamed:@"image-load1"];
            self.messageLabel.text = [languageManager getStringWithKey:@"load.message.1"];
            break;
        }
    }
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
