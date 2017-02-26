//
//  MPMetroCellExpandStepView.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 26/02/2017.
//  Copyright © 2017 Antoine Cointepas. All rights reserved.
//

#import "MPMetroCellExpandStepView.h"

@interface MPMetroCellExpandStepView()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation MPMetroCellExpandStepView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [[UINib nibWithNibName:@"MPMetroCellExpandStepView" bundle:nil] instantiateWithOwner:self options:nil];
        [self addSubview:_view];
        _view.frame = self.bounds;
    }
    return self;
}

- (void)setInformations:(UIColor*)color title:(NSString*)title {
    self.imageView.tintColor = color;
    self.label.text = [title uppercaseString];
}

@end
