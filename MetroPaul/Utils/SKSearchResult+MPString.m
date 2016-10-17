//
//  MPString.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 17/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "SKSearchResult+MPString.h"

@implementation SKSearchResult (MPString)
- (NSString *)toString {
    NSMutableString *string = [NSMutableString stringWithString:self.name];
    if ([self.parentSearchResults[0] isKindOfClass:[SKSearchResult class]]) {
        SKSearchResult *streetResult = (SKSearchResult*)self.parentSearchResults[0];
        [string appendFormat:@" %@", [streetResult name]];
        for (SKSearchResultParent *parent in [streetResult parentSearchResults]) {
            if (parent.type < SKSearchResultStreet) {
                [string appendString:[NSString stringWithFormat:@", %@", parent.name]];
            }
        }
    } else {
        for (SKSearchResultParent *parent in self.parentSearchResults) {
            if (parent.type < SKSearchResultStreet) {
                [string appendString:[NSString stringWithFormat:@", %@", parent.name]];
            }
        }
    }
    return string;
}

@end
