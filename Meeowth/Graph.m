//
//  Graph.m
//  MathGUI
//
//  Created by Kaige Liu on 5/17/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import "Graph.h"

@implementation Graph
-(id)initWithFrame:(CGRect)frame
{
    rangeStart = 0;
    rangeEnd = 9;
    allPaths = [[NSMutableArray alloc]init];
    _functionsConnected = [[NSMutableArray alloc]init];
    return [super initWithFrame:frame];
}
-(void)drawRect:(CGRect)rect
{
    for (UIBezierPath *path in allPaths) {
        [path removeAllPoints];
    }
    
    for (UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    
    if ([self.functionsConnected count] > 0) {
        //set border color
        self.layer.borderColor = [[UIColor clearColor]CGColor];
        self.currentBorderColor = [[UIColor clearColor]CGColor];
        self.moduleType = @"graph";
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (FunctionView *eachFunctionView in _functionsConnected)
        {
            if (eachFunctionView)
            {
                NSMutableArray *xList = [[NSMutableArray alloc]init];
                NSMutableArray *yList = [[NSMutableArray alloc]init];
                double interval = (rangeEnd - rangeStart)/self.frame.size.width;
                for (double i = rangeStart; i <= rangeEnd; i += interval)
                {
                    NSNumber *thisNumber =[NSNumber numberWithDouble:[eachFunctionView.thisFunction produceValueFromStructureAlgo:eachFunctionView.thisFunction.functionStructure varList:@{[eachFunctionView.thisFunction.varList objectAtIndex:0]: [NSNumber numberWithDouble:i]}]];
                    if ( thisNumber.doubleValue < 10000000000 && thisNumber.doubleValue > -10000000000 )
                    {
                        [xList addObject:[NSNumber numberWithDouble:i]];
                        [yList addObject:thisNumber];
                    }

                }
                [result addObject:@[xList,yList]];
            }
        }
        CGFloat widgeWidth = 50;
        double maxY = [self maxInResult:result];
        double minY = [self minInResult:result];
        CGFloat unitWidth = (self.frame.size.width - 2 * widgeWidth)/(rangeEnd - rangeStart);
        if (maxY ==  minY)
        {
            maxY = minY + 1;
            minY = minY - 1;
        }
        CGFloat unitHeight = (self.frame.size.height - 2 * widgeWidth)/(maxY - minY);
        

        int eachFuncCount = 0;
        while (eachFuncCount < [result count]) {
            NSArray *xyComb = [result objectAtIndex:eachFuncCount];
            UIBezierPath *path = [[UIBezierPath alloc]init];
            [allPaths addObject:path];
            int i = 0;
            double xValue = [[[xyComb objectAtIndex:0]objectAtIndex:0] doubleValue];
            double yValue = [[[xyComb objectAtIndex:1]objectAtIndex:0] doubleValue];
            CGFloat xPosition = widgeWidth + (xValue - rangeStart) * unitWidth;
            CGFloat yPosition = self.frame.size.height - widgeWidth - (yValue - minY) * unitHeight;
            
            
            
            [path moveToPoint:CGPointMake(xPosition, yPosition)];
            i = 1;
            while (i < [[xyComb objectAtIndex:0] count]) {
                double xValue = [[[xyComb objectAtIndex:0]objectAtIndex:i] doubleValue];
                double yValue = [[[xyComb objectAtIndex:1]objectAtIndex:i] doubleValue];
                CGFloat xPosition = widgeWidth + (xValue - rangeStart) * unitWidth;
                CGFloat yPosition = self.frame.size.height - widgeWidth - (yValue - minY) * unitHeight;
                [path addLineToPoint:CGPointMake(xPosition, yPosition)];
                i += 1;
            }
            [[[self.functionsConnected objectAtIndex:eachFuncCount] functionColor]setStroke];
            [path stroke];
            eachFuncCount += 1;
        }
        
        //Plot coordinate
        [[UIColor blackColor]setStroke];
        UIBezierPath *xLine = [[UIBezierPath alloc] init];
        [allPaths addObject:xLine];
        [xLine moveToPoint:CGPointMake(widgeWidth, self.frame.size.height - widgeWidth )];
        [xLine addLineToPoint:CGPointMake(self.frame.size.width - widgeWidth, self.frame.size.height - widgeWidth)];
        UIBezierPath *yLine = [[UIBezierPath alloc] init];
        [allPaths addObject:yLine];
        [yLine moveToPoint:CGPointMake(widgeWidth, self.frame.size.height - widgeWidth)];
        [yLine addLineToPoint:CGPointMake(widgeWidth, widgeWidth)];
        [xLine stroke];
        [yLine stroke];
        
        //add small lines
        NSArray *xIntervals = [[NSArray alloc]initWithArray:[self findProperInterval:rangeStart number2:rangeEnd]];
        NSArray *yIntervals = [[NSArray alloc]initWithArray:[self findProperInterval:minY number2:maxY]];
        int i = 0;
        
        while (i < [xIntervals count]) {
            CGFloat xCoor = widgeWidth + ([[xIntervals objectAtIndex:i] doubleValue] - rangeStart) * unitWidth;
            UIBezierPath *smallLine = [[UIBezierPath alloc]init];
            [allPaths addObject:smallLine];
            [smallLine moveToPoint:CGPointMake(xCoor, self.frame.size.height - widgeWidth)];
            [smallLine addLineToPoint:CGPointMake(xCoor, self.frame.size.height - widgeWidth - 5)];
            [smallLine stroke];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xCoor - 80, self.frame.size.height - widgeWidth + 5, 160, 20)];
            label.text = [self jianLingJiuShan:[NSString stringWithFormat:@"%f", [[NSString stringWithFormat:@"%f",[[xIntervals objectAtIndex:i]doubleValue]]doubleValue]]];
            label.font = [UIFont fontWithName:@"STHeiti-Medium.ttc" size:2];
            [label setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:label];
            i += 1;
        }
        i = 0;
        while (i < [yIntervals count]) {
            CGFloat yCoor =  self.frame.size.height - widgeWidth - ([[yIntervals objectAtIndex:i] doubleValue] - minY) * unitHeight;
            UIBezierPath *smallLine = [[UIBezierPath alloc]init];
            [allPaths addObject:smallLine];
            [smallLine moveToPoint:CGPointMake(widgeWidth, yCoor)];
            [smallLine addLineToPoint:CGPointMake(widgeWidth + 5, yCoor)];
            [smallLine stroke];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(widgeWidth - 205,yCoor - 10, 200, 20)];
            label.text = [self jianLingJiuShan:[NSString stringWithFormat:@"%f", [[NSString stringWithFormat:@"%f",[[yIntervals objectAtIndex:i]doubleValue]]doubleValue]]];
            label.font = [UIFont fontWithName:@"STHeiti-Medium.ttc" size:2];
            [label setTextAlignment:NSTextAlignmentRight];
            [self addSubview:label];
            i += 1;
        }
        
    }

    
    //panning around
    
    UIPanGestureRecognizer *rec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:rec];

    
    
    //show all functions button
    showAllFunctionButtons = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    [showAllFunctionButtons setBackgroundImage:[UIImage imageNamed:@"gear"] forState:UIControlStateNormal];
    [showAllFunctionButtons addTarget:self action:@selector(showAllFunctionsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:showAllFunctionButtons];

    //deleteButton
    deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30,5, 25,25)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(selfDeletion) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    
    //resize pan
    resizeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 30,self.frame.size.height - 30,30,30)];
    UIImageView *resizeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, resizeButton.frame.size.width, resizeButton.frame.size.height)];
    resizeImageView.image = [UIImage imageNamed:@"resize"];
    [resizeButton addSubview:resizeImageView];
    [self addSubview:resizeButton];
    
    UIPanGestureRecognizer *resizePan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panResize:)];
    [resizeButton addGestureRecognizer:resizePan];
    
    
    
}


