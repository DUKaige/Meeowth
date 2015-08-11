//
//  FormulaWebView.h
//  learn
//
//  Created by mac on 15/5/26.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormulaWebView : UIWebView
{
    NSString *formulaString;
    UIColor *color;
    int count;
    NSData *data;
}
-(void) displayFormulaString;
-(void) setColor: (UIColor *) newColor;
-(void) setFormulaString: (NSString *) newFormulaString;
-(NSString *) toHexColorString: (UIColor *) color;
-(void)removeSelf;
@end
