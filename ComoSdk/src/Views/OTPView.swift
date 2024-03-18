import UIKit
import RevoFoundation

protocol OTPViewDelegate : AnyObject {
    func otp(codeEntered code:String);
    
}
class OTPView : UIStackView {
    
    weak var delegate:OTPViewDelegate?
    
    override func awakeFromNib() {
        arrangedSubviews.each { element in
            (element as? UITextField)?.addTarget(self, action:#selector(onPinTextFieldChanged(_:)), for: .editingChanged)
        }
    }
    
    public var code : String {
        arrangedSubviews.compactMap { ($0 as? UITextField)?.text }.implode("")
    }
    
    @objc func onPinTextFieldChanged(_ textField:UITextField){
        let index = arrangedSubviews.firstIndex(of: textField) ?? 0
        
        if index == arrangedSubviews.count - 1 {
            delegate?.otp(codeEntered: code)
            return
        }
        
        (arrangedSubviews[index + 1] as? UITextField)?.text = ""
        (arrangedSubviews[index + 1] as? UITextField)?.becomeFirstResponder()
    }
}
