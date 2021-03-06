//
//  CEFDownloadItemCallback+Interop.g.swift
//  CEF.swift
//
//  This file was generated automatically from cef_download_handler.h.
//

import Foundation

extension cef_download_item_callback_t: CEFObject {}

/// Callback interface used to asynchronously cancel a download.
/// CEF name: `CefDownloadItemCallback`
public final class CEFDownloadItemCallback: CEFProxy<cef_download_item_callback_t> {
    override init?(ptr: UnsafeMutablePointer<cef_download_item_callback_t>?) {
        super.init(ptr: ptr)
    }
    
    static func fromCEF(_ ptr: UnsafeMutablePointer<cef_download_item_callback_t>?) -> CEFDownloadItemCallback? {
        return CEFDownloadItemCallback(ptr: ptr)
    }
}

