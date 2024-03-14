import UIKit
import RevoUIComponents

class ComoLoginByEmailController : UIViewController {
    
    @IBOutlet var searchButton: AsyncButton!
    @IBOutlet var inputField: UITextField!
    
    @IBOutlet var sendVerifyCodeButton: AsyncButton!
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        sendVerifyCodeButton.border(UIColor(hex:"#EDEBEA"), size: 1).round(4)
        searchButton.round(4)
        errorLabel.text = ""
    }
    
    @IBAction func onSearchPressed(_ sender: Any) {
                
        errorLabel.text = ""
        
        guard (inputField.text?.count ?? 0) > 0 else {
            return inputField.shake()
        }
        
        guard inputField.text!.contains("@") else {
            return inputField.shake()
        }
        
        let customer = Como.Customer(email: inputField.text!.lowercased())
        
        searchButton.animateProgress()
        Task {
            do {
                let details = try await Como.shared.getMemberDetails(customer: customer, purchase: Como.shared.currentSale!.purchase)
                Como.shared.currentSale?.customer = details.membership.customer
                await MainActor.run {
                    searchButton.animateSuccess()
                    //onMemberFetched(details: details)
                }
            } catch {
                await MainActor.run {
                    searchButton.animateFailed()
                    onError(error)
                }
            }
        }
    }
    
    private func onError(_ error:Error){
        errorLabel.text = Como.trans("como_\(error)")
    }
}
