//
//  BubbleViewViewController.h
//  BubbleView
//
//  Created by Mikael Hallendal on 2011-02-18.
//  Copyright 2011 Mikael Hallendal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleViewViewController : UIViewController {
@private
    UIView *currentBubbleView;
}
- (IBAction)buttonPressed:(id)sender;

@end
