//
//  CEFRegisterCDMCallbackBridge.swift
//  CEF.swift
//
//  Created by Tamas Lustyik on 2016. 11. 05..
//  Copyright © 2016. Tamas Lustyik. All rights reserved.
//

import Foundation

/// Method that will be called when CDM registration is complete. |result|
/// will be CEF_CDM_REGISTRATION_ERROR_NONE if registration completed
/// successfully. Otherwise, |result| and |error_message| will contain
/// additional information about why registration failed.
public typealias CEFRegisterCDMCallbackOnCDMRegistrationCompleteBlock =
    (_ result: CEFCDMRegistrationError, _ message: String?) -> Void

class CEFRegisterCDMCallbackBridge: CEFRegisterCDMCallback {
    let block: CEFRegisterCDMCallbackOnCDMRegistrationCompleteBlock
    
    init(block: @escaping CEFRegisterCDMCallbackOnCDMRegistrationCompleteBlock) {
        self.block = block
    }
    
    func onCDMRegistrationComplete(result: CEFCDMRegistrationError, message: String?) {
        block(result, message)
    }
}
