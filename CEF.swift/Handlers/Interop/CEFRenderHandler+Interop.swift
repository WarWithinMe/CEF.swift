//
//  CEFRenderHandler.g.swift
//  CEF.swift
//
//  Created by Tamas Lustyik on 2015. 08. 11..
//  Copyright © 2015. Tamas Lustyik. All rights reserved.
//

import Foundation

func CEFRenderHandler_get_accessibility_handler(ptr: UnsafeMutablePointer<cef_render_handler_t>?) -> UnsafeMutablePointer<cef_accessibility_handler_t>? {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return nil
    }

    if let handler = obj.accessibilityHandler {
        return handler.toCEF()
    }

    return nil
}

func CEFRenderHandler_get_root_screen_rect(ptr: UnsafeMutablePointer<cef_render_handler_t>?,
                                           browser: UnsafeMutablePointer<cef_browser_t>?,
                                           cefRect: UnsafeMutablePointer<cef_rect_t>?) -> Int32 {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return 0
    }

    let rect = obj.rootScreenRectForBrowser(browser: CEFBrowser.fromCEF(browser)!)
    if let rect = rect {
        cefRect!.pointee = rect.toCEF()
    }
    
    return rect != nil ? 1 : 0
}

func CEFRenderHandler_get_view_rect(ptr: UnsafeMutablePointer<cef_render_handler_t>?,
                                    browser: UnsafeMutablePointer<cef_browser_t>?,
                                    cefRect: UnsafeMutablePointer<cef_rect_t>?) -> Int32 {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return 0
    }

    let rect = obj.viewRectForBrowser(browser: CEFBrowser.fromCEF(browser)!)
    if let rect = rect {
        cefRect!.pointee = rect.toCEF()
    }
    
    return rect != nil ? 1 : 0
}

func CEFRenderHandler_get_screen_point(ptr: UnsafeMutablePointer<cef_render_handler_t>?,
                                       browser: UnsafeMutablePointer<cef_browser_t>?,
                                       viewX: Int32,
                                       viewY: Int32,
                                       screenX: UnsafeMutablePointer<Int32>?,
                                       screenY: UnsafeMutablePointer<Int32>?) -> Int32 {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return 0
    }
    
    let point = obj.screenPointForBrowser(browser: CEFBrowser.fromCEF(browser)!,
                                          viewPoint: NSPoint(x: Int(viewX), y: Int(viewY)))
    if let point = point {
        screenX!.pointee = Int32(point.x)
        screenY!.pointee = Int32(point.y)
    }
    
    return point != nil ? 1 : 0
}

func CEFRenderHandler_get_screen_info(ptr: UnsafeMutablePointer<cef_render_handler_t>?,
                                      browser: UnsafeMutablePointer<cef_browser_t>?,
                                      cefInfo: UnsafeMutablePointer<cef_screen_info_t>?) -> Int32 {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return 0
    }
    
    let info = obj.screenInfoForBrowser(browser: CEFBrowser.fromCEF(browser)!)
    if let info = info {
        cefInfo!.pointee = info.toCEF()
    }
    
    return info != nil ? 1 : 0
}

func CEFRenderHandler_on_popup_show(ptr: UnsafeMutablePointer<cef_render_handler_t>?,
                                    browser: UnsafeMutablePointer<cef_browser_t>?,
                                    showing: Int32) {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return
    }
    
    obj.onPopupTransition(browser: CEFBrowser.fromCEF(browser)!, willShow: showing != 0)
}

func CEFRenderHandler_on_popup_size(ptr: UnsafeMutablePointer<cef_render_handler_t>?,
                                    browser: UnsafeMutablePointer<cef_browser_t>?,
                                    rect: UnsafePointer<cef_rect_t>?) {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return
    }
    
    obj.onPopupRectChange(browser: CEFBrowser.fromCEF(browser)!, newRect: NSRect.fromCEF(rect!.pointee))
}

func CEFRenderHandler_on_paint(ptr: UnsafeMutablePointer<cef_render_handler_t>?,
                               browser: UnsafeMutablePointer<cef_browser_t>?,
                               type: cef_paint_element_type_t,
                               rectCount: size_t,
                               cefRects: UnsafePointer<cef_rect_t>?,
                               buffer: UnsafeRawPointer?,
                               width: Int32,
                               height: Int32) {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return
    }
    
    var rects = [NSRect]()
    for i in 0..<rectCount {
        rects.append(NSRect.fromCEF(cefRects!.advanced(by: i).pointee))
    }
    
    obj.onPaint(browser: CEFBrowser.fromCEF(browser)!,
                type: CEFPaintElementType.fromCEF(type),
                dirtyRects: rects,
                buffer: buffer!,
                size: NSSize(width: Int(width), height: Int(height)))
}

