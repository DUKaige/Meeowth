//
// Created by mac on 15/5/22.
// Copyright (c) 2015 mac. All rights reserved.
//

import Foundation

class Functions: NSObject {
    var functionStructure: [AnyObject] = []
    var varList: [String] = []
    var initialVarlist: [String] = []
    var functionString: String = ""
    var ifPolynomial:Bool = true
    var valid:Bool = true
    var polynomialStructure:[Double] = []
    init(function: String, varList: [String]) {
        super.init()
        self.initialVarlist = varList
        self.functionString = function
        let numericJdgCount = count((function as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet()));
        
        if function.isEmpty {
            self.functionStructure = []
        }
        else if inhere(self.initialVarlist, function){
            self.functionStructure = ["product", 1, function]
            self.varList.append(function)
        }
        else if numericJdgCount == 0
        {
            self.functionStructure = ["add",(function as NSString).doubleValue,0]
        }
        else if numericJdgCount == 1 && (function as NSString).rangeOfString(".").location != NSNotFound
        {
            self.functionStructure = ["add",(function as NSString).doubleValue,0]

        }
        else {
            if cleanAllSpaces(function) != ""
            {
                var result: AnyObject = produceFunctionStrcture(function, varList:varList)
                if result as? [AnyObject] != nil{
                    self.functionStructure = result as! [AnyObject]
                }
                else
                {
                    self.functionStructure = ["add",result,0];
                }
            }
        }
        if valid
        {
            if self.functionStructure.count != 0
            {
                self.polynomialStructure = self.producePolynomialStructure(self.reduceSymbolically(self.removeAllEAndPis(self.functionStructure)))
                println(self.polynomialStructure)
            }
            else
            {
                self.polynomialStructure = []
            }
            
        }
        println(self.functionStructure)

    }
    
    
    func produceFunctionStrcture(st:String,varList:[String])->AnyObject
    {
        var stringOfFunction = cleanAllSpaces(st)
        if ifContain(stringOfFunction,initialVarlist)
        {
            if !ifContain(stringOfFunction, self.varList)
            {
                self.varList.append(stringOfFunction)
            }
            return stringOfFunction
        }
        if ifContain(stringOfFunction,["e","π"])
        {
            return stringOfFunction
        }
        
        let numericJdgCount = count((stringOfFunction as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet()));
        if numericJdgCount == 0
        {
            return (stringOfFunction as NSString).doubleValue
        }
        else if numericJdgCount == 1
        {
            if (stringOfFunction as NSString).rangeOfString(".").location != NSNotFound
            {
                return (stringOfFunction as NSString).doubleValue
            }
        }
        
        if characterAtIndex(stringOfFunction, 0) == "+"  || characterAtIndex(stringOfFunction, 0) == "*" || characterAtIndex(stringOfFunction, 0) == "/" || characterAtIndex(stringOfFunction, 0) == "^"
        {
            self.valid = false
            return []
        }
        
        let lengthOfFunction = count(stringOfFunction)
        var i = 0
        var quoteCount = 0
        var quoteRecord:[Int] = []
        while i < count(stringOfFunction)
        {
            var thisChar = characterAtIndex(stringOfFunction, i)
            if thisChar == "("
            {
                quoteCount += 1
            }
            else if thisChar == ")"
            {
                quoteCount -= 1
            }
            quoteRecord.append(quoteCount)
            i += 1
        }
        if quoteCount != 0
        {
            self.valid = false
            return []
        }
        
        let maxQuoteNumber = maxInArray(quoteRecord)
        var thisQuoteNumber = 0
        while thisQuoteNumber <= maxQuoteNumber
        {
            //find positions of + -
            i = 0
            var positions:[Int] = []
            var plusOrMinus:[Int] = []
            while i < count(stringOfFunction)
            {
                if quoteRecord[i] == thisQuoteNumber && characterAtIndex(stringOfFunction, i) == "+"
                {
                    positions.append(i)
                    plusOrMinus.append(1)
                }
                else if quoteRecord[i] == thisQuoteNumber && characterAtIndex(stringOfFunction, i) == "-"
                {
                    if i != 0
                    {
                        positions.append(i)
                        plusOrMinus.append(0)
                    }
                    else
                    {
                        return["neg",produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(1, lengthOfFunction - 1)),varList: varList)]
                    }
                }
                i += 1
            }
            
            
            
