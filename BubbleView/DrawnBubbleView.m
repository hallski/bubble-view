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
#define ARROW_POSITION 60

@implementation DrawnBubbleView
@synthesize gradientStartColor;
@synthesize gradientEndColor;
@synthesize borderColor;

- (CGRect)bubbleFrame
{
    CGSize viewSize = self.frame.size;
    CGRect frame = CGRectMake(HORIZONTAL_PADDING, ARROW_HEIGHT + VERTICAL_PADDING, 
                              viewSize.width - 2 * HORIZONTAL_PADDING, 
                              viewSize.height - ARROW_HEIGHT - 2 * VERTICAL_PADDING);
    return frame;
}

- (UIBezierPath *)bubblePathWithRoundedCornerRadius:(CGFloat)cornerRadius
{
    UIBezierPath *path = [UIBezierPath bezierPath];

    CGRect bubbleFrame = [self bubbleFrame];
    CGPoint arrowMiddleBase = CGPointMake(bubbleFrame.origin.x + ARROW_POSITION, bubbleFrame.origin.y);
    
    // Start at the arrow
    [path moveToPoint:CGPointMake(arrowMiddleBase.x - ARROW_WIDTH / 2, arrowMiddleBase.y)];
    [path addLineToPoint:CGPointMake(arrowMiddleBase.x, arrowMiddleBase.y - ARROW_HEIGHT)];
    [path addLineToPoint:CGPointMake(arrowMiddleBase.x + ARROW_WIDTH / 2, arrowMiddleBase.y)];
    [path addLineToPoint:CGPointMake(bubbleFrame.origin.x + bubbleFrame.size.width - cornerRadius, 
                                     arrowMiddleBase.y)];
    // Top right corner
    [path addArcWithCenter:CGPointMake(CGRectGetMaxX(bubbleFrame) - cornerRadius, 
                                       arrowMiddleBase.y + cornerRadius)
                    radius:cornerRadius
                startAngle:3 * M_PI / 2
                  endAngle:2 * M_PI
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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.borderColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
        self.gradientStartColor = [UIColor grayColor];
        self.gradientEndColor = [UIColor blackColor];

        
        
        [self.layer addSublayer:[self bubbleLayer]];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
