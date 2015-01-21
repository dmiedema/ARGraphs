//
//  ARHelpers.m
//  ARGraphsDemo
//
//  Created by Alex Reynolds on 1/20/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ARHelpers.h"

@implementation ARHelpers
+ (CGColorRef)darkenColor:(CGColorRef)color withPercent:(CGFloat)percent {
    percent = 1.0 - fabs(percent);
    
    NSInteger   totalComponents = CGColorGetNumberOfComponents(color);
    BOOL  isGreyscale     = totalComponents == 2 ? YES : NO;
    
    CGFloat* oldComponents = (CGFloat *)CGColorGetComponents(color);
    CGFloat newComponents[4];
    
    if (isGreyscale) {
        newComponents[0] = oldComponents[0]*percent;
        newComponents[1] = oldComponents[0]*percent;
        newComponents[2] = oldComponents[0]*percent;
        newComponents[3] = oldComponents[1];
    } else {
        newComponents[0] = oldComponents[0]*percent;
        newComponents[1] = oldComponents[1]*percent;
        newComponents[2] = oldComponents[2]*percent;
        newComponents[3] = oldComponents[3];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
    CGColorSpaceRelease(colorSpace);
    
    return newColor;
}

+ (CGColorRef)lightenColor:(CGColorRef)color withPercent:(CGFloat)percent {
    percent = 1.0 + fabs(percent);
    
    NSInteger   totalComponents = CGColorGetNumberOfComponents(color);
    bool  isGreyscale     = totalComponents == 2 ? YES : NO;
    
    CGFloat* oldComponents = (CGFloat *)CGColorGetComponents(color);
    CGFloat newComponents[4];
    
    // FIXME: Clean this SHITE up
    if (isGreyscale) {
        newComponents[0] = MIN(oldComponents[0] * percent, 1.0);
        newComponents[1] = MIN(oldComponents[0] * percent, 1.0);
        newComponents[2] = MIN(oldComponents[0] * percent, 1.0);
        newComponents[3] = oldComponents[1];
    } else {
        newComponents[0] = MIN(oldComponents[0] * percent, 1.0);
        newComponents[1] = MIN(oldComponents[1] * percent, 1.0);
        newComponents[2] = MIN(oldComponents[2] * percent, 1.0);
        newComponents[3] = oldComponents[3];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
    CGColorSpaceRelease(colorSpace);
    return newColor;
}
@end