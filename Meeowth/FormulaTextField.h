//
//  FormulaTextField.h
//  MathGUI
//
//  Created by Kaige Liu on 5/27/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormulaTextField : UITextField
@property (retain,nonatomic) NSMutableArray* textInStructure;
@property (retain,nonatomic) NSMutableArray *countArray;

- (NSRange) selectedRange;
-(void)changeText:(NSString *)addText;
-(void)deleteText;
-(void)cleanText;
-(void)mySetText:(NSString *)text;
-(void)setTextWithArray:(NSArray *)array;
@end
