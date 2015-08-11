//
//  CalculationView.h
//  MathGUI
//
//  Created by Kaige Liu on 5/23/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

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

@class ModuleView;
@class DesignViewController;
@class FormulaTextField;
@interface CalculationView : ModuleView<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    CGPoint startPosition;
    DesignViewController *parent;
    UILabel *resultLabel;
    UIView *varListView;
    UIButton *variableButton;
    UIButton *resizeButton;
    UIButton *deleteButton;
}
@property BOOL availableForAutoHidden;
@property (retain) FormulaWebView *webView;
@property (retain) FormulaTextField *formulaField;
@property (retain) DesignViewController *parent;
@property  NSInteger moduleTagNumber;
@property (retain) Functions *thisFunction;
@property (retain) NSMutableDictionary *dictionaryOfValues;

-(void)selfDeletion;

-(void)updateWebView:(UITextField*)textField;
-(void)updateVarList;

@end

