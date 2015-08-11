//
//  Equation.m
//  MathGUI
//
//  Created by Kaige Liu on 6/19/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import "EquationView.h"

@implementation EquationView
@synthesize parent;
-(id)initWithFrame:(CGRect)frame
{
    //init
    self.resultArray = [[NSMutableArray alloc]init];
    _formulaField = [[FormulaTextField alloc] init];
    _formulaField.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:14];
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
    _formulaField.placeholder = @"Type in an equation";
    [self addSubview:_formulaField];
    
    //pan
    UIPanGestureRecognizer *rec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:rec];
    
    //variableButton

    
    //deleteButton
    deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30,5, 25,25)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"deleteyellow"] forState:UIControlStateNormal];
    [self addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(selfDeletion) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //resize pan
    resizeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 30,self.frame.size.height - 30,30,30)];
    UIImageView *resizeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, resizeButton.frame.size.width, resizeButton.frame.size.height)];
    resizeImageView.image = [UIImage imageNamed:@"resizeyellow"];
    [resizeButton addSubview:resizeImageView];
    [self addSubview:resizeButton];
    
    UIPanGestureRecognizer *resizePan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panResize:)];
    [resizeButton addGestureRecognizer:resizePan];
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
        solutionView.frame = CGRectMake(self.frame.origin.x - 110, self.frame.origin.y, 100,height);
    }
}



-(void)selfDeletion
{
    [solutionView removeFromSuperview];
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


-(void)hideWebView:(UITapGestureRecognizer  *)sender
{
    _formulaField.hidden = NO;
    [_webView removeFromSuperview];
    [_formulaField becomeFirstResponder];
}


//text field delegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.parent.fieldOnEdit = _formulaField;
    [self.parent showKeyboardWithID:@"function"];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    BOOL found = NO;
    NSUInteger i = 0;
    while (i < [textField.text length]) {
        if ([[textField.text substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"="])
        {
            found = YES;
            break;
        }
        i += 1;
    }


    if (!found)
    {
        self.thisFunction = [[Functions alloc]initWithFunction:textField.text varList:@[@"x",@"y",@"z",@"a",@"b",@"c"]];
        [self updateWebView:textField];
        [self.parent hideKeyboard];
        if (self.thisFunction.valid)
        {
            [self.parent hideKeyboard];
            if ([self.thisFunction.varList count] == 1)
            {
                [self solve];
            }
            else
            {
                [self.parent produceErrorMessage:@"Equation not single variable"];
            }
        }
        else if(!self.thisFunction.valid )
        {
            self.thisFunction = nil;
            [self.parent produceErrorMessage:@"Equation not valid"];
            [self.parent hideKeyboard];
        }
    }
    else
    {
        self.thisFunction = [[Functions alloc]initWithFunction:[[[textField.text substringWithRange:NSMakeRange(0, i)] stringByAppendingString:@"-"] stringByAppendingString:[textField.text substringWithRange:NSMakeRange(i + 1, textField.text.length - i - 1)] ] varList:@[@"x",@"y",@"z",@"a",@"b",@"c"]];
        [self updateWebView:textField];
        [self.parent hideKeyboard];
        if (self.thisFunction.valid)
        {
            [self.parent hideKeyboard];
            if ([self.thisFunction.varList count] == 1)
            {
                [self solve];
            }
            else
            {
                [self.parent produceErrorMessage:@"Equation not single variable"];
            }
        }
        else if(!self.thisFunction.valid )
        {
            self.thisFunction = nil;
            [self.parent produceErrorMessage:@"Equation not valid"];
            [self.parent hideKeyboard];
        }
    }
    if ([[self thisFunction] ifPolynomial])
    {
        [self solve];
    }
    else
    {
        [self.parent produceErrorMessage:@"Only currently allow polynomial equations"];
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
        [cancelButton addTarget:self action:@selector(hideWebView:) forControlEvents:UIControlEventTouchUpInside];
        [_webView addSubview:cancelButton];
    }
    else
    {
        self.thisFunction = nil;
    }
}

-(void)solve
{
    [solutionView removeFromSuperview];
    solutionView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.origin.x - 110, self.frame.origin.y , 100, 0)];
    solutionView.layer.cornerRadius = 4;
    solutionView.layer.borderColor = [[UIColor blueColor] CGColor];
    solutionView.layer.borderWidth = 1;
    [solutionView setBackgroundColor:[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1]];
    [self.parent.scrollView addSubview:solutionView];
    NSArray *solutions = [[NSArray alloc]init];
     if ([self.thisFunction ifPolynomial])
     {
         solutions = [self.thisFunction solvePolynomialEquation:self.thisFunction.polynomialStructure];
     }
    height = 0;
    for (NSNumber *aSolution in solutions) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, height, 80, 40)];
        label.text = [self toSignificantFigure:3 string:[NSString stringWithFormat:@"%f",[aSolution doubleValue]]];
        [solutionView addSubview:label];
        height += 50;
    }
    solutionView.frame = CGRectMake(self.frame.origin.x - 110, self.frame.origin.y , 100, height);
    if ([solutions count] == 0)
    {
        [[self parent] produceErrorMessage:@"No Solution"];
    }

}

-(BOOL)ifNumeric:(NSString *)string
{
    return true;
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
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.parent.scrollView bringSubviewToFront:self];
    }
}
-(void)tmpResetFrames
{
    [_formulaField setFrame:CGRectMake(20, 60, self.frame.size.width - 40, 30)];
    resizeButton.frame = CGRectMake(self.frame.size.width - 30,self.frame.size.height - 30,30,30);
    deleteButton.frame = CGRectMake(self.frame.size.width - 30,5, 25,25);
    variableButton.frame = CGRectMake(7, self.frame.size.height - 7 - 23, 23, 23);
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
