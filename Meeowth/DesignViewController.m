//
//  DesignViewController.m
//  MathGUI
//
//  Created by Kaige Liu on 5/6/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import "DesignViewController.h"
@import ObjectiveC.runtime;

@interface DesignViewController ()
@property (retain, nonatomic)  UIView *collectionOfOptions;
@property (retain, nonatomic)  UIButton *functionButton;
@property (retain, nonatomic)  UIButton *graphButton;
@property (retain, nonatomic)  UIButton *calculationButton;
@property (retain, nonatomic)  UIButton *equationButton;
@property (retain, nonatomic)  UIButton *threeDPlotButton;

@property (retain,nonatomic) UIScrollView *mathKeyboardScrollView;
@property (retain,nonatomic) UIScrollView *numberKeyboardScrollView;
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (retain,nonatomic)IBOutlet UINavigationItem *titleItem;
@property (retain,nonatomic) UITableView *listOfFile;
@property (retain,nonatomic) UIView *listOfFileBar;
@property (retain,nonatomic) UIView *settingsBar;

@property (retain,nonatomic) UIView *errorReportView;
@property (retain,nonatomic) UILabel *errorReportLabel;



@property (retain,nonatomic) NSMutableArray *contentOfFile;
@end

@implementation DesignViewController
- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
- (void)viewDidLoad
{
    //auto
    [super viewDidLoad];
    self.view.frame = [ UIScreen mainScreen].bounds;
    _inConnectedViews = [[NSMutableArray alloc]initWithObjects:nil];
    _allModules = [[NSMutableArray alloc]init];
    
    ifOriginalKeyboard = YES;
    
    //set scroll view
    self.scrollView = [[BezierPathScrollView alloc]init];
    self.scrollView.parent = self;
    self.scrollView.frame = CGRectMake(0, self.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationBar.frame.size.height);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2,self.view.frame.size.height * 2);
    
    self.scrollView.bounces= NO;
    self.scrollView.bouncesZoom = NO;
    [self.view addSubview:self.scrollView];
    
    widthOfKeyboard = (self.view.frame.size.height - self.navigationBar.frame.size.height)/4 * 3;

    //set the creator buttons
    
    
    
    //test
    
    _collectionOfOptions = [[UIView alloc]init];
    [self.view addSubview:_collectionOfOptions];
    [self.view insertSubview:_collectionOfOptions aboveSubview:self.scrollView];
    _collectionOfOptions.frame = CGRectMake(self.view.frame.size.width, self.navigationBar.frame.size.height,widthOfKeyboard / 4 * 3 , self.view.frame.size.height - self.navigationBar.frame.size.height);
    _collectionOfOptions.backgroundColor = [UIColor colorWithRed:0.90625 green:0.90625 blue:0.90625 alpha:1];
    
    
    _functionButton = [[UIButton alloc]init];
    _graphButton = [[UIButton alloc]init];
    _calculationButton = [[UIButton alloc]init];
    _equationButton = [[UIButton alloc]init];
    _threeDPlotButton = [[UIButton alloc]init];
    [_functionButton addTarget:self action:@selector(newFunction:) forControlEvents:UIControlEventTouchUpInside];
    [_graphButton addTarget:self action:@selector(newGraph:) forControlEvents:UIControlEventTouchUpInside];
    [_calculationButton addTarget:self action:@selector(newCalculation:) forControlEvents:UIControlEventTouchUpInside];
    [_equationButton addTarget:self action:@selector(newEquation:) forControlEvents:UIControlEventTouchUpInside];
    [_threeDPlotButton addTarget:self action:@selector(newThreeDPlot:) forControlEvents:UIControlEventTouchUpInside];
    
    _functionButton.frame = CGRectMake(0, 0, widthOfKeyboard/4*3, (self.view.frame.size.height - self.navigationBar.frame.size.height)/5);
    _graphButton.frame = CGRectMake(0, (self.view.frame.size.height - self.navigationBar.frame.size.height)/5, widthOfKeyboard/4*3, (self.view.frame.size.height - self.navigationBar.frame.size.height)/5);
    _calculationButton.frame = CGRectMake(0, (self.view.frame.size.height - self.navigationBar.frame.size.height)/5*2, widthOfKeyboard/4*3, (self.view.frame.size.height - self.navigationBar.frame.size.height)/5);
    _equationButton.frame = CGRectMake(0, (self.view.frame.size.height - self.navigationBar.frame.size.height)/5 * 3, widthOfKeyboard/4*3, (self.view.frame.size.height - self.navigationBar.frame.size.height)/5);
    _threeDPlotButton.frame = CGRectMake(0, (self.view.frame.size.height - self.navigationBar.frame.size.height)/5 * 4, widthOfKeyboard/4*3, (self.view.frame.size.height - self.navigationBar.frame.size.height)/5);

    
    _functionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _graphButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _calculationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _equationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _threeDPlotButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIImageView *functionImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, ( (self.view.frame.size.height - self.navigationBar.frame.size.height)/5- 30)/2, 30, 30)];
    functionImage.image = [UIImage imageNamed:@"function"];
    [_functionButton addSubview:functionImage];
    UIImageView *graphImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, ( (self.view.frame.size.height - self.navigationBar.frame.size.height)/5- 30)/2 + 3, 30, 30)];
    graphImage.image = [UIImage imageNamed:@"graph"];
    [_graphButton addSubview:graphImage];
    UIImageView *calculationImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, ( (self.view.frame.size.height - self.navigationBar.frame.size.height)/5- 30)/2, 30, 30)];
    calculationImage.image = [UIImage imageNamed:@"calculate"];
    [_calculationButton addSubview:calculationImage];
    UIImageView *equationImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, ( (self.view.frame.size.height - self.navigationBar.frame.size.height)/5- 30)/2 + 3, 30, 30)];
    equationImage.image = [UIImage imageNamed:@"equation"];
    [_equationButton addSubview:equationImage];
    
    UIImageView *threeDPlotImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, ( (self.view.frame.size.height - self.navigationBar.frame.size.height)/5- 30)/2 + 3, 30, 30)];
    threeDPlotImage.image = [UIImage imageNamed:@"3d"];
    [_threeDPlotButton addSubview:threeDPlotImage];

    
    [_functionButton setTitle:@"          function" forState:UIControlStateNormal];
    [_graphButton setTitle:@"          graph" forState:UIControlStateNormal];
    [_calculationButton setTitle:@"          calculation" forState:UIControlStateNormal];
    [_equationButton setTitle:@"          equation" forState:UIControlStateNormal];
    [_threeDPlotButton setTitle:@"           3d plot"forState:UIControlStateNormal];
    
    _functionButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    _graphButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    _calculationButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    _equationButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    _threeDPlotButton.titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    
    [_functionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_graphButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_calculationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_equationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_threeDPlotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    
    [self.collectionOfOptions addSubview:_functionButton];
    [self.collectionOfOptions addSubview:_graphButton];
    [self.collectionOfOptions addSubview:_calculationButton];
    [self.collectionOfOptions addSubview:_equationButton];
    [self.collectionOfOptions addSubview:_threeDPlotButton];
    
    //set keyboard
    //hidden position
    //_mathKeyboardScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, self.navigationBar.frame.size.height,widthOfKeyboard , self.view.frame.size.height - self.navigationBar.frame.size.height)];


    
    //set file content
    self.contentOfFile = [[NSMutableArray alloc]init];
    [self updateContentOfFile];
    //set list of file
    _listOfFile = [[UITableView alloc]initWithFrame: CGRectMake(0, 50, 200, self.view.frame.size.height - 50) style:UITableViewStylePlain];

    _listOfFileBar = [[UIView alloc]initWithFrame:CGRectMake(-200, 0, 200, self.view.frame.size.height)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(160, 7, 30, 30)];
    UILabel *historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 140, 40)];
    historyLabel.text = @"History";
    historyLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [button setTitle:@"+" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];

    [button addTarget:self action:@selector(newBoardCreate) forControlEvents:UIControlEventTouchDown];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton *showSettingBarButton = [[UIButton alloc]initWithFrame:CGRectMake(120, 10, 30, 30)];
    [_listOfFileBar addSubview:showSettingBarButton];
    [showSettingBarButton setBackgroundImage:[UIImage imageNamed:@"gearwhite"] forState:UIControlStateNormal];
    [showSettingBarButton addTarget:self  action:@selector(showSettingBar) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    _settingsBar = [[UIView alloc]initWithFrame:CGRectMake(-350, 0, 150, self.view.frame.size.height)];
    [self.view addSubview:_settingsBar];
    
    
    UIButton *aboutButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30,30 )];
    [aboutButton setBackgroundImage:[UIImage imageNamed:@"about"] forState:UIControlStateNormal];
    aboutButton.layer.borderColor = [[UIColor grayColor]CGColor];
    aboutButton.layer.borderWidth = 1;
    aboutButton.layer.cornerRadius = 5;
    //[aboutButton addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    //[_settingsBar addSubview:aboutButton];
    
    UILabel *websiteLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 30)];
    websiteLabel.text = @"visit our website";
    websiteLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    //[_settingsBar addSubview:websiteLabel];

    //UITapGestureRecognizer *websiteTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(<#selector#>)];
    //[websiteLabel addGestureRecognizer:websiteTap];
    
    
    
    UIButton *emailButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 150,30 )];
    emailButton.backgroundColor = [UIColor clearColor];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 30, 30)];
    image.image = [UIImage imageNamed:@"email"];
    [emailButton addSubview:image];
    
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 30)];
    emailLabel.text = @"email to developers";
    emailLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    [_settingsBar addSubview:emailLabel];
    emailLabel.userInteractionEnabled = YES;

    [emailButton addTarget:self action:@selector(businessContactWithMail) forControlEvents:UIControlEventTouchUpInside];
    [_settingsBar addSubview:emailButton];

    
    
    
    
    
    
    UIButton *rateButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 60, 150,30 )];
    rateButton.backgroundColor = [UIColor clearColor];
    UIImageView *rateImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 30, 30)];
    rateImage.image = [UIImage imageNamed:@"star"];
    [rateButton addSubview:rateImage];
    [rateButton addTarget:self action:@selector(goToReview) forControlEvents:UIControlEventTouchUpInside];
    [_settingsBar addSubview:rateButton];
    
    UILabel *rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 60, 100, 30)];
    rateLabel.text = @"Rate Meeowth";
    rateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    [_settingsBar addSubview:rateLabel];
    
    
    
    
    NSString *str = @"Meeowth \n Version 1.1  \n  \n Copyright (c) 2015 RDFZ ICC Modeling Club. All rights reserved.";
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - 95,150,100)];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.numberOfLines = 0; // 最关键的一句
    lb.text = str;
    lb.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [self.settingsBar addSubview:lb];
    //_aboutView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200, self.view.frame.size.height, 400, 300)];
    //self.view.frame.size.height/2 - 150
    //[self.view addSubview:_aboutView];
    //[button.layer setCornerRadius:15];
    //[button.layer setBorderColor:[[UIColor blackColor]CGColor]];
    //[button.layer setBorderWidth:1];
    
    [_listOfFileBar addSubview:button];
    [_listOfFileBar setBackgroundColor:[UIColor whiteColor]];
    [_listOfFileBar addSubview:historyLabel];
    [_listOfFileBar addSubview:_listOfFile];
    [self.view addSubview:_listOfFileBar];
    
    //set error report view
    _errorReportView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width,50)];
    _errorReportView.backgroundColor = [UIColor grayColor];
    _errorReportView.alpha = 0.4;
    _errorReportLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, _errorReportView.frame.size.width, _errorReportView.frame.size.height)];
    _errorReportLabel.textColor = [UIColor whiteColor];
    _errorReportLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:17];
    [self.scrollView addSubview:_errorReportView];
    [self.view insertSubview:_errorReportView aboveSubview:_scrollView];
    [_errorReportView addSubview:_errorReportLabel];
    [_errorReportView setAlpha:0.9];
    animationOfErrorMessageAvai = YES;

    
    //normal position:
    _mathKeyboardScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, self.navigationBar.frame.size.height,widthOfKeyboard , self.view.frame.size.height - self.navigationBar.frame.size.height)];
    _mathKeyboardScrollView.alpha = 0.9;
    [self.view addSubview:_mathKeyboardScrollView];
    [self.view insertSubview:_mathKeyboardScrollView aboveSubview:self.scrollView];
    _mathKeyboardScrollView.pagingEnabled = YES;
    
    
    
    //number keyboard
    _numberKeyboardScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, self.navigationBar.frame.size.height,(self.view.frame.size.height  - self.navigationBar.frame.size.height)/5 * 3 , self.view.frame.size.height  - self.navigationBar.frame.size.height)];
    _numberKeyboardScrollView.backgroundColor = [UIColor grayColor];
    
    _numberKeyboardScrollView.contentSize = CGSizeMake(widthOfKeyboard, self.view.frame.size.height - self.navigationBar.frame.size.height);
    _numberKeyboardScrollView.alpha = 0.9;
    [self.view addSubview:_numberKeyboardScrollView];
    [self.view insertSubview:_numberKeyboardScrollView aboveSubview:self.scrollView];
    _numberKeyboardScrollView.pagingEnabled = YES;
    
    
    _listOfFile.delegate = self;
    _listOfFile.dataSource = self;

    
    [self produceErrorMessage:@"Click the button on the upper right corner to creat a new module."];
    //app delegate
    
}

