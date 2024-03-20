import UIKit
import RevoUIComponents
import RevoFoundation

class ComoLoginByPhoneController : UIViewController, PhoneCountryControllerDelegate, UITextFieldDelegate, OTPViewDelegate {
    

    @IBOutlet var loginOtpView: UIView!
    @IBOutlet var searchButton: AsyncButton!
    @IBOutlet var inputField: UITextField!
    @IBOutlet var phoneCountryTextInput: UITextField!
    @IBOutlet var phoneCountryIcon: UIImageView!
    
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
    
    var phone:String {
        (phoneCountry.prefix + inputField.text!).replace("+", "").trim()
    }
    
    func sendAuthCode(){
        Task {
            do {
                searchButton.animateProgress()
                try await Como.shared.sendIdentificationCode(
                    customer: Como.Customer(phoneNumber:phone)
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
        searchButton.isHidden = true
        phoneCountryTextInput.isHidden = true
        inputField.isHidden = true
        phoneCountryIcon.isHidden = true
    }
    
    func otp(codeEntered code: String) {
        Task {
            do {
                let customer = Como.Customer(appClientId: code)
                let details = try await Como.shared.getMemberDetails(
                    customer: customer,
                    purchase: Como.shared.currentSale!.purchase
                )
                Como.shared.currentSale?.customer = details.membership.customer
                await MainActor.run {
                    searchButton.animateSuccess()
                    delegate?.como(onLoggedIn: details)
                }
            } catch {
                await MainActor.run {
                    loginOtpView.shake()
                    searchButton.animateFailed()
                    onError(error)
                }
            }
        }
    }
    
    private func onError(_ error:Error){
        //if "\(error)".contains("4001012") { //Customer not found
        //    return askToRegister()
        //}
        errorLabel.text = Como.trans("como_\(error)")
    }    
    
    private func askToRegister(){
        Task {
            if case .ok = await Alert(Como.trans("como_wantToRegister"), message:Como.trans("como_wantToRegisterDesc"), cancelText: Como.trans("como_no")).show() {
                do {
                    searchButton.animateProgress()
                    try await Como.shared.quickRegister(customer: Como.Customer(phoneNumber: phone))
                    searchButton.animateSuccess()
                    //TODO: Enter
                } catch {
                    searchButton.animateFailed()
                    onError(error)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? ComoControllerLoginOTPController)?.delegate = self
    }
}
