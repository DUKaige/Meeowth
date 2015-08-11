//
//  ModuleView.h
//  MathGUI
//
//  Created by Kaige Liu on 5/23/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleView : UIView
@property CGColorRef currentBorderColor;
@property (retain) NSString *moduleType;
-(void)selfDeletion;
@end
