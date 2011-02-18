//
//  BubbleViewAppDelegate.h
//  BubbleView
//
//  Created by Mikael Hallendal on 2011-02-18.
//  Copyright 2011 Mikael Hallendal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BubbleViewViewController;

@interface BubbleViewAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet BubbleViewViewController *viewController;

@end
