//
//  MPMetroCell.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 26/12/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPSectionItinerary.h"

@class MPMetroCell;

#define NORMAL_SIZE 35.0
#define FULL_SIZE 19.0

typedef NS_ENUM(NSInteger, MPMetroCellExpensionType) {
    MPMetroCellExpensionNil,
    MPMetroCellExpensionNormal,
    MPMetroCellExpensionFull,
};

@protocol MPMetroCellDelegate <NSObject>
@required
- (void)tapOnSwitchDimension:(MPMetroCell*)cell;
@end

@interface MPMetroCell : UITableViewCell
@property(nonatomic, weak) id <MPMetroCellDelegate> delegate;

@property(nonatomic, strong) MPSectionItinerary *sectionItinerary;
@property(nonatomic) MPMetroCellExpensionType expensionType;

@end
