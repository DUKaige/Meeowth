//
// Created by mac on 15/5/22.
// Copyright (c) 2015 mac. All rights reserved.
//

import Foundation

var operationDict: [String: (Double -> Double)] = [
    "neg"   : {(x: Double) in -x},
    "rev"   : {(x: Double) in 1.0/x},
    "sin"   : {(x: Double) in sin(x)},
    "cos"   : {(x: Double) in cos(x)},
    "tan"   : {(x: Double) in tan(x)},
    "exp"   : {(x: Double) in exp(x)},
    "ln"    : {(x: Double) in log(x)},
    "log2"  : {(x: Double) in log2(x)},
    "log10" : {(x: Double) in log10(x)},
    "cot"   : {(x: Double) in 1/tan(x)},
    "csc"   : {(x: Double) in 1/sin(x)},
    "sec"   : {(x: Double) in 1/cos(x)},
    "arcsin":{(x: Double) in asin(x)},
    "arccos":{(x: Double) in acos(x)},
    "arctan":{(x: Double) in atan(x)},
    "sqrt": {(x: Double) in pow(x, 0.5)}
]

func  inhere(this: [AnyObject], wanted: AnyObject) -> Bool {
    return !((this as NSArray).indexOfObject(wanted) >= this.count)
}

func log (base: Double, result: Double) -> Double {
    return log(result) / log(base)
}


func numeric_list_add (this: [Double]) -> Double {
    var result = 0.0
    for i: Double in this {
        result += i
    }
    return result
}

func numeric_list_time (this: [Double]) -> Double {
    var result = 1.0
    for i: Double in this {
        result *= i
    }
    return result
}

func getDimension (this: [AnyObject]) -> Int {
    var result:  Double
    return 1
}







