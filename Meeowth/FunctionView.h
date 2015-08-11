//
//  FunctionView.h
//  MathGUI
//
//  Created by Kaige Liu on 5/6/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignViewController.h"
#import "Meeowth-swift.h"
#import "ModuleView.h"
#import "FormulaWebView.h"
#import "FormulaTextField.h"
#import "OpenGLView.h"
@class ModuleView;
@class DesignViewController;
@class FormulaTextField;
@interface FunctionView : ModuleView<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIButton *deleteButton;
    UIButton *optionsButtonView;
    FormulaWebView *webView;
    CGPoint startPosition;
    UIButton *connectionButton;
    UIView *colorPad;
    UIButton *colorButton;
    UIButton *menuShowButton;
    UIView *menu;
    DesignViewController *parent;
    //tmp keep border color
    CGColorRef tmpBorderColor;
    UIButton *resizeButton;
    UILabel *functionLabel;
    //to keep connection
    ModuleView *tmpKeepViewOnConnection;
    //operations
}
@property (strong) FormulaTextField *formulaField;
@property (strong) NSMutableArray *graphsConnected;
@property (strong) DesignViewController *parent;
@property  NSInteger moduleTagNumber;
@property (strong) UIColor *functionColor;
@property (retain) Functions *thisFunction;
//options buttons
@property (strong) UIButton *threeDPlotButton;
@property (strong) UIScrollView *optionsView;
@property (strong) UIButton *plotButton;
@property (strong) UIButton *diffButton;
@property (strong) UIButton *produceCalculationButton;
@property (strong) UIButton *produceEquationButton;
@property (strong) UIButton *simplifyButton;
@property (strong) UIButton *factorization;

-(NSArray *)produceIndexOfGraphs;
-(void)setFunctionViewColor:(UIColor *)color;
-(void)selfDeletion;
-(void)optionsTapping;
-(void)connectWith:(id)other;
-(void)setWebView;
@end
