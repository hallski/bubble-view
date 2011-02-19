//
//  DrawnBubbleView.h
//  BubbleView
//
//  Created by Mikael Hallendal on 2011-02-19.
//  Copyright 2011 Mikael Hallendal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DrawnBubbleView : UIView {

@private
    UIColor *gradientStartColor;
    UIColor *gradientEndColor;
    UIColor *borderColor;
}
@property(nonatomic, retain) UIColor *gradientStartColor;
@property(nonatomic, retain) UIColor *gradientEndColor;
@property(nonatomic, retain) UIColor *borderColor;

@end
