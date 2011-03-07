//
//  DrawnBubbleView.m
//  BubbleView
//
//  Created by Mikael Hallendal on 2011-02-19.
//  Copyright 2011 Mikael Hallendal. All rights reserved.
//

#import "DrawnBubbleView.h"
#import <QuartzCore/QuartzCore.h>

#define HORIZONTAL_PADDING 10
#define VERTICAL_PADDING 5
#define ARROW_HEIGHT 20
#define ARROW_WIDTH 40
#define DEFAULT_ARROW_POSITION 60
#define CORNER_RADIUS 10
#define ACTIVATION_PADDING 0

CGFloat 
clamp(CGFloat value, CGFloat minValue, CGFloat maxValue) 
{
    if (value < minValue) {
        return minValue;
    }
    
    if (value > maxValue) {
        return maxValue;
    }
    
    return value;
}

@implementation DrawnBubbleView
@synthesize gradientStartColor = _gradientStartColor;
@synthesize gradientEndColor = _gradientEndColor;
@synthesize borderColor = _borderColor;

- (CGRect)bubbleFrame
{
    CGSize viewSize = self.frame.size;
    CGRect frame = CGRectMake(HORIZONTAL_PADDING, ARROW_HEIGHT + VERTICAL_PADDING, 
                              viewSize.width - 2 * HORIZONTAL_PADDING, 
                              viewSize.height - ARROW_HEIGHT - 2 * VERTICAL_PADDING);
    return frame;
}

- (CGFloat)minArrowPosition
{
    return CGRectGetMinX([self bubbleFrame]) + ARROW_WIDTH / 2 + CORNER_RADIUS;
}

- (CGFloat)maxArrowPosition
{
    return CGRectGetMaxX([self bubbleFrame]) - ARROW_WIDTH / 2 - CORNER_RADIUS;
}

- (CGFloat)arrowPosition
{
    if (CGRectIsEmpty(_activationFrame)) {
        return DEFAULT_ARROW_POSITION;
    }
    
    return clamp(CGRectGetMidX(_activationFrame), [self minArrowPosition], [self maxArrowPosition]);
}

- (CGPoint)arrowMiddleBase
{
    CGRect bubbleFrame = [self bubbleFrame];
    return CGPointMake(CGRectGetMinX(bubbleFrame) + [self arrowPosition], CGRectGetMinY(bubbleFrame));
}

- (UIBezierPath *)bubblePathWithRoundedCornerRadius:(CGFloat)cornerRadius
{
    UIBezierPath *path = [UIBezierPath bezierPath];

    CGRect bubbleFrame = [self bubbleFrame];
    CGPoint arrowMiddleBase = CGPointMake([self arrowPosition], bubbleFrame.origin.y);

    // Start at the arrow
    [path moveToPoint:CGPointMake(arrowMiddleBase.x - ARROW_WIDTH / 2, arrowMiddleBase.y)];
    [path addLineToPoint:CGPointMake(arrowMiddleBase.x, arrowMiddleBase.y - ARROW_HEIGHT)];
    [path addLineToPoint:CGPointMake(arrowMiddleBase.x + ARROW_WIDTH / 2, arrowMiddleBase.y)];
    [path addLineToPoint:CGPointMake(bubbleFrame.origin.x + bubbleFrame.size.width - cornerRadius, 
                                     arrowMiddleBase.y)];
    // Top right corner
    [path addArcWithCenter:CGPointMake(CGRectGetMaxX(bubbleFrame) - cornerRadius, 
                                       arrowMiddleBase.y + cornerRadius)
                    radius:cornerRadius startAngle:3 * M_PI / 2 endAngle:2 * M_PI
                 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(bubbleFrame), 
                                     CGRectGetMaxY(bubbleFrame) - cornerRadius)];
    // Bottom right corner
    [path addArcWithCenter:CGPointMake(CGRectGetMaxX(bubbleFrame) - cornerRadius, 
                                       CGRectGetMaxY(bubbleFrame) - cornerRadius) 
                    radius:cornerRadius startAngle:0 endAngle:M_PI / 2
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(bubbleFrame) + cornerRadius, 
                                     CGRectGetMaxY(bubbleFrame))];

    // Bottom left corner
    [path addArcWithCenter:CGPointMake(CGRectGetMinX(bubbleFrame) + cornerRadius,
                                       CGRectGetMaxY(bubbleFrame) - cornerRadius)
                    radius:cornerRadius startAngle:M_PI / 2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(bubbleFrame), 
                                     CGRectGetMinY(bubbleFrame) + cornerRadius)];
    
    // Top left corner
    [path addArcWithCenter:CGPointMake(CGRectGetMinX(bubbleFrame) + cornerRadius, 
                                       CGRectGetMinY(bubbleFrame) + cornerRadius)
                    radius:cornerRadius startAngle:M_PI endAngle:3 * M_PI / 2 clockwise:YES];
    
    [path closePath];
    
    return path;
}

- (CALayer *)bubbleLayer
{
    CALayer *bubbleLayer = [CALayer layer];
    bubbleLayer.frame = (CGRect) { CGPointZero, self.frame.size };
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = (CGRect) { CGPointZero, bubbleLayer.frame.size };
    
    UIBezierPath *path = [self bubblePathWithRoundedCornerRadius:10.0];
   
    // Gradient colors from gray to black
    gradientLayer.colors = [NSArray arrayWithObjects:(id)self.gradientStartColor.CGColor, (id)self.gradientEndColor.CGColor, nil];
    
    // Apply a mask to the gradient layer
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    gradientLayer.mask = maskLayer;
    
    // Draw the border
    CAShapeLayer *outlineLayer = [CAShapeLayer layer];
    outlineLayer.path = path.CGPath;
    outlineLayer.strokeColor = self.borderColor.CGColor;
    outlineLayer.lineWidth = 1.5;
    outlineLayer.fillColor = [UIColor clearColor].CGColor;

    // And finally a shadow 
    CAShapeLayer *shadowLayer = [CAShapeLayer layer];
    shadowLayer.shadowPath = path.CGPath;
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    shadowLayer.shadowRadius = 5;
    shadowLayer.shadowOffset = CGSizeMake(1.0, 1.0);
    shadowLayer.shadowOpacity = 0.75;
    
    [bubbleLayer addSublayer:shadowLayer];
    [bubbleLayer addSublayer:gradientLayer];
    [bubbleLayer addSublayer:outlineLayer];
    
    return bubbleLayer;
}

- (void)setupDefaultValuesAndLayers
{
    self.borderColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
    self.gradientStartColor = [UIColor grayColor];
    self.gradientEndColor = [UIColor blackColor];
    
    [self.layer addSublayer:[self bubbleLayer]];   
}

- (id)initWithFrame:(CGRect)frame activationFrame:(CGRect)activationFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        _activationFrame = activationFrame;
        [self setupDefaultValuesAndLayers];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaultValuesAndLayers];
    }
    return self;
}

- (id)initWithHeight:(CGFloat)height activationFrame:(CGRect)activationFrame
{
    CGRect frame = CGRectMake(0.0, CGRectGetMaxY(activationFrame) + ACTIVATION_PADDING, [UIScreen mainScreen].bounds.size.width, height);
    
    return [self initWithFrame:frame activationFrame:activationFrame];
}

- (void)dealloc
{
    self.borderColor = nil;
    self.gradientStartColor = nil;
    self.gradientEndColor = nil;
    
    [super dealloc];
}

@end
