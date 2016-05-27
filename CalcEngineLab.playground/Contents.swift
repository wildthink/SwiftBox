//: Playground - noun: a place where people can play

import Cocoa
import JavaScriptCore


class Cell : NSObject
{
    var name: String!
    weak var engine: CalcEngine?
    private var _cache: Double?

    var value: Double {
        get { return _cache ?? 0 }
        set(v) {
            _cache = v
            engine?.needsRecalculation = true
        }
    }
    
    func clear() {
        _cache = nil
    }
}

class CalcEngine: NSObject
{
    var cells = [String: Cell]()
    var needsRecalculation = false
    
    func clearAllValues() {
        cells.values.map { $0.clear() }
    }
}

//@objc(ScriptEngineExports)

@objc public protocol ScriptEngineExports : JSExport {
    func display(text: String)
    func doit() -> Int
}

@objc public class ScriptEngine : NSObject, ScriptEngineExports {
    var context: JSContext!
    let engineQueue = dispatch_queue_create(
        "script_engine", DISPATCH_QUEUE_SERIAL)
    
    override init() {
        super.init()
        
        dispatch_async(engineQueue) {
            self.context = JSContext()
            self.context.setObject(self, forKeyedSubscript: "$")
            
            let result = self.context.evaluateScript(
                    "function print(text) {$.display(text);};" +
                    "function println(text) {$.display(text); return text; };")
            print (result)
            
//            let mult = { (o: AnyObject, p: AnyObject)-> AnyObject? in
//                if let x = o as? Double {
//                    if let y = p as? Double {
//                        return x * y
//                    }
//                }
//                return nil
//            }
//            
//            self.context.setObject(mult, forKeyedSubscript:"multiply")
        }
    }
    
    @objc (display:)
    dynamic public func display (text: String) {
        print(text)
    }

    public func doit() -> Int {
        return 23
    }
    
    func run (text: String) {
        let result = context.evaluateScript(text)
        print (result)
    }
}


let engine = ScriptEngine()
engine.run ("print('hi there'")

public class JSCore : JSContext, ScriptEngineExports
{
    public class func newContext() -> JSCore
    {
        let context = JSCore(virtualMachine: JSVirtualMachine())
        
        context.setObject(self, forKeyedSubscript: "$")

        let sum : @convention(block) (Int, Int) -> Int = {
            (x: Int, y:Int) -> Int in
            return x + y
        }
        
        let sumObj : AnyObject = unsafeBitCast(sum, AnyObject.self)
        context.setObject(sumObj, forKeyedSubscript: "sum")
        
        return context
    }
    
    @objc (display:)
    dynamic public func display (text: String) {
        print(text)
    }
    
    @objc public func doit() -> Int {
        print ("will do it")
        return 23
    }

    public func run(js : String) -> AnyObject {
        let result = self.evaluateScript(js) as JSValue!
        if result.isObject {
            return result.toObject()
        } else if result.isBoolean {
            return Bool(result.toBool())
        } else if result.isString {
            return result.toString()
        } else if result.isNumber {
            return result.toNumber()
        }
        return ""
    }
}

let jc = JSCore.newContext()
jc.run("sum (1, 2, 3)")
jc.run ("$.doit()")

