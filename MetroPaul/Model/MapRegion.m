//
//  MapRegion.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 02/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MapRegion.h"

@implementation MapRegion

-(id)init
{
    self = [super init];
    if (self)
    {
        self.childRegions=[NSMutableArray array];
    }
    return self;
}

- (BOOL)isEqual:(id)other
{
    if ([[(MapRegion*)other code]isEqual:[self code]])
    {
        return YES;
    }
    return NO;
    
}


@end
