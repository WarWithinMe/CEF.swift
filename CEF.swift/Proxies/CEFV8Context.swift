//
//  CEFV8Context.swift
//  CEF.swift
//
//  Created by Tamas Lustyik on 2015. 07. 31..
//  Copyright © 2015. Tamas Lustyik. All rights reserved.
//

import Foundation

public extension CEFV8Context {
    
    /// Returns the current (top) context object in the V8 context stack.
    /// CEF name: `GetCurrentContext`
    public static var current: CEFV8Context? {
        let cefCtx = cef_v8context_get_current_context()
        return CEFV8Context.fromCEF(cefCtx)
    }
    
    /// Returns the entered (bottom) context object in the V8 context stack.
    /// CEF name: `GetEnteredContext`
    public static var entered: CEFV8Context? {
        let cefCtx = cef_v8context_get_entered_context()
        return CEFV8Context.fromCEF(cefCtx)
    }

    /// Returns true if V8 is currently inside a context.
    /// CEF name: `InContext`
    public static var isV8InContext: Bool {
        return cef_v8context_in_context() != 0
    }

    /// Returns the task runner associated with this context. V8 handles can only
    /// be accessed from the thread on which they are created. This method can be
    /// called on any render process thread.
    /// CEF name: `GetTaskRunner`
    public var taskRunner: CEFTaskRunner? {
        let cefTaskRunner = cefObject.get_task_runner(cefObjectPtr)
        return CEFTaskRunner.fromCEF(cefTaskRunner)
    }
    
    /// Returns true if the underlying handle is valid and it can be accessed on
    /// the current thread. Do not call any other methods if this method returns
    /// false.
    /// CEF name: `IsValid`
    public var isValid: Bool {
        return cefObject.is_valid(cefObjectPtr) != 0
    }

    /// Returns the browser for this context. This method will return an empty
    /// reference for WebWorker contexts.
    /// CEF name: `GetBrowser`
    public var browser: CEFBrowser? {
        let cefBrowser = cefObject.get_browser(cefObjectPtr)
        return CEFBrowser.fromCEF(cefBrowser)
    }

    /// Returns the frame for this context. This method will return an empty
    /// reference for WebWorker contexts.
    /// CEF name: `GetFrame`
    public var frame: CEFFrame? {
        let cefFrame = cefObject.get_frame(cefObjectPtr)
        return CEFFrame.fromCEF(cefFrame)
    }
    
    /// Returns the global object for this context. The context must be entered
    /// before calling this method.
    /// CEF name: `GetGlobal`
    public var globalObject: CEFV8Value? {
        let cefValue = cefObject.get_global(cefObjectPtr)
        return CEFV8Value.fromCEF(cefValue)
    }
    
    /// Enter this context. A context must be explicitly entered before creating a
    /// V8 Object, Array, Function or Date asynchronously. Exit() must be called
    /// the same number of times as Enter() before releasing this context. V8
    /// objects belong to the context in which they are created. Returns true if
    /// the scope was entered successfully.
    /// CEF name: `Enter`
    @discardableResult
    public func enter() -> Bool {
        return cefObject.enter(cefObjectPtr) != 0
    }

    /// Exit this context. Call this method only after calling Enter(). Returns
    /// true if the scope was exited successfully.
    /// CEF name: `Exit`
    @discardableResult
    public func exit() -> Bool {
        return cefObject.exit(cefObjectPtr) != 0
    }
    
    /// Returns true if this object is pointing to the same handle as |that|
    /// object.
    /// CEF name: `IsSame`
    public func isSame(as other: CEFV8Context) -> Bool {
        return cefObject.is_same(cefObjectPtr, other.toCEF()) != 0
    }

    /// Execute a string of JavaScript code in this V8 context. The |script_url|
    /// parameter is the URL where the script in question can be found, if any.
    /// The |start_line| parameter is the base line number to use for error
    /// reporting. On success |retval| will be set to the return value, if any, and
    /// the function will return true. On failure |exception| will be set to the
    /// exception, if any, and the function will return false.
    /// CEF name: `Eval`
    public func eval(_ code: String,
                     scriptURL: URL? = nil,
                     startLine: Int = 1) -> CEFV8EvalResult {
        let cefCodePtr = CEFStringPtrCreateFromSwiftString(code)
        defer { CEFStringPtrRelease(cefCodePtr) }
        let cefURLPtr = scriptURL != nil ? CEFStringPtrCreateFromSwiftString(scriptURL!.absoluteString) : nil
        defer { CEFStringPtrRelease(cefURLPtr) }
        
        var cefRetval: UnsafeMutablePointer<cef_v8value_t>? = nil
        var cefExc: UnsafeMutablePointer<cef_v8exception_t>? = nil
        let result = cefObject.eval(cefObjectPtr, cefCodePtr, cefURLPtr, Int32(startLine), &cefRetval, &cefExc)
        
        if result != 0 {
            return .success(CEFV8Value.fromCEF(cefRetval)!)
        }
        
        return .failure(CEFV8Exception.fromCEF(cefExc)!)
    }
    
}

