//
//  UIView+CPSize.m
//  CamPark
//
//  Created by Antoine Cointepas on 08/10/2015.
//  Copyright © 2015 Antoine Cointepas. All rights reserved.
//

#import "UIView+CPSize.h"

@implementation UIView (CPSize)

- (CGFloat)endOffX {
    return self.frame.origin.x+self.frame.size.width;
}

- (CGFloat)endOffY {
    return self.frame.origin.y+self.frame.size.height;
}

- (CGFloat)getX {
    return self.frame.origin.x;
}

- (CGFloat)getY {
    return self.frame.origin.y;
}

- (CGFloat)getWidth {
    return self.frame.size.width;
}

- (CGFloat)getHeight {
    return self.frame.size.height;
}

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)setSize:(CGSize)size {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

@end
