//
//  UIViewController+extension.swift
//  VideoRecorder
//
//  Created by 유영훈 on 2022/10/13.
//

import UIKit

extension UIViewController {

    func askForTextAndConfirmWithAlert(title: String, placeholder: String, okHandler: @escaping (String?) -> Void) {
        var alertController: UIAlertController?
        alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alertController!.addTextField { textField in
            textField.accessibilityIdentifier = "filename"
            textField.placeholder = placeholder
            textField.clearButtonMode = .whileEditing
            textField.borderStyle = .none
            textField.addTarget(alertController!, action: #selector(alertController!.textDidChanged), for: .editingChanged)
        }
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            guard let text = alertController!.textFields?.first?.text else {
                return
            }
            okHandler(text)
            alertController = nil
        })
        
        okAction.accessibilityIdentifier = "filename_ok"
        okAction.isEnabled = false
        alertController!.addAction(okAction)

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            okHandler(nil)
            alertController = nil
        })
        alertController!.addAction(cancelAction)
        
        present(alertController!, animated: true, completion: nil)
    }
}

extension UIAlertController {
    @objc func textDidChanged() {
        guard let textField = textFields?.first else { return }
        actions.first?.isEnabled = !(textField.text ?? "").isEmpty
    }
}