- (IBAction)newCreateButton:(UIBarButtonItem *)sender
{
    if (self.collectionOfOptions.frame.origin.x == self.view.frame.size.width) {
        widthOfKeyboard = (self.view.frame.size.height - self.navigationBar.frame.size.height)/4 * 3;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.collectionOfOptions.frame =CGRectMake(self.view.frame.size.width - widthOfKeyboard / 4 * 3, self.navigationBar.frame.size.height,widthOfKeyboard / 4 * 3 , self.view.frame.size.height - self.navigationBar.frame.size.height);
            
        }];
    }
    else
    {
        [self hideCollectionOfOptions];
    }


}

-(void)hideCollectionOfOptions
{
    widthOfKeyboard = (self.view.frame.size.height - self.navigationBar.frame.size.height)/4 * 3;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionOfOptions.frame =CGRectMake(self.view.frame.size.width, self.navigationBar.frame.size.height,widthOfKeyboard / 4 * 3 , self.view.frame.size.height - self.navigationBar.frame.size.height);
        
    }];
}



-(void)newBoardCreate
{
    [self save];
    [self removeAllModules];
    self.currentName = nil;
    [self hideListOfFile];
    [self updateContentOfFile];
    [self.listOfFile reloadData];
}


-(void)updateContentOfFile
{
    NSString * path = [NSTemporaryDirectory() stringByAppendingString:@"save.plist"] ;
    _contentOfFile = [[NSMutableArray alloc]initWithContentsOfFile:path];
}

