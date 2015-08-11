//
//  FunctionView.m
//  MathGUI
//
//  Created by Kaige Liu on 5/6/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import "FunctionView.h"
#import "DesignViewController.h"
@implementation FunctionView
@synthesize parent;
@synthesize thisFunction;

-(id)initWithFrame:(CGRect)frame
{
    //init
    _graphsConnected = [[NSMutableArray alloc]init];
    _functionColor = [UIColor blackColor];
    _formulaField = [[FormulaTextField alloc] init];
    _formulaField.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:14];

    
    return [super initWithFrame:frame];
}

-(void)drawRect:(CGRect)rect
{
    webView = nil;
    connectionButton = nil;
    colorPad = nil;
    colorButton = nil;
    resizeButton = nil;
    self.plotButton = nil;

    
    webView = [[FormulaWebView alloc]initWithFrame:CGRectMake(20, 50, self.frame.size.width - 20, 50)];

    //operations
    for (UIView *sub in self.subviews)
    {
        [sub removeFromSuperview];
    }

    //text field
    if (!_formulaField) {
        _formulaField = [[FormulaTextField alloc] init];
    }
    _formulaField.backgroundColor = [UIColor whiteColor];
    [_formulaField setFrame:CGRectMake(50, 60, self.frame.size.width - 70, 30)];
    _formulaField .delegate = self;
    _formulaField.inputView  = [[UIView alloc]initWithFrame:CGRectZero];
    _formulaField.borderStyle = UITextBorderStyleRoundedRect;
    _formulaField.placeholder = @"Type in an equation";
    
    if (!functionLabel)
    {
        functionLabel = [[UILabel alloc]init];
    }
    functionLabel.backgroundColor = [UIColor clearColor];
    [functionLabel setFrame:CGRectMake(10, 60, 30, 30)];
    functionLabel.text = @"f  =";
    functionLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:20];
    [self addSubview:functionLabel];
    [self addSubview:_formulaField];
    

    //menu button
    menuShowButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 30,30)];
    [menuShowButton setBackgroundImage:[UIImage imageNamed:@"menublue"] forState:UIControlStateNormal];
    [self addSubview:menuShowButton];
    [menuShowButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    //menu
    menu = [[UIView alloc]initWithFrame:CGRectMake(self.frame.origin.x - 200,self.frame.origin.y, 190, 150)];
    menu.backgroundColor = [UIColor colorWithRed: 0.92156 green: 0.92156 blue: 0.92156 alpha:1];
    [menu.layer setBorderWidth:1];
    [menu.layer setBorderColor:[[UIColor blueColor]CGColor]];
    [menu.layer setCornerRadius:5];
    [self.parent.scrollView addSubview:menu];
    menu.alpha = 0;
    
    //colorButton
    colorButton = [[UIButton alloc]init];
    colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    colorButton.frame = CGRectMake(0,0,190,50);
    colorButton.layer.cornerRadius = 0;
    [colorButton addTarget:self action:@selector(colorButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *colorButtonImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 30, 30)];
    colorButtonImage.image = [UIImage imageNamed:@"color"];
    [colorButton addSubview:colorButtonImage];
    UILabel *colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 60, 30)];
    colorLabel.text = @"Color";
    colorLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:17];
    [colorButton addSubview:colorLabel];
    [menu addSubview:colorButton];
    
    //options button view
    optionsButtonView = [[UIButton alloc]initWithFrame:CGRectMake(0,50,190,50)];
    optionsButtonView.backgroundColor = [UIColor clearColor];
    optionsButtonView.layer.borderColor = [[UIColor blueColor
                                            ]CGColor];
    optionsButtonView.layer.borderWidth = 1;
    [menu addSubview:optionsButtonView];
    [optionsButtonView addTarget:self action:@selector(optionsTapping) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *optionsButtonImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 30, 30)];
    optionsButtonImage.image = [UIImage imageNamed:@"options"];
    [optionsButtonView addSubview:optionsButtonImage];
    UILabel *optionsLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 120, 30)];
    optionsLabel.text = @"Options";
    optionsLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:17];

    [optionsButtonView addSubview:optionsLabel];
    
    //connection button
    connectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0,100,190,50)];
    connectionButton.backgroundColor = [UIColor clearColor];
    
    //[connectionButton addTarget:self action:@selector(connectionButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [connectionButton addTarget:self action:@selector(pressDragButton) forControlEvents:UIControlEventTouchUpInside];
    [menu addSubview:connectionButton];
    UIImageView *connectionButtonImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 30, 30)];
    connectionButtonImage.image = [UIImage imageNamed:@"connect"];
    [connectionButton addSubview:connectionButtonImage];
    UILabel *connectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 120, 30)];
    connectionLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:17];

    connectionLabel.text = @"Connection";
    [connectionButton addSubview:connectionLabel];
    
    
    
    UIPanGestureRecognizer *connectionPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(connectionPanning:)];
    [connectionButton addGestureRecognizer:connectionPan];
    
    
    //resize pan
    resizeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 30,self.frame.size.height - 30,30,30)];
    UIImageView *resizeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, resizeButton.frame.size.width, resizeButton.frame.size.height)];
    resizeImageView.image = [UIImage imageNamed:@"resizeblue"];
    [resizeButton addSubview:resizeImageView];
    [self addSubview:resizeButton];
    
    UIPanGestureRecognizer *resizePan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panResize:)];
    [resizeButton addGestureRecognizer:resizePan];
    

    
    //deleteButton
    deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30,5, 25,25)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"deleteblue"] forState:UIControlStateNormal];
    [self addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(selfDeletion) forControlEvents:UIControlEventTouchUpInside];

    

    //color pad
    colorPad = [[UIView alloc]initWithFrame:CGRectMake(self.frame.origin.x - 130,self.frame.origin.y, 160, 160)];
    colorPad.userInteractionEnabled = YES;
    [self.parent.scrollView addSubview:colorPad];
    [colorPad setAlpha:0];
    CGFloat cubeMag = (colorPad.frame.size.height- 10)/4 / 5 * 4;
    NSUInteger numberCount = 0;
    NSUInteger numberEachColumn = 3;
    NSArray *colorList = [[NSArray alloc]initWithObjects:[UIColor blackColor], [UIColor grayColor],[UIColor redColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor purpleColor], nil];
    while (numberCount < 8)
    {
        UIButton *newButton = [[UIButton alloc]init];
        [UIButton buttonWithType:UIButtonTypeCustom];
        newButton.frame = CGRectMake(cubeMag / 7 * 8 * ((numberCount - numberCount % numberEachColumn)/numberEachColumn) + cubeMag / 7,cubeMag / 7 * 8 * (numberCount % numberEachColumn) + cubeMag/7, cubeMag, cubeMag);
        newButton.layer.cornerRadius = cubeMag/2;
        newButton.backgroundColor = [colorList objectAtIndex:numberCount];
        [newButton addTarget:self action:@selector(eachColorPressed:) forControlEvents:UIControlEventTouchUpInside];
        [colorPad addSubview:newButton];
        numberCount += 1;
    }

    

    

    
    //pan
    UIPanGestureRecognizer *rec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:rec];
    
    
    //set webview
    if (![_formulaField.text isEqualToString:@""]) {
        [self setWebView];
    }


    
}

