//
//  Graph.h
//  MathGUI
//
//  Created by Kaige Liu on 5/17/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionView.h"
#import "Meeowth-swift.h"
#import "ModuleView.h"
#import "FormulaTextField.h"
#import "FormulaWebView.h"
@class DesignViewController;
@class FormulaTextField;
@interface Graph : ModuleView<UITextFieldDelegate>
{
    CGPoint startPosition;
    UIButton *colorButton;
    UIButton *showAllFunctionButtons;
    UIButton *deleteButton;
    UIButton *resizeButton;
    
    UIView *rangeView;
    FormulaTextField *startField;
    FormulaTextField *endField;
    
    //plotting
    double rangeStart;
    double rangeEnd;
    
    //removeAllPath
    NSMutableArray *allPaths;
}

@property (retain) DesignViewController  *parent;
@property NSInteger moduleTagNumber;
@property (retain) NSMutableArray *functionsConnected;



-(NSArray *)produceIndexOfFunctions;
-(void)selfDeletion;

-(void)showAllFunctionsButtonPressed;
-(void)resetRangeView;
@end
