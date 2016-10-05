//
//  MPSwitchCell.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 30/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPSwitchCell;

@protocol MPSwitchCellDelegate <NSObject>
@optional
- (void)switchCellChanged:(MPSwitchCell *)cell;
@end

@interface MPSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *switchView;
@property (nonatomic, weak) id <MPSwitchCellDelegate> delegate;

- (void)setTitle:(NSString*)title image:(UIImage*)image switchState:(BOOL)switchState;

@end
