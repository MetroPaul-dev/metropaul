//
//  SettingsViewController.h
//  FrameworkIOSDemo
//
//  Copyright (c) 2016 Skobbler. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SDKTools/Navigation/SKTNavigationConfiguration.h>

@interface SettingsViewController : UITableViewController

- (id)initWithConfigObject:(SKTNavigationConfiguration *)config;

@end
