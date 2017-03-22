//
//  UIView+MyUtils.m
//  RACHoroscope
//
//  Created by v.q on 2017/3/21.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "UIView+MyUtils.h"

@implementation UIView (MyUtils)

- (void)setLayerBorderColor:(UIColor *)layerBorderColor {
    if (!layerBorderColor) { return; }
    self.layer.borderColor = layerBorderColor.CGColor;
}

- (nullable UIColor *)layerBorderColor {
    if (!self.layer.borderColor) { return nil; }
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

@end