//function -> string
func produceStringFromFunctionStructure(functionStr:AnyObject,varList:[String]) -> String
{
    println(functionStr)
    var resultString = ""
    if ifArray(functionStr)
    {
        if (functionStr as! [AnyObject]).isEmpty
        {
            return ""
        }
        if functionStr[0] as! String == "add"
        {
            var tmpFuncStr:[AnyObject] = functionStr as! [AnyObject]
            var found:Bool = false
            tmpFuncStr = (functionStr as! [AnyObject]).filter({!($0 is Double && $0 as! Double == 0)})
            
            if tmpFuncStr.count == 1
            {
                return "0"
            }

            resultString += produceStringFromFunctionStructure(tmpFuncStr[1], varList)
            var i = 2
            println(tmpFuncStr)
            while i < count(tmpFuncStr)
            {
                println(tmpFuncStr[i])
                if (tmpFuncStr[i] as? [AnyObject]) != nil
                {
                    var added:String = produceStringFromFunctionStructure(tmpFuncStr[i] as AnyObject,varList)
                    if !((added as NSString).substringWithRange(NSMakeRange(0, 1)) == "-")
                    {
                        resultString += "+"
                    }
                    resultString += added
                    
                }
                else
                {
                    var added:String = produceStringFromFunctionStructure(tmpFuncStr[i] as AnyObject,varList)
                    if !((added as NSString).substringWithRange(NSMakeRange(0, 1)) == "-")
                    {
                        resultString += "+"
                    }
                    resultString += added

                }

                i += 1
            }
        }
        else if functionStr[0] as! String == "neg"
        {
            resultString += "0-"
            resultString += produceStringFromFunctionStructure(functionStr[1] as AnyObject,varList)
        }
        else if functionStr[0] as! String == "product"
        {
            var tmpFuncStr:[AnyObject] = functionStr as! [AnyObject]
            if inhere(functionStr as! [AnyObject], 0) {
                return "0"
            }
            tmpFuncStr = (functionStr as! [AnyObject]).filter({!($0 is Double && $0 as! Double == 1)})
            if tmpFuncStr.count == 1
            {
                return "1"
            }
            var i = 1
            while i < count(tmpFuncStr) - 1
            {
                var ifAddQuotes = false
                if ifArray(tmpFuncStr[i])
                {
                    var newObject: [AnyObject]! = tmpFuncStr[i] as! [AnyObject]
                    if newObject[0] as! String == "add" || newObject[0] as! String == "neg"
                    {
                        resultString += "("
                        resultString += produceStringFromFunctionStructure(tmpFuncStr[i] as AnyObject,varList)
                        resultString += ")"
                    }
                    else if newObject[0] as! String == "rev"
                    {
                        resultString += "1/"
                        resultString += produceStringFromFunctionStructure(newObject[1], varList)
                    }
                    else
                    {
                        resultString += produceStringFromFunctionStructure(tmpFuncStr[i] as AnyObject,varList)
                    }
                }
                else
                {
                    resultString += produceStringFromFunctionStructure(tmpFuncStr[i] as AnyObject,varList)
                }
                resultString += "*"
                i += 1
            }
            var ifAddQuotes = false
            if ifArray(tmpFuncStr[i])
            {
                var newObject: [AnyObject]! = tmpFuncStr[i] as! [AnyObject]
                if newObject[0] as! String == "add" || newObject[0] as! String == "neg"
                {
                    resultString += "("
                    resultString += produceStringFromFunctionStructure(tmpFuncStr[i] as AnyObject,varList)
                    resultString += ")"
                }
                else
                {
                    resultString += produceStringFromFunctionStructure(tmpFuncStr[i] as AnyObject,varList)
                }
            }
            else
            {
                resultString += produceStringFromFunctionStructure(tmpFuncStr[i] as AnyObject,varList)
            }
        }
        else if functionStr[0] as! String == "rev"
        {
            resultString += "1/"
            resultString += produceStringFromFunctionStructure(functionStr[1] as AnyObject,varList)
            if ifArray(functionStr[1])
            {
                var newObject: [AnyObject]! = functionStr[1] as! [AnyObject]
                if newObject[0] as! String == "+" || newObject[0] as! String == "-"
                {
                    resultString += "("
                    resultString += produceStringFromFunctionStructure(functionStr[1] as AnyObject,varList)
                    resultString += ")"
                }
            }
            else
            {
                return resultString
            }

            
        }
        else if functionStr[0] as! String == "pow"
        {
            var i = 1
            while i < count(functionStr as! [AnyObject] ) - 1
            {
                var ifAddQuotes = false
                if ifArray(functionStr[i])
                {
                    var newObject: [AnyObject]! = functionStr[i] as! [AnyObject]
                    if newObject[0] as! String == "add" || newObject[0] as! String == "neg" || newObject[0] as! String == "produce" || newObject[0] as! String == "rev"
                    {
                        resultString += "("
                        resultString += produceStringFromFunctionStructure(functionStr[i] as AnyObject,varList)
                        resultString += ")"
                    }
                    else
                    {
                        resultString += produceStringFromFunctionStructure(functionStr[i] as AnyObject,varList)
                    }
                }
                else
                {
                    resultString += produceStringFromFunctionStructure(functionStr[i] as AnyObject,varList)
                }
                i += 1
            }
            var ifAddQuotes = false
            if ifArray(functionStr[i])
            {
                resultString += "^"
                var newObject: [AnyObject]! = functionStr[i] as! [AnyObject]
                if newObject[0] as! String == "add" || newObject[0] as! String == "neg" || newObject[0] as! String == "pow" || newObject[0] as! String == "rev"
                {
                    resultString += "("
                    resultString += produceStringFromFunctionStructure(functionStr[i] as AnyObject,varList)
                    resultString += ")"
                }
                else
                {
                    resultString += produceStringFromFunctionStructure(functionStr[i] as AnyObject,varList)
                }
            }
            else
            {
                var added = produceStringFromFunctionStructure(functionStr[i] as AnyObject,varList)
                if !(added as? String == "1")
                {
                    resultString += "^"
                    resultString += added
                }
            }
        }
        else
        {
            resultString += functionStr[0] as! String
            resultString += "("
            var i = 1
            while i < count(functionStr as! [AnyObject]) - 1
            {
                resultString += produceStringFromFunctionStructure(functionStr[i],varList)
                resultString += ","
                i += 1
            }
            resultString += produceStringFromFunctionStructure(functionStr[i], varList)
            resultString += ")"
        }
        
    }
    else
    {
        if ifString(functionStr)
        {
            return functionStr as! String
        }
        else
        {
            return jianLingJiuShan(NSString(format: "%f",(functionStr as! Double)) as String)
        }
    }
    
    return resultString
}


