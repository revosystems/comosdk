import UIKit
import RevoUIComponents
import RevoFoundation

class ComoRegisterByPhoneController : UIViewController, PhoneCountryControllerDelegate, UITextFieldDelegate, OTPViewDelegate {
        
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var button: AsyncButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet var phoneCountryInput: UITextField!
    @IBOutlet var phoneCountryIcon: UIImageView!
    
    weak var delegate:ComoRegisterDelegate?
 
    private var phoneCountry:PhoneCountry = PhoneCountryEnum.spain.country
    
    override func viewDidLoad() {
        errorLabel.text = ""
        button.round(4)
        phoneCountrySelector(countrySelected: phoneCountry)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if textField === phoneCountryInput {
            onSelectCountryPressed()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        return string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil
    }
    
    @objc func onSelectCountryPressed(){
        let sb = UIStoryboard(name: "Como", bundle: Bundle.module)
        let vc = sb.instantiateViewController(withIdentifier: "phoneCountry") as! PhoneCountryController
        
        vc.delegate = self
        vc.selectedCountry = phoneCountry
        
        modalPresentationStyle = .popover
        popoverPresentationController?.permittedArrowDirections = .any
        popoverPresentationController?.sourceView = phoneCountryInput
        popoverPresentationController?.sourceRect = phoneCountryInput.bounds
        
        present(vc, animated:true)
    }
    
    func phoneCountrySelector(countrySelected: PhoneCountry) {
        phoneCountry = countrySelected
        phoneCountryInput.text = "\(phoneCountry.flag) \(phoneCountry.prefix)"
    }
    
    var phone:String {
        "\(phoneCountry.prefix)\(textField.text!)".replace("+", "").trim()
    }
    
    
    @IBAction func onButtonPressed(_ sender: Any) {
        errorLabel.text = ""
        
        guard (textField.text?.count ?? 0) > 4 else {
            return textField.shake()
        }
        
        Task {
            do {
                button.animateProgress()
                let customer = Como.Customer(phoneNumber: phone)
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
    
    func otp(codeEntered code: String) {
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? ComoControllerLoginOTPController)?.delegate = self
    }
}
