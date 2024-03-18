import UIKit
import RevoUIComponents

class ComoLoginAddCouponController : UIViewController {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var button: AsyncButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        errorLabel.text = ""
    }
}