-(double)maxInResult:(NSArray*)result
{
    double currentMax = [[[[result objectAtIndex:0] objectAtIndex:1] objectAtIndex:0] doubleValue];
    for (NSArray *eachResult in result) {
        NSUInteger i = 0;
        while (i < [[eachResult objectAtIndex:1] count])
        {
            if (currentMax < [[[eachResult objectAtIndex:1] objectAtIndex:i] doubleValue]) {
                currentMax = [[[eachResult objectAtIndex:1] objectAtIndex:i] doubleValue];
            }
            i += 1;
        }
    }
    
    return currentMax;
    
}

-(double)minInResult:(NSArray*)result
{

    double currentMin = [[[[result objectAtIndex:0] objectAtIndex:1] objectAtIndex:0] doubleValue];
    for (NSArray *eachResult in result) {
        NSUInteger i = 0;
        while (i < [[eachResult objectAtIndex:1] count]) {
            if (currentMin > [[[eachResult objectAtIndex:1] objectAtIndex:i] doubleValue]) {
                currentMin = [[[eachResult objectAtIndex:1] objectAtIndex:i] doubleValue];
            }
            
            i += 1;
        }
    }
    
    return currentMin;
}


-(NSArray *)findProperInterval:(double)number1 number2:(double)number2
{
    double difference = number2 - number1;
    int inde = [[NSString stringWithFormat:@"%f",difference] length];
    double mode = 0;
    while (difference < pow(10, inde))
    {
        inde -= 1;
    }
    double basePower = pow(10, inde);
    if (difference < 2 * basePower) {
        
        mode = 0.2;
    }
    else if (difference < 5 * basePower)
    {
        mode = 0.5;
    }
    else if (difference <= 10 * basePower)
    {
        mode = 1;
    }
    double interval = mode * basePower;
    double smallest = number1 - [self mod:number1 number2:pow(10, inde)];
    double largest = smallest;
    NSMutableArray *result = [[NSMutableArray alloc]init];
    while (largest < number2)
    {
        largest += interval;
        if (largest <= number2 && largest >= number1) {
            [result addObject:[NSNumber numberWithDouble:largest]];
        }
    }
    return result;
}


