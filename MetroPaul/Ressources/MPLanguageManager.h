//
//  MPLanguageManager.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 30/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPLanguageManager : NSObject
+ (instancetype)sharedManager;
- (void)setLanguage:(NSString *)language;
- (NSString *)getStringWithKey:(NSString*)key comment:(NSString*)comment;
@end
