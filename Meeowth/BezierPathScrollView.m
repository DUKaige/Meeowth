//
//  BezierPathScrollView.m
//  MathGUI
//
//  Created by Kaige Liu on 5/20/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import "BezierPathScrollView.h"

@implementation BezierPathScrollView
- (void)drawRect:(CGRect)rect
{
    [self.path setLineWidth:1];
    [self.path stroke];
}
-(void)setPath:(UIBezierPath *)path
{
    _path  = path;
    [self setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.parent touched];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
