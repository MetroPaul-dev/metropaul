//
//  MPLanguageCollectionViewCell.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 29/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPLanguageCollectionViewCell.h"

@interface MPLanguageCollectionViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCenterConstraint;
@end

@implementation MPLanguageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.tintColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [Constantes blueBackGround];
        self.label.font = [UIFont fontWithName:FONT_BOLD size:16.0f];
        self.label.textColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.label.font = [UIFont fontWithName:FONT_REGULAR size:16.0f];
        self.label.textColor = [Constantes blueBackGround];

    }
}

@end
