//
//  FormulaTextField.m
//  MathGUI
//
//  Created by Kaige Liu on 5/27/15.
//  Copyright (c) 2015 Dustin Liu. All rights reserved.
//

#import "FormulaTextField.h"

@implementation FormulaTextField
//-(void)
-(id)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame];
}

- (NSRange) selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}


-(void)changeText:(NSString *)addText
{
    if (!_textInStructure) {
        self.textInStructure = [[NSMutableArray alloc]init];

    }
    if (!_countArray) {
        self.countArray = [[NSMutableArray alloc]init];

    }
    
    
    
    NSRange currentRange =[self selectedRange];
    if (currentRange.length == 0)
    {
        NSArray *position = [self positionOfShine:currentRange.location];
        if ([[position objectAtIndex:1]integerValue] == 2) {
            [self addThingAtIndex:addText atIndex:[[position objectAtIndex:0] integerValue] + 1];
        }
        else
        {
            [self.textInStructure setObject:addText atIndexedSubscript:[[position objectAtIndex:0]integerValue]];
            [self.countArray setObject:[NSNumber numberWithInteger:[addText length]] atIndexedSubscript:[[position objectAtIndex:0]integerValue]];
            [self updateText];
        }
    }
    
}

-(void)deleteText
{
    if (_textInStructure) {
        if ([_textInStructure count] != 0) {
            NSRange currentRange =[self selectedRange];
            if (currentRange.length == 0)
            {
                NSArray *position = [self positionOfShine:currentRange.location];
                if ([[position objectAtIndex:1]integerValue] == 2) {
                    [self removeThingAtIndex:[[position objectAtIndex:0] integerValue]];
                }
                else
                {
                    [self removeThingAtIndex:[[position objectAtIndex:0] integerValue] - 1];
                }
            }
        }
    }
}

-(void)cleanText
{
    self.textInStructure = [[NSMutableArray alloc]init];
    self.countArray = [[NSMutableArray alloc]init];
    self.text = @"";
}

-(void)addThingAtIndex:(NSString *)thing atIndex:(NSUInteger)index
{
    if (index != 0) {
        NSString *lastString =  [self.textInStructure objectAtIndex:index - 1];
        if (self.textInStructure) {
            if ([self ifNumeric:lastString]) {
                if (!([self ifNumeric:thing] || [thing isEqualToString:@")" ] || [@[@"*",@"/",@"+",@"-",@"^",@"^2",@"*10^",@".",@"=",@","]  containsObject:thing])) {
                    [self.textInStructure insertObject:@"*" atIndex:index];
                    [self.countArray insertObject:@1 atIndex:index];
                    index += 1;
                }
            }

            else if ([@[@"x",@"y",@"z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"j",@"i",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"o",@"p",@"w",@"π",@")"] containsObject:lastString])
            {
                if (!([thing isEqualToString:@")" ] || [@[@"*",@"/",@"+",@"-",@"^",@"^2",@"*10^",@".",@"=",@","]  containsObject:thing])) {
                    [self.textInStructure insertObject:@"*" atIndex:index];
                    [self.countArray insertObject:@1 atIndex:index];
                    index += 1;
                }
            }
        }
    }
    [self.textInStructure insertObject:thing atIndex:index];
    [self.countArray insertObject:[NSNumber numberWithInteger:[thing length]] atIndex:index];
    [self updateText];
    int total = 0;
    for (int i = 0; i <= index; i+=1) {
        total += [[_countArray objectAtIndex:i] integerValue];
    }
    [self setSelectedRange:NSMakeRange(total, 0)];
}

-(void)removeThingAtIndex:(NSUInteger)index
{
    [self.textInStructure removeObjectAtIndex: index];
    [self.countArray removeObjectAtIndex: index];
    [self updateText];
    if (index != 0) {
        int total = 0;
        for (int i = 0; i <= index - 1; i+=1) {
            total += [[_countArray objectAtIndex:i] integerValue];
        }
        
        [self setSelectedRange:NSMakeRange(total, 0)];
    }
    else
    {
        [self setSelectedRange:NSMakeRange(0, 0)];

    }

}
-(void)updateText
{
    NSMutableString *result = [[NSMutableString alloc]initWithString:@""];
    for (NSString *eachString in self.textInStructure) {
        [result appendString:eachString];
    }
    self.text = result;
}

-(NSArray *)positionOfShine:(int)Position
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    int ifBetween = 2;
    int currentPosition = 0;
    NSUInteger i = 0;
    int iterCount = 0;
    if (Position == 0) {
        ifBetween = 2;
    }
    else
    {
        for (i = 0;i < [self.countArray count];i += 1) {
            iterCount += 1;
            NSNumber *eachLength = [self.countArray objectAtIndex:i];
            currentPosition += [eachLength integerValue];
            if (currentPosition >= Position)
            {
                if (currentPosition == Position)
                {
                    ifBetween = 2;
                }
                else
                {
                    ifBetween = 1;
                }
                break;
            }
        }
    }
    
    if (iterCount == 0) {
        [result addObject:[NSNumber numberWithInt:-1]];
    }
    else
    {
        [result addObject:[NSNumber numberWithInt:i]];
    }
    [result addObject:[NSNumber numberWithInt:ifBetween]];

    return  result;
}

- (void) setSelectedRange:(NSRange) range
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:)) return NO;
    if (action == @selector(select:)) return NO;
    if (action == @selector(selectAll:)) return NO;
    return [super canPerformAction:action withSender:sender];
}

-(void)mySetText:(NSString *)text
{
    _textInStructure = [[NSMutableArray alloc]init];
    _countArray = [[NSMutableArray alloc]init];
    int i = 0;
    for (i = 0; i < [text length]; i += 1) {
        [_textInStructure addObject:[text substringWithRange:NSMakeRange(i, 1)]];
        [_countArray addObject:@1];
    }
    [self setText:text];
}
-(void)setTextWithArray:(NSArray *)array
{
    self.textInStructure = [[NSMutableArray alloc]initWithArray:array];
    _countArray= [[NSMutableArray alloc]init];
    for (NSString *string in array) {
        [_countArray addObject:[NSNumber numberWithInteger:[string length]]];
    }
    [self updateText];
}


-(BOOL)ifNumeric:(NSString *)string
{
    if ([string isEqualToString:@"0"] || [string isEqualToString:@"1"] ||[string isEqualToString:@"2"] ||[string isEqualToString:@"3"] ||[string isEqualToString:@"5"] ||[string isEqualToString:@"7"] ||[string isEqualToString:@"4"] ||[string isEqualToString:@"6"] ||[string isEqualToString:@"8"] ||[string isEqualToString:@"9"] )
    {
        return true;
    }
    else{
        return false;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
