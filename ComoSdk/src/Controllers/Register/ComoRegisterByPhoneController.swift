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
 
    private var phoneCountry:PhoneCountry = PhoneCountry.spain
    
    override func viewDidLoad() {
        errorLabel.text = ""
        button.round(4)
        phoneCountrySelector(countrySelected: phoneCountry)
    }
    
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
        popoverPresentationController?.sourceView = phoneCountryInput
        popoverPresentationController?.sourceRect = phoneCountryInput.bounds
        
        present(vc, animated:true)
    }
    
    func phoneCountrySelector(countrySelected: PhoneCountry) {
        phoneCountry = countrySelected
        phoneCountryInput.text = "\(phoneCountry.flag) \(phoneCountry.prefix)"
    }
    
    
    @IBAction func onButtonPressed(_ sender: Any) {
        errorLabel.text = ""
        
        guard (textField.text?.count ?? 0) > 4 else {
            return textField.shake()
        }
        
        Task {
            do {
                button.animateProgress()
                let details = try await Como.shared.quickRegister(customer:
                    Como.Customer(phoneNumber:
                    "\(phoneCountry.prefix)\(textField.text!)".replace("+", ""))
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
