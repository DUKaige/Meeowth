//
//  BezierPathScrollView.h
//  MathGUI
//
//  Created by Kaige Liu on 5/20/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignViewController.h"
@class DesignViewController;
@interface BezierPathScrollView : UIScrollView
@property (retain,nonatomic) UIBezierPath *path;
@property DesignViewController *parent;
@end
