
//
//  CalculationView.m
//  MathGUI
//
//  Created by Kaige Liu on 5/23/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import "CalculationView.h"
#import "FunctionView.h"
#import "DesignViewController.h"

@implementation CalculationView
@synthesize parent;
@synthesize thisFunction;
-(id)initWithFrame:(CGRect)frame
{
    //init
    self.dictionaryOfValues = [[NSMutableDictionary alloc]init];
    _formulaField = [[FormulaTextField alloc] init];
    _formulaField.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:14];
    variableButton = [[UIButton alloc]initWithFrame:CGRectMake(7, self.frame.size.height - 7 - 23, 23, 23)];
    return [super initWithFrame:frame];
}

-(void)drawRect:(CGRect)rect
{
    
    _webView = nil;
    
    for (UIView *sub in self.subviews)
    {
        [sub removeFromSuperview];
    }
    
    
    //text field
    if (!_formulaField) {
        _formulaField = [[FormulaTextField alloc] init];
    }
    _formulaField.backgroundColor = [UIColor whiteColor];
    [_formulaField setFrame:CGRectMake(20, 60, self.frame.size.width - 40, 30)];
    _formulaField .delegate = self;
    _formulaField.inputView  = [[UIView alloc]initWithFrame:CGRectZero];
    _formulaField.borderStyle = UITextBorderStyleRoundedRect;
    _formulaField.placeholder = @"Type in a value";
    [self addSubview:_formulaField];
    
    //pan
    UIPanGestureRecognizer *rec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:rec];
    
    //variableButton
    variableButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 40, 40
                                                               )];
    [variableButton setBackgroundImage:[UIImage imageNamed:@"variablepink"] forState:UIControlStateNormal];
    [variableButton addTarget:self action:@selector(updateVarList) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:variableButton];
    
    //deleteButton
    deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30,5, 25,25)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"deletepink"] forState:UIControlStateNormal];
    [self addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(selfDeletion) forControlEvents:UIControlEventTouchUpInside];

    //resize pan
    resizeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 30,self.frame.size.height - 30,30,30)];
    UIImageView *resizeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, resizeButton.frame.size.width, resizeButton.frame.size.height)];
    resizeImageView.image = [UIImage imageNamed:@"resizepink"];
    [resizeButton addSubview:resizeImageView];
    [self addSubview:resizeButton];
    
    UIPanGestureRecognizer *resizePan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panResize:)];
    [resizeButton addGestureRecognizer:resizePan];
    
    
    //update value
    if ([self.dictionaryOfValues count] == [self.thisFunction.varList count]) {
        [self calculateValue];
        
    }

}

-(void)updateVarList
{
    if ([self.thisFunction.varList count] != 0) {
        if (varListView) {
            [varListView removeFromSuperview];
            varListView = nil;
        }
        else
        {
            [varListView removeFromSuperview];
            [self initVarList];
        }
        
        if ([self.dictionaryOfValues count] == [self.thisFunction.varList count]) {
            [self calculateValue];
            
        }
    }
    else
    {
        self.dictionaryOfValues = [[NSMutableDictionary alloc]init];
        [self calculateValue];
    }



}

-(void)initVarList
{
    _availableForAutoHidden = NO;
    self.parent.autoHiddenVariableView = self;
    varListView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.origin.x - 125, self.frame.origin.y , 120, [self.thisFunction.varList count] * 50)];
    varListView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    varListView.layer.borderColor = [[UIColor blackColor]CGColor];
    varListView.layer.borderWidth = 1;
    varListView.layer.cornerRadius = 5;
    int count = 0;
    for (NSString *string in self.thisFunction.varList) {
        UILabel *varLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50 * count, 30, 50)];
        varLabel.text = string;
        varLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18];
        
        [varListView addSubview:varLabel];
        
        FormulaTextField *field = [[FormulaTextField alloc]initWithFrame:CGRectMake(40, 50*count + 10, 70, 30 )];
        field.backgroundColor = [UIColor whiteColor];
        field.borderStyle = UITextBorderStyleRoundedRect;
        field.tag = count;
        field.delegate = self;
        field.inputView = [[UIView alloc]initWithFrame:CGRectZero];
        if (self.dictionaryOfValues) {
            [field mySetText:[[self.dictionaryOfValues objectForKey:string] stringValue] ];
        }
        [varListView addSubview:field];
        count += 1;
    }
    [self.parent.scrollView addSubview:varListView];
}


-(void)pan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:[self.parent scrollView]];
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        startPosition = [recognizer locationInView:self];
        [self.parent.scrollView bringSubviewToFront:self];

    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint frameLocation = CGPointMake(location.x - startPosition.x, location.y - startPosition.y);
        self.frame = CGRectMake(frameLocation.x,frameLocation.y,self.frame.size.width, self.frame.size.height);
        varListView.frame = CGRectMake(self.frame.origin.x - 125, self.frame.origin.y , 120, [self.thisFunction.varList count] * 50);
    }
}



-(void)selfDeletion
{
    [varListView removeFromSuperview];
    if  ([self.parent.autoHiddenVariableView isEqual:self])
    {
        self.parent.autoHiddenVariableView = nil;
    }
    if ([self.parent.currentViewOnConnection isEqual:self]) {
        self.parent.currentViewOnConnection = nil;
    }
    
    for (UIView *view in self.parent.inConnectedViews) {
        if ([view isEqual:self]) {
            [self.parent.inConnectedViews removeObject:self];
            break;
        }
    }
    [self removeFromSuperview];
    [self.parent.allModules removeObject:self];
}


