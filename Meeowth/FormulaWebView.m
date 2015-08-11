//
//  FormulaWebView.m
//  learn
//
//  Created by mac on 15/5/26.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "FormulaWebView.h"

@implementation FormulaWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    //init
    
    
    return [super initWithFrame:frame];
}

-(void)displayFormulaString {
    [self loadHTMLString: @"" baseURL: nil];
    NSString *hexColor = [self toHexColorString:color];
    NSString *content = [NSString stringWithFormat: @"<!DOCTYPE html><html><head><script type=\"text/javascript\"src=\"http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=AM_HTMLorMML-full\"></script><script>MathJax.Hub.Config({messageStyle: 'none',tex2jax: {preview: 'none'}});</script><style>.wrapper{opacity:1;}</style></head><body style=\"background-color:transparent\"><p style=\"text-align:left;color:%@\" class=\"wrapper\">`%@`</p></body></html>", hexColor, formulaString];
    data = nil;
    data = [[NSData alloc] initWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
    [self setDefault];
    count += 1;
}

-(void)setDefault
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setColor:(UIColor *)newColor{
    if ([[UIColor blackColor] isEqual:newColor]) {
        color = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
    else if ([[UIColor grayColor] isEqual:newColor  ]) {
        color = [[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    }
    else {
        color = newColor;
    }
}

-(void)setFormulaString:(NSString *)newFormulaString {
    formulaString = newFormulaString;
}

-(NSString *)toHexColorString:(UIColor *)rgbColor {
    const int r = CGColorGetComponents(rgbColor.CGColor)[0] * 255;
    const int g = CGColorGetComponents(rgbColor.CGColor)[1] * 255;
    const int b = CGColorGetComponents(rgbColor.CGColor)[2] * 255;
    NSString *red, *green, *blue;
    if (r <= 16) {
        red = [[NSString alloc] initWithFormat:@"0%x", r];
    }
    else {
        red = [[NSString alloc] initWithFormat:@"%x", r];
    }
    if (g <= 16) {
        green = [[NSString alloc] initWithFormat:@"0%x", g];
    }
    else {
        green = [[NSString alloc] initWithFormat:@"%x", g];
    }
    if (b <= 16) {
        blue = [[NSString alloc] initWithFormat:@"0%x",b];
    }
    else {
        blue = [[NSString alloc] initWithFormat:@"%x", b];
    }
    NSString *result = [[NSString alloc] initWithFormat:@"#%@%@%@", red, green, blue];
    return result;
}

-(void)removeSelf
{
    color = nil;
    formulaString = nil;
}
@end