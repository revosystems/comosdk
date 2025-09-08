import UIKit
import RevoUIComponents

class ComoRegisterByMailController : UIViewController {
    
    @IBOutlet var button: AsyncButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    weak var delegate:ComoRegisterDelegate?
    
    override func viewDidLoad() {
        textField.placeholder = Como.trans("como_enter_your_email")
        errorLabel.text = ""
        button.round(4)
        button.setTitle(Como.trans("como_register_customer"), for: .normal)
    }
    
    @IBAction func onButtonPressed(_ button:AsyncButton){
        errorLabel.text = ""
        
        guard (textField.text?.count ?? 0) > 0 else {
            return textField.shake()
        }
        
        guard textField.text!.contains("@") else {
            return textField.shake()
        }
        
        Task {
            do {
                button.animateProgress()
                let customer = Como.Customer(email: textField.text!.trim())
                let _        = try await Como.shared.quickRegister(customer: customer)
                let details  = try await Como.shared.getMemberDetails(
                    customer: customer,
                    purchase: Como.shared.currentSale!.purchase
                )
                await MainActor.run {
                    button.animateSuccess()
                    delegate?.como(registered: details)
                }
            } catch {
                await MainActor.run {
                    button.animateFailed()
                    errorLabel.text = Como.trans("como_\(error)")
                }
            }
        }
    }
}
