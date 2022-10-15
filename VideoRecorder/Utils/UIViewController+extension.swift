//
//  UIViewController+extension.swift
//  VideoRecorder
//
//  Created by 유영훈 on 2022/10/13.
//

import UIKit

extension UIViewController {

    func askForTextAndConfirmWithAlert(title: String, placeholder: String, okHandler: @escaping (String?)->Void) {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let textChangeHandler = TextFieldTextChangeHandler { text in
            alertController.actions.first?.isEnabled = !(text ?? "").isEmpty
        }
        
        var textHandlerKey = 0
        objc_setAssociatedObject(self, &textHandlerKey, textChangeHandler, .OBJC_ASSOCIATION_RETAIN)

        alertController.addTextField { textField in
            textField.placeholder = placeholder
            textField.clearButtonMode = .whileEditing
            textField.borderStyle = .none
            textField.addTarget(textChangeHandler, action: #selector(TextFieldTextChangeHandler.onTextChanged(sender:)), for: .editingChanged)
        }

        let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            guard let text = alertController.textFields?.first?.text else {
                return
            }
            okHandler(text)
            objc_setAssociatedObject(self, &textHandlerKey, nil, .OBJC_ASSOCIATION_RETAIN)
        })
        okAction.isEnabled = false
        alertController.addAction(okAction)

        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            okHandler(nil)
            objc_setAssociatedObject(self, &textHandlerKey, nil, .OBJC_ASSOCIATION_RETAIN)
        }))

        present(alertController, animated: true, completion: nil)
    }

}

class TextFieldTextChangeHandler {
    
    let handler: (String?)->Void
    
    init(handler: @escaping (String?)->Void) {
        self.handler = handler
    }

    @objc func onTextChanged(sender: AnyObject) {
        handler((sender as? UITextField)?.text)
    }
}
