//
//  KeyButton.m
//  MathGUI
//
//  Created by Kaige Liu on 5/28/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import "KeyButton.h"

@implementation KeyButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setText:(NSString *)text
{
    if (!_textLabel) {
        self.textLabel = [[UILabel alloc]init];
        _textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_textLabel];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    _textLabel.text = text;
}
@end