func ifArray(obj:AnyObject)->Bool
{
    if (obj as? [AnyObject]) != nil
    {
        return true
    }
    else
    {
        return false
    }
}

func ifString(obj:AnyObject)->Bool
{
    if (obj as? String) != nil
    {
        return true
    }
    else
    {
        return false
    }
}

func characterAtIndex(thisString:String,index:Int)->String
{
    return (thisString as NSString).substringWithRange(NSMakeRange(index, 1))
}

func cleanAllSpaces(aString:String)->String
{
    var result = ""
    var eachCharacter:String = ""
    var i = 0
    while i < count(aString)
    {
        eachCharacter = characterAtIndex(aString, i)
        if eachCharacter != " "
        {
            result += eachCharacter
        }
        i += 1
    }
    return result
}


func maxInArray(thisArray:[Int])->Int
{
    var current = thisArray[0]
    for i in thisArray
    {
        current = max(i, current)
    }
    return current
}

func findPositionsOfSpecificChar(string1:String,string2:String)->[Int]
{
    var i = 0
    var result:[Int] = []
    while i < count(string1)
    {
        var thisChar = characterAtIndex(string1, i)
        if thisChar == string2
        {
            result.append(i)
        }
    }
    return result
}

func findPositionsOfOuterQuotes(funcString:String)->[Int]
{
    var i = 0
    var result = [0,0]
    while i < count(funcString)
    {
        if(characterAtIndex(funcString, i) == "(")
        {
            result[0] = i
            break
        }
        i += 1
    }
    i = count(funcString) - 1
    while i >= 0
    {
        if characterAtIndex(funcString, i) == ")"
        {
            result[1] = i
            break
        }
        i -= 1
    }
    return result
}

func removeOuterQuotes(funcString:String)->String
{
    var i = 1
    var result = ""
    while i < count(funcString) - 1
    {
        result += characterAtIndex(funcString, i)
        i += 1
    }
    return result
}

func ifContain(thisString:String,array:[String])->Bool
{
    for eachStirng in array
    {
        if eachStirng == thisString
        {
            return true
        }
    }
    return false
}

func ifTermsSame(term1:AnyObject,term2:AnyObject)->Bool
{
    if (ifArray(term1) && !ifArray(term2)) || (!ifArray(term1) && ifArray(term2))
    {
        return false
    }
    else
    {
        if (ifArray(term1))
        {
            if(term1 as! [AnyObject]).count == (term2 as! [AnyObject]).count
            {
                if term1[0] as! String == "product" && term2[0] as! String == "add"
                {
                    var tmpTerm2 = term2 as! [AnyObject]
                    var i = 0
                    while i < (term1 as! [AnyObject]).count
                    {
                        var this:AnyObject = (term1 as! [AnyObject])[i]
                        var currentIndex = termInArray(this,tmpTerm2 as [AnyObject])
                        if (currentIndex != -1)
                        {
                            tmpTerm2.removeAtIndex(currentIndex)
                        }
                        else
                        {
                            return false
                        }
                        i += 1
                    }
                    return true
                }
                else if (term1[0] as! String == "pow" || term2[0] as! String == "log") && term1[0] as! String == term2[0] as! String
                {
                    return ifTermsSame(term1[1], term2[1]) && ifTermsSame(term1[2], term2[2])
                }
                else if (term1[0] as! String == term2[0] as! String)
                {
                    return ifTermsSame(term1[1], term2[1])
                }
                else
                {
                    return false
                }
            }
            else
            {
                return false
            }
        }
        else
        {
            if term1 is String && term2 is String && term1 as! String == term2 as! String
            {
                return true
            }
            else if term1 is Double && term2 is Double && term1 as! Double == term2 as! Double {
                return true
            }
            else
            {
                return false
            }
        }
    }
}

func termInArray(term:AnyObject,inArray:[AnyObject])->Int
{
    var i = 0
    while i < inArray.count
    {
        if ifTermsSame(inArray[i], term)
        {
            return i
        }
        i += 1
    }
    return -1
}