-(double)mod:(double)number1 number2:(double)number2
{
    double quot = floor(number1 / number2);
    return number1 - quot * number2;
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
        CGPoint frameLocation = CGPointMake (location.x - startPosition.x, location.y - startPosition.y);
        self.frame = CGRectMake(frameLocation.x,frameLocation.y,self.frame.size.width, self.frame.size.height);
        rangeView.frame = CGRectMake(-170, self.frame.origin.y, 150,100);
        
    }
}


-(void)showAllFunctionsButtonPressed
{
    if (!rangeView)
    {
        rangeView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.origin.x - 170, self.frame.origin.y, 150,100)];
        rangeView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
        rangeView.alpha = 0;
        rangeView.layer.cornerRadius = 4;

        [self.parent.scrollView addSubview:rangeView];
        CGFloat heightForEach = 40;
        
        
        UIView *firstHolder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rangeView.frame.size.width,heightForEach)];
        firstHolder.backgroundColor = [UIColor whiteColor];
        startField = [[FormulaTextField alloc]initWithFrame:CGRectMake(5, 5,firstHolder.frame.size.width/2 - 10, heightForEach - 10)];
        [startField mySetText: [self jianLingJiuShan:[NSString stringWithFormat:@"%f",rangeStart]]];
        startField.borderStyle = UITextBorderStyleRoundedRect;
        startField.delegate = self;
        startField.inputView  = [[UIView alloc]initWithFrame:CGRectZero];
        endField = [[FormulaTextField alloc]initWithFrame:CGRectMake(firstHolder.frame.size.width/2 + 5,5 ,firstHolder.frame.size.width/2 - 10, heightForEach - 10)];
        [endField mySetText:[self jianLingJiuShan:[NSString stringWithFormat:@"%f",rangeEnd]]];
        endField.delegate = self;
        endField.borderStyle = UITextBorderStyleRoundedRect;
        endField.inputView  = [[UIView alloc]initWithFrame:CGRectZero];

        startField.borderStyle = UITextBorderStyleRoundedRect;
        endField.borderStyle = UITextBorderStyleRoundedRect;
        
        [firstHolder addSubview:startField];
        [firstHolder addSubview:endField];
        [firstHolder setBackgroundColor:[UIColor clearColor]];
        startField.placeholder = @"a";
        endField.placeholder = @"b";
        [rangeView addSubview:firstHolder];
        
        //rangeView.size
        int maxSize = 0;
        int count = 0;
        
        for (FunctionView *eachFunction in self.functionsConnected)
        {
            FormulaWebView *formulaView = [[FormulaWebView alloc]initWithFrame:CGRectMake(0, count * heightForEach + heightForEach, rangeView.frame.size.width, heightForEach)];
            formulaView.scrollView.bounces = NO;
            [formulaView setColor:eachFunction.functionColor];
            [formulaView setFormulaString:eachFunction.thisFunction.functionString];
            [formulaView displayFormulaString];
            formulaView.userInteractionEnabled = NO;
            formulaView.backgroundColor = [UIColor clearColor];
            formulaView.opaque = NO;
            [rangeView addSubview:formulaView];
            count += 1;
        }
        self.parent.autoHiddenRangeView = self;
        [UIView animateWithDuration:0.3 animations:^{
            [rangeView setAlpha:1];
        }];
    }
    else
    {
        BOOL reset = NO;
        [UIView animateWithDuration:0.3 animations:^{
            [rangeView setAlpha:1];
        }];
        if ([self ifNumeric:[startField text]] && [self ifNumeric:[endField text]]) {
            if ([[startField text] doubleValue] < [[endField text]doubleValue]) {
                if(rangeStart != [[startField text] doubleValue])
                {
                    rangeStart = [[startField text] doubleValue];
                    reset = YES;
                }
                if (rangeEnd != [[endField text]doubleValue]){
                    rangeEnd = [[endField text]doubleValue];
                    reset = YES;
                }
                if (reset) {
                    [self setNeedsDisplay];
                }
            }

        }
        [self resetRangeView];

    }
    
}
-(void)resetRangeView
{
    self.parent.fieldOnEdit = nil;
    [startField removeFromSuperview];
    [endField removeFromSuperview];
    [rangeView removeFromSuperview];
    rangeView = nil;
}




