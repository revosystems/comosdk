import Foundation
import UIKit
import RevoUIComponents


class ComoControllerLoginOTPController : UIViewController, OTPViewDelegate {
    
    @IBOutlet private weak var pinCode:OTPView!
    weak var delegate:OTPViewDelegate?
    
    override func viewDidLoad() {
        pinCode.delegate = self
    }
    
    func otp(codeEntered code: String) {
        delegate?.otp(codeEntered: code)
    }
}
