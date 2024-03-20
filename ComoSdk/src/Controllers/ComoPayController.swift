import UIKit
import RevoFoundation
import RevoUIComponents

class ComoPayController : UIViewController, OTPViewDelegate {
    
    var amount:Int!
    
    @IBOutlet weak var payCodeInput:UITextField!
    @IBOutlet weak var errorLabel:UILabel!
    @IBOutlet weak var loading:LoadingAnimation!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusIcon:UIImageView!
    @IBOutlet weak var pinCode:OTPView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var resendCodeButton:UIButton!
    
    let ERROR_CODE_NEEDS_VERIFICATION = "4007005"
        
    var delegate:ComoDelegate?
    
    override func viewDidLoad() {
        isModalInPresentation = true
        errorLabel.text = ""
        loading.isHidden = true
        translate()
        
        appearance()
        amountLabel.text = str("%.2f €", Double(amount) / 100.0)
        
        loading.set(size: CGSize(width: 50, height: 20), color: .darkGray)
        startPaymentProcess()
        preferredContentSize = CGSize(width: 580, height: 460)
        
        pinCode.delegate = self
    }
    
    @IBAction func onCancelPressed(_ sender:Any){
        dismiss(animated: true)
    }
    
    
    private func startPaymentProcess(code:String? = nil){
        hideAskCodeDetails()
        Task {
            do {
                loading.startAnimating()
                errorLabel.text = ""
                let response = try await Como.shared.currentSale!.pay(amount: amount, code: code)
                loading.stopAnimating()
                showPaymentOk(response: response)
            }
            catch {
                loading.stopAnimating()
                if("\(error)".contains(ERROR_CODE_NEEDS_VERIFICATION)) {
                    return askVerificationCode()
                }
                errorLabel.text = Como.trans("como_\(error)")
                showPaymentFailed(Como.trans("como_\(error)"))
                print(error)
            }
        }
    }
    
    private func askVerificationCode(){
        titleLabel.isHidden       = false
        descriptionLabel.isHidden = false
        statusIcon.isHidden       = false
        pinCode.isHidden          = false
        resendCodeButton.isHidden = false
    }
    
    
    @IBAction func onResendCodePressed(_ sender:UIButton?){
        startPaymentProcess(code: pinCode.code)
    }
    
    private func showPaymentOk(response:Como.PaymentResponse){
        titleLabel.isHidden         = false
        titleLabel.text             = Como.trans("como_paymentCompleted")
        
        descriptionLabel.isHidden   = false
        descriptionLabel.text       = Como.trans("como_paymentCompletedDesc")
        
        statusIcon.isHidden         = false
        statusIcon.image            = UIImage(systemName: "checkmark.circle.fill")
        statusIcon.tintColor        = UIColor(hex: "#6BB637")
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [unowned self] in
            dismiss(animated: true) { [unowned self] in
                self.delegate?.como(onPaid: response)
            }
        }
    }
    
    private func showPaymentFailed(_ error:String){
        titleLabel.isHidden         = false
        titleLabel.text             = Como.trans("como_paymentFailed")
        
        descriptionLabel.isHidden   = false
        descriptionLabel.text       = error
        
        statusIcon.isHidden         = false
        statusIcon.image            = UIImage(systemName: "xmark.circle.fill")
        statusIcon.tintColor        = UIColor(hex: "#E44848")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { [unowned self] in
            dismiss(animated: true) { [unowned self] in
                self.delegate?.comoActionCanceled()
            }
        }
    }
    
    private func hideAskCodeDetails(){
        titleLabel.isHidden       = true
        statusIcon.isHidden       = true
        descriptionLabel.isHidden = true
        pinCode.isHidden          = true
        resendCodeButton.isHidden = true
        errorLabel.text           = ""
    }
    
    private func appearance(){
        hideAskCodeDetails()
        
        descriptionLabel.text = Como.trans("como_paymentCodeHasBeenSentTo") + " " + (Como.shared.currentSale?.customer?.phoneNumber ?? Como.shared.currentSale?.customer?.email ?? "")
    }
    
    func translate(){
        //payTitle.text = Como.trans("como_payTitle")
        //payDesc.text = Como.trans("como_payDesc")
        //payCodeInput.placeholder = Como.trans("como_SMSValidationCode")
        //payButton.setTitle(Como.trans("como_paySendAuthCode"), for: .normal)
    }
 
    func otp(codeEntered code: String) {
        onResendCodePressed(nil)
    }

}

