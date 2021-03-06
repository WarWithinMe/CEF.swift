//
//  CEFPrintDialogCallback+Interop.g.swift
//  CEF.swift
//
//  This file was generated automatically from cef_print_handler.h.
//

import Foundation

extension cef_print_dialog_callback_t: CEFObject {}

/// Callback interface for asynchronous continuation of print dialog requests.
/// CEF name: `CefPrintDialogCallback`
public final class CEFPrintDialogCallback: CEFProxy<cef_print_dialog_callback_t> {
    override init?(ptr: UnsafeMutablePointer<cef_print_dialog_callback_t>?) {
        super.init(ptr: ptr)
    }
    
    static func fromCEF(_ ptr: UnsafeMutablePointer<cef_print_dialog_callback_t>?) -> CEFPrintDialogCallback? {
        return CEFPrintDialogCallback(ptr: ptr)
    }
}

