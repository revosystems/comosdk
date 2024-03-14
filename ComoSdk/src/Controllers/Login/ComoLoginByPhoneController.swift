import UIKit

class ComoLoginByPhoneController : UIViewController {
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var findMemberButton: UIButton!
    @IBOutlet weak var sendAuthCodeButton: UIButton!
    
    override func viewDidLoad() {
        
        /*if let customer = Como.shared.currentSale?.customer {
            inputField.text = customer.phoneNumber
        }*/
    }
    
    /*@IBAction func onFindMemberPressed(_ sender: UIButton?) {
        guard let customer = customer() else {
            return inputField.shake()
        }
        loading.start(findMemberButton)
        
        Task {
            do {
                let details = try await Como.shared.getMemberDetails(customer: customer, purchase: Como.shared.currentSale!.purchase)
                Como.shared.currentSale?.customer = details.membership.customer
                loading.stop(self.findMemberButton)
                onMemberFetched(details: details)
            } catch {
                loading.stop(sender)
                onError(error)
            }
        }
    }
    
    func onError(_ error:Error){
        errorLabel.text = Como.trans("como_\(error)")
    }
    
    @IBAction func onSendAuthCodePressed(_ sender: UIButton) {
        loading.start(sender)
        Task {
            do {
                try await Como.shared.sendIdentificationCode(phoneNumber: inputField.text!)
                loading.stop(sender)
            } catch {
                loading.stop(sender)
                onError(error)
            }
        }
    }
    
    func customer() -> Como.Customer? {
        guard inputField.text?.count ?? 0 > 0 else {
            return nil
        }
        
        if inputField.text!.count == 4 {
            return Como.Customer(appClientId: inputField.text!)
        }
        
        if inputField.text!.contains("@") {
            return Como.Customer(email: inputField.text!.lowercased())
        }
        
        if inputField.text!.isPhoneNumber {
            return Como.Customer(phoneNumber: inputField.text!.lowercased())
        }
        
        return Como.Customer(customIdentifier: inputField.text!)
    }*/
}
