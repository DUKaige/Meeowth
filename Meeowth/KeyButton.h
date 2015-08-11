//
//  KeyButton.h
//  MathGUI
//
//  Created by Kaige Liu on 5/28/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyButton : UIButton
@property (retain) NSString *textProduce;
@property (retain) UILabel *textLabel;
-(void)setText:(NSString *)text;
@end
