//
//  BubbleView.m
//  BubbleView
//
//  Created by Mikael Hallendal on 2011-02-18.
//  Copyright 2011 Mikael Hallendal. All rights reserved.
//

#import "ImageBubbleView.h"
#import <QuartzCore/QuartzCore.h>


@implementation ImageBubbleView

- (UIImage *)bubbleImage
{
    UIImage *image = [UIImage imageNamed:@"Bubble.png"];
    
    return [image stretchableImageWithLeftCapWidth:119 topCapHeight:70];
}

#define BORDER_WIDTH 20
#define ARROW_HEIGHT 30

- (CGRect)bubbleFrame
{
    CGSize size = self.frame.size;
    
    return CGRectMake(10.0, 10.0, size.width - 20.0, size.height - 20.0);
}

- (CGRect)contentFrame
{
    CGRect rect = [self bubbleFrame];
    
    rect.origin.x += BORDER_WIDTH;
    rect.origin.y += ARROW_HEIGHT + BORDER_WIDTH;
    rect.size.width -= 2 * BORDER_WIDTH;
    rect.size.height -= ARROW_HEIGHT + 2 * BORDER_WIDTH;
    
    return rect;
}

- (void)addContentView
{
    UILabel *label = [[[UILabel alloc] initWithFrame:[self contentFrame]] autorelease];
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:24];
    label.text = @"ImageBubbleView";
    label.textAlignment = UITextAlignmentCenter;

 //   [self addSubview:label];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[self bubbleImage]];

        imageView.frame = [self bubbleFrame];
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(3, 3);
        imageView.layer.shadowOpacity = 0.75;
        imageView.layer.shadowRadius = 5.0;
        imageView.clipsToBounds = NO;

        [self addSubview:imageView];
                
        [self addContentView];
        // Initialization code
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