-(void)selfDeletion
{
    [self removeFromSuperview];
    [rangeView removeFromSuperview];
    
    for (FunctionView *view in self.functionsConnected) {
        [view.graphsConnected removeObject:self];
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
    [self.parent.allModules removeObject:self];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.parent.fieldOnEdit = textField;
    [self.parent showKeyboardWithID:@"number"];
    [self.parent setNormalTextFieldOnEdit:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self showAllFunctionsButtonPressed];
    [self.parent hideKeyboard];
    self.parent.normalTextFieldOnEdit = nil;
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
        if (point.x < 300 && point.y > 250)
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,300, point.y);
        }
        else if (point.y < 250 && point.x > 300) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,point.x,250);
        }
        else if (point.y < 250 && point.x < 300)
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,300,250);
        }
        else
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,point.x,point.y);
        }
        [self tmpResetFrames];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self setNeedsDisplay];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.parent.scrollView bringSubviewToFront:self];
    }
}
-(void)tmpResetFrames
{
    deleteButton.frame=CGRectMake(self.frame.size.width - 30,5, 25,25);
    showAllFunctionButtons.frame = CGRectMake(5, 5, 40, 40);
    resizeButton.frame =CGRectMake(self.frame.size.width - 30,self.frame.size.height - 30,30,30);

}

-(BOOL)ifNumeric:(NSString *)string
{
    return true;
}
-(NSArray *)produceIndexOfFunctions
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (FunctionView *view  in self.functionsConnected) {
        [result addObject:[NSNumber numberWithInteger:[self.parent.allModules indexOfObject:view] ]];
    }
    return result;
}

@end
