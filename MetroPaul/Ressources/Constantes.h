//
//  Constantes.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 29/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define FONT_REGULAR @"Roboto-Regular"
#define FONT_LIGHT @"Roboto-Light"
#define FONT_BOLD @"Roboto-Bold"
#define FONT_MEDIUM @"Roboto-Medium"
#define FONT_ITALIC @"Roboto-Italic"


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define KEY_TITLE_ROW @"KEY_TITLE_ROW"
#define KEY_IMAGE_ROW @"KEY_IMAGE_ROW"

#define STOP_AREA_DISTANCE_MAX 800


@interface Constantes : NSObject

+ (UIColor*)blueBackGround;
+ (UIColor*)gray;

+ (NSArray*)rowMenu;
@end
