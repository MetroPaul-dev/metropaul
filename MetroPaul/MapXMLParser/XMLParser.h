//
//  XMLParser.h
//  MetroPaul
//
//  Created by Antoine Cointepas on 02/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kParsingFinishedNotificationName = @"XMLParsingFinishedNotification";

@interface XMLParser : NSObject

@property(nonatomic,assign) BOOL isParsingFinished;
-(void)downloadAndParseXML;
- (void)downloadAndParseJSON;

+(XMLParser*)sharedInstance;

@end