func sortArrayOnlyToElementsOrder (this: [AnyObject]) -> [AnyObject] {
    var exprWithArrays = this.filter({ifArray($0)}) as! [[AnyObject]]
    var result = [exprWithArrays[0]] as [[AnyObject]]
    exprWithArrays.removeAtIndex(0)
    for i in exprWithArrays {
        if ifTermsSame(i, result[result.count - 1]) {
            result.append(i)
        }
        else {
            var found = false
            for j in result {
                if ifTermsSame(j, i) {
                    result.insert(i, atIndex: (result as NSArray).indexOfObject(j))
                    found = true
                    break
                }
            }
            if !found {
                result.insert(i, atIndex: 0)
            }
        }
    }
    result.reverse()
    return result
}

func sortNonArrayOnlyToElementsOrder (this: [AnyObject]) -> [AnyObject] {
    var exprWithoutArrays = this.filter({!ifArray($0)})
    var result = [exprWithoutArrays[0]]
    exprWithoutArrays.removeAtIndex(0)
    for i in exprWithoutArrays {
        if ifTermsSame(i, result[result.count - 1]) {
            result.append(i)
        }
        else {
            var found = false
            for j in result {
                if ifTermsSame(j, i) {
                    result.insert(i, atIndex: (result as NSArray).indexOfObject(j))
                    found = true
                    break
                }
            }
            if !found {
                result.insert(i, atIndex: 0)
            }
        }
    }
    result.reverse()
    return result
}

func sortToElementsOrder (this: [AnyObject]) -> [AnyObject] {
    var exprWithoutArrays = this.filter({!ifArray($0)})
    var exprWithArrays = this.filter({ifArray($0)})
    var result = [AnyObject]()
    if !(exprWithoutArrays.isEmpty) {
        for i in sortNonArrayOnlyToElementsOrder(exprWithoutArrays) {
            result.append(i)
        }
    }
    if !(exprWithArrays.isEmpty) {
        for i in sortArrayOnlyToElementsOrder(exprWithArrays) {
            result.append(i)
        }
    }
    return result
}



//TODO: gaicheng numbers
infix operator ** {}

func ** (a1: Double, a2: Int) -> Double {
    return pow(a1, (a2 as NSNumber).doubleValue)
}

func sqrt (n: Double) -> Double {
    return pow(n, 0.5)
}

func accompArray (mat: [[Double]], coor: Int) -> [[Double]] {
    var this = mat
    this.removeAtIndex(0)
    var result = [[Double]]()
    for i in this {
        var tmp = i
        tmp.removeAtIndex(coor)
        result.append(tmp)
    }
    return result
}

func det (mat: [[Double]]) -> Double {
    if mat.count == 2 {
        return (mat[0][0]*mat[1][1] - mat[1][0] * mat[0][1])
    }
    else {
        var result = 0.0
        var counter : Int = 0
        while counter < mat.count {
            if counter%2 == 0 {
                result += mat[0][counter] * det(accompArray(mat, counter))
            }
            else {
                result -= mat[0][counter] * det(accompArray(mat, counter))
            }
            counter += 1
        }
        return result
    }
}



//===========
func simp (f: [Double]) -> [Double] {
    if f.last == 0 {
        var c = f
        c.removeLast()
        return simp(c)
    }
    else {
        return f
    }
}

func fgcd (f1: Double, f2: Double) -> Double {
    if f1 % f2 == 0 {
        return f1
    }
    else {
        return fgcd(f2, f1 % f2)
    }
}

func DIV (p1: [Double], p2: [Double]) -> [Double] {
    var x = Functions(function: "x",varList:["x"])
    var (div, _) = x.polynomialDivision(p1, smaller: p2)
    return div
}

func jianLingJiuShan(thisDouble:String)->String
{
    var i:Int = (thisDouble as NSString).length - 1;
    var thisChar:String = "0"
    while thisChar == "0" && i >= 0
    {
        thisChar = (thisDouble as NSString).substringWithRange(NSMakeRange(i, 1))
        i -= 1
    }
    if thisChar != "."
    {
        i += 1
    }
    return (thisDouble as NSString).substringWithRange(NSMakeRange(0, i+1))
}
//func fToInt (n: Double) -> Int {
//    if n <= 1.0e-8 {
//        return 0
//    }
//    var temp = "\(n)" as NSString
//    var loc = temp.rangeOfString(".").location
//    var ttemp = temp.substringToIndex(loc)
//    ttemp += (temp.substringFromIndex(loc+1)) as String
//    return (ttemp as String).toInt()!
////    return temp.toInt()!
//}