- (IBAction)showFileList:(id)sender
{
    if (!listOfFileIsShowing) {
        listOfFileIsShowing = YES;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.scrollView.frame = CGRectMake(200, self.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationBar.frame.size.height);
            self.navigationBar.frame = CGRectMake(200, 0, self.view.frame.size.width, self.navigationBar.frame.size.height);
            self.settingsBar.frame = CGRectMake(-150, 0, 150, self.view.frame.size.height);
            _listOfFileBar.frame = CGRectMake(0, 0, 200, self.view.frame.size.height);
        } completion:^(BOOL complete){}];
    }
    else
    {
        [self hideListOfFile];
    }

}

-(void)hideListOfFile
{
    listOfFileIsShowing = NO;

    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.frame = CGRectMake(0, self.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationBar.frame.size.height);
        self.navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, self.navigationBar.frame.size.height);

        _listOfFileBar.frame = CGRectMake(-200, 0, 200,  self.view.frame.size.height);
        self.settingsBar.frame = CGRectMake(-350, 0, 150, self.view.frame.size.height);

    }];
}
-(void)showSettingBar
{
    if (_settingsBar.frame.origin.x + _settingsBar.frame.size.width > 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.scrollView.frame = CGRectMake(200, self.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationBar.frame.size.height);
            self.navigationBar.frame = CGRectMake(200, 0, self.view.frame.size.width, self.navigationBar.frame.size.height);
            self.settingsBar.frame = CGRectMake(-150, 0, 150, self.view.frame.size.height);
            _listOfFileBar.frame = CGRectMake(0, 0, 200, self.view.frame.size.height);
        } completion:^(BOOL complete){}];
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.scrollView.frame = CGRectMake(350, self.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationBar.frame.size.height);
            self.navigationBar.frame = CGRectMake(350, 0, self.view.frame.size.width, self.navigationBar.frame.size.height);
            self.settingsBar.frame = CGRectMake(0, 0, 150, self.view.frame.size.height);
            _listOfFileBar.frame = CGRectMake(150, 0, 200, self.view.frame.size.height);
        } completion:^(BOOL complete){}];
    }
}


- (void)newFunction:(id)sender
{
    [self generateNewFunctionAtPosition:CGPointMake(self.scrollView.contentOffset.x + 20, self.scrollView.contentOffset.y + 50)];
    [self hideCollectionOfOptions];
}
- (void)newGraph:(id)sender
{
    [self generateNewGraphAtPosition:CGPointMake(self.scrollView.contentOffset.x + 20, self.scrollView.contentOffset.y + 50)];
    [self hideCollectionOfOptions];
    [self produceErrorMessage:@"Connect a function to the graph to plot something."];
}
- (void)newThreeDPlot:(id)sender
{
    [self generateNewThreeDPloatAtPosition:CGPointMake(self.scrollView.contentOffset.x + 20, self.scrollView.contentOffset.y + 50)];
    [self hideCollectionOfOptions];
}

-(void)generateNewThreeDPloatAtPosition:(CGPoint)point
{
    OpenGLView *thisGraphView = [[OpenGLView alloc]initWithFrame:CGRectMake(point.x, point.y, 400,300)];
    thisGraphView.parent = self;
    [self.allModules addObject:thisGraphView];
    thisGraphView.moduleType = @"3d";
    thisGraphView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    thisGraphView.layer.borderWidth = 5;
    thisGraphView.layer.borderColor = [[UIColor clearColor]CGColor];
    thisGraphView.layer.cornerRadius = 10;
    thisGraphView.currentBorderColor = [[UIColor clearColor]CGColor];
    thisGraphView.layer.masksToBounds = YES;
    
    [self.scrollView addSubview:thisGraphView];
    [self.scrollView bringSubviewToFront:thisGraphView];
}

