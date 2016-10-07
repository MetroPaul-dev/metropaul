//
//  MPSwitchCell.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 30/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPSwitchCell.h"

@interface MPSwitchCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MPSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.font = [UIFont fontWithName:FONT_MEDIUM size:16.0];
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = [UIColor clearColor];

    self.iconImageView.tintColor = [UIColor whiteColor];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.switchView.onTintColor = [Constantes gray];
    self.switchView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setTitle:(NSString*)title image:(UIImage*)image switchState:(BOOL)switchState {
    self.label.text = title;
    self.iconImageView.image = image;
    [self.switchView setOn:switchState];
}

- (IBAction)switchValueChanged:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchCellChanged:)]) {
        [self.delegate switchCellChanged:self];
    }
}

@end
