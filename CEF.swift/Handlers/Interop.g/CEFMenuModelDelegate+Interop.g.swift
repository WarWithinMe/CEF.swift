//
//  CEFMenuModelDelegate+Interop.g.swift
//  CEF.swift
//
//  This file was generated automatically from cef_menu_model_delegate.h.
//

import Foundation

extension cef_menu_model_delegate_t: CEFObject {}

typealias CEFMenuModelDelegateMarshaller = CEFMarshaller<CEFMenuModelDelegate, cef_menu_model_delegate_t>

extension CEFMenuModelDelegate {
    func toCEF() -> UnsafeMutablePointer<cef_menu_model_delegate_t> {
        return CEFMenuModelDelegateMarshaller.pass(self)
    }
}

extension cef_menu_model_delegate_t: CEFCallbackMarshalling {
    mutating func marshalCallbacks() {
        execute_command = CEFMenuModelDelegate_execute_command
        mouse_outside_menu = CEFMenuModelDelegate_mouse_outside_menu
        unhandled_open_submenu = CEFMenuModelDelegate_unhandled_open_submenu
        unhandled_close_submenu = CEFMenuModelDelegate_unhandled_close_submenu
        menu_will_show = CEFMenuModelDelegate_menu_will_show
        menu_closed = CEFMenuModelDelegate_menu_closed
        format_label = CEFMenuModelDelegate_format_label
    }
}
