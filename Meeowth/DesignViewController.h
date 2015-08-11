//
//  DesignViewController.h
//  MathGUI
//
//  Created by Kaige Liu on 5/6/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionView.h"
#import "BezierPathScrollView.h"
#import "Graph.h"
#import "CalculationView.h"
#import "KeyButton.h"
#import "FormulaTextField.h"
#import "Meeowth-swift.h"
#import "EquationView.h"
#import "AppDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>
@class EquationView;
@class CalculationView;
@class BezierPathScrollView;
@class Graph;
@class FunctionView;

@interface DesignViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
{
    BOOL ifOriginalKeyboard;
    CGFloat widthOfKeyboard;
    BOOL listOfFileIsShowing;
    BOOL animationOfErrorMessageAvai;

}
@property (retain,nonatomic) NSMutableArray *inConnectedViews;
@property (retain,atomic) NSMutableArray *allModules;
@property (retain, nonatomic)  BezierPathScrollView *scrollView;
@property (retain,nonatomic) UIView *currentViewOnConnection;
@property (retain,nonatomic) FormulaTextField *fieldOnEdit;
@property (retain) NSString *currentName;
@property (retain) UIView *aboutView;


//auto hidden
@property (retain) UITextField *normalTextFieldOnEdit;
@property (retain) UIView * autoHiddenView;
@property (retain) CalculationView *autoHiddenVariableView;
@property (retain) Graph *autoHiddenRangeView;
@property (retain) FunctionView *autoHiddenFunctionOptionsView;



-(void)produceErrorMessage:(NSString *)message;



-(void)makeConnection:(id)view1 view2:(id)view2;
-(void)drawLine:(CGPoint)point1 point2:(CGPoint)point2;
-(void)generateNewGraphAtPosition:(CGPoint)point;
-(void)generateNewFunctionAtPosition:(CGPoint)point;
-(void)generateNewEquationAtPosition:(CGPoint)point;
-(void)generateNewCalculationAtPosition:(CGPoint)point;
-(void)generateNewThreeDPloatAtPosition:(CGPoint)point;

//keyboard
-(void)showKeyboardWithID:(NSString *)ID;
-(void)hideKeyboard;
-(void)touched;
-(void)save;
-(UIView *)inWhichArea:(CGPoint)point;
@end