-(void)setWebView
{
    if (![_formulaField.text isEqualToString:@""]) {
        _formulaField.hidden = YES;
        webView = [[FormulaWebView alloc] initWithFrame:CGRectMake(50, 50, self.frame.size.width - 50, 80)];
        [self addSubview:webView];
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = NO;
        
        [webView setColor:self.functionColor];
        [webView setFormulaString:_formulaField.text];
        [webView displayFormulaString];
        webView.scrollView.scrollEnabled = NO;
        
        
        
        UIButton *cancelButton = [[UIButton  alloc]initWithFrame:CGRectMake(0, 0, webView.frame.size.width, webView.frame.size.height)];
        [cancelButton addTarget:self action:@selector(hideWebView) forControlEvents:UIControlEventTouchUpInside];
        [webView addSubview:cancelButton];
    }
    else
    {
        self.thisFunction = nil;
    }

}

-(void)colorButtonPressed
{
    if (colorPad.alpha == 0) {
        [UIView animateWithDuration:0.5 animations:^{[colorPad setAlpha:1];}];
        [self.parent.scrollView bringSubviewToFront:colorPad];
        [self.parent setAutoHiddenView:colorPad];

    }
    else
    {
        {
            [UIView animateWithDuration:0.5 animations:^{[colorPad setAlpha:0];}];
        }
    }
    [self showMenu];
}

