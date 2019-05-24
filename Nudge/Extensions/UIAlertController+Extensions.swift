import UIKit

extension UIAlertController {
    func addTextField(placeholder: String) {
        addTextField { textField in
            textField.placeholder = placeholder
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .yes
        }
    }
    
    func addCancelAction() {
        addAction(.init(title: "Cancel", style: .cancel, handler: nil))
    }
    
    func addOKAction(_ handler: @escaping (UIAlertAction) -> Void) {
        addAction(.init(title: "OK", style: .default, handler: handler))
    }
}
