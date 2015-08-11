//
//  Equation.h
//  MathGUI
//
//  Created by Kaige Liu on 6/19/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import "ModuleView.h"
#import "DesignViewController.h"
@interface EquationView : ModuleView<UITextFieldDelegate>
{
    CGPoint startPosition;
    DesignViewController *parent;
    UILabel *resultLabel;
    UIView *solutionView;
    UIButton *variableButton;
    UIButton *resizeButton;
    UIButton *deleteButton;
    CGFloat height;
}

@property (retain) FormulaWebView *webView;
@property (retain) FormulaTextField *formulaField;

@property (retain) DesignViewController *parent;
@property  NSInteger moduleTagNumber;
@property (retain) Functions *thisFunction;
@property (retain) NSMutableArray *resultArray;
-(void)updateWebView:(UITextField*)textField;
-(void)solve;
-(void)selfDeletion;
@end
