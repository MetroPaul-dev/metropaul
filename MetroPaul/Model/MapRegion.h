//
//  MapRegion.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 02/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SKMaps/SKBoundingBox.h>

typedef enum
{
    kMapRegionTypeCity=0,
    kMapRegionTypeState,
    kMapRegionTypeCountry,
    kMapRegionTypeContinent
}MapRegionType;

@interface MapRegion : NSObject

@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) MapRegionType type;
@property (nonatomic,strong) NSString *mapURL;
@property (nonatomic,strong) NSString *nbURL;
@property (nonatomic,strong) NSString *textureURL;
@property (nonatomic,strong) NSString *parentCode;
@property (nonatomic,strong) NSMutableArray *childRegions;
@property (nonatomic,strong) SKBoundingBox *boundingBox;

@end