-(void)eachColorPressed:(id)sender
{
    self.functionColor = [sender backgroundColor];
    _formulaField.textColor = [sender backgroundColor];
    [webView setColor:[sender backgroundColor]];
    [webView displayFormulaString];
    [self colorButtonPressed];
    for (Graph *thisGraph in _graphsConnected) {
        [thisGraph setNeedsDisplay];
        [thisGraph resetRangeView];
    }
}

-(void)setFunctionViewColor:(UIColor *)color
{
    self.functionColor = color;
    _formulaField.textColor = color;
    [webView setColor:color];
    [webView displayFormulaString];
    [self colorButtonPressed];
    for (Graph *thisGraph in _graphsConnected) {
        [thisGraph setNeedsDisplay];
        [thisGraph resetRangeView];
    }
}

-(void)pressDragButton
{
    [self.parent produceErrorMessage:@"Drag this button to make connection with other modules"];
}

-(void)connectWith:(id)other
{
    if ([[other moduleType]  isEqualToString:@"graph"])
    {
        if ([self.thisFunction.varList count] == 1) {
            if ([_graphsConnected indexOfObject:other] == NSNotFound)
            {
                [[other functionsConnected] addObject:self];
                [other setNeedsDisplay];
                [self.graphsConnected addObject:other];
                [other resetRangeView];
                
                
            }
        }
    }
    else if ([[other moduleType] isEqualToString:@"calculation"])
    {
        [other setThisFunction:self.thisFunction];
        [[other formulaField] setTextWithArray:[self.formulaField textInStructure]];
    
        [other updateWebView:[other formulaField]];
        [other updateVarList];
        
    }
    else if ([[other moduleType] isEqualToString:@"equation"])
    {
        if ([self.thisFunction.varList count] == 1)
        {
            if ([_graphsConnected indexOfObject:other] == NSNotFound)
            {
                [other setThisFunction:self.thisFunction];
                [[other formulaField] setTextWithArray:[self.formulaField textInStructure]];
            
                [other updateWebView:[other formulaField]];
                [other solve];
            }
        }
    }
    else if ([[other moduleType] isEqualToString:@"3d"])
    {
        if ([self.thisFunction.varList count] <= 2) {
            [other setThisFunction:[[Functions alloc] initWithFunction:self.thisFunction.functionString varList:self.thisFunction.varList]];
            [other setVertices];
            [other setup];
        }
    }
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
        menu.frame = CGRectMake(self.frame.origin.x - 200,self.frame.origin.y, 190, 150);
        colorPad.frame =CGRectMake(self.frame.origin.x - 130,self.frame.origin.y, 160, 160);

    }
}




