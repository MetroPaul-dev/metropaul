//
//  MenuView.m
//  FrameworkIOSDemo
//
//  Copyright (c) 2016 Skobbler. All rights reserved.
//

#import "MenuView.h"
#import "UIView+Additions.h"
#import "UIDevice+Additions.h"

@implementation MenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addButtons];
        self.navigationStyle = NO;
        self.showClearViaPoint = NO;
    }
    return self;
}

- (void)setNavigationStyle:(BOOL)navigationStyle {
    if (navigationStyle) {
        _cancelButton.hidden = NO;
        _plusButton.hidden = NO;
        _minusButton.hidden = NO;
        _styleButton.hidden = NO;
        _navigateButton.hidden = YES;
        _freeDriveButton.hidden = YES;
        _positionSelect.hidden = YES;
        _settingsButton.hidden = YES;
        _viaPointSelect.hidden = YES;
        _clearViaPoint.hidden = YES;
        _cancelButton.frameY = 0.0;
        _styleButton.frameY = _cancelButton.frameMaxY + 1.0;
        _plusButton.frameY = _styleButton.frameMaxY + 1.0;
        _minusButton.frameY = _styleButton.frameMaxY + 1.0;
    } else {
        _cancelButton.hidden = YES;
        _plusButton.hidden = YES;
        _minusButton.hidden = YES;
        _navigateButton.hidden = NO;
        _freeDriveButton.hidden = NO;
        _positionSelect.hidden = NO;
        _settingsButton.hidden = NO;
        _styleButton.hidden = YES;
        _clearViaPoint.hidden = !self.showClearViaPoint;
        _viaPointSelect.hidden = NO;
        _positionSelect.frameY = 0.0;
        _navigateButton.frameY =  (_showClearViaPoint ? _clearViaPoint.frameMaxY : _viaPointSelect.frameMaxY) + 1.0;
        _freeDriveButton.frameY = _navigateButton.frameMaxY + 1.0;
        _settingsButton.frameY = _freeDriveButton.frameMaxY + 1.0;
    }
}

- (void)setShowClearViaPoint:(BOOL)showClearViaPoint {
    _showClearViaPoint = showClearViaPoint;
    self.navigationStyle = self.navigationStyle;
}

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    }
    
    return hitView;
}

