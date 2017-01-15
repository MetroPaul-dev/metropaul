//
//  MenuView.h
//  FrameworkIOSDemo
//
//  Copyright (c) 2016 Skobbler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UISegmentedControl *positionSelect;
@property (nonatomic, strong) UIButton *clearViaPoint;
@property (nonatomic, strong) UISegmentedControl *viaPointSelect;
@property (nonatomic, strong) UIButton *navigateButton;
@property (nonatomic, strong) UIButton *freeDriveButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UIButton *minusButton;
@property (nonatomic, strong) UIButton *styleButton;
@property (nonatomic, assign) BOOL navigationStyle;
@property (nonatomic, assign) BOOL showClearViaPoint;

@end