-(void)connectionPanning:(UIPanGestureRecognizer*)sender
{
    CGPoint currentLocation = [sender locationInView:self.parent.scrollView];
    CGPoint startLocationOfLine = CGPointMake(self.frame.origin.x  - 198, self.frame.origin.y + 148);
    ModuleView *currentView =[self.parent inWhichArea:currentLocation];
    if (sender.state == UIGestureRecognizerStateChanged) {
        [self.parent drawLine:startLocationOfLine point2:currentLocation];
        if (currentView && ![currentView isEqual:self]) {
            if ([tmpKeepViewOnConnection isEqual:currentView])
            {
                currentView.layer.borderColor = [[UIColor blueColor] CGColor];
                self.parent.currentViewOnConnection = currentView;
            }
            else
            {
                if (tmpKeepViewOnConnection) {
                    tmpKeepViewOnConnection.layer.borderColor = tmpKeepViewOnConnection.currentBorderColor;
                    tmpKeepViewOnConnection = currentView;
                }
                else
                {
                    tmpKeepViewOnConnection = currentView;
                }
            }
        }
        else
        {
            self.parent.currentViewOnConnection.layer.borderColor = tmpKeepViewOnConnection.currentBorderColor;
            self.parent.currentViewOnConnection = nil;

        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        self.parent.scrollView.path = nil;
        if ([[self.parent inWhichArea:currentLocation] isEqual:currentView])
        {
            [self.parent makeConnection:self view2:self.parent.currentViewOnConnection];
        }
        self.parent.scrollView.path = nil;
        self.parent.currentViewOnConnection.layer.borderColor = tmpKeepViewOnConnection.currentBorderColor;
        [self showMenu];
    }
}


-(void)showMenu
{

    if (menu.alpha == 0) {
        [self.parent.scrollView bringSubviewToFront:menu];
        [UIView animateWithDuration:0.3 animations:^{
            [colorPad setAlpha:0];
        }];
        [UIView animateWithDuration:0.5 animations:^{
            menu.alpha = 1;
        }];
        [self.parent setAutoHiddenView:menu];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            menu.alpha = 0;
        }];
    }
}
-(void)optionsTapping
{
    [self showMenu];
    if (!_optionsView) {
        if (thisFunction) {
            if (thisFunction.valid) {
                CGFloat height = 0;
                _optionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.parent.view.frame.size.width,0,200,self.parent.view.frame.size.height)];
                _optionsView.backgroundColor = [UIColor colorWithRed:0.90625 green:0.90625 blue:0.90625 alpha:1];


                [self.parent.view addSubview:_optionsView];
                [self.parent.view bringSubviewToFront:_optionsView];

                _simplifyButton = [[UIButton alloc]initWithFrame:CGRectMake(0, height, 200, 50)];
                [_optionsView addSubview:_simplifyButton];
                [_simplifyButton addTarget:self  action:@selector(automaticallySimplify:) forControlEvents:UIControlEventTouchUpInside];
                [_simplifyButton setTitle:@"          simplify" forState:UIControlStateNormal];

                [_simplifyButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17]];
                [_simplifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _simplifyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

                UIImageView *simpifyImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 30, 30)];
                simpifyImage.image = [UIImage imageNamed:@"simplify"];
                [_simplifyButton addSubview:simpifyImage];
                
                height += 50;
                
                if (thisFunction.varList.count <= 2)
                {
                    _threeDPlotButton = [[UIButton alloc]initWithFrame:CGRectMake(0, height, 200, 50)];
                    [_optionsView addSubview:_threeDPlotButton];
                    [_threeDPlotButton addTarget:self action:@selector(automaticallyPlot3D:) forControlEvents:UIControlEventTouchUpInside];
                    [_threeDPlotButton setTitle:@"          3D Plot" forState:UIControlStateNormal];
                    [_threeDPlotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [_threeDPlotButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17]];

                    _threeDPlotButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    UIImageView *threeDPlotImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 30, 30)];
                    threeDPlotImage.image = [UIImage imageNamed:@"3d"];
                    [_threeDPlotButton addSubview:threeDPlotImage];
                    height += 50;
                }
                
                if (thisFunction.varList.count == 1) {
                    _plotButton = [[UIButton alloc]initWithFrame:CGRectMake(0, height, 200, 50)];
                    [_optionsView addSubview:_plotButton];
                    [_plotButton addTarget:self action:@selector(automaticallyPlot:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [_plotButton setTitle:@"          plot a graph" forState:UIControlStateNormal];
                    [_plotButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17]];

                    [_plotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    _plotButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    UIImageView *plotImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 30, 30)];
                    plotImage.image = [UIImage imageNamed:@"graph"];
                    [_plotButton addSubview:plotImage];
                    height += 50;
                }
                if (thisFunction.ifPolynomial)
                {
                    _produceEquationButton = [[UIButton alloc]initWithFrame:CGRectMake(0, height, 200, 50)];
                    [_optionsView addSubview:_produceEquationButton];
                    [_produceEquationButton addTarget:self action:@selector(automaticallyProduceEquation:) forControlEvents:UIControlEventTouchUpInside];
                    [_produceEquationButton setTitle:@"          generate equation" forState:UIControlStateNormal];
                    [_produceEquationButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17]];

                    [_produceEquationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    _produceEquationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

                    UIImageView *euqationImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 30, 30)];
                    euqationImage.image = [UIImage imageNamed:@"equation=0"];
                    
                    [_produceEquationButton addSubview:euqationImage];

                    height += 50;
                }

                
                _produceCalculationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height, 200, 50)];
                [_optionsView addSubview:_produceCalculationButton];
                [_produceCalculationButton addTarget:self action:@selector(automaticallyProduceCalculation:) forControlEvents:UIControlEventTouchUpInside];
                [_produceCalculationButton setTitle:@"          calculate value" forState:UIControlStateNormal];
                [_produceCalculationButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17]];

                [_produceCalculationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _produceCalculationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

                UIImageView *calculationImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 30, 30)];
                calculationImage.image = [UIImage imageNamed:@"calculate"];
                [_produceCalculationButton addSubview:calculationImage];
                
                height += 50;
                if ([thisFunction.varList count] == 1) {
                    _diffButton =[[UIButton alloc] initWithFrame:CGRectMake(0, height, 200, 50)];
                    [_optionsView addSubview:_diffButton];
                    [_diffButton addTarget:self action:@selector(automaticallyDifferentiation:) forControlEvents:UIControlEventTouchUpInside];
                    [_diffButton setTitle:@"          differentiate" forState:UIControlStateNormal];
                    [_diffButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17]];

                    [_diffButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    _diffButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

                    UIImageView *diffImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 30, 30)];
                    diffImage.image = [UIImage imageNamed:@"diff"];
                    [_diffButton addSubview:diffImage];
                    
                    
                    height += 50;
                }
                if ([thisFunction ifPolynomial]) {
                    _factorization = [[UIButton alloc] initWithFrame:CGRectMake(0, height, 200, 50)];
                    [_optionsView addSubview:_factorization];
                    [_factorization addTarget:self action:@selector(automaticallyFactorize:) forControlEvents:UIControlEventTouchUpInside];
                    [_factorization setTitle:@"          factorize" forState:UIControlStateNormal];
                    [_factorization.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17]];

                    [_factorization setTitleColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1] forState:UIControlStateNormal];
                    _factorization.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

                    UIImageView *factImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 30, 30)];
                    factImage.image = [UIImage imageNamed:@"factorize"];
                    [_factorization addSubview:factImage];
                    
                    height += 50;
                }
                
                
                [UIView animateWithDuration:0.5 animations:^{
                    _optionsView.frame = CGRectMake(self.parent.view.frame.size.width - 200,0,200,self.parent.view.frame.size.height);
                }];
                self.parent.autoHiddenFunctionOptionsView = self;
                if (height > self.parent.view.frame.size.height)
                {
                    _optionsView.contentSize = CGSizeMake(200, height);
                }
            }


        }
        else
        {
            [self.parent produceErrorMessage:@"Please input a function first"];
        }
    }
    else
    {
        [UIView animateWithDuration:0.5
            animations:^{
            _optionsView.frame = CGRectMake(self.parent.view.frame.size.width,0,200,self.parent.view.frame.size.height);
            }
            completion:^(BOOL finished){
            [_optionsView removeFromSuperview];
            }];
        _optionsView = nil;
        self.parent.autoHiddenFunctionOptionsView = nil;
    }

}