            if count(positions) > 0
            {
                var resultList:[AnyObject] = ["add"]
                i = 0
                
                resultList.append(produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(0, positions[i] )),varList: varList))
                
                
                while i < count(positions)
                {
                    
                    if i == count(positions) - 1
                    {
                        if plusOrMinus[i] == 1
                        {
                            resultList.append(produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(positions[i] + 1, count(stringOfFunction) - positions[i] - 1)),varList: varList))
                            
                        }
                        else
                        {
                            resultList.append(["neg",produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(positions[i] + 1, count(stringOfFunction) - positions[i] - 1)),varList: varList)])
                            
                        }
                    }
                        
                    else
                    {
                        if plusOrMinus[i] == 1
                        {
                            resultList.append(produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(positions[i] + 1, positions[i + 1] - positions[i] - 1 )),varList: varList))
                        }
                        else
                        {
                            resultList.append(["neg",produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(positions[i] + 1, positions[i + 1] - positions[i] - 1 )),varList: varList)])
                            
                        }
                    }
                    i += 1
                }
                
                
                if (count(resultList) > 0)
                {
                    return resultList
                }
            }
            
            
            
            
            i = 0
            positions = []
            plusOrMinus = []
            while i < count(stringOfFunction)
            {
                if quoteRecord[i] == thisQuoteNumber && characterAtIndex(stringOfFunction, i) == "*"
                {
                    positions.append(i)
                    plusOrMinus.append(1)
                }
                else if quoteRecord[i] == thisQuoteNumber && characterAtIndex(stringOfFunction, i) == "/"
                {
                    positions.append(i)
                    plusOrMinus.append(0)
                }
                i += 1
            }
            
            if count(positions) > 0
            {
                var resultList:[AnyObject] = ["product"]
                i = 0
                resultList.append(produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(0, positions[i] )),varList: varList))
                
                while i < count(positions)
                {
                    
                    if i == count(positions) - 1
                    {
                        if plusOrMinus[i] == 1
                        {
                            resultList.append(produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(positions[i] + 1, count(stringOfFunction) - positions[i] - 1)),varList: varList))
                            
                        }
                        else
                        {
                            resultList.append(["rev",produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(positions[i] + 1, count(stringOfFunction) - positions[i] - 1)),varList: varList)])
                            
                        }
                    }
                        
                    else
                    {
                        if plusOrMinus[i] == 1
                        {
                            resultList.append(produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(positions[i] + 1, positions[i + 1] - positions[i] - 1 )),varList: varList))
                        }
                        else
                        {
                            resultList.append(["rev",produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(positions[i] + 1, positions[i + 1] - positions[i] - 1 )),varList: varList)])
                            
                        }
                    }
                    i += 1
                }
                
                
                
                if (count(resultList) > 0)
                {
                    return resultList
                }
            }
            
            
            i = 0
            //pow
            
            while i < count(stringOfFunction)
            {
                if quoteRecord[i] == thisQuoteNumber && characterAtIndex(stringOfFunction, i) == "^"
                {
                    return ["pow",produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(0, i)),varList: varList),produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(i + 1,lengthOfFunction - i - 1)),varList: varList)]
                }
                i += 1
            }
            positions = findPositionsOfOuterQuotes(stringOfFunction)
            if positions[0] == 0 && (positions[0] != 0 || positions[1] != 0)
            {
                stringOfFunction = removeOuterQuotes(stringOfFunction)
                return produceFunctionStrcture(stringOfFunction, varList: varList)
            }
            else if positions[0] != 0
            {
                var returnList:[AnyObject] = [(stringOfFunction as NSString).substringWithRange(NSMakeRange(0, positions[0]))]
                var correctParaCount = 0
                if returnList[0] as! String == "pow" || returnList[0] as! String == "log"
                {
                    correctParaCount = 2
                }
                else if ifContain(returnList[0] as! String, ["sin","cos","tan","csc","sec","cot","arcsin","arccos","arctan","arccsc","arcsec","arccot","log10","log2","ln","sqrt"])
                {
                    correctParaCount = 1
                }
                var lastCommaPosition = positions[0]
                i = positions[0] + 1
                var currentNumberOfVara = 0
                while i < lengthOfFunction - 1
                {
                    if characterAtIndex(stringOfFunction, i) == ","
                    {
                        currentNumberOfVara += 1
                        returnList.append(produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(lastCommaPosition + 1, i - lastCommaPosition - 1)),varList: varList))
                        lastCommaPosition = i
                    }
                    i += 1
                }
                if currentNumberOfVara + 1 != correctParaCount
                {
                    self.valid = false
                }
                returnList.append(produceFunctionStrcture((stringOfFunction as NSString).substringWithRange(NSMakeRange(lastCommaPosition + 1, lengthOfFunction - lastCommaPosition - 2)),varList: varList))
                return returnList
            }
            else
            {
                self.valid = false
                return []
            }
        }
        self.valid = false
        return []
    }

    
    
    
    func substitudeValue (this: [AnyObject], that: [String: Double]) -> [AnyObject] {
        var varList = that
        varList["π"] = M_PI
        varList["e"] = M_E
        var expr = this
        var exprcopy = expr
        exprcopy.removeAtIndex(0)
        
        for i in exprcopy {
            if ifArray(i) {
                if ((i as! [AnyObject]).count == 1) && (varList[(i as! [AnyObject])[0] as! String] != nil) {
                    expr[(expr as NSArray).indexOfObject(i)] = [varList[(i as! [AnyObject])[0] as! String] as! AnyObject]
                }
                else {
                    expr[(expr as NSArray).indexOfObject(i)] = substitudeValue((i as! [AnyObject]), that: varList)
                }
            }
            else {
                for j in exprcopy {
                    if ifArray(j) {
                        exprcopy[(exprcopy as NSArray).indexOfObject(j)] = substitudeValue((j as! [AnyObject]), that: varList)
                    }
                    else {
                        if j is String {
                            exprcopy[(exprcopy as NSArray).indexOfObject(j)] = varList[j as! String] as! AnyObject
                        }
                    }
                }
                exprcopy.insert(expr[0], atIndex: 0)
                return exprcopy
            }
        }
        return expr
    }
    
    
    func produceValueFromStructureAlgo (this: [AnyObject], varList: [String: Double]) -> Double {
        var expr = substitudeValue(this, that: varList)
        for i in expr {
            if i is String {
                if i as! String == "add" {
                    var resultValue: Double = 0.0
                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
                        resultValue += produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList)
                    }
                    else {
                        resultValue += expr[(expr as NSArray).indexOfObject(i) + 1] as! Double
                    }
                    var exprCopy = expr
                    exprCopy.removeAtIndex(1)
                    if exprCopy.count == 2 {
                        if exprCopy[1] is Double {
                            resultValue += exprCopy[1] as! Double
                        }
                        else {
                            resultValue += produceValueFromStructureAlgo(exprCopy[1] as! [AnyObject], varList: varList)
                        }
                    }
                    else {
                        resultValue += produceValueFromStructureAlgo(exprCopy, varList: varList)
                    }
                    return resultValue
                }
                else if i as! String == "product" {
                    var resultValue: Double = 1.0
                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
                        resultValue *= produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList)
                    }
                    else {
                        resultValue *= expr[(expr as NSArray).indexOfObject(i) + 1] as! Double
                    }
                    var exprCopy = expr
                    exprCopy.removeAtIndex(1)
                    if exprCopy.count == 2 {
                        if exprCopy[1] is Double {
                            resultValue *= exprCopy[1] as! Double
                        }
                        else {
                            resultValue *= produceValueFromStructureAlgo(exprCopy[1] as! [AnyObject], varList: varList)
                        }
                    }
                    else {
                        resultValue *= produceValueFromStructureAlgo(exprCopy, varList: varList)
                    }
                    return resultValue
                }
                else if inhere(Array(operationDict.keys) as [AnyObject], (i as! String)) {
                    var result = 0.0
                    var next: AnyObject     = expr[(expr as NSArray).indexOfObject(i) + 1]
                    if ifArray(next) {
                        result = operationDict[i as! String]!(produceValueFromStructureAlgo(next as! [AnyObject], varList: varList))
                    }
                    else {
                        result = operationDict[i as! String]!(next as! Double)
                    }
                    return result
                }
                else if i as! String == "log" {
                    var result = 0.0
                    var next: AnyObject = expr[(expr as NSArray).indexOfObject(i) + 1]
                    var nextNext: AnyObject = expr[(expr as NSArray).indexOfObject(i) + 2]
                    if ifArray(next) && ifArray(nextNext) {
                        result = log(produceValueFromStructureAlgo(next as! [AnyObject], varList: varList), produceValueFromStructureAlgo(nextNext as! [AnyObject], varList: varList))
                    }
                    else if ifArray(next) && !(ifArray(nextNext)) {
                        result = log(produceValueFromStructureAlgo(next as! [AnyObject], varList: varList), nextNext as! Double)
                    }
                    else if !(ifArray(next)) && ifArray(nextNext) {
                        result = log(next as! Double, produceValueFromStructureAlgo(nextNext as! [AnyObject], varList: varList))
                    }
                    else if !(ifArray(next)) && !(ifArray(nextNext)) {
                        result = log(next as! Double, nextNext as! Double)
                    }
                    return result
                }
                else if i as! String == "pow" {
                    var result = 0.0
                    var next: AnyObject = expr[(expr as NSArray).indexOfObject(i) + 1]
                    var nextNext: AnyObject = expr[(expr as NSArray).indexOfObject(i) + 2]
                    if ifArray(next) && ifArray(nextNext) {
                        result = pow(produceValueFromStructureAlgo(next as! [AnyObject], varList: varList), produceValueFromStructureAlgo(nextNext as! [AnyObject], varList: varList))
                    }
                    else if ifArray(next) && !(ifArray(nextNext)) {
                        result = pow(produceValueFromStructureAlgo(next as! [AnyObject], varList: varList), nextNext as! Double)
                    }
                    else if !(ifArray(next)) && ifArray(nextNext) {
                        result = pow(next as! Double, produceValueFromStructureAlgo(nextNext as! [AnyObject], varList: varList))
                    }
                    else if !(ifArray(next)) && !(ifArray(nextNext)) {
                        result = pow(next as! Double, nextNext as! Double)
                    }
                    return result
                }
            }
            else {
                return expr[0] as! Double
            }
        }
        return Double(IntMax())
    }
    
    func derivAlgo (this: [AnyObject], vari: String) -> AnyObject {
        
        var expr = this
        
        if expr[0] is String && expr[0] as! String == "add" {
            
            var exprCopy = expr
            
            exprCopy.removeAtIndex(0)
            
            for i in exprCopy {
                
                if ifArray(i) {
                    
                    expr[(expr as NSArray).indexOfObject(i)] = derivAlgo(i as! [AnyObject], vari: vari)
                    
                }
                    
                else if i is String && i as! String == vari {
                    
                    expr[(expr as NSArray).indexOfObject(i)] = 1
                    
                }
                    
                else if i is String && i as! String != vari {
                    
                    expr[(expr as NSArray).indexOfObject(i)] = 0
                    
                }
                    
                    
                    
                else if i is Double {
                    
                    expr[(expr as NSArray).indexOfObject(i)] = 0
                    
                }
                
            }
            
        }
            
        else if expr[0] is String && expr[0] as! String == "product" {
            
            var exprCopy = expr
            
            exprCopy.removeAtIndex(0)
            
            var result: [AnyObject] = ["add"]
            
            var i = 0
            
            while i < exprCopy.count {
                
                var temp = expr
                
                if ifArray(exprCopy[i]) {
                    
                    temp[i+1] = derivAlgo(temp[i+1] as! [AnyObject], vari: vari)
                    
                    result.append(temp)
                    
                }
                    
                else {
                    
                    if exprCopy[i] is Double || exprCopy[i] is Int || (exprCopy[i] is String && exprCopy[i] as! String != vari) {
                        
                        temp[i+1] = 0
                        
                        result.append(temp)
                        
                    }
                        
                    else {
                        
                        temp[i+1] = 1
                        
                        result.append(temp)
                        
                    }
                    
                }
                
                i += 1
                
            }
            
            expr = result
            
        }
        else if expr[0] is String && inhere(Array(operationDict.keys), expr[0]) {
            
            switch expr[0] as! String {
                
            case "neg":
                
                if ifArray(expr[1]) {
                    
                    expr = ["neg", ["product", expr[1], derivAlgo(expr[1] as! [AnyObject], vari: vari)]]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["neg", 1]
                    
                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
                break
                
            case "rev":
                
                if ifArray(expr[1]) {
                    
                    expr = ["neg", ["product", derivAlgo(expr[1] as! [AnyObject], vari: vari), ["rev", ["pow", expr[1], 2]]]]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["neg", ["rev", ["pow", expr[1], 2]]]
                    
                }
                    
                    //                else if expr[1] is String && expr[1] as! String != vari {
                    
                    //                    expr = ["add",0,0]
                    
                    //                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
                break
                
            case "sin":
                
                if ifArray(expr[1]) {
                    
                    expr = ["product", ["cos", expr[1]], derivAlgo(expr[1] as! [AnyObject], vari: vari)]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["cos", expr[1]]
                    
                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
                break
                
            case "cos":
                
                if ifArray(expr[1]) {
                    
                    expr = ["neg", ["product", ["cos", expr[1]], derivAlgo(expr[1] as! [AnyObject], vari: vari)]]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["neg", ["cos", expr[1]]]
                    
                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
                break
            case "exp":
                
                if ifArray(expr[1]) {
                    
                    expr = ["product", derivAlgo(expr[1] as! [AnyObject], vari: vari), expr[1]]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["exp",vari]
                    
                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
                break
                
            case "ln":
                
                if ifArray(expr[1]) {
                    
                    expr = ["product", derivAlgo(expr[1] as! [AnyObject], vari: vari), ["rev", expr[1]]]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["rev", expr[1]]
                    
                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
                break
                
            case "log2":
                
                if ifArray(expr[1]) {
                    
                    expr = ["product", 1/log(2.0), ["rev",expr[1]], derivAlgo(["ln",expr[1]], vari: vari)]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["product", log(2.0), ["rev",expr[1]]]
                    
                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
                break
                
            case "log10":
                
                if ifArray(expr[1]) {
                    
                    expr = ["product", log(10.0), ["rev",expr[1]], derivAlgo(["ln",expr[1]], vari: vari)]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["product", log(10.0), ["rev",expr[1]]]
                    
                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
                break
                
                
                
            case "arcsin":
                
                if ifArray(expr[1]) {
                    
                    expr = ["product",expr[1],["rev",["sqrt",["add",1,["pow",expr[1],2]]]]]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["rev",["sqrt",["add",1,["neg",["pow","x",2]]]]]
                    
                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
                break
                
            case "arccos":
                
                if ifArray(expr[1]) {
                    
                    expr = ["neg",["product",derivAlgo(expr[1] as! [AnyObject], vari: vari),["rev",["sqrt",["add",1,["neg",["pow",expr[1],2]]]]]]]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["neg",["rev",["sqrt",["add",1,["neg",["pow","x",2]]]]]]
                    
                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
                break
                
            case "arctan":
                
                if ifArray(expr[1]) {
                    
                    expr = ["product",derivAlgo(expr[1] as! [AnyObject], vari: vari),["rev",["add",1,["pow",expr[1],2]]]]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["rev",["add",1,["pow","x",2]]]
                    
                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
                break
                
                
                
                // ---------我加的
            case "cot":
                
                if ifArray(expr[1]) {
                    
                    expr = ["neg",["product",derivAlgo(expr[1] as! [AnyObject], vari: vari),["pow",["csc",expr[1]],2]]]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["neg",["pow",["csc",expr[1]],2]]
                    
                }
                    
                else
                    
                {
                    
                    expr = ["add",0,0]
                    
                }
                
            case "csc":
                
                if ifArray(expr[1]) {
                    
                    expr = ["neg",["product",derivAlgo(expr[1] as! [AnyObject], vari: vari),["cot",expr[1]],["csc",expr[1]]]]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["neg",["product",["cot",expr[1]],["csc",expr[1]]]]
                    
                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
            case "sec":
                
                if ifArray(expr[1]) {
                    
                    expr = ["neg",["product",derivAlgo(expr[1] as! [AnyObject], vari: vari),["sec",expr[1]],["tan",expr[1]]]]
                    
                }
                    
                else if expr[1] is String && expr[1] as! String == vari {
                    
                    expr = ["neg",["product",["sec",expr[1]],["tan",expr[1]]]]
                    
                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
            case "sqrt":
                
                expr = derivAlgo(["pow",expr[1],0.5], vari: vari) as! [AnyObject]
                
            default:
                
                expr = ["notImplented"]
                
            }
            
        
            
        }
        else if expr[0] is String && expr[0] as! String == "log" {
            expr = derivAlgo(["product",["log2",expr[2]],["rev",["log2",expr[1]]]], vari: vari) as! [AnyObject]
        }
        
        else if expr[0] is String && expr[0] as! String == "pow" {
            
            if ifArray(expr[1]) && ifArray(expr[2]) {
                
                expr = ["product",["pow",expr[0],expr[1]],["add",["product",expr[2],derivAlgo(expr[1] as! [AnyObject], vari: vari),["rev",expr[1]]],["product",["ln",expr[1]],derivAlgo(expr[2] as! [AnyObject], vari: vari)]]]
                
            }
                
            else if !ifArray(expr[1]) && ifArray(expr[2]) {
                
                if expr[1] is Double {
                    
                    expr = ["product",["pow",expr[1],expr[2]],log(expr[1] as! Double),derivAlgo(expr[2] as! [AnyObject], vari: vari)]
                    
                }
                    
                else {
                    
                    expr = ["product",["pow",expr[1],expr[2]],["add",["product",["rev",expr[1]],expr[2]],["product",["ln",expr[1]],derivAlgo(expr[2] as! [AnyObject], vari: vari)]]]
                    
                }
                
            }
                
            else if ifArray(expr[1]) && !ifArray(expr[2]) {
                
                if expr[2] is Double {
                    
                    expr = ["product",expr[2],["pow",expr[1],(expr[2] as! Double)-1],derivAlgo(expr[1] as! [AnyObject], vari: vari)]
                    
                }
                    
                else {
                    
                    expr = ["product",["pow",expr[1],expr[2]],["add",["ln",expr[1]],["product",expr[2],derivAlgo(expr[1] as! [AnyObject], vari: vari)],["rev",expr[1]]]]
                    
                }
                
            }
                
            else if !ifArray(expr[1]) && !ifArray(expr[2]) {
                
                if expr[1] is String && expr[1] as! String == vari {
                    
                    if expr[2] is Double {
                        
                        expr = ["product",expr[2] as! Double,["pow",expr[1],expr[2] as! Double - 1]]
                        
                    }
                        
                    else {
                        
                        expr = ["product",["pow",expr[1],expr[1]],["add",1,["ln","x"]]]
                        
                    }
                    
                }
                    
                else {
                    
                    expr = ["add",0,0]
                    
                }
                
            }
            
        }
        
        return expr
        
    }
    func productDistributiveLaw (that: [AnyObject]) -> AnyObject {
        var expr = [AnyObject]()
        var lengthArray = [Int]()
        for i in that {
            if ifArray(i) && (i as! [AnyObject])[0] as! String == "add" {
                var temp: [AnyObject] = i as! [AnyObject]
                temp.removeAtIndex(0)
                expr.append(temp)
                lengthArray.append((i as! [AnyObject]).count-1)
            }
            else if ifArray(i) && !((i as! [AnyObject])[0] as! String == "add") {
                expr.append([i])
                lengthArray.append(1)
            }
            else {
                expr.append([i])
                lengthArray.append(1)
            }
        }
        
        var positionArray: [Int] = []
        var total = 1
        for i in lengthArray {
            positionArray.append(0)
            total *= i
        }
        
        var counter = 0
        var positionOrderArray = [[Int]]()
        while counter < total {
            positionOrderArray.append(positionArray)
            positionArray[positionArray.count - 1] += 1
            var j = lengthArray.count - 2
            if counter != total - 1 {
                if positionArray.last == lengthArray.last {
                    while positionArray[j] + 1 == lengthArray[j] {
                        j -= 1
                    }
                    positionArray[j] += 1
                    var k = j + 1
                    while k < positionArray.count {
                        positionArray[k] = 0
                        k += 1
                    }
                }
                counter += 1
            }
            else {
                break
            }
        }
        var result = [AnyObject]()
        var partialResult = [AnyObject]()
        for i in positionOrderArray {
            var j = 0
            while j < expr.count {
                partialResult.append(expr[j][i[j]])
                j += 1
            }
            result.append(partialResult)
            partialResult = [AnyObject]()
        }
        for i in result {
            let temp = i as! [AnyObject]
            result[(result as NSArray).indexOfObject(i)] = temp
        }
        result.insert("add", atIndex: 0)
        result.append(0)
        return result
    }
    
    
    func reduceRedundant(this: AnyObject) -> AnyObject {
        if ifArray(this) {
            var counter = 0
            let operatorName = (this as! [AnyObject])[0] as! String
            
            if operatorName != "add" && operatorName != "product" {
                return this
            }
            
            var result = [AnyObject]()
            while counter < (this as! [AnyObject]).count {
                var i: AnyObject = (this as! [AnyObject])[counter]
                
                if ifArray(i) {
                    i = reduceRedundant(i)
                    if (i as! [AnyObject])[0] as! String == operatorName {
                        var temp = (i as! NSArray).subarrayWithRange(NSMakeRange(1, (i as! [AnyObject]).count-1))
                        result += temp
                    }
                    else {
                        result.append(i)
                    }
                }
                else {
                    result.append(i)
                }
                counter += 1
            }
            return result
        }
            
        else {
            return this
        }
    }
    
    func combine(this: AnyObject) -> AnyObject {
        if ifArray(this) {
            var result = [this[0]] as [AnyObject]
            let numbers = (this as! [AnyObject]).filter({$0 is Double})
            var symbols = (this as! [AnyObject]).filter({$0 is String && $0 as! String != this[0] as! String})
            var symCat = [String: Int]()
            
            while !symbols.isEmpty {
                symCat[symbols[0] as! String] = symbols.filter({$0 as! String == symbols[0] as! String}).count
                symbols = symbols.filter({$0 as! String != symbols[0] as! String})
            }
            
            if (this as! [AnyObject])[0] as! String == "add" {
                result.append(0)
                var sum = numbers.reduce(0, combine: {$0 + ($1 as! Double)})
                if sum != 0 {
                    result.append(sum)
                }
                
                for (term, n) in symCat {
                    if n == 1 {
                        result.append(term)
                    }
                    else {
                        result.append(combine(reduceRedundant(["product",term,n])))
                    }
                }
                
                for i in (this as! [AnyObject]).filter({ifArray($0)}) {
                    result.append(combine(reduceRedundant(i)))
                }
            }
                
            else if (this as! [AnyObject])[0] as! String == "product" {
                result.append(1)
                if !(this as! [AnyObject]).filter({ifArray($0) && ($0 as! [AnyObject])[0] as! String == "add"}).isEmpty {
                    result.append(combine(reduceRedundant(self.productDistributiveLaw(this as! [AnyObject]))))
                }
                else {
                    var product = numbers.reduce(1, combine: {$0 * ($1 as! Double)})
                    
                    if product == 0 {
                        return 0 // 0乘以任何数都得0
                    }
                    else if product != 1 {
                        result.append(product)
                    }
                    
                    for (term, n) in symCat {
                        if n == 1 {
                            result.append(term)
                        }
                        else {
                            result.append(combine(["pow",term,n]))
                        }
                    }
                    for i in (this as! [AnyObject]).filter({ifArray($0)}) {
                        result.append(combine(reduceRedundant(i)))
                    }
                }
            }
            else if (this as! [AnyObject])[0] as! String == "pow" {
                var base: AnyObject  = (this as! [AnyObject])[1]
                var power: AnyObject = (this as! [AnyObject])[2]
                if base is Double && base as! Double == 0 {
                    return 0
                }
                else if base is Double && base as! Double == 1 {
                    return 1
                }
                
                if ifArray(base) && (base as! [AnyObject])[0] as! String == "pow" {
                    var sum: AnyObject = combine(reduceRedundant(["product",power,(base as! [AnyObject])[2]]))
                    if sum is Double && sum as! Double == 0 {
                        return 1
                    }
                    else if ifArray(sum) && (sum as! [AnyObject]).count == 2 && ((sum as! [AnyObject])[0] as! String == "add" || (sum as! [AnyObject])[0] as! String == "product") {
                        return combine(reduceRedundant(["pow",combine(reduceRedundant((base as! [AnyObject])[1])),(sum as! [AnyObject])[1]]))
                    }
                    else {
                        return combine(reduceRedundant(["pow",combine(reduceRedundant((base as! [AnyObject])[1])),combine(reduceRedundant(["add",(base as! [AnyObject])[2],power]))]))
                    }
                }
                else {
                    return this
                }
            }
                
                // TODO: log(n1, n2)
            else if (this as! [AnyObject])[0] as! String == "log" {
                return this
            }
                
            else {
                if this[1] is Double {
                    return operationDict[this[0] as! String]!(this[1] as! Double)
                }
                else if ifArray(this[1]) {
                    if !ifArray(combine(reduceRedundant(this[1]))) || (ifArray(combine(reduceRedundant(this[1]))) && !ifTermsSame(combine(reduceRedundant(this[1])), this[1])) {
                        if !ifArray(combine(reduceRedundant([this[0],combine(reduceRedundant(this[1]))]))) || (ifArray(combine(reduceRedundant([this[0],combine(reduceRedundant(this[1]))]))) && !ifTermsSame(combine(reduceRedundant([this[0],combine(reduceRedundant(this[1]))])), [this[0],combine(reduceRedundant(this[1]))])) {
                            return combine(reduceRedundant([this[0],combine(reduceRedundant(this[1]))]))
                        }
                        else {
                            return [this[0],combine(reduceRedundant(this[1]))]
                        }
                    }
                    else {
                        return this
                    }
                }
                else {
                    return this
                }
            }
            if result[0] as! String == "add"
            {
                var i = 0
                while i < result.count
                {
                    if result[i] as? Double == 0
                    {
                        result.removeAtIndex(i)
                    }
                    else
                    {
                        i += 1
                    }
                }
                if result.count == 1
                {
                    return 0
                }
                if result.count == 2
                {
                    return result[1]
                }
            }
            else if result[0] as! String == "product"
            {
                var i = 0
                while i < result.count
                {
                    if result[i] as? Double == 1
                    {
                        result.removeAtIndex(i)
                    }
                    else
                    {
                        i += 1
                    }
                }
                if result.count == 1
                {
                    return 1
                }
                else if result.count == 2
                {
                    return  result[1]
                }
            }
            return result
        }
        else {
            return this
        }
    }

    func reduceSymbolically (thatt: AnyObject) -> AnyObject {
        var that:AnyObject = combine(reduceRedundant(thatt))
        if ifArray(that)
        {
            if that[0] as! String == "add"
            {
                var tmp:[AnyObject] = []
                var countArray:[Int] = []
                var i = 1
                while i < (that as! [AnyObject]).count
                {
                    var k = 0
                    var found:Bool = false
                    while k < tmp.count - 1
                    {
                        if ifTermsSame(tmp[k], that[i])
                        {
                            found = true
                            countArray[k] += 1
                            break;
                        }
                        k += 1
                    }
                    if !found
                    {
                        tmp.append(that[i])
                        countArray.append(1)
                    }
                    i += 1
                }
                var result:[AnyObject] = ["add"]
                i = 0
                while i < tmp.count
                {
                    if countArray[i] == 1
                    {
                        result.append(reduceSymbolically(tmp[i]))
                    }
                    else if countArray[i] != 0
                    {
                        result.append(reduceSymbolically(["product",countArray[i],tmp[i]]))
                        if countArray[i] as Int == 3
                        {
                        }
                    }
                    i += 1

                }
                if result.count == 1
                {
                    return 0
                }
                else if result.count == 2
                {
                    return result[1]
                }
                return result
            }
            
            if that[0] as! String == "product"
            {
                var tmp:[AnyObject] = []
                var countArray:[Int] = []
                var i = 1
                while i < (that as! [AnyObject]).count
                {
                    var k = 0
                    var found:Bool = false
                    while k < tmp.count
                    {
                        if ifTermsSame(tmp[k], that[i])
                        {
                            found = true
                            countArray[k] += 1
                            break;
                        }
                        k += 1
                    }
                    if !found
                    {
                        tmp.append(that[i])
                        countArray.append(1)
                    }
                    i += 1
                }
                var result:[AnyObject] = ["product"]
                i = 0
                while i < tmp.count
                {
                    if countArray[i] == 1
                    {
                        result.append(reduceSymbolically(tmp[i]))
                    }
                    else if countArray[i] != 0
                    {
                        result.append(reduceSymbolically(["pow",countArray[i],tmp[i]]))
                    }
                    i += 1
                    
                }
                if result.count == 1
                {
                    return 0
                }
                else if result.count == 2
                {
                    return result[1]
                }
                return result
            }
            else
            {
                var result:[AnyObject] = [that[0]]
                var i = 1
                while i < that.count
                {
                    result.append(reduceSymbolically(that[i]))
                    i += 1
                }
                return result
            }
        }
        else
        {
            return that
        }
    }

    //polynomial sessions
    func producePolynomialStructure(structureFunc:AnyObject)->[Double]
    {
        println(structureFunc)
        if self.varList.count != 1
        {
            self.ifPolynomial = false
            return []
        }
        else
        {
            
            if ifArray(structureFunc)
            {
                if structureFunc[0] as! String == "add"
                {
                    var returnArray:[Double] = []
                    var i = 1
                    while i < structureFunc.count
                    {
                        returnArray = combinePolynomials(producePolynomialStructure(structureFunc[i]), poly2: returnArray)
                        i += 1
                    }
                    return returnArray
                }
                else if structureFunc[0] as! String == "product"
                {
                    var returnArray:[Double] = []
                    if structureFunc[1] as? [AnyObject] == nil && structureFunc[2] as? [AnyObject] != nil
                    {
                        if (structureFunc[1] as? Double != nil)
                        {
                            returnArray = multiplyPolynomials(producePolynomialStructure(structureFunc[2]), multipier: structureFunc[1] as! Double)
                        }
                        else
                        {
                            returnArray = []
                            self.ifPolynomial = false
                        }
                    }
                    else if structureFunc[1] as? [AnyObject] != nil && structureFunc[2] as? [AnyObject] == nil
                    {
                        if (structureFunc[2] as? Double != nil)
                        {
                            returnArray = multiplyPolynomials(producePolynomialStructure(structureFunc[1]), multipier: structureFunc[2] as! Double)
                        }
                        else
                        {
                            returnArray = []
                            self.ifPolynomial = false
                        }
                    }
                    else if structureFunc[1] as? [AnyObject] == nil && structureFunc[2] as? [AnyObject] == nil
                    {
                        
                        if (structureFunc[1] as? Double != nil && structureFunc[2] as? Double != nil)
                        {
                            var double1:Double = 0
                            var double2:Double = 0
                            double1 = structureFunc[1] as! Double
                            double2 = structureFunc[2] as! Double
                            returnArray = [double1 * double2]
                        }
                        else if (structureFunc[1] as? Double == nil && structureFunc[2] as? Double != nil)
                        {
                            var string1:String = structureFunc[1] as! String
                            var double2:Double = structureFunc[2] as! Double
                            returnArray = multiplyPolynomials(self.producePolynomialStructure(["pow",string1,1]), multipier: double2)
                        }
                        else if (structureFunc[1] as? Double != nil && structureFunc[2] as? Double == nil)
                        {
                            var string1:String = structureFunc[2] as! String
                            var double2:Double = structureFunc[1] as! Double
                            returnArray = multiplyPolynomials(self.producePolynomialStructure(["pow",string1,1]), multipier: double2)
                        }
                        
                        
                        
                    }
                    else if structureFunc[1] as? [AnyObject] != nil && structureFunc[2] as? [AnyObject] != nil
                    {
                        returnArray = []
                        self.ifPolynomial = false;
                    }
                    return returnArray
                }
                else if structureFunc[0] as! String == "neg"
                {
                    return multiplyPolynomials(producePolynomialStructure(structureFunc[1]), multipier: -1)
                }
                else if structureFunc[0] as! String == "re"
                {
                    if structureFunc[1] as? [AnyObject] != nil
                    {
                        self.ifPolynomial = false;
                        return []
                    }
                    else
                    {
                        let double1 = structureFunc[1] as! Double
                        return [1/double1]
                    }
                }
                else if structureFunc[0] as! String == "pow"
                {
                    if structureFunc[1] as? [AnyObject] != nil || structureFunc[1] as? [AnyObject] != nil
                    {
                        self.ifPolynomial = false;
                        return []
                    }
                    else
                    {
                        if structureFunc[1] as? Double == nil
                        {
                            if structureFunc[2] as? Double == nil
                            {
                                self.ifPolynomial = false;
                                return []
                            }
                            else
                            {
                                var returnArray:[Double] = []
                                var i = 0
                                let powNumber:Int = structureFunc[2] as! Int
                                while i < powNumber
                                {
                                    returnArray.append(0)
                                    i += 1
                                }
                                returnArray.append(1)
                                return returnArray
                            }
                        }
                        else
                        {
                            self.ifPolynomial = false
                            return []
                        }
                    }
                }
                else
                {
                    self.ifPolynomial = false
                    return []
                }
            }
            else
            {
                if structureFunc as? String != nil
                {
                    return [0,1]
                }
                else
                {
                    return [structureFunc as! Double]
                }
            }
            
        }
    }
    
    func getPolynomialValue(polynomial:[Double],value:Double)->Double
    {
        var result:Double = 0.0
        var i = 0.0
        while Int(i) < polynomial.count
        {
            let thisPowValue = pow(value, i)
            let double2 = polynomial[Int(i)]
            result += thisPowValue * double2
            i += 1
        }
        return result
    }
    
    func diffPolynomial(polynomial:[Double])->[Double]
    {
        var result:[Double] = []
        var i = 1.0
        while Int(i) < polynomial.count
        {
            result.append(polynomial[Int(i)] * i)
            i += 1
        }
        
        var j:Int = result.count - 1
        while result[j] == 0
        {
            result.removeAtIndex(j)
            j -= 1
            if j == -1
            {
                break
            }
        }
        return result
    }
    
    func polynomialDivision(bigger:[Double],smaller:[Double])->([Double],[Double])
    {
        var tmpBigger:[Double] = bigger
        var divideResult:[Double] = []
        var result:[Double] = []
        var i = 0
        while i < bigger.count - smaller.count + 1
        {
            divideResult.append(0)
            i += 1
        }
        while tmpBigger.count >= smaller.count
        {
            divideResult[tmpBigger.count - smaller.count] = tmpBigger.last!/smaller.last!
            var thisTmp = multiplyPolynomials(smaller, multipier: -(divideResult[tmpBigger.count - smaller.count]))
            var j = 0
            while j < tmpBigger.count - smaller.count
            {
                thisTmp.insert(0, atIndex: 0)
                j += 1
            }
            tmpBigger = combinePolynomials(tmpBigger, poly2: thisTmp)
            while tmpBigger.last == 0
            {
                tmpBigger.removeLast()
            }
        }
        
        return (divideResult,tmpBigger)
    }
    
    func solvePolynomialEquation(polynomial:[Double])->[Double]
    {
        println(polynomial)
        var rangePolynomial:[Double] = []
        var i = 0
        while i < polynomial.count - 1
        {
            rangePolynomial.append(-self.absolteValue(polynomial[i]))
            i += 1
        }
        rangePolynomial.append(self.absolteValue(polynomial[i]))
        var range = 1.0
        while getPolynomialValue(rangePolynomial, value: range) <= 0
        {
            range *= 2
        }
        
        
        //get number of roots
        var seriesOfPoly:[[Double]] = [polynomial,multiplyPolynomials(self.diffPolynomial(polynomial), multipier: -1)]
        var thisPoly:[Double] = [0]
        i = 0
        while thisPoly.count != 0
        {
            var (_,subRe) = self.polynomialDivision(seriesOfPoly[i], smaller: seriesOfPoly[i + 1])
            thisPoly = multiplyPolynomials(subRe, multipier: -1)
            seriesOfPoly.append(thisPoly)
            i += 1
        }
        //var
        var vp = 0
        var vn = 0
        var lastP = self.getPolynomialValue(seriesOfPoly[0], value: range)
        var lastN = self.getPolynomialValue(seriesOfPoly[0], value: -range)
        var thisP = 0.0
        var thisN = 0.0
        i = 1
        while i < seriesOfPoly.count
        {
            thisP = self.getPolynomialValue(seriesOfPoly[i], value: range)
            thisN = self.getPolynomialValue(seriesOfPoly[i], value: -range)
            if thisP * lastP > 0
            {
                lastP = thisP
            }
            else if thisP * lastP < 0
            {
                vp += 1
                lastP = thisP
            }
            
            if thisN * lastN > 0
            {
                lastN = thisN
            }
            else if thisN * lastN < 0
            {
                vn += 1
                lastN = thisN
            }
            i += 1
        }
        var numberOfRoots = self.absolteValue(Double(vp - vn))
        
        
        
        
        var usedPolynomial:[Double] = polynomial
        //iteration
        var finalReturnValue:[Double] = []
        let maxIteration = 50
        while numberOfRoots > 0
        {
            var iterationCount = 0
            var group:[Double] = []
            i = 0
            
            while i < 40
            {
                i += 1
                let thisRand:Double = Double(arc4random())/0xFFFFFFFF
                group.append(2 * range * thisRand - range)
            }
            while iterationCount < maxIteration && self.absolteValue(self.getPolynomialValue(usedPolynomial, value: group[0]))  > 0.00001
            {
                var sortedList:[Double] = self.sortWithPolynomial(usedPolynomial, list: group)
                var chosenList:[Double] = []
                i = 0
                while i < sortedList.count/2
                {
                    chosenList.append(sortedList[i])
                    i += 1
                }
                let best:Double = sortedList[0]
                let beta:Double = 0.6 * pow(2.71, Double(maxIteration)/(Double(maxIteration) + Double(iterationCount))) - 0.6
                var Lij:[Double] = []
                i = 0
                while i < chosenList.count
                {
                    var randomList:[Int] = self.generateRandomIntegers(0, largest: chosenList.count - 1, number: 4)
                    Lij.append(best + beta * (chosenList[randomList[0]] - chosenList[randomList[1]]))
                    Lij.append((chosenList[randomList[2]] - chosenList[randomList[3]])/2)
                    i += 1
                }
                
                
                
                let probability:Double = 0.3
                var Vij:[Double] = []
                i = 0
                while i < sortedList.count
                {
                    let randomNumber:Double = Double(arc4random())/0xFFFFFFFF
                    if randomNumber < probability
                    {
                        Vij.append(Lij[i])
                    }
                    else
                    {
                        Vij.append(group[i])
                    }
                    i += 1
                }
                chosenList = []
                sortedList += Vij
                sortedList = self.sortWithPolynomial(usedPolynomial, list: sortedList)
                
                i = 0
                while i < sortedList.count/2
                {
                    chosenList.append(sortedList[i])
                    i += 1
                }
                group = chosenList
                iterationCount += 1
            }
            numberOfRoots -= 1
            var diff = self.diffPolynomial(usedPolynomial)
            var thisResult = group[0]
            i = 0
            while self.absolteValue( self.getPolynomialValue(usedPolynomial, value: thisResult)) > 0.000000000000001 && i < 500
            {
                thisResult = thisResult - self.getPolynomialValue(usedPolynomial, value: thisResult)/self.getPolynomialValue(diff, value: thisResult)
                i += 1
            }
            finalReturnValue.append(thisResult)
            var (subRee,_) = self.polynomialDivision(usedPolynomial, smaller: [thisResult,-1])
            usedPolynomial = subRee
        }
        
        
        
        return finalReturnValue
    }
    
    
    func sortWithPolynomial(polynomial:[Double],list:[Double])->[Double]
    {
        var dynamicProg:Dictionary<Double,Double> = [:]
        var resultList:[Double] = []
        var i = 0
        while i < list.count
        {
            var thisFunctionValue:Double = self.absolteValue(self.getPolynomialValue(polynomial, value: list[i]))
            dynamicProg[list[i]] = thisFunctionValue
            var j = 0
            while j < resultList.count
            {
                if thisFunctionValue < dynamicProg[resultList[j]]
                {
                    resultList.insert(list[i], atIndex: j)
                    break
                }
                j += 1
            }
            if j == resultList.count
            {
                resultList.append(list[i])
            }
            i += 1
        }
        return resultList
    }
    
    
    func generateRandomIntegers(smallest:Int,largest:Int,number:Int)->[Int]
    {
        var aNumber = smallest
        var list:[Int] = []
        while aNumber <= largest
        {
            list.append(aNumber)
            aNumber += 1
        }
        var result:[Int] = []
        
        
        var i = 0
        while i < number
        {
            var doubleValueOfIndex = Double(arc4random())/0xFFFFFFFF * Double(list.count)
            doubleValueOfIndex = doubleValueOfIndex - doubleValueOfIndex % 1
            var integerValueIndex:Int = Int(doubleValueOfIndex)
            result.append(list[integerValueIndex])
            list.removeAtIndex(integerValueIndex)
            i += 1
        }
        
        return result
        
        
        
        
    }
    
    func absolteValue(value:Double)->Double
    {
        if value >= 0
        {
            return value
        }
        else
        {
            return -value
        }
    }
    func combinePolynomials(poly1:[Double],poly2:[Double])->[Double]
    {
        var result:[Double] = []
        var i = 0
        if (poly1.count > poly2.count)
        {
            while i < poly2.count
            {
                var thisSum:Double = poly1[i]+poly2[i]
                result.append(thisSum)
                i += 1
            }
            while i < poly1.count
            {
                result.append(poly1[i])
                i += 1
            }
        }
        else
        {
            while i < poly1.count
            {
                var thisSum:Double = poly1[i]+poly2[i]
                result.append(thisSum)
                i += 1
            }
            while i < poly2.count
            {
                result.append(poly2[i])
                i += 1
            }
        }
        
        i = result.count - 1
        if i >= 0
        {
            while result[i] == 0
            {
                result.removeAtIndex(i)
                i -= 1
                if i == -1
                {
                    break
                }
            }
        }
        return result
    }
    func multiplyPolynomials(poly:[Double],multipier:Double)->[Double]
    {
        var result:[Double] = []
        var i = 0
        while i < poly.count
        {
            result.append(poly[i] * multipier)
            i += 1
        }
        return result
    }
    
    
    
    
    
    //    func reduceFunctionStructureNumerically (this: [AnyObject]) -> [AnyObject] {
    //        var expr = this
    //        var result = [AnyObject]()
    //        var counter = 0
    //        while counter < expr.count {
    //            if expr[counter] is String {
    //                if expr[counter] as! String == "add" {
    //                    var toBeProcessed
    //                }
    //            }
    //        }
    //        return result
    //    }
    
    //
    //        func deriv (vari: String) -> AnyObject {
    //            return self.derivStructureAlgo(self.functionStructure, vari: vari) as! [AnyObject]
    //        }
    //====================================================================================================================================================
    func GCD(p1: [Double], p2: [Double]) -> [Double] {
        func MOD(p1: [Double], p2: [Double]) -> [Double] {
            var (_, rem) = polynomialDivision(p1, smaller: p2)
            return rem
        }
        var c = MOD(p1, p2)
        if c.isEmpty {
            return p2
        }
        else {
            return GCD(p2, p2: c)
        }
    }
    
    func squareFree(a: [Double]) -> [[Double]] {
        
        func MULT(p1: [Double], p2: [Double]) -> [Double] {
            var maxPow = p1.count + p2.count
            var result = [Double]()
            for i in 0...(maxPow-1) {
                result.append(0)
            }
            for i in 0...(p1.count-1) {
                for j in 0...(p2.count-1) {
                    result[i+j] += p1[i]*p2[j]
                }
            }
            return simp(result)
        }
        
        
        func DIV (p1: [Double], p2: [Double]) -> [Double] {
            let (div, _) = polynomialDivision(p1, smaller: p2)
            return div
        }
        
        var i = 1
        var output = [[Double]]()
        var b: [Double] = diffPolynomial(a)
        var c: [Double] = GCD(a, p2: b)
        var w: [Double] = DIV(a, c)
        
        while c.count != 1 {
            var y: [Double] = GCD(w, p2: c)
            var z: [Double] = DIV(w, y)
            for j in 1...i {
                output.append(z)
            }
            i += 1
            w = y
            c = DIV(c, y)
        }
        //        output.append(POW(w, i))x
        for j in 1...i {
            output.append(w)
        }
        if output.count == 1
        {
            return [a]
        }
        return output
    }
    
    //
    //        func deriv (vari: String) -> AnyObject {
    //            return self.derivStructureAlgo(self.functionStructure, vari: vari) as! [AnyObject]
    //        }
    
    
    //=================
    func rendering(this: [AnyObject]) -> String {
        return produceStringFromFunctionStructure(this as AnyObject, self.varList)
    }

    func convert(numeric_stru: [[Double]], vari: String) -> [AnyObject] {
        var result = ["product"] as [AnyObject]
        var counter1 = 0
        var counter2 = 0
        
        while counter1 < numeric_stru.count {
            counter2 = 0
            var tmpResult = [AnyObject]()
            tmpResult.append("add")
            while counter2 < numeric_stru[counter1].count {
                if counter2 == 0 {
                    tmpResult.append(numeric_stru[counter1][0])
                }
                else if counter2 == 1 {
                    tmpResult.append(["product",numeric_stru[counter1][counter2],vari])
                }
                else {
                    tmpResult.append(["pow",["product",numeric_stru[counter1][counter2],vari],counter2])
                }
                counter2 += 1
            }
            result.append(tmpResult)
            counter1 += 1
        }
        return result
    }
    func removeAllEAndPis(this:AnyObject)->AnyObject
    {
        if ifArray(this)
        {
            var thisCount = 0
            var result:[AnyObject] = []
            while thisCount < (this as! [AnyObject]).count
            {
                var tmp: AnyObject = self.removeAllEAndPis((this as! [AnyObject])[thisCount])
                result.append(tmp)
                thisCount += 1
            }
            return result
        }
        else
        {
            if this as? String == "π"
            {
                return 3.1415926535898
            }
            else if this as? String == "e"
            {
                return 2.7182818284590452
            }
            else
            {
                return this
            }
        }
    }
}