-(void)generateNewGraphAtPosition:(CGPoint)point
{
    Graph *thisGraphView = [[Graph alloc]init];
    thisGraphView.parent = self;
    [self.allModules addObject:thisGraphView];
    thisGraphView.moduleType = @"graph";
    thisGraphView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    thisGraphView.frame = CGRectMake(point.x, point.y, 400,300);
    thisGraphView.layer.borderWidth = 5;
    thisGraphView.layer.borderColor = [[UIColor clearColor]CGColor];
    thisGraphView.layer.cornerRadius = 10;
    thisGraphView.currentBorderColor = [[UIColor clearColor]CGColor];
    thisGraphView.layer.masksToBounds = YES;

    [self.scrollView addSubview:thisGraphView];
    [self.scrollView bringSubviewToFront:thisGraphView];

}
-(void)generateNewFunctionAtPosition:(CGPoint)point
{

    FunctionView *thisFunctionView = [[FunctionView alloc]init];
    thisFunctionView.parent = self;
    [self.allModules addObject:thisFunctionView];
    thisFunctionView.moduleType = @"function";
    thisFunctionView.frame = CGRectMake(point.x, point.y, 300,150);
    thisFunctionView.layer.borderWidth = 5;
    thisFunctionView.layer.borderColor = [[UIColor clearColor] CGColor];
    thisFunctionView.layer.cornerRadius = 10;
    thisFunctionView.currentBorderColor = [[UIColor clearColor]CGColor];
    [self.scrollView addSubview:thisFunctionView];
    thisFunctionView.backgroundColor = [UIColor colorWithRed:0.92 - 0.05859375 green:0.92 blue:0.92 alpha:1];
    thisFunctionView.layer.masksToBounds = YES;
    [self.scrollView bringSubviewToFront:thisFunctionView];
}


-(void)generateNewCalculationAtPosition:(CGPoint)point
{
    CalculationView *thisCalculation = [[CalculationView alloc]init];
    thisCalculation.parent = self;
    [self.allModules addObject:thisCalculation];
    thisCalculation.moduleType = @"calculation";
    thisCalculation.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 - 0.05859375 blue:0.92 alpha:1];
    thisCalculation.frame = CGRectMake(point.x, point.y, 300,150);
    thisCalculation.layer.borderWidth = 5;
    thisCalculation.layer.borderColor = [[UIColor clearColor] CGColor];
    thisCalculation.layer.cornerRadius = 10;
    thisCalculation.currentBorderColor = [[UIColor clearColor]CGColor];
    thisCalculation.layer.masksToBounds = YES;

    [self.scrollView addSubview:thisCalculation];
    [self.scrollView bringSubviewToFront:thisCalculation];
}

-(void)generateNewEquationAtPosition:(CGPoint)point
{
    
    EquationView *thisEquationView = [[EquationView alloc]init];
    thisEquationView.parent = self;
    [self.allModules addObject:thisEquationView];
    thisEquationView.moduleType = @"equation";
    thisEquationView.frame = CGRectMake(point.x, point.y, 300,150);
    thisEquationView.layer.borderWidth = 5;
    thisEquationView.layer.borderColor = [[UIColor clearColor] CGColor];
    thisEquationView.layer.cornerRadius = 10;
    thisEquationView.currentBorderColor = [[UIColor clearColor]CGColor];
    [self.scrollView addSubview:thisEquationView];
    thisEquationView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 - 0.05859375 alpha:1];
    thisEquationView.layer.masksToBounds = YES;
    [self.scrollView bringSubviewToFront:thisEquationView];

}
- (void)newCalculation:(id)sender
{
    [self generateNewCalculationAtPosition:CGPointMake(self.scrollView.contentOffset.x + 20, self.scrollView.contentOffset.y + 50)];
    [self hideCollectionOfOptions];
    
}
- (void)newEquation:(id)sender
{
    [self generateNewEquationAtPosition:CGPointMake(self.scrollView.contentOffset.x + 20, self.scrollView.contentOffset.y + 50)];
    [self hideCollectionOfOptions];
}


-(void)makeConnection:(id)view1 view2:(id)view2;
{
    if (![view1 isEqual:view2])
    {
        [view1 connectWith:view2];
    }

}



-(NSInteger)maxInNSNumbers:(NSMutableArray*)array
{
    NSInteger currentMax = [[array objectAtIndex:0]integerValue];
    for (NSInteger i = 1; i <= [array count] - 1; i += 1) {
        currentMax = MAX(currentMax, [[array objectAtIndex:i]integerValue]);
    }
    return currentMax;
}

-(void)addKeysToMathKeyboards:(NSMutableArray *)keys stringsProduced:(NSMutableArray *)stringsProduced numberEachColumn:(NSUInteger)numberEachColumn
{
    CGFloat cubeMag = widthOfKeyboard/6;
    NSUInteger numberCount = 0;
    while (numberCount < [keys count])
    {
        KeyButton *newButton = [[KeyButton alloc]initWithFrame:CGRectMake(cubeMag * ((numberCount - numberCount % numberEachColumn)/numberEachColumn),cubeMag*(numberCount % numberEachColumn), cubeMag, cubeMag)];
        [newButton setText:[keys objectAtIndex:numberCount]];
        newButton.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12];
        [newButton setTextProduce:[stringsProduced objectAtIndex:numberCount]];
        newButton.backgroundColor = [UIColor whiteColor];
        //test
        if ([[keys objectAtIndex:numberCount] isEqualToString:@"2nd"])
        {
            [newButton addTarget:self action:@selector(twoND) forControlEvents:UIControlEventTouchDown];
        }
        else
        {
            [newButton addTarget:self action:@selector(keyboardPressed:) forControlEvents:UIControlEventTouchDown];
        }
        [_mathKeyboardScrollView addSubview:newButton];
        newButton.layer.borderColor = [[UIColor blackColor]CGColor];
        newButton.layer.borderWidth = 1;
        
        if ((numberCount >= 4 && numberCount  <= 7) || (numberCount >=12 && numberCount <= 15) || (numberCount >= 20 && numberCount <= 23)) {
            newButton.backgroundColor = [UIColor whiteColor];
        }
        else if (numberCount >= 28 && numberCount <= 31)
        {
            newButton.backgroundColor = [UIColor orangeColor];
            newButton.textLabel.textColor = [UIColor whiteColor];
        }
        else if (numberCount == 0 || (numberCount >= 40 && numberCount <= 43))
        {
            newButton.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
        }
        else
        {
            newButton.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
        }
        if (numberCount >= 34 && numberCount<=39)
        {
            newButton.textLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:12];
        }
        //newButton.textLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:12];

        numberCount += 1;
    }
    
    //enter button
    KeyButton *newButton = [[KeyButton alloc]initWithFrame:CGRectMake(cubeMag * ((numberCount - numberCount % numberEachColumn)/numberEachColumn),cubeMag*(numberCount % numberEachColumn), cubeMag, 5*cubeMag)];
    newButton.layer.borderColor = [[UIColor blackColor]CGColor];
    newButton.layer.borderWidth = 1;
    [newButton setText:@"enter"];
    newButton.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12];
    
    newButton.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];

    [newButton addTarget:self action:@selector(enterButtonClicked) forControlEvents:UIControlEventTouchDown];
    [_mathKeyboardScrollView addSubview:newButton];

}

