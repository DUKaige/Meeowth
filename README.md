README

            else if !ifArray(expr[1]) && !ifArray(expr[2]) {

                if expr[1] is String && expr[1] as! String == vari {

                    if expr[2] is Double {

                        expr = ["product",expr[2] as! Double,["pow",expr[1],expr[2] as! Double - 1]]

                    }

                    else {

                        expr = ["product",["pow",expr[1],expr[1]],["add",1,["ln","x"]]]

                    }

                }

                else if expr[1] is String && expr[1] as! String != vari {

                    expr = ["add",0,0]

                }

                else if expr[1] is Double {

                    if expr[2] is String {

                        expr = ["product",["pow", expr[1],expr[2]],log(expr[1] as! Double)]

                    }

                    else {

                        expr = ["add",0,0]

                    }

                }

            }



 你把这个替换到deriv里的pow

else if !ifArray(expr[1]) && !ifArray(expr[2])这一句再找找bug

            else if power is Int {

                var temp = [AnyObject]()

                for i in 1...(power as! Int) {

                    temp.append(base)

                }

                return combine(reduceRedundant(temp))

            }

            else {

                return this

            }



把combine的pow部分的else

改成这个试试