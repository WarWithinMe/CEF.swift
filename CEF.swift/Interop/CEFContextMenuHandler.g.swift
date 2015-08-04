//
//  CEFContextMenuHandler.g.swift
//  CEF.swift
//
//  Created by Tamas Lustyik on 2015. 08. 04..
//  Copyright © 2015. Tamas Lustyik. All rights reserved.
//

import Foundation


extension cef_context_menu_handler_t: CEFObject {
}

typealias CEFContextMenuHandlerMarshaller = CEFMarshaller<CEFContextMenuHandler, cef_context_menu_handler_t>

extension CEFContextMenuHandler {
    func toCEF() -> UnsafeMutablePointer<cef_context_menu_handler_t> {
        return CEFContextMenuHandlerMarshaller.pass(self)
    }
}

extension cef_context_menu_handler_t: CEFCallbackMarshalling {
    mutating func marshalCallbacks() {
        on_before_context_menu = CEFContextMenuHandler_onBeforeContextMenu
        on_context_menu_command = CEFContextMenuHandler_onContextMenuCommand
        on_context_menu_dismissed = CEFContextMenuHandler_onContextMenuDismissed
    }
}

func CEFContextMenuHandler_onBeforeContextMenu(ptr: UnsafeMutablePointer<cef_context_menu_handler_t>,
                                               browser: UnsafeMutablePointer<cef_browser_t>,
                                               frame: UnsafeMutablePointer<cef_frame_t>,
                                               params: UnsafeMutablePointer<cef_context_menu_params_t>,
                                               model: UnsafeMutablePointer<cef_menu_model_t>) {
    guard let obj = CEFContextMenuHandlerMarshaller.get(ptr) else {
        return
    }

    obj.onBeforeContextMenu(CEFBrowser.fromCEF(browser)!,
                            frame: CEFFrame.fromCEF(frame)!,
                            params: CEFContextMenuParams.fromCEF(params)!,
                            model: CEFMenuModel.fromCEF(model)!)
}


func CEFContextMenuHandler_onContextMenuCommand(ptr: UnsafeMutablePointer<cef_context_menu_handler_t>,
                                                browser: UnsafeMutablePointer<cef_browser_t>,
                                                frame: UnsafeMutablePointer<cef_frame_t>,
                                                params: UnsafeMutablePointer<cef_context_menu_params_t>,
                                                commandID: Int32,
                                                eventFlags: cef_event_flags_t) -> Int32 {
    guard let obj = CEFContextMenuHandlerMarshaller.get(ptr) else {
        return 0
    }

    return obj.onContextMenuCommand(CEFBrowser.fromCEF(browser)!,
                                    frame: CEFFrame.fromCEF(frame)!,
                                    params: CEFContextMenuParams.fromCEF(params)!,
                                    commandID: CEFMenuID.fromCEF(commandID),
                                    eventFlags: CEFEventFlags.fromCEF(eventFlags)) ? 1 : 0
}

func CEFContextMenuHandler_onContextMenuDismissed(ptr: UnsafeMutablePointer<cef_context_menu_handler_t>,
                                                  browser: UnsafeMutablePointer<cef_browser_t>,
                                                  frame: UnsafeMutablePointer<cef_frame_t>) {
    guard let obj = CEFContextMenuHandlerMarshaller.get(ptr) else {
        return
    }

    obj.onContextMenuDismissed(CEFBrowser.fromCEF(browser)!, frame: CEFFrame.fromCEF(frame)!)
}