-(void)hideWebView
{
    _formulaField.hidden = NO;
    [_webView removeFromSuperview];
    [_formulaField becomeFirstResponder];
}


//text field delegate methods
-(void)textFieldDidBeginEditing:(FormulaTextField *)textField
{
    if ([textField isEqual: self.formulaField])
    {
        self.parent.fieldOnEdit = _formulaField;
        [self.parent showKeyboardWithID:@"function"];
    }
    else
    {
        self.parent.fieldOnEdit = textField;
        [_formulaField mySetText:_formulaField.text];
        [self.parent showKeyboardWithID:@"number"];

    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField isEqual: self.formulaField]) {
        NSString *thisVar = [self.thisFunction.varList objectAtIndex:textField.tag];
        if ([self ifNumeric:textField.text]) {
            [self.dictionaryOfValues setObject:[NSNumber numberWithDouble:[textField.text doubleValue]] forKey:thisVar];

        }
        [self.parent hideKeyboard];
    }
    else
    {
        self.thisFunction = [[Functions alloc]initWithFunction:textField.text varList:@[@"x",@"y",@"z",@"a",@"b",@"c"]];
        if (self.thisFunction.valid && [self.thisFunction.varList count] == 0 )
        {
            [self updateWebView:textField];
            [self.parent hideKeyboard];
            [self calculateValue];
        }
        else if (self.thisFunction.valid && [self.thisFunction.varList count] != 0 )
        {
            [self updateWebView:textField];
            [self.parent hideKeyboard];
            [self updateVarList];
        }
        else if(!self.thisFunction.valid )
        {
            self.thisFunction = nil;
            [self.parent produceErrorMessage:@"Function not valid"];
            [self updateWebView:textField];
            [self.parent hideKeyboard];
        }
    }
    if ([self.dictionaryOfValues count] == [self.thisFunction.varList count]) {
        [self calculateValue];
    }
}



-(void)updateWebView:(UITextField*)textField
{
    if (![textField.text isEqualToString:@""]) {
        _webView = [[FormulaWebView alloc]initWithFrame:CGRectMake(20, 50, self.frame.size.width - 20, 80)];
        [self addSubview:_webView];
        _formulaField.hidden = YES;
        _webView.backgroundColor = [UIColor clearColor];
        [self addSubview:_webView];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        [_webView setColor:[UIColor blackColor]];
        [_webView setFormulaString:_formulaField.text];
        [_webView displayFormulaString];
        _webView.scrollView.scrollEnabled = NO;
        
        UIButton *cancelButton = [[UIButton  alloc]initWithFrame:CGRectMake(0, 0, _webView.frame.size.width, _webView.frame.size.height)];
        [cancelButton addTarget:self action:@selector(hideWebView) forControlEvents:UIControlEventTouchUpInside];
        [_webView addSubview:cancelButton];
    }
    else
    {
        self.thisFunction = nil;
    }
}


-(BOOL)ifNumeric:(NSString *)string
{
    return true;
}

-(void)calculateValue
{
    [resultLabel removeFromSuperview];
    resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.frame.size.height/2 + 20, self.frame.size.width - 40, 30)];
    resultLabel.text = [self toSignificantFigure:4 string:[self jianLingJiuShan:[NSString stringWithFormat:@"= %f",[self.thisFunction produceValueFromStructureAlgo:self.thisFunction.functionStructure varList:self.dictionaryOfValues]]]];
    [self addSubview:resultLabel];
}

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.parent touched];
}*/

-(void)panResize:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        if (point.x < 200 && point.y > 140)
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,200, point.y);
        }
        else if (point.y < 140 && point.x > 200) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,point.x,140);
        }
        else if (point.y < 140 && point.x < 200)
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,200,140);
        }
        else
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,point.x,point.y);
            
        }
        [self tmpResetFrames];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self tmpResetFrames];
    }
}
-(void)tmpResetFrames
{
    [_formulaField setFrame:CGRectMake(20, 60, self.frame.size.width - 40, 30)];
    resizeButton.frame = CGRectMake(self.frame.size.width - 30,self.frame.size.height - 30,30,30);
    //deleteButton
    resultLabel.frame = CGRectMake(20, self.frame.size.height/2 + 20, self.frame.size.width - 40, 30);
    deleteButton.frame = CGRectMake(self.frame.size.width - 30,5, 25,25);
    _webView.frame =CGRectMake(20, 50, self.frame.size.width - 20, 80);
}

-(NSString *)jianLingJiuShan:(NSString *)string
{
    int i = [string length] - 1;
    NSString *thisChar = @"0";
    while ([thisChar isEqualToString: @"0"]&& i >= 0)
    {
        thisChar =[string substringWithRange:NSMakeRange(i, 1)];
        i -= 1;
    }
    if (![thisChar isEqualToString:@"."]) {
        i += 1;
    }
    return [string substringWithRange:NSMakeRange(0, i + 1)];
}

-(NSString *)toSignificantFigure:(NSUInteger)numberOfFigures string:(NSString *)string
{
    if ([string rangeOfString:@"."].location == NSNotFound) {
        return string;
    }
    else
    {
        if (numberOfFigures >= [string length] - [string rangeOfString:@"."].location - 1)
        {
            return string;
        }
        else
        {
            return [self jianLingJiuShan:[string substringWithRange:NSMakeRange(0, [string rangeOfString:@"."].location+numberOfFigures + 1)]];

        }
    }
}


@end
