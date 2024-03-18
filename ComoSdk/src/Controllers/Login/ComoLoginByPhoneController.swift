import UIKit
import RevoUIComponents
import RevoFoundation

class ComoLoginByPhoneController : UIViewController, PhoneCountryControllerDelegate, UITextFieldDelegate {

    @IBOutlet var loginOtpView: UIView!
    @IBOutlet var searchButton: AsyncButton!
    @IBOutlet var inputField: UITextField!
    @IBOutlet var phoneCountryTextInput: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    
    weak var delegate:ComoLoginDelegate!
    
    var phoneCountry = PhoneCountry.spain
    
    
    override func viewDidLoad() {
        searchButton.round(4)
        errorLabel.text = ""
        loginOtpView.isHidden = true
        phoneCountrySelector(countrySelected: phoneCountry)
    }
    
    @IBAction func onSearchPressed(_ sender:Any){
        
        errorLabel.text = ""
        
        guard (inputField.text?.count ?? 0) > 0 else {
            return inputField.shake()
        }
                
        sendAuthCode()
    }
    
    //So the country text field can't be edited manually
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        onSelectCountryPressed()
        return false
    }
    
    @objc func onSelectCountryPressed(){
        let vc:PhoneCountryController = SBController("Como", "phoneCountry")
        vc.delegate = self
        vc.selectedCountry = phoneCountry
        
        modalPresentationStyle = .popover
        popoverPresentationController?.permittedArrowDirections = .any
        popoverPresentationController?.sourceView = phoneCountryTextInput
        popoverPresentationController?.sourceRect = phoneCountryTextInput.bounds
        
        present(vc, animated:true)
    }
    
    func phoneCountrySelector(countrySelected: PhoneCountry) {
        phoneCountry = countrySelected
        phoneCountryTextInput.text = "\(phoneCountry.flag) \(phoneCountry.prefix)"
    }
    
    func sendAuthCode(){
        Task {
            do {
                searchButton.animateProgress()
                try await Como.shared.sendIdentificationCode(phoneNumber:
                    (phoneCountry.prefix + inputField.text!).replace("+", "")
                )
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
