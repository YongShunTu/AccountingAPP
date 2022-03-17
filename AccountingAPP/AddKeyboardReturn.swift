//
//  AddKeyboardReturn.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/4.
//

import Foundation
import UIKit

extension UITextField {
    func addKeyboardReturn() {
        let weigh = Float(UIScreen.main.bounds.width)
        let accessoryView = UIToolbar(frame: CGRect(x: 0, y: 0, width: CGFloat(weigh), height: CGFloat(0.1 * weigh)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton))
        accessoryView.items = [space,space,done]
        self.inputAccessoryView = accessoryView
    }

    @objc func doneButton() {
        self.resignFirstResponder()
    }
}

extension UITextView {
    func addKeyboardReturn() {
        let weigh = Float(UIScreen.main.bounds.width)
        let accessoryView = UIToolbar(frame: CGRect(x: 0, y: 0, width: CGFloat(weigh), height: CGFloat(0.1 * weigh)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton))
        accessoryView.items = [space,space,done]
        self.inputAccessoryView = accessoryView
    }

    @objc func doneButton() {
        self.resignFirstResponder()
    }
}
