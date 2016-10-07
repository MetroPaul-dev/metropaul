//
//  UIView+CPSize.h
//  CamPark
//
//  Created by Antoine Cointepas on 08/10/2015.
//  Copyright © 2015 Antoine Cointepas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CPSize)

- (CGFloat)endOffX;

- (CGFloat)endOffY;

- (CGFloat)getX;

- (CGFloat)getY;

- (CGFloat)getWidth;

- (CGFloat)getHeight;

- (void)setX:(CGFloat)x;

- (void)setY:(CGFloat)y;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

- (void)setSize:(CGSize)size;

@end