-(void)addKeysToNumberKeyboards:(NSMutableArray *)keys stringsProduced:(NSMutableArray *)stringsProduced numberEachColumn:(NSUInteger)numberEachColumn
{
    CGFloat cubeMag = self.numberKeyboardScrollView.frame.size.width/3;
    
    NSUInteger numberCount = 0;
    while (numberCount < [keys count])
    {
        KeyButton *newButton = [[KeyButton alloc]initWithFrame:CGRectMake(cubeMag* ((numberCount - numberCount % numberEachColumn)/numberEachColumn), cubeMag+cubeMag* (numberCount % numberEachColumn), cubeMag, cubeMag)];
        [newButton setText:[keys objectAtIndex:numberCount]];
        newButton.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12];
        
        [newButton setTextProduce:[stringsProduced objectAtIndex:numberCount]];
        newButton.backgroundColor = [UIColor whiteColor];
        [newButton addTarget:self action:@selector(keyboardPressed:) forControlEvents:UIControlEventTouchDown];
        newButton.layer.borderWidth = 1;
        newButton.layer.borderColor = [[UIColor blackColor]CGColor];
        //test
        [_numberKeyboardScrollView addSubview:newButton];
        numberCount += 1;
    }
    
    //enter button
    KeyButton *newButton = [[KeyButton alloc]initWithFrame:CGRectMake(0,0, cubeMag, cubeMag)];
    [newButton setText:@"enter"];
    newButton.titleLabel.font = [UIFont systemFontOfSize: 8.0];
        newButton.backgroundColor = [UIColor whiteColor];
    [newButton addTarget:self action:@selector(enterButtonClicked) forControlEvents:UIControlEventTouchDown];
    newButton.layer.borderWidth = 1;
    newButton.layer.borderColor = [[UIColor blackColor]CGColor];

    [_numberKeyboardScrollView addSubview:newButton];
    
    KeyButton *delButton =[[KeyButton alloc]initWithFrame:CGRectMake( cubeMag,0,2* cubeMag, cubeMag)];
    [delButton setText:@"DEL"];
    delButton.titleLabel.font = [UIFont systemFontOfSize: 8.0];
        delButton.backgroundColor = [UIColor whiteColor];
    [delButton addTarget:self action:@selector(keyboardPressed:) forControlEvents:UIControlEventTouchDown];
    delButton.layer.borderWidth = 1;
    delButton.layer.borderColor = [[UIColor blackColor]CGColor];

    [_numberKeyboardScrollView addSubview:delButton];
    
    
}

-(void)showKeyboardWithID:(NSString *)ID
{
    [self twoND];
    [self twoND];
    if ([ID isEqualToString:@"function"]) {
        [UIView animateWithDuration:0.3 animations:^{
            _mathKeyboardScrollView.frame =CGRectMake(self.view.frame.size.width - widthOfKeyboard, self.navigationBar.frame.size.height,widthOfKeyboard , self.view.frame.size.height - self.navigationBar.frame.size.height);
        }];
    }
    else if([ID isEqualToString:@"number"])
    {
        NSUInteger count = 0;
        while (count < [[_numberKeyboardScrollView subviews] count])
        {
            [[_numberKeyboardScrollView.subviews objectAtIndex:count] removeFromSuperview];
            count += 1;
        }
        [self addKeysToNumberKeyboards:@[@"7",@"4",@"1",@"-",@"8",@"5",@"2",@"0",@"9",@"6",@"3",@"."] stringsProduced:@[@"7",@"4",@"1",@"-",@"8",@"5",@"2",@"0",@"9",@"6",@"3",@"."] numberEachColumn:4];

        [UIView animateWithDuration:0.3 animations:^{
            _numberKeyboardScrollView.frame =CGRectMake(self.view.frame.size.width - (self.view.frame.size.height  - self.navigationBar.frame.size.height)/5 * 3, self.navigationBar.frame.size.height,(self.view.frame.size.height  - self.navigationBar.frame.size.height)/5 * 3 , self.view.frame.size.height  - self.navigationBar.frame.size.height);
        }];
    }
}

-(void)hideKeyboard
{
    [UIView animateWithDuration:0.3 animations:^{
        _mathKeyboardScrollView.frame =CGRectMake(self.view.frame.size.width, self.navigationBar.frame.size.height,widthOfKeyboard , self.view.frame.size.height - self.navigationBar.frame.size.height);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        _numberKeyboardScrollView.frame =CGRectMake(self.view.frame.size.width, self.navigationBar.frame.size.height,(self.view.frame.size.height  - self.navigationBar.frame.size.height)/5 * 3 , self.view.frame.size.height  - self.navigationBar.frame.size.height);
    }];
}

-(void)enterButtonClicked
{
    [self.fieldOnEdit resignFirstResponder];
    [self hideKeyboard];
}
-(void)twoND
{
    if(ifOriginalKeyboard)
    {
        ifOriginalKeyboard = NO;
        NSUInteger count = 0;
        while (count < [_mathKeyboardScrollView.subviews count])
        {
            [[self.mathKeyboardScrollView.subviews objectAtIndex:0] removeFromSuperview];
            count += 1;
        }
        [self addKeysToMathKeyboards:@[@"2nd",@"asin",@"acos",@"atan",@"7",@"4",@"1",@"0",@"^2",@"acsc",@"asec",@"acot",@"8",@"5",@"2",@".",@"sqrt",@"e",@"^",@"ln",@"9",@"6",@"3",@"*10^",@"log",@"log10",@"π",@"=",@"*",@"+",@"-",@"/",@"(",@")",@"x",@"y",@"z",@"a",@"b",@"c",@"DEL",@"AC",@","] stringsProduced:@[@"2nd",@"arcsin(",@"arccos(",@"arctan(",@"7",@"4",@"1",@"0",@"^2",@"arccsc(",@"arcsec(",@"arccot(",@"8",@"5",@"2",@".",@"sqrt(",@"e",@"^",@"ln(",@"9",@"6",@"3",@"*10^",@"log(",@"log10(",@"π",@"=",@"*",@"+",@"-",@"/",@"(",@")",@"x",@"y",@"z",@"a",@"b",@"c",@"DEL",@"AC",@","] numberEachColumn:8];
    }
    else
    {
        ifOriginalKeyboard = YES;
        NSUInteger count = 0;
        while (count < [_mathKeyboardScrollView.subviews count])
        {
            [[self.mathKeyboardScrollView.subviews objectAtIndex:0] removeFromSuperview];
            count += 1;
        }
            [self addKeysToMathKeyboards:@[@"2nd",@"sin",@"cos",@"tan",@"7",@"4",@"1",@"0",@"^2",@"csc",@"sec",@"cot",@"8",@"5",@"2",@".",@"sqrt",@"e",@"^",@"ln",@"9",@"6",@"3",@"*10^",@"log",@"log2",@"π",@"=",@"*",@"+",@"-",@"/",@"(",@")",@"x",@"y",@"z",@"a",@"b",@"c",@"DEL",@"AC",@","] stringsProduced:@[@"2nd(",@"sin(",@"cos(",@"tan(",@"7",@"4",@"1",@"0",@"^2",@"csc(",@"sec(",@"cot(",@"8",@"5",@"2",@".",@"sqrt(",@"e",@"^",@"ln(",@"9",@"6",@"3",@"*10^",@"log(",@"log2(",@"π",@"=",@"*",@"+",@"-",@"/",@"(",@")",@"x",@"y",@"z",@"a",@"b",@"c",@"DEL",@"AC",@","] numberEachColumn:8];
    }


}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)drawLine:(CGPoint)point1 point2:(CGPoint)point2
{
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [self.scrollView setPath:path];
}