func CEFRenderHandler_on_cursor_change(ptr: UnsafeMutablePointer<cef_render_handler_t>?,
                                       browser: UnsafeMutablePointer<cef_browser_t>?,
                                       cursor: UnsafeMutableRawPointer?,
                                       type: cef_cursor_type_t,
                                       info: UnsafePointer<cef_cursor_info_t>?) {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return
    }
    
    obj.onCursorChange(browser: CEFBrowser.fromCEF(browser)!,
                       cursor: Unmanaged<CEFCursorHandle>.fromOpaque(cursor!).takeUnretainedValue(),
                       type: CEFCursorType.fromCEF(type),
                       cursorInfo: info != nil ? CEFCursorInfo.fromCEF(info!.pointee) : nil)
}

func CEFRenderHandler_start_dragging(ptr: UnsafeMutablePointer<cef_render_handler_t>?,
                                     browser: UnsafeMutablePointer<cef_browser_t>?,
                                     dragData: UnsafeMutablePointer<cef_drag_data_t>?,
                                     opMask: cef_drag_operations_mask_t,
                                     x: Int32,
                                     y: Int32) -> Int32 {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return 0
    }
    
    let action = obj.onStartDragging(browser: CEFBrowser.fromCEF(browser)!,
                                     dragData: CEFDragData.fromCEF(dragData)!,
                                     operationMask: CEFDragOperationsMask.fromCEF(opMask),
                                     location: NSPoint(x: Int(x), y: Int(y)))
    return action == .allow ? 1 : 0
}

func CEFRenderHandler_update_drag_cursor(ptr: UnsafeMutablePointer<cef_render_handler_t>?,
                                         browser: UnsafeMutablePointer<cef_browser_t>?,
                                         opMask: cef_drag_operations_mask_t) {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return
    }
    
    obj.onUpdateDragCursor(browser: CEFBrowser.fromCEF(browser)!, operation: CEFDragOperationsMask.fromCEF(opMask))
}

func CEFRenderHandler_on_scroll_offset_changed(ptr: UnsafeMutablePointer<cef_render_handler_t>?,
                                               browser: UnsafeMutablePointer<cef_browser_t>?,
                                               x: Double,
                                               y: Double) {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return
    }
    
    obj.onScrollOffsetChanged(browser: CEFBrowser.fromCEF(browser)!, offset: NSPoint(x: x, y: y))
}

func CEFRenderHandler_on_ime_composition_range_changed(ptr: UnsafeMutablePointer<cef_render_handler_t>?,
                                                       browser: UnsafeMutablePointer<cef_browser_t>?,
                                                       selectedRange: UnsafePointer<cef_range_t>?,
                                                       rectCount: size_t,
                                                       charRects: UnsafePointer<cef_rect_t>?) {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return
    }

    var rects = [NSRect]()
    for i in 0..<rectCount {
        rects.append(NSRect.fromCEF(charRects!.advanced(by: i).pointee))
    }

    obj.onIMECompositionRangeChanged(browser: CEFBrowser.fromCEF(browser)!,
                                     selectedRange: CEFRange.fromCEF(selectedRange!.pointee),
                                     characterBounds: rects)
}

func CEFRenderHandler_on_text_selection_changed(ptr: UnsafeMutablePointer<cef_render_handler_t>?,
                                                browser: UnsafeMutablePointer<cef_browser_t>?,
                                                selectedText: UnsafePointer<cef_string_t>?,
                                                selectedRange: UnsafePointer<cef_range_t>?) {
    guard let obj = CEFRenderHandlerMarshaller.get(ptr) else {
        return
    }

    var selection: CEFTextSelection?
    if let text = selectedText, let range = selectedRange {
        selection = CEFTextSelection(text: CEFStringToSwiftString(text.pointee),
                                     range: CEFRange.fromCEF(range.pointee))
    }
    
    obj.onTextSelectionChanged(browser: CEFBrowser.fromCEF(browser)!,
                               selection: selection)
}