-(void)automaticallyPlot3D:(UIButton *)sender{
    [self.parent generateNewThreeDPloatAtPosition:CGPointMake(self.frame.origin.x, self.frame.origin.y)];
    OpenGLView *newOpenGLView = [self.parent.allModules lastObject];
    newOpenGLView.thisFunction = [[Functions alloc] initWithFunction:self.thisFunction.functionString varList:self.thisFunction.varList];
    [newOpenGLView setVertices];
    [newOpenGLView setup];
    [UIView animateWithDuration:0.5 animations:^{
        [[[self.parent allModules] lastObject] setFrame:CGRectMake(self.frame.origin.x +200, self.frame.origin.y, [[[self.parent allModules] lastObject] frame].size.width, [[[self.parent allModules] lastObject] frame].size.height)];
        [[self.parent.allModules lastObject] setAlpha:1];
    }];
    [self optionsTapping];

}

-(void)automaticallyPlot:(UIButton *)sender
{
    [self.parent generateNewGraphAtPosition:CGPointMake(self.frame.origin.x, self.frame.origin.y)];
    [self connectWith:[[self.parent allModules] lastObject]];
    [[self.parent.allModules lastObject] setAlpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [[[self.parent allModules] lastObject] setFrame:CGRectMake(self.frame.origin.x +200, self.frame.origin.y, [[[self.parent allModules] lastObject] frame].size.width, [[[self.parent allModules] lastObject] frame].size.height)];
        [[self.parent.allModules lastObject] setAlpha:1];
    }];
    [self optionsTapping];
}

