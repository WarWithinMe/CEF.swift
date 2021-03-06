//
//  CEFV8StackTrace+Interop.g.swift
//  CEF.swift
//
//  This file was generated automatically from cef_v8.h.
//

import Foundation

extension cef_v8stack_trace_t: CEFObject {}

/// Class representing a V8 stack trace handle. V8 handles can only be accessed
/// from the thread on which they are created. Valid threads for creating a V8
/// handle include the render process main thread (TID_RENDERER) and WebWorker
/// threads. A task runner for posting tasks on the associated thread can be
/// retrieved via the CefV8Context::GetTaskRunner() method.
/// CEF name: `CefV8StackTrace`
public final class CEFV8StackTrace: CEFProxy<cef_v8stack_trace_t> {
    override init?(ptr: UnsafeMutablePointer<cef_v8stack_trace_t>?) {
        super.init(ptr: ptr)
    }
    
    static func fromCEF(_ ptr: UnsafeMutablePointer<cef_v8stack_trace_t>?) -> CEFV8StackTrace? {
        return CEFV8StackTrace(ptr: ptr)
    }
}

