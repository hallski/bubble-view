//
//  BubbleViewViewController.m
//  BubbleView
//
//  Created by Mikael Hallendal on 2011-02-18.
//  Copyright 2011 Mikael Hallendal. All rights reserved.
//

#import "BubbleViewViewController.h"
#import "DrawnBubbleView.h"

@implementation BubbleViewViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showBubbleViewWithActivationFrame:(CGRect)activationFrame
{
    currentBubbleView = [[DrawnBubbleView alloc] initWithHeight:150
                                                activationFrame:activationFrame];
    currentBubbleView.alpha = 0.0;
    [self.view addSubview:currentBubbleView];
   
    [UIView animateWithDuration:0.3
                     animations:^{
                         currentBubbleView.alpha = 1;
                     }
     ];
}

- (IBAction)buttonPressed:(id)sender 
{
    if (currentBubbleView) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             currentBubbleView.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             //self.contentView.layer.shouldRasterize = NO;
                             [currentBubbleView removeFromSuperview];
                             [currentBubbleView release];
                             [self showBubbleViewWithActivationFrame:((UIView *)sender).frame];
                         }
         ];
    } else {
        [self showBubbleViewWithActivationFrame:((UIView *)sender).frame];
    }
}
@end
