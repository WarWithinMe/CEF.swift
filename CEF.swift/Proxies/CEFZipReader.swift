//
//  CEFZipReader.swift
//  CEF.swift
//
//  Created by Tamas Lustyik on 2015. 08. 14..
//  Copyright © 2015. Tamas Lustyik. All rights reserved.
//

import Foundation

public extension CEFZipReader {
    /// Create a new CefZipReader object. The returned object's methods can only
    /// be called from the thread that created the object.
    /// CEF name: `Create`
    public convenience init?(stream: CEFStreamReader) {
        self.init(ptr: cef_zip_reader_create(stream.toCEF()))
    }
    
    /// Moves the cursor to the first file in the archive. Returns true if the
    /// cursor position was set successfully.
    /// CEF name: `MoveToFirstFile`
    @discardableResult
    public func moveToFirstFile() -> Bool {
        return cefObject.move_to_first_file(cefObjectPtr) != 0
    }
    
    /// Moves the cursor to the next file in the archive. Returns true if the
    /// cursor position was set successfully.
    /// CEF name: `MoveToNextFile`
    @discardableResult
    public func moveToNextFile() -> Bool {
        return cefObject.move_to_next_file(cefObjectPtr) != 0
    }
    
    /// Moves the cursor to the specified file in the archive. If |caseSensitive|
    /// is true then the search will be case sensitive. Returns true if the cursor
    /// position was set successfully.
    /// CEF name: `MoveToFile`
    @discardableResult
    public func moveToFile(_ name: String, caseSensitive: Bool) -> Bool {
        let cefStrPtr = CEFStringPtrCreateFromSwiftString(name)
        defer { CEFStringPtrRelease(cefStrPtr) }
        return cefObject.move_to_file(cefObjectPtr, cefStrPtr, caseSensitive ? 1 : 0) != 0
    }
    
    /// Closes the archive. This should be called directly to ensure that cleanup
    /// occurs on the correct thread.
    /// CEF name: `Close`
    @discardableResult
    public func close() -> Bool {
        return cefObject.close(cefObjectPtr) != 0
    }

    // The below methods act on the file at the current cursor position.
    
    /// Returns the name of the file.
    /// CEF name: `GetFileName`
    public var fileName: String {
        let cefStrPtr = cefObject.get_file_name(cefObjectPtr)
        defer { CEFStringPtrRelease(cefStrPtr) }
        return CEFStringToSwiftString(cefStrPtr!.pointee)
    }

    /// Returns the uncompressed size of the file.
    /// CEF name: `GetFileSize`
    public var fileSize: Int64 {
        return cefObject.get_file_size(cefObjectPtr)
    }
    
    /// Returns the last modified timestamp for the file.
    /// CEF name: `GetFileLastModified`
    public var fileLastModified: Date {
        let cefTime = cefObject.get_file_last_modified(cefObjectPtr)
        return CEFTimeToSwiftDate(cefTime)
    }
    
    /// Opens the file for reading of uncompressed data. A read password may
    /// optionally be specified.
    /// CEF name: `OpenFile`
    @discardableResult
    public func openFile(password: String? = nil) -> Bool {
        var cefPwd = password != nil ? CEFStringPtrCreateFromSwiftString(password!) : nil
        defer { CEFStringPtrRelease(cefPwd) }
        
        return cefObject.open_file(cefObjectPtr, cefPwd) != 0
    }
    
    /// Closes the file.
    /// CEF name: `CloseFile`
    @discardableResult
    public func closeFile() -> Bool {
        return cefObject.close_file(cefObjectPtr) != 0
    }
    
    /// Read uncompressed file contents into the specified buffer. Returns < 0 if
    /// an error occurred, 0 if at the end of file, or the number of bytes read.
    /// CEF name: `ReadFile`
    public func readFile(buffer: UnsafeMutableRawPointer, size: size_t) -> size_t? {
        let retval = cefObject.read_file(cefObjectPtr, buffer, size)
        return retval < 0 ? nil : size_t(retval)
    }
    
    /// Returns the current offset in the uncompressed file contents.
    /// CEF name: `Tell`
    public func tell() -> Int64 {
        return cefObject.tell(cefObjectPtr)
    }
    
    /// Returns true if at end of the file contents.
    /// CEF name: `Eof`
    public func isEOF() -> Bool {
        return cefObject.eof(cefObjectPtr) != 0
    }
    
}

