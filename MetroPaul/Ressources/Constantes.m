//
//  Constantes.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 29/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "Constantes.h"

@implementation Constantes

+ (UIColor *)blueBackGround {
    return [UIColor colorWithRed:(55/255.f) green:(106/255.f) blue:(178/255.f) alpha:1];
}

+ (UIColor *)gray {
    return [UIColor colorWithRed:(63/255.f) green:(63/255.f) blue:(63/255.f) alpha:1];
}

+ (UIColor *)purpleLoading {
    return [UIColor colorWithRed:(144/255.f) green:(91/255.f) blue:(161/255.f) alpha:1];
}

+ (UIColor *)orangeLoading {
    return [UIColor colorWithRed:(244/255.f) green:(156/255.f) blue:(20/255.f) alpha:1];
}

+ (UIColor *)blueLoading {
    return [UIColor colorWithRed:(57/255.f) green:(151/255.f) blue:(211/255.f) alpha:1];
}

+ (UIColor *)greenLoading {
    return [UIColor colorWithRed:(82/255.f) green:(179/255.f) blue:(110/255.f) alpha:1];
}

+ (UIColor *)redLoading {
    return [UIColor colorWithRed:(232/255.f) green:(76/255.f) blue:(60/255.f) alpha:1];
}

+ (NSArray*)rowMenu {
    NSArray *section0 = [NSArray arrayWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.map_itinerary" comment:nil], KEY_TITLE_ROW, [UIImage imageNamed:@"icon-search-menu"], KEY_IMAGE_ROW, nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.note" comment:nil], KEY_TITLE_ROW, [UIImage imageNamed:@"icon-rate"], KEY_IMAGE_ROW, nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.share" comment:nil], KEY_TITLE_ROW, [UIImage imageNamed:@"icon-share"], KEY_IMAGE_ROW, nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.map" comment:nil], KEY_TITLE_ROW, [UIImage imageNamed:@"icon-map"], KEY_IMAGE_ROW, nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.contact" comment:nil], KEY_TITLE_ROW, [UIImage imageNamed:@"icon-contact"], KEY_IMAGE_ROW, nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.cgu" comment:nil], KEY_TITLE_ROW, [UIImage imageNamed:@"icon-cgu"], KEY_IMAGE_ROW, nil],
                         nil];
    NSArray *section1 = [NSArray arrayWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.download" comment:nil], KEY_TITLE_ROW, [UIImage imageNamed:@"icon-download"], KEY_IMAGE_ROW, nil],
//                         [NSDictionary dictionaryWithObjectsAndKeys:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.pmr" comment:nil], KEY_TITLE_ROW, [UIImage imageNamed:@"icon-pmr"], KEY_IMAGE_ROW, nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.language" comment:nil], KEY_TITLE_ROW, [UIImage imageNamed:@"icon-flag"], KEY_IMAGE_ROW, nil],
                         nil];
    
    NSArray *datas = [NSArray arrayWithObjects:section0, section1, nil];
    
    return datas;
}

@end
