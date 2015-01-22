//
//  CYCMinMaxLabelLayer.m
//  Cyclr
//
//  Created by Alex Reynolds on 1/9/15.
//  Copyright (c) 2015 Cyclr. All rights reserved.
//

#import "ARYMinMaxLayer.h"
#import "ARGraphDataPoint.h"
#import <UIKit/UIKit.h>

@interface ARYMinMaxLayer()

@property (nonatomic, strong) CATextLayer *minTextLayer;
@property (nonatomic, strong) CATextLayer *maxTextLayer;
@property (nonatomic) CGColorRef defaultLineColor;
@property (nonatomic) CGColorRef defaultLabelColor;

@end

@implementation ARYMinMaxLayer

- (instancetype)init
{
    self = [super init];
    CGFloat fillColors [] = {
        1.0, 1.0, 1.0, 0.6
    };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); //NEED TO RELEASE
    _defaultLineColor = CGColorCreate(colorSpace, fillColors); //RELEASE ON DEalloc
    _defaultLabelColor = CGColorCreate(colorSpace, fillColors); //RELEASE ON DEalloc
    
    CGColorSpaceRelease(colorSpace);
    
    [self addSublayer:self.minTextLayer];
    [self addSublayer:self.maxTextLayer];
    

    return self;
}

- (void)dealloc
{
    CGColorRelease(_defaultLineColor);
    CGColorRelease(_defaultLabelColor);
}
#pragma mark - Setters

- (void)setLineColor:(CGColorRef)lineColor
{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setLabelColor:(CGColorRef)labelColor
{
    _labelColor = labelColor;
    self.minTextLayer.foregroundColor = labelColor;
    self.maxTextLayer.foregroundColor = labelColor;
    [self setNeedsDisplay];
}


- (void)setYMax:(NSInteger)yMax
{
    _yMax = yMax;
    [self.maxTextLayer setString:[NSString stringWithFormat:@"%ld",(long)yMax]];

}

- (void)setYMin:(NSInteger)yMin
{
    _yMin = yMin;
    [self.minTextLayer setString:[NSString stringWithFormat:@"%ld",(long)yMin]];
    
}

#pragma mark - Helpers

- (CGFloat)yPositionForYDataPoint:(NSInteger)dataPoint inHeight:(CGFloat)height
{
    CGFloat range = self.yMax - self.yMin;
    CGFloat availableHeight = height - self.topPadding - self.bottomPadding;
    CGFloat normalizedDataPointYValue = dataPoint - self.yMin;

    CGFloat percentageOfDataPointToRange =  (normalizedDataPointYValue / range);
    CGFloat inversePercentage = 1.0 - percentageOfDataPointToRange; // Must invert because the greater the value the higher we want it on the chart which is a smaller y value on a iOS coordinate system
    if(range == 0){
        return NSNotFound;
    }else{
        return self.topPadding + inversePercentage * availableHeight;
    }
}

- (CGRect)frameforMinLabel
{
    CGRect rect = [self.minTextLayer.string boundingRectWithSize:self.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
    rect.origin.x = self.bounds.size.width - rect.size.width - 8;
    rect.origin.y = [self yPositionForYDataPoint:self.yMin inHeight:self.bounds.size.height] - rect.size.height;
    if(rect.origin.y == NSNotFound){
        rect = CGRectZero;
    }
    return rect;

}

- (CGRect)frameforMaxLabel
{
    CGRect rect = [self.maxTextLayer.string boundingRectWithSize:self.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
    rect.origin.x = self.bounds.size.width - rect.size.width - 8;
    rect.origin.y = [self yPositionForYDataPoint:self.yMax inHeight:self.bounds.size.height];
    if(rect.origin.y == NSNotFound){
        rect = CGRectZero;
    }
    return rect;
}

- (void)layoutSublayers
{
    self.minTextLayer.frame = [self frameforMinLabel];
    self.maxTextLayer.frame = [self frameforMaxLabel];
}

- (void)drawInContext:(CGContextRef)ctx
{
    if(_lineColor){
        CGContextSetStrokeColorWithColor(ctx, self.lineColor);
    }else {
        CGContextSetStrokeColorWithColor(ctx, _defaultLineColor);
    }
    CGContextSetLineWidth(ctx, 1.0);

    CGFloat minY = [self yPositionForYDataPoint:self.yMin inHeight:self.bounds.size.height];
    CGFloat maxY = [self yPositionForYDataPoint:self.yMax inHeight:self.bounds.size.height];

    if(minY != NSNotFound){
        CGContextMoveToPoint(ctx, 0, minY);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, minY);
    }
    
    if(maxY != NSNotFound){
        CGContextMoveToPoint(ctx, 0, maxY);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, maxY);
    }

    CGContextStrokePath(ctx);
}

#pragma mark - Layer Creation Methods

- (CATextLayer *)minTextLayer
{
    if(_minTextLayer == nil){
        CATextLayer *textLayer = [CATextLayer layer];

        [textLayer setString:@"Hello World"];
        if(_labelColor){
            [textLayer setForegroundColor:self.labelColor];
        }else {
            [textLayer setForegroundColor:_defaultLabelColor];
        }
        [textLayer setFontSize:12.0];
        CGFontRef font = CGFontCreateWithFontName((CFStringRef)@"Helvetica"); //NEED TO RELEASE
        textLayer.font = font;

        CGFontRelease(font); //RELEASED
        textLayer.shouldRasterize = NO;
        textLayer.anchorPoint = CGPointMake(0, 0.5);
        textLayer.contentsScale = 2.0;
        
        [textLayer setFrame:CGRectMake(0, 30, 40, 40)];
        _minTextLayer = textLayer;
    }
    return _minTextLayer;
}

- (CATextLayer *)maxTextLayer
{
    if(_maxTextLayer == nil){
        CATextLayer *textLayer = [CATextLayer layer];
 
        [textLayer setString:@"Hello World"];
        if(_labelColor){
            [textLayer setForegroundColor:self.labelColor];
        }else {
            [textLayer setForegroundColor:_defaultLabelColor];
        }
        [textLayer setFontSize:12.0];
        CGFontRef font = CGFontCreateWithFontName((CFStringRef)@"Helvetica"); //NEED TO RELEASE
        textLayer.font = font;
        
        CGFontRelease(font); //RELEASED
        textLayer.shouldRasterize = NO;
        textLayer.anchorPoint = CGPointMake(0, 0.5);
        textLayer.contentsScale = 2.0;
        
        [textLayer setFrame:CGRectMake(0, 30, 40, 40)];
        _maxTextLayer = textLayer;
    }
    return _maxTextLayer;
}


@end