-(void)automaticallyProduceEquation:(UIButton *)sender
{
    [self.parent generateNewEquationAtPosition:CGPointMake(self.frame.origin.x, self.frame.origin.y)];
    EquationView *this  = [self.parent.allModules lastObject];
    [this setAlpha:0];
    [this setThisFunction:self.thisFunction];
    [[this formulaField] setTextWithArray:[self.formulaField textInStructure]];
    [UIView animateWithDuration:0.5 animations:^{
        [this setFrame:CGRectMake(self.frame.origin.x +200, self.frame.origin.y, [[[self.parent allModules] lastObject] frame].size.width, [[[self.parent allModules] lastObject] frame].size.height)];
        [this setAlpha:1];
    }];
    [this solve];
 //   [this setThisFunction:self.thisFunction];
  //  [this updateWebView:this.formulaField];
  //  [this solve];

    
    [self optionsTapping];
}



-(void)automaticallyProduceCalculation:(UIButton *)sender
{
    [self.parent generateNewCalculationAtPosition:CGPointMake(self.frame.origin.x, self.frame.origin.y)];
    CalculationView *this  = [self.parent.allModules lastObject];
    [this setAlpha:0];


    [this setThisFunction:self.thisFunction];
    [[this formulaField] setTextWithArray:[self.formulaField textInStructure]];
    [UIView animateWithDuration:0.5 animations:^{
        [this setFrame:CGRectMake(self.frame.origin.x +200, self.frame.origin.y, [[[self.parent allModules] lastObject] frame].size.width, [[[self.parent allModules] lastObject] frame].size.height)];
        [this setAlpha:1];
    }];
    [this updateVarList];
    [self optionsTapping];
}

-(void)automaticallyDifferentiation:(UIButton *)sender
{
    [self.parent generateNewFunctionAtPosition:CGPointMake(self.frame.origin.x, self.frame.origin.y)];
    FunctionView *this = [self.parent.allModules lastObject];
    [this setAlpha:0];
    Functions *result = [[Functions alloc] initWithFunction:[self.thisFunction rendering:[self.thisFunction reduceSymbolically:[self.thisFunction derivAlgo:self.thisFunction.functionStructure vari:[self.thisFunction.varList objectAtIndex:0]]]] varList:self.thisFunction.varList];
    [this setThisFunction:result];

    [this.formulaField mySetText:result.functionString];
    [UIView animateWithDuration:0.5 animations:^{
        [this setFrame:CGRectMake(self.frame.origin.x +200, self.frame.origin.y, [[[self.parent allModules] lastObject] frame].size.width, [[[self.parent allModules] lastObject] frame].size.height)];
        [this setAlpha:1];
        
    }];
    [self optionsTapping];
}
-(void)automaticallySimplify:(UIButton *)sender
{
    [self.parent generateNewFunctionAtPosition:CGPointMake(self.frame.origin.x, self.frame.origin.y)];
    FunctionView *this = [self.parent.allModules lastObject];
    [this setAlpha:0];
    Functions *result = [[Functions alloc]initWithFunction:[self.thisFunction rendering:[self.thisFunction reduceSymbolically:self.thisFunction.functionStructure]] varList:self.thisFunction.varList];
    [this setThisFunction:result];

    [this.formulaField mySetText:result.functionString];
    [UIView animateWithDuration:0.5 animations:^{
        [this setFrame:CGRectMake(self.frame.origin.x +200, self.frame.origin.y, [[[self.parent allModules] lastObject] frame].size.width, [[[self.parent allModules] lastObject] frame].size.height)];
        [this setAlpha:1];
        
    }];
    [self optionsTapping];
}

-(void)automaticallyFactorize:(UIButton *)sender
{
    [self.parent produceErrorMessage:@"TIP: factorization is still under development"];
    [self.parent generateNewFunctionAtPosition:CGPointMake(self.frame.origin.x, self.frame.origin.y)];
    FunctionView *this = [self.parent.allModules lastObject];
    [this setAlpha:0];
    Functions *result = [[Functions alloc]initWithFunction:[self.thisFunction rendering:[self.thisFunction convert:[self.thisFunction squareFree:self.thisFunction.polynomialStructure] vari:[self.thisFunction.varList objectAtIndex:0]]] varList:self.thisFunction.varList];
    [this setThisFunction:result];
    if (webView) {
        [self hideWebView];
    }
    [this.formulaField mySetText:result.functionString];
    [UIView animateWithDuration:0.5 animations:^{
        [this setFrame:CGRectMake(self.frame.origin.x +200, self.frame.origin.y, [[[self.parent allModules] lastObject] frame].size.width, [[[self.parent allModules] lastObject] frame].size.height)];
        [this setAlpha:1];
        
    }];
    [self optionsTapping];
}

