import UIKit
import RevoUIComponents

class ComoLoginByPhoneController : UIViewController {

    @IBOutlet var loginOtpView: UIView!
    @IBOutlet var searchButton: AsyncButton!
    @IBOutlet var inputField: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    
    weak var delegate:ComoLoginDelegate!
    
    
    override func viewDidLoad() {
        searchButton.round(4)
        errorLabel.text = ""
        loginOtpView.isHidden = true
    }
    
    @IBAction func onSearchPressed(_ sender:Any){
        
        errorLabel.text = ""
        
        guard (inputField.text?.count ?? 0) > 0 else {
            return inputField.shake()
        }
                
        sendAuthCode()
    }
    
    func sendAuthCode(){
        Task {
            do {
                try await Como.shared.sendIdentificationCode(phoneNumber: inputField.text!)
                await MainActor.run {
                    searchButton.animateSuccess()
                    onCodeSent()
                }
            } catch {
                await MainActor.run {
                    searchButton.animateFailed()
                    onError(error)
                }
            }
        }
    }
    
    private func onCodeSent(){
        loginOtpView.isHidden = false
    }
    
    private func onError(_ error:Error){
        errorLabel.text = Como.trans("como_\(error)")
    }
    
    /*
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
