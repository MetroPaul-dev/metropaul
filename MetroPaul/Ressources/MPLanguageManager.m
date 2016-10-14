//
//  MPLanguageManager.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 30/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPLanguageManager.h"

@interface MPLanguageManager ()
@property(nonatomic, strong) NSString *language;
@property(nonatomic, strong) NSBundle *localeBundle;

@end

@implementation MPLanguageManager

+ (instancetype)sharedManager {
    static MPLanguageManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{        
        _sharedManager = [[self alloc] init];
        NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];

        NSString *path = [[ NSBundle mainBundle ] pathForResource:[languages objectAtIndex:0] ofType:@"lproj"];
        if (path) {
            _sharedManager.localeBundle = [NSBundle bundleWithPath:path];
        }
        else {
            _sharedManager.localeBundle = [NSBundle mainBundle];
        }
        if (_sharedManager.localeBundle == nil) {
            _sharedManager.localeBundle = [NSBundle mainBundle];
        }

    });
    
    return _sharedManager;
}

- (void)setLanguage:(NSString *)language {
    NSMutableArray *languages = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]];
    [languages removeObject:language];
    [languages insertObject:language atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:languages forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *path = [[ NSBundle mainBundle ] pathForResource:language ofType:@"lproj"];
    if (path) {
        self.localeBundle = [NSBundle bundleWithPath:path];
    }
    else {
        self.localeBundle = [NSBundle mainBundle];
    }
    if (self.localeBundle == nil) {
        self.localeBundle = [NSBundle mainBundle];
    }
}

- (NSString *)getStringWithKey:(NSString*)key {
    
    return [self getStringWithKey:key comment:nil];
}

- (NSString *)getStringWithKey:(NSString*)key comment:(NSString*)comment {
    return [self.localeBundle localizedStringForKey:key value:@"" table:nil];
}


@end