-(UIView *)inWhichArea:(CGPoint)point
{
    for (UIView *view in self.allModules)
    {
        if (point.x > view.frame.origin.x && point.y > view.frame.origin.y && point.x < view.frame.origin.x + view.frame.size.width && point.y < view.frame.origin.y + view.frame.size.height)
        {
            return view;
        }
    }
    return nil;
}
-(void)touched;
{
    if (self.fieldOnEdit) {
        if ([self.fieldOnEdit isFirstResponder]) {
            [self.fieldOnEdit resignFirstResponder];
        }
    }
    if (self.normalTextFieldOnEdit) {
        if ([self.normalTextFieldOnEdit isFirstResponder]) {
            [self.normalTextFieldOnEdit resignFirstResponder];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.autoHiddenView.alpha = 0;
    }];
    self.autoHiddenView = nil;
    
    if (self.autoHiddenVariableView) {
        if (self.autoHiddenVariableView.availableForAutoHidden) {
            [self.autoHiddenVariableView updateVarList];
            self.autoHiddenVariableView = nil;
        }
        else
        {
            self.autoHiddenVariableView.availableForAutoHidden = YES;
        }

    }
    
    if (self.autoHiddenRangeView) {
        [self.autoHiddenRangeView showAllFunctionsButtonPressed];
        self.autoHiddenRangeView = nil;
    }
    if (listOfFileIsShowing)
    {
        [self hideListOfFile];
    }
    if (self.collectionOfOptions.frame.origin.x < self.view.frame.size.width) {
        [self hideCollectionOfOptions];
    }
    if (self.autoHiddenFunctionOptionsView) {
        [self.autoHiddenFunctionOptionsView optionsTapping];
        self.autoHiddenFunctionOptionsView = nil;
    }
}



-(void)keyboardPressed:(KeyButton *)sender
{

    if ([sender.textLabel.text  isEqualToString: @"DEL"]) {
        [self.fieldOnEdit deleteText];
    }
    else if ([sender.textLabel.text  isEqualToString: @"AC"])
    {
        [self.fieldOnEdit cleanText];
    }
    else
    {
        [self.fieldOnEdit changeText:sender.textProduce];
    }
    
}

//table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contentOfFile count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableSampleIdentifier];
    }
    else {
        while ([cell.contentView.subviews lastObject ]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    
    cell.textLabel.text = [[_contentOfFile objectAtIndex:indexPath.row] objectForKey:@"date"];
    return cell;
 }


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * path = [NSTemporaryDirectory() stringByAppendingString:@"save.plist"] ;
    NSMutableArray *currentContent = [[NSMutableArray alloc]initWithContentsOfFile:path];
    [self loadFromFile:[currentContent objectAtIndex:indexPath.row]];
    [self hideListOfFile];
}

