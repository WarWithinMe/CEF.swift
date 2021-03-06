//
//  CEFParseUtils.swift
//  CEF.swift
//
//  Created by Tamas Lustyik on 2015. 08. 13..
//  Copyright © 2015. Tamas Lustyik. All rights reserved.
//

import Foundation

public enum CEFParseUtils {
    
    /// This is a convenience function for formatting a URL in a concise and human-
    /// friendly way to help users make security-related decisions (or in other
    /// circumstances when people need to distinguish sites, origins, or otherwise-
    /// simplified URLs from each other). Internationalized domain names (IDN) may be
    /// presented in Unicode if the conversion is considered safe. The returned value
    /// will (a) omit the path for standard schemes, excepting file and filesystem,
    /// and (b) omit the port if it is the default for the scheme. Do not use this
    /// for URLs which will be parsed or sent to other applications.
    /// CEF name: `CefFormatUrlForSecurityDisplay`
    public static func formatURLForSecurityDisplay(_ url: URL) -> String {
        let cefURLPtr = CEFStringPtrCreateFromSwiftString(url.absoluteString)
        defer { CEFStringPtrRelease(cefURLPtr) }
        
        let cefStrPtr = cef_format_url_for_security_display(cefURLPtr)
        defer { CEFStringPtrRelease(cefStrPtr) }
        return CEFStringPtrToSwiftString(cefStrPtr, defaultValue: "")
    }

    /// Returns the mime type for the specified file extension or an empty string if
    /// unknown.
    /// CEF name: `CefGetMimeType`
    public static func mimeTypeForExtension(_ fileExt: String) -> String? {
        let cefStrPtr = CEFStringPtrCreateFromSwiftString(fileExt)
        defer { CEFStringPtrRelease(cefStrPtr) }
        let cefType = cef_get_mime_type(cefStrPtr)
        defer { CEFStringPtrRelease(cefType) }
        return CEFStringPtrToSwiftString(cefType)
    }

    // Get the extensions associated with the given mime type. This should be passed
    // in lower case. There could be multiple extensions for a given mime type, like
    // "html,htm" for "text/html", or "txt,text,html,..." for "text/*". Any existing
    // elements in the provided vector will not be erased.
    /// CEF name: `CefGetExtensionsForMimeType`
    public static func extensionsForMIMEType(_ mimeType: String) -> [String] {
        let cefList = cef_string_list_alloc()!
        let cefStrPtr = CEFStringPtrCreateFromSwiftString(mimeType)
        defer {
            CEFStringListRelease(cefList)
            CEFStringPtrRelease(cefStrPtr)
        }
        cef_get_extensions_for_mime_type(cefStrPtr, cefList)
        return CEFStringListToSwiftArray(cefList)
    }

    /// Escapes characters in |text| which are unsuitable for use as a query
    /// parameter value. Everything except alphanumerics and -_.!~*'() will be
    /// converted to "%XX". If |use_plus| is true spaces will change to "+". The
    /// result is basically the same as encodeURIComponent in Javacript.
    /// CEF name: `CefURIEncode`
    public static func uriEncode(_ text: String, usingPlusForSpace usePlus: Bool) -> String {
        let cefStrPtr = CEFStringPtrCreateFromSwiftString(text)
        let cefEncodedPtr = cef_uriencode(cefStrPtr, usePlus ? 1 : 0)
        defer {
            CEFStringPtrRelease(cefStrPtr)
            CEFStringPtrRelease(cefEncodedPtr)
        }
        return CEFStringToSwiftString(cefEncodedPtr!.pointee)
    }

    /// Unescapes |text| and returns the result. Unescaping consists of looking for
    /// the exact pattern "%XX" where each X is a hex digit and converting to the
    /// character with the numerical value of those digits (e.g. "i%20=%203%3b"
    /// unescapes to "i = 3;"). If |convert_to_utf8| is true this function will
    /// attempt to interpret the initial decoded result as UTF-8. If the result is
    /// convertable into UTF-8 it will be returned as converted. Otherwise the
    /// initial decoded result will be returned.  The |unescape_rule| parameter
    /// supports further customization the decoding process.
    /// CEF name: `CefURIDecode`
    public static func uriDecode(_ text: String,
                                 convertToUTF8: Bool,
                                 unescapeRule: CEFURIUnescapeRule = .none) -> String {
        let cefStrPtr = CEFStringPtrCreateFromSwiftString(text)
        let cefDecodedPtr = cef_uridecode(cefStrPtr, convertToUTF8 ? 1 : 0, unescapeRule.toCEF())
        defer {
            CEFStringPtrRelease(cefStrPtr)
            CEFStringPtrRelease(cefDecodedPtr)
        }
        return CEFStringToSwiftString(cefDecodedPtr!.pointee)
    }

    // Parses the specified |json_string| and returns a dictionary or list
    // representation. If JSON parsing fails this method returns NULL.
    /// CEF name: `CefParseJSON`
    public static func parseJSON(_ jsonString: String, options: CEFJSONParserOptions = .rfc) -> CEFValue? {
        let cefStrPtr = CEFStringPtrCreateFromSwiftString(jsonString)
        defer { CEFStringPtrRelease(cefStrPtr) }
        let cefValue = cef_parse_json(cefStrPtr, options.toCEF())
        return CEFValue.fromCEF(cefValue)
    }

    // Parses the specified |json_string| and returns a dictionary or list
    // representation. If JSON parsing fails this method returns NULL and populates
    // |error_code_out| and |error_msg_out| with an error code and a formatted error
    // message respectively.
    /// CEF name: `CefParseJSONAndReturnError`
    public static func parseJSONToResult(_ jsonString: String,
                                         options: CEFJSONParserOptions = .rfc) -> CEFJSONParseResult {
        let cefStrPtr = CEFStringPtrCreateFromSwiftString(jsonString)
        defer { CEFStringPtrRelease(cefStrPtr) }
        var code = CEFJSONParserError.noError.toCEF()
        var msg = cef_string_t()
        
        let cefValue = cef_parse_jsonand_return_error(cefStrPtr, options.toCEF(), &code, &msg)
        if cefValue != nil {
            return .failure(CEFJSONParserError.fromCEF(code), CEFStringToSwiftString(msg))
        }
        
        return .success(CEFValue.fromCEF(cefValue)!)
    }

    // Generates a JSON string from the specified root |node| which should be a
    // dictionary or list value. Returns an empty string on failure. This method
    // requires exclusive access to |node| including any underlying data.
    /// CEF name: `CefWriteJSON`
    public static func writeJSON(value: CEFValue, options: CEFJSONWriterOptions = .default) -> String? {
        let cefStrPtr = cef_write_json(value.toCEF(), options.toCEF())
        defer { CEFStringPtrRelease(cefStrPtr) }
        
        return CEFStringPtrToSwiftString(cefStrPtr)
    }

}
