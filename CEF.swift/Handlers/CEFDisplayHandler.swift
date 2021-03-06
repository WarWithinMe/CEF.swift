//
//  CEFDisplayHandler.swift
//  CEF.swift
//
//  Created by Tamas Lustyik on 2015. 08. 07..
//  Copyright © 2015. Tamas Lustyik. All rights reserved.
//

import Foundation

public enum CEFOnConsoleMessageAction {
    case show
    case ignore
}

public enum CEFOnTooltipAction {
    case showDefault(String)
    case showCustom
}

public enum CEFOnAutoResizeAction {
    /// Treat event as handled
    case consume
    
    /// Fall back to default behavior
    case performDefault
}

/// Implement this interface to handle events related to browser display state.
/// The methods of this class will be called on the UI thread.
/// CEF name: `CefDisplayHandler`
public protocol CEFDisplayHandler {
    /// Called when a frame's address has changed.
    /// CEF name: `OnAddressChange`
    func onAddressChange(browser: CEFBrowser, frame: CEFFrame, url: URL)
    
    /// Called when the page title changes.
    /// CEF name: `OnTitleChange`
    func onTitleChange(browser: CEFBrowser, title: String)
    
    /// Called when the page icon changes.
    /// CEF name: `OnFaviconURLChange`
    func onFaviconURLChange(browser: CEFBrowser, iconURLs: [URL]?)
    
    /// Called when web content in the page has toggled fullscreen mode. If
    /// |fullscreen| is true (1) the content will automatically be sized to fill
    /// the browser content area. If |fullscreen| is false (0) the content will
    /// automatically return to its original size and position. The client is
    /// responsible for resizing the browser if desired.
    /// CEF name: `OnFullscreenModeChange`
    func onFullscreenModeChange(browser: CEFBrowser, fullscreen: Bool)
    
    /// Called when the browser is about to display a tooltip. |text| contains the
    /// text that will be displayed in the tooltip. To handle the display of the
    /// tooltip yourself return true. Otherwise, you can optionally modify |text|
    /// and then return false to allow the browser to display the tooltip.
    /// When window rendering is disabled the application is responsible for
    /// drawing tooltips and the return value is ignored.
    /// CEF name: `OnTooltip`
    func onTooltip(browser: CEFBrowser, text: String) -> CEFOnTooltipAction
    
    /// Called when the browser receives a status message. |value| contains the
    /// text that will be displayed in the status message.
    /// CEF name: `OnStatusMessage`
    func onStatusMessage(browser: CEFBrowser, text: String)
    
    /// Called to display a console message. Return true to stop the message from
    /// being output to the console.
    /// CEF name: `OnConsoleMessage`
    func onConsoleMessage(browser: CEFBrowser,
                          logSeverity: CEFLogSeverity,
                          message: String,
                          source: String,
                          lineNumber: Int) -> CEFOnConsoleMessageAction

    /// Called when auto-resize is enabled via CefBrowserHost::SetAutoResizeEnabled
    /// and the contents have auto-resized. |new_size| will be the desired size in
    /// view coordinates. Return true if the resize was handled or false for
    /// default handling.
    /// CEF name: `OnAutoResize`
    func onAutoResize(browser: CEFBrowser, newSize: CGSize) -> CEFOnAutoResizeAction
    
    /// Called when the overall page loading progress has changed. |progress|
    /// ranges from 0.0 to 1.0.
    /// CEF name: `OnLoadingProgressChange`
    func onLoadingProgressChange(browser: CEFBrowser, progress: Double)
}

public extension CEFDisplayHandler {

    func onAddressChange(browser: CEFBrowser, frame: CEFFrame, url: URL) {
    }
    
    func onTitleChange(browser: CEFBrowser, title: String) {
    }
    
    func onFaviconURLChange(browser: CEFBrowser, iconURLs: [URL]?) {
    }

    func onFullscreenModeChange(browser: CEFBrowser, fullscreen: Bool) {
    }

    func onTooltip(browser: CEFBrowser, text: String) -> CEFOnTooltipAction {
        return .showDefault(text)
    }
    
    func onStatusMessage(browser: CEFBrowser, text: String) {
    }
    
    func onConsoleMessage(browser: CEFBrowser,
                          logSeverity: CEFLogSeverity,
                          message: String,
                          source: String,
                          lineNumber: Int) -> CEFOnConsoleMessageAction {
        return .show
    }

    func onAutoResize(browser: CEFBrowser, newSize: CGSize) -> CEFOnAutoResizeAction {
        return .performDefault
    }

    func onLoadingProgressChange(browser: CEFBrowser, progress: Double) {
    }
}