-(void)selfDeletion
{
    if ([self.parent.currentViewOnConnection isEqual:self]) {
        self.parent.currentViewOnConnection = nil;
    }
    for (UIView *view in self.parent.inConnectedViews) {
        if ([view isEqual:self]) {
            [self.parent.inConnectedViews removeObject:self];
            break;
        }
    }
    [colorPad removeFromSuperview];
    [_optionsView removeFromSuperview];
    [menu removeFromSuperview];
    [self removeFromSuperview];
    [self.parent.allModules removeObject:self];
    for (Graph *eachGraph in _graphsConnected)
    {
        [eachGraph.functionsConnected removeObject:self];
        [eachGraph resetRangeView];
        [eachGraph setNeedsDisplay];
    }

    [colorPad removeFromSuperview];
}


-(void)hideWebView
{
    
    [webView removeFromSuperview];
    
    [_formulaField becomeFirstResponder];
    _formulaField.hidden = NO;
}


//text field delegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.parent.fieldOnEdit = _formulaField;
    [self.parent showKeyboardWithID:@"function"];
}

-(void)textFieldDidEndEditing:(FormulaTextField *)textField
{
    if ([textField.textInStructure containsObject:@"="])
    {
        if ([textField.textInStructure indexOfObject:@"="] == 1)
        {
            NSMutableArray *tmp = textField.textInStructure;
            [tmp removeObjectAtIndex:0];
            [tmp removeObjectAtIndex:0];
            [textField setTextWithArray:tmp];
        }

    }
    self.thisFunction = [[Functions alloc]initWithFunction:textField.text varList:@[@"x",@"y",@"z",@"a",@"b",@"c"]];
    if (self.thisFunction.valid && [self.thisFunction.varList count] == 1 )
    {
        for (Graph *eachGraph in _graphsConnected)
        {
            [eachGraph setNeedsDisplay];
        }
        [self setWebView];
        [self.parent hideKeyboard];
    }
    else if (self.thisFunction.valid && [self.thisFunction.varList count] != 1 )
    {
        [self setWebView];
        [self.parent hideKeyboard];
    }
    else if(!self.thisFunction.valid )
    {
        self.thisFunction = nil;
        [self.parent produceErrorMessage:@"Function not valid"];
        for (Graph *eachGraph in _graphsConnected)
        {
            [eachGraph.functionsConnected removeObject:self];
            [eachGraph setNeedsDisplay];
        }
        [_graphsConnected removeAllObjects];
        [self setWebView];
        [self.parent hideKeyboard];
    }

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
    [_formulaField setFrame:CGRectMake(50, 60, self.frame.size.width - 70, 30)];
    resizeButton.frame = CGRectMake(self.frame.size.width - 30,self.frame.size.height - 30,30,30);
    deleteButton.frame = CGRectMake(self.frame.size.width - 30,5, 25,25);
    webView.frame = CGRectMake(50, 50, self.frame.size.width - 50, 80);
}



-(BOOL)ifNumeric:(NSString *)string
{
    NSUInteger numericJdgCount = [[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] length];
    numericJdgCount = [string length] - numericJdgCount;

    if (numericJdgCount == 0)
    {
        return true;
    }
    else if (numericJdgCount == 1)
    {
        if ([string rangeOfString:@"."].location != NSNotFound || [string rangeOfString:@"-"].location == 0)
        {
            return true;
        }
    }
    else if (numericJdgCount == 2)
    {
        if ([string rangeOfString:@"."].location != NSNotFound && [string rangeOfString:@"-"].location == 0)
        {
            return true;
        }
    }
    return false;
}

-(NSArray *)produceIndexOfGraphs
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (Graph *view  in self.graphsConnected) {
        [result addObject:[NSNumber numberWithInteger:[self.parent.allModules indexOfObject:view] ]];
    }
    return result;
}
@end