- (void)addButtons {
    CGFloat sizeMultiplier = ([UIDevice isiPad] ? 2.0 : 1.0);
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_menuButton.backgroundColor = [UIColor brownColor];
	[_menuButton setTitle:@"<" forState:UIControlStateNormal];
	_menuButton.frame = CGRectMake(120.0 * sizeMultiplier, 0.0, 50.0, 50.0);
    _menuButton.tag = YES;
	[self addSubview:_menuButton];
    
    _positionSelect = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0 * sizeMultiplier, 40.0 * sizeMultiplier)];
    [_positionSelect addTarget:self action:@selector(positionChanged) forControlEvents:UIControlEventValueChanged];
    [_positionSelect insertSegmentWithTitle:@"Select start point" atIndex:0 animated:NO];
    [_positionSelect insertSegmentWithTitle:@"Select end point" atIndex:1 animated:NO];
    for (id segment in [_positionSelect subviews])
    {
        for (id label in [segment subviews])
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                UILabel *actualLabel = (UILabel *)label;
                actualLabel.adjustsFontSizeToFitWidth = YES;
                actualLabel.numberOfLines = 2;
            }
        }
    }
    
    _positionSelect.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    _positionSelect.selectedSegmentIndex = 1;
    [self addSubview:_positionSelect];
    
    _navigateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_navigateButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
	[_navigateButton setTitle:@"Calculate route(s)" forState:UIControlStateNormal];
	_navigateButton.titleLabel.textColor = [UIColor blackColor];
	_navigateButton.frame = CGRectMake(0.0, _positionSelect.frameMaxY, 120.0 * sizeMultiplier, 40.0 * sizeMultiplier);
	[self addSubview:_navigateButton];
    
	_freeDriveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_freeDriveButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
	[_freeDriveButton setTitle:@"Start free drive" forState:UIControlStateNormal];
	_freeDriveButton.titleLabel.textColor = [UIColor blackColor];
	_freeDriveButton.frame = CGRectMake(0.0, _navigateButton.frameMaxY, 120.0 * sizeMultiplier, 40.0 * sizeMultiplier);
	[self addSubview:_freeDriveButton];
    
	_cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_cancelButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
	[_cancelButton setTitle:@"Stop" forState:UIControlStateNormal];
	_cancelButton.titleLabel.textColor = [UIColor blackColor];
	_cancelButton.frame = CGRectMake(0.0, _freeDriveButton.frameMaxY, 120.0 * sizeMultiplier, 40.0 * sizeMultiplier);
	[self addSubview:_cancelButton];
    
    _styleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_styleButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
	[_styleButton setTitle:@"Change style" forState:UIControlStateNormal];
	_styleButton.titleLabel.textColor = [UIColor blackColor];
	_styleButton.frame = CGRectMake(0.0, _cancelButton.frameMaxY, 120.0 * sizeMultiplier, 40.0 * sizeMultiplier);
    _styleButton.tag = YES;
	[self addSubview:_styleButton];
    
    _settingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_settingsButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
	[_settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
	_settingsButton.titleLabel.textColor = [UIColor blackColor];
	_settingsButton.frame = CGRectMake(0.0, _styleButton.frameMaxY, 120.0 * sizeMultiplier, 40.0 * sizeMultiplier);
    _settingsButton.tag = YES;
	[self addSubview:_settingsButton];
    
    _plusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_plusButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
	[_plusButton setTitle:@"Increase simulation speed" forState:UIControlStateNormal];
	_plusButton.titleLabel.textColor = [UIColor blackColor];
    _plusButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _plusButton.titleLabel.numberOfLines = 2;
    _plusButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	_plusButton.frame = CGRectMake(0.0, _positionSelect.frameMaxY, 60 * sizeMultiplier, 40.0 * sizeMultiplier);
    _plusButton.tag = YES;
	[self addSubview:_plusButton];
    
    _minusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_minusButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
	[_minusButton setTitle:@"Decrease simulation speed" forState:UIControlStateNormal];
	_minusButton.titleLabel.textColor = [UIColor blackColor];
    _minusButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _minusButton.titleLabel.numberOfLines = 2;
    _minusButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	_minusButton.frame = CGRectMake(60.0 * sizeMultiplier + 1.0, _positionSelect.frameMaxY, 60 * sizeMultiplier - 1.0, 40.0 * sizeMultiplier);
    _minusButton.tag = YES;
	[self addSubview:_minusButton];
    
    _viaPointSelect = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0 * sizeMultiplier, 40.0 * sizeMultiplier)];
    [_viaPointSelect insertSegmentWithTitle:@"Select via point" atIndex:0 animated:NO];
    [_viaPointSelect addTarget:self action:@selector(viaPointChanged) forControlEvents:UIControlEventValueChanged];
    for (id segment in [_viaPointSelect subviews])
    {
        for (id label in [segment subviews])
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                UILabel *actualLabel = (UILabel *)label;
                actualLabel.adjustsFontSizeToFitWidth = YES;
                actualLabel.numberOfLines = 2;
            }
        }
    }
    _viaPointSelect.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    _viaPointSelect.frameY = _positionSelect.frameMaxY + 1;
    [self addSubview:_viaPointSelect];
    
    _clearViaPoint = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _clearViaPoint.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    [_clearViaPoint setTitle:@"Clear via point" forState:UIControlStateNormal];
    _clearViaPoint.titleLabel.textColor = [UIColor blackColor];
    _clearViaPoint.titleLabel.adjustsFontSizeToFitWidth = YES;
    _clearViaPoint.titleLabel.numberOfLines = 2;
    _clearViaPoint.titleLabel.textAlignment = NSTextAlignmentCenter;
    _clearViaPoint.frame = CGRectMake(0, _viaPointSelect.frameMaxY, 120 * sizeMultiplier - 1.0, 40.0 * sizeMultiplier);
    _clearViaPoint.tag = YES;
    _clearViaPoint.hidden = YES;
    [self addSubview:_clearViaPoint];
}

- (void)positionChanged {
    if (_positionSelect.selectedSegmentIndex >= 0) {
        _viaPointSelect.selectedSegmentIndex = -1;
    }
}

- (void)viaPointChanged {
    if (_viaPointSelect.selectedSegmentIndex >= 0) {
        _positionSelect.selectedSegmentIndex = -1;
    }
}

@end
