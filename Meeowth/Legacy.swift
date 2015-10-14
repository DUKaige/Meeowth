



//    func performeOperation (this: [AnyObject], operation: String) -> [AnyObject] {
//        var result: [AnyObject]
//        switch operation {
//        case "add", "product":
//            var expr = self.sort_type(this)
//            var numbers = expr.filter({ $0 is Int || $0 is Double })
//            var remains = expr.filter({ !($0 is Int) && !($0 is Double) })
//            result = operationDict[operation]!(numbers)
//            for i in remains {
//                result.append(i)
//            }
//            break
//        case "sin", "cos", "tan", "exp", "ln", "log2", "log10", "rev", "neg", "logb":
//            if this is [Double] {
//                result = operationDict[operation]!(this)
//            } else {
//                result = [operation, this]
//            }
//        default:
//            result = ["Not Implemented Yet"]
//        }
//        return result
//    }



//                else if i as! String == "sin" {
//                    var result = 0.0
//                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
//                        result = sin(produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList))
//                    }
//                    else {
//                        result = sin(expr[(expr as NSArray).indexOfObject(i) + 1] as! Double)
//                    }
//                    return result
//                }
//                else if i as! String == "cos" {
//                    var result = 0.0
//                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
//                        result = cos(produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList))
//                    }
//                    else {
//                        result = cos(expr[(expr as NSArray).indexOfObject(i) + 1] as! Double)
//                    }
//                    return result
//                }
//                else if i as! String == "tan" {
//                    var result = 0.0
//                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
//                        result = tan(produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList))
//                    }
//                    else {
//                        result = tan(expr[(expr as NSArray).indexOfObject(i) + 1] as! Double)
//                    }
//                    return result
//                }
//                else if i as! String == "sec" {
//                    var result = 0.0
//                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
//                        result = 1.0/cos(produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList))
//                    }
//                    else {
//                        result = 1.0/cos(expr[(expr as NSArray).indexOfObject(i) + 1] as! Double)
//                    }
//                    return result
//                }
//                else if i as! String == "csc" {
//                    var result = 0.0
//                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
//                        result = 1/sin(produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList))
//                    }
//                    else {
//                        result = 1/sin(expr[(expr as NSArray).indexOfObject(i) + 1] as! Double)
//                    }
//                    return result
//                }
//                else if i as! String == "cot" {
//                    var result = 0.0
//                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
//                        result = 1/tan(produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList))
//                    }
//                    else {
//                        result = 1/tan(expr[(expr as NSArray).indexOfObject(i) + 1] as! Double)
//                    }
//                    return result
//                }
//                else if i as! String == "exp" {
//                    var result = 0.0
//                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
//                        result = exp(produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList))
//                    }
//                    else {
//                        result = exp(expr[(expr as NSArray).indexOfObject(i) + 1] as! Double)
//                    }
//                    return result
//                }
//                else if i as! String == "ln" {
//                    var result = 0.0
//                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
//                        result = log(produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList))
//                    }
//                    else {
//                        result = log(expr[(expr as NSArray).indexOfObject(i) + 1] as! Double)
//                    }
//                    return result
//                }
//                else if i as! String == "log2" {
//                    var result = 0.0
//                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
//                        result = log2(produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList))
//                    }
//                    else {
//                        result = log2(expr[(expr as NSArray).indexOfObject(i) + 1] as! Double)
//                    }
//                    return result
//                }
//                else if i as! String == "log10" {
//                    var result = 0.0
//                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
//                        result = log10(produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList))
//                    }
//                    else {
//                        result = log10(expr[(expr as NSArray).indexOfObject(i) + 1] as! Double)
//                    }
//                    return result
//                }
//                else if i as! String == "neg" {
//                    var result = 0.0
//                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
//                        result = -(produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList))
//                    }
//                    else {
//                        result = -(expr[(expr as NSArray).indexOfObject(i) + 1] as! Double)
//                    }
//                    return result
//                }
//                else if i as! String == "rev" {
//                    var result = 0.0
//                    if ifArray(expr[(expr as NSArray).indexOfObject(i) + 1]) {
//                        result = 1/(produceValueFromStructureAlgo(expr[(expr as NSArray).indexOfObject(i) + 1] as! [AnyObject], varList: varList))
//                    }
//                    else {
//                        result = 1/(expr[(expr as NSArray).indexOfObject(i) + 1] as! Double)
//                    }
//                    return result
//                }

//
//private func sort_type (this: [AnyObject]) -> [AnyObject] {
//    var result      = this.filter({$0 is Int || $0 is Double})
//    var remains     = this.filter({!($0 is Int) && !($0 is Double)})
//    for i in remains {
//        result.append(i)
//    }
//    return result
//}