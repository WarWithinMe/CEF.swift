//
//  CEFWebPluginInfo+Interop.g.swift
//  CEF.swift
//
//  This file was generated automatically from cef_web_plugin.h.
//

import Foundation

extension cef_web_plugin_info_t: CEFObject {}

/// Information about a specific web plugin.
/// CEF name: `CefWebPluginInfo`
public final class CEFWebPluginInfo: CEFProxy<cef_web_plugin_info_t> {
    override init?(ptr: UnsafeMutablePointer<cef_web_plugin_info_t>?) {
        super.init(ptr: ptr)
    }
    
    static func fromCEF(_ ptr: UnsafeMutablePointer<cef_web_plugin_info_t>?) -> CEFWebPluginInfo? {
        return CEFWebPluginInfo(ptr: ptr)
    }
}

