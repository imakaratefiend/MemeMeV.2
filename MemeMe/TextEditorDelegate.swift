//
//  TextEditorDelegate.swift
//  MemeMe
//
//  Created by Bradley Hill on 6/13/17.
//  Copyright © 2017 Bradley Hill. All rights reserved.
//

import Foundation
import UIKit

// MARK: - TextEditorDelegate

class TextEditorDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP") || (textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