-(void)save
{
    NSMutableArray *finalArray = [[NSMutableArray alloc]init];
    NSUInteger bigCount = 0;
    while (bigCount < [_allModules count]) {
        ModuleView *view = [_allModules objectAtIndex:bigCount];
        
        NSMutableDictionary *smallDictionary = [[NSMutableDictionary alloc]init];
        if ([[view moduleType] isEqualToString:@"function"])
        {
            FunctionView *thisView = view;
            [smallDictionary setValue:@"function" forKey:@"type"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.origin.x] forKey:@"x"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.origin.y] forKey:@"y"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.size.width] forKey:@"width"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.size.height] forKey:@"height"];
            if (thisView.formulaField.textInStructure && [thisView.formulaField.textInStructure count] != 0) {
                [smallDictionary setValue:thisView.formulaField.text forKey:@"functionString"];
                [smallDictionary setValue:thisView.formulaField.textInStructure forKey:@"functionInFormulaStructure"];
            }
            else
            {
                [smallDictionary setValue:@"" forKey:@"functionString"];
            }
            //[smallDictionary setValue:颜色 forKey:@"color"]

            [smallDictionary setValue:[thisView produceIndexOfGraphs] forKey:@"graphsConnected"];
            if ([[thisView functionColor] isEqual:[UIColor greenColor]]) {
                [smallDictionary setValue:@"green" forKey:@"color"];
            }
            else if ([[thisView functionColor] isEqual:[UIColor blueColor]]) {
                [smallDictionary setValue:@"blue" forKey:@"color"];
            }
            else if ([[thisView functionColor] isEqual:[UIColor blackColor]]) {
                [smallDictionary setValue:@"black" forKey:@"color"];
            }
            else if ([[thisView functionColor] isEqual:[UIColor grayColor]]) {
                [smallDictionary setValue:@"gray" forKey:@"color"];
            }
            else if ([[thisView functionColor] isEqual:[UIColor purpleColor]]) {
                [smallDictionary setValue:@"purple" forKey:@"color"];
            }
            else if ([[thisView functionColor] isEqual:[UIColor yellowColor]]) {
                [smallDictionary setValue:@"yellow" forKey:@"color"];
            }
            else if ([[thisView functionColor] isEqual:[UIColor redColor]]) {
                [smallDictionary setValue:@"red" forKey:@"color"];
            }
            else if ([[thisView functionColor] isEqual:[UIColor orangeColor]]) {
                [smallDictionary setValue:@"orange" forKey:@"color"];
            }

        }
        else if ([[view moduleType] isEqualToString:@"graph"])
        {
            Graph *thisView = view;
            [smallDictionary setValue:@"graph" forKey:@"type"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.origin.x] forKey:@"x"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.origin.y] forKey:@"y"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.size.width] forKey:@"width"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.size.height] forKey:@"height"];
            
            [smallDictionary setValue:[thisView produceIndexOfFunctions] forKey:@"functionsConnected"];
            
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.rangeStart] forKey:@"rangeStart"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.rangeEnd] forKey:@"rangeEnd"];
        }
        
        else if ([[view moduleType] isEqualToString:@"calculation"]) {
            CalculationView *thisView = view;
            [smallDictionary setValue:@"calculation" forKey:@"type"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.origin.x] forKey:@"x"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.origin.y] forKey:@"y"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.size.width] forKey:@"width"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.size.height] forKey:@"height"];
            if (thisView.formulaField.textInStructure && [thisView.formulaField.textInStructure count] != 0) {
                [smallDictionary setValue:thisView.formulaField.text forKey:@"functionString"];
                [smallDictionary setValue:thisView.formulaField.textInStructure forKey:@"functionInFormulaStructure"];
            }
            else
            {
                [smallDictionary setValue:@"" forKey:@"functionString"];
            }
            [smallDictionary setValue:thisView.dictionaryOfValues forKey:@"dictionaryOfValues"];
        }
        else if ([[view moduleType] isEqualToString:@"equation"])
        {
            EquationView *thisView = view;
            [smallDictionary setValue:@"equation" forKey:@"type"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.origin.x] forKey:@"x"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.origin.y] forKey:@"y"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.size.width] forKey:@"width"];
            [smallDictionary setValue:[NSNumber numberWithDouble:thisView.frame.size.height] forKey:@"height"];
            if (thisView.formulaField.textInStructure && [thisView.formulaField.textInStructure count] != 0) {
                [smallDictionary setValue:thisView.formulaField.text forKey:@"functionString"];
                [smallDictionary setValue:thisView.formulaField.textInStructure forKey:@"functionInFormulaStructure"];
            }
            else
            {
                [smallDictionary setValue:@"" forKey:@"functionString"];
            }
        }
        [finalArray addObject:smallDictionary];
        bigCount += 1;
    }
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *t2=[nsdf2 stringFromDate:[NSDate date]];
    NSString * path = [NSTemporaryDirectory() stringByAppendingString:@"save.plist"] ;
    NSArray *fileArray = [[NSMutableArray alloc]initWithContentsOfFile:path];
    NSMutableArray *writtenArray = [[NSMutableArray alloc]initWithContentsOfFile:path];
    
    if (!writtenArray)
    {
        writtenArray = [[NSMutableArray alloc]init];
    }
    NSUInteger index = 0;
    if (_currentName)
    {
        NSUInteger count = 0;
        while (count < [writtenArray count]) {
            NSDictionary* dic = [writtenArray objectAtIndex:count];
            if ([[dic objectForKey:@"date"] isEqualToString:_currentName]) {
                index = [writtenArray indexOfObject:dic];
                [writtenArray removeObject:dic];
                break;
            }
            else
            {
                count += 1;
            }
        }
    }
    else
    {
        _currentName = t2;
    }
    NSDictionary *thisDictioanry = [[NSMutableDictionary alloc]initWithObjects:@[_currentName,finalArray] forKeys:@[@"date",@"content"]];
    if ([finalArray count] != 0)
    {
        [writtenArray insertObject:thisDictioanry atIndex:index];

    }
    [self createManageDocumentForRewriting:writtenArray];
    [self updateContentOfFile];
    [self.listOfFile reloadData];
}

//file operation
-(void)createManageDocumentForRewriting:(NSMutableArray *)listToWrite
{
    NSString * path = [NSTemporaryDirectory() stringByAppendingString:@"save.plist"] ;
    NSFileManager * aFileManager = [NSFileManager defaultManager];
    if (![aFileManager fileExistsAtPath:path])
    {
        NSMutableDictionary * aDefaultDict = [[NSMutableDictionary alloc] init];
        if (![aDefaultDict writeToFile:path atomically:YES]) {
        }
    }
    if (![listToWrite writeToFile:path atomically:YES]) {
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString * path = [NSTemporaryDirectory() stringByAppendingString:@"save.plist"] ;
        NSMutableArray *currentContent = [[NSMutableArray alloc]initWithContentsOfFile:path];
        [currentContent removeObjectAtIndex:indexPath.row];
        [self createManageDocumentForRewriting:currentContent];
        [self.contentOfFile removeObjectAtIndex:indexPath.row];
        [self.listOfFile reloadData];
    }
}

