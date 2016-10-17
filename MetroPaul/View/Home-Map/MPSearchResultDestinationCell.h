//
//  MPSearchResultDestinationCell.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 06/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPStopArea.h"
#import <SKMaps/SKMaps.h>

@protocol MPSearchResultDestinationCellDelegate <NSObject>
@required
- (void)searchResultDestinationCellTapOnSearchResult:(SKSearchResult*)searchResult;
- (void)searchResultDestinationCellTapOnStopArea:(MPStopArea*)stopArea;
@end

@interface MPSearchResultDestinationCell : UITableViewCell
@property(nonatomic, weak) id <MPSearchResultDestinationCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property(nonatomic, strong) MPStopArea *stopArea;
@property(nonatomic, strong) SKSearchResult *searchResult;

@end
