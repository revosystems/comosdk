import UIKit
import RevoFoundation

protocol OTPViewDelegate : AnyObject {
    func otp(codeEntered code:String);
}

class OTPView : UIStackView, OTPTextFieldDelegate {
    
    weak var delegate:OTPViewDelegate?
    
    override func awakeFromNib() {
        arrangedSubviews.each { element in
            (element as? UITextField)?.addTarget(self, action:#selector(onPinTextFieldChanged(_:)), for: .editingChanged)
            (element as? UITextField)?.addTarget(self, action:#selector(onPinTextFieldStarted(_:)), for: .editingDidBegin)
            
            (element as? OTPTextField)?.otpDelegate = self
        }
    }
    
    public var code : String {
        arrangedSubviews.compactMap { ($0 as? UITextField)?.text }.implode("")
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        arrangedSubviews.first {
            $0 is UITextField
        }?.becomeFirstResponder() ?? false
    }
    
    @objc func onPinTextFieldChanged(_ textField:UITextField){
        let index = arrangedSubviews.firstIndex(of: textField) ?? 0
        
        if (textField.text?.count ?? 0) > 1 {
            textField.text = String(textField.text?.suffix(1) ?? "")
        }
        
        if index == arrangedSubviews.count - 1 {
            delegate?.otp(codeEntered: code)
            return
        }
        
        (arrangedSubviews[index + 1] as? UITextField)?.text = ""
        (arrangedSubviews[index + 1] as? UITextField)?.becomeFirstResponder()
    }
    
    @objc func onPinTextFieldStarted(_ textField:UITextField){
        textField.text = ""
    }
    
    func onDeletedBackward(_ textField: UITextField) {
        
        let index = arrangedSubviews.firstIndex(of: textField) ?? 0
        guard index != 0 else { return }
        
        (arrangedSubviews[index - 1] as? UITextField)?.text = ""
        (arrangedSubviews[index - 1] as? UITextField)?.becomeFirstResponder()
    }
}


public protocol OTPTextFieldDelegate : AnyObject {
    func onDeletedBackward(_ textField:UITextField)
}

public class OTPTextField : UITextField {
    weak var otpDelegate:OTPTextFieldDelegate?
    
    public override func deleteBackward() {
        if (text?.count ?? 0) == 0 {
            otpDelegate?.onDeletedBackward(self)
        }
        super.deleteBackward()
    }
}