-(void)loadFromFile:(NSDictionary *)file
{
    if (![_currentName isEqualToString:[file objectForKey:@"date"]]) {
        [self save];
        [self removeAllModules];
        self.currentName = [file objectForKey:@"date"];
        [self.titleItem setTitle:_currentName];
        int count = 0;
        NSMutableArray *content = [file objectForKey:@"content"];
        for (count = 0;count < [content count];count += 1)
        {
            NSDictionary *thisdict = [content objectAtIndex:count];
            if ([[thisdict objectForKey:@"type"] isEqualToString:@"function"]) {
                [self generateNewFunctionAtPosition:CGPointMake([[thisdict objectForKey:@"x"] floatValue], [[thisdict objectForKey:@"y"]floatValue])];
                FunctionView *this = [[self allModules] objectAtIndex:count];
                [this setNeedsDisplay];
                [this setFrame:CGRectMake([[thisdict objectForKey:@"x"] floatValue],[[thisdict objectForKey:@"y"] floatValue],[[thisdict objectForKey:@"width"] floatValue],[[thisdict objectForKey:@"height"] floatValue])];
                [this setThisFunction:[[Functions alloc]initWithFunction:[thisdict objectForKey:@"functionString"] varList:@[@"x",@"y",@"z",@"a",@"b",@"c"]]];
                [[this formulaField] setTextWithArray:[thisdict objectForKey:@"functionInFormulaStructure"]];
                if ([[thisdict objectForKey:@"color"] isEqualToString:@"black"])
                {
                    [this setFunctionViewColor:[UIColor blackColor]];
                }
                if ([[thisdict objectForKey:@"color"] isEqualToString:@"blue"])
                {
                    [this setFunctionViewColor:[UIColor blueColor]];
                }
                if ([[thisdict objectForKey:@"color"] isEqualToString:@"orange"])
                {
                    [this setFunctionViewColor:[UIColor orangeColor]];
                }
                if ([[thisdict objectForKey:@"color"] isEqualToString:@"gray"])
                {
                    [this setFunctionViewColor:[UIColor grayColor]];
                }
                if ([[thisdict objectForKey:@"color"] isEqualToString:@"green"])
                {
                    [this setFunctionViewColor:[UIColor greenColor]];
                }
                if ([[thisdict objectForKey:@"color"] isEqualToString:@"purple"])
                {
                    [this setFunctionViewColor:[UIColor purpleColor]];
                }
                if ([[thisdict objectForKey:@"color"] isEqualToString:@"red"])
                {
                    [this setFunctionViewColor:[UIColor redColor]];
                }
                if ([[thisdict objectForKey:@"color"] isEqualToString:@"yellow"])
                {
                    [this setFunctionViewColor:[UIColor yellowColor]];
                }
                [this setWebView];
            }
            else if ([[thisdict objectForKey:@"type"] isEqualToString:@"calculation"]) {
                [self generateNewCalculationAtPosition:CGPointMake([[thisdict objectForKey:@"x"] floatValue], [[thisdict objectForKey:@"y"]floatValue])];
                CalculationView *this = [[self allModules] objectAtIndex:count];
                [this setFrame:CGRectMake([[thisdict objectForKey:@"x"] floatValue],[[thisdict objectForKey:@"y"] floatValue],[[thisdict objectForKey:@"width"] floatValue],[[thisdict objectForKey:@"height"] floatValue])];
                if (![[thisdict objectForKey:@"functionString"]  isEqualToString:@""])
                {
                    [this setThisFunction:[[Functions alloc]initWithFunction:[thisdict objectForKey:@"functionString"] varList:@[@"x",@"y",@"z",@"a",@"b",@"c"]]];
                    [[this formulaField] setTextWithArray:[thisdict objectForKey:@"functionInFormulaStructure"]];
                }
                [this updateVarList];
            }
            else if ([[thisdict objectForKey:@"type"] isEqualToString:@"graph"])
            {
                [self generateNewGraphAtPosition:CGPointMake([[thisdict objectForKey:@"x"] floatValue], [[thisdict objectForKey:@"y"]floatValue])];
                Graph *this = [[self allModules] objectAtIndex:count];
                [this setFrame:CGRectMake([[thisdict objectForKey:@"x"] floatValue],[[thisdict objectForKey:@"y"] floatValue],[[thisdict objectForKey:@"width"] floatValue],[[thisdict objectForKey:@"height"] floatValue])];
                this.rangeStart = [[thisdict objectForKey:@"rangeStart"] doubleValue];
                this.rangeEnd = [[thisdict objectForKey:@"rangeEnd"] doubleValue];
                [this setNeedsDisplay];
            }
            else if ([[thisdict objectForKey:@"type"] isEqualToString:@"equation"]) {
                [self generateNewEquationAtPosition:CGPointMake([[thisdict objectForKey:@"x"] floatValue], [[thisdict objectForKey:@"y"]floatValue])];
                EquationView *this = [[self allModules] objectAtIndex:count];
                [this setFrame:CGRectMake([[thisdict objectForKey:@"x"] floatValue],[[thisdict objectForKey:@"y"] floatValue],[[thisdict objectForKey:@"width"] floatValue],[[thisdict objectForKey:@"height"] floatValue])];
                [this setThisFunction:[[Functions alloc]initWithFunction:[thisdict objectForKey:@"functionString"] varList:@[@"x",@"y",@"z",@"a",@"b",@"c"]]];
                [[this formulaField] setTextWithArray:[thisdict objectForKey:@"functionInFormulaStructure"]];
                [this solve];
            }
        }
        //add connection
        for (count = 0;count < [content count];count += 1)
        {
            NSDictionary *thisdict = [content objectAtIndex:count];
            if ([[thisdict objectForKey:@"type"] isEqualToString:@"function"]) {
                FunctionView *thisView = [_allModules objectAtIndex:count];
                for (NSNumber *number in [thisdict objectForKey:@"graphsConnected"]) {
                    [[thisView graphsConnected] addObject:[_allModules objectAtIndex:[number integerValue]]];
                }
            }
            else if ([[thisdict objectForKey:@"type"] isEqualToString:@"graph"])
            {
                Graph *thisView = [_allModules objectAtIndex:count];
                for (NSNumber *number in [thisdict objectForKey:@"functionsConnected"]) {
                    [[thisView functionsConnected] addObject:[_allModules objectAtIndex:[number integerValue]]];
                }
                [thisView setNeedsDisplay];
            }
        }
    }
    [self updateContentOfFile];
    [self.listOfFile reloadData];
}

-(void)removeAllModules
{
    NSUInteger count = 0;
    while (count < [_allModules count])
    {
        [[_allModules objectAtIndex:count] removeFromSuperview];
        ModuleView *view = [_allModules objectAtIndex:count];
        [view selfDeletion];
    }
    [_allModules removeAllObjects];
    count = 0;
    while (count < [_inConnectedViews count])
    {
        UIView *view = [_inConnectedViews objectAtIndex:count];
        [view removeFromSuperview];
    }
    [_inConnectedViews removeAllObjects];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)produceErrorMessage:(NSString *)message
{
    _errorReportLabel.text = message;
    if (animationOfErrorMessageAvai) {
        animationOfErrorMessageAvai = NO;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{        _errorReportView.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width,50);
        } completion:^(BOOL finished){}];
        [UIView animateWithDuration:0.5 delay:4.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{        _errorReportView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width,50);
        } completion:^(BOOL finished){        animationOfErrorMessageAvai = YES;}];
    }
}

//email
- (void)businessContactWithMail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            [picker setToRecipients:[NSArray arrayWithObject:@"meeowthofficial@126.com"]];
            [picker setSubject:[NSString stringWithFormat:@""]];
            
            
            NSString *content=[NSString stringWithFormat:@""];
            [picker setMessageBody:content isHTML:NO];
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
        else
        {
            [self produceErrorMessage:@"Your device is not capable of sending emails"];
        }
    } else {
        [self produceErrorMessage:@"Your device is not capable of sending emails"];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    listOfFileIsShowing = NO;
    self.scrollView.frame = CGRectMake(0, self.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationBar.frame.size.height);
    self.navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, self.navigationBar.frame.size.height);
    _listOfFileBar.frame = CGRectMake(-200, 0, 200,  self.view.frame.size.height);
    self.settingsBar.frame = CGRectMake(-350, 0, 150, self.view.frame.size.height);
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)goToReview
{
    NSString *evaluateString = [NSString stringWithFormat:@"itms://itunes.apple.com/gb/app/meeowth/id1019375424?l=en&mt=8"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
    
}
@end
