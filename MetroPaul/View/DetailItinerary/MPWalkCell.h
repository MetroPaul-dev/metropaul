//
//  MPWalkCell.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 26/12/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SKMaps/SKMaps.h>

@interface MPWalkCell : UITableViewCell
@property(nonatomic, strong) SKRouteInformation *routeInformation;
@end
