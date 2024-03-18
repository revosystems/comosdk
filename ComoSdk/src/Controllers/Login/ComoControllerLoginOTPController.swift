import Foundation
import UIKit


class ComoControllerLoginOTPController : UIViewController, OTPViewDelegate {
    
    @IBOutlet private weak var pinCode:OTPView!
    
    override func viewDidLoad() {
        pinCode.delegate = self
    }
    
    func otp(codeEntered code: String) {
        
    }
}
