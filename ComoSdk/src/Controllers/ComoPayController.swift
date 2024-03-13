import UIKit
import RevoFoundation
import RevoUIComponents

class ComoPayController : UIViewController {
    
    var amount:Int!
    
    @IBOutlet weak var payCodeInput:UITextField!
    @IBOutlet weak var errorLabel:UILabel!
    @IBOutlet weak var loading:LoadingAnimation!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusIcon:UIImageView!
    @IBOutlet weak var pinCode:UIStackView!
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
                showPaymentFailed()
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
        let code = pinCode.arrangedSubviews.compactMap { ($0 as? UITextField)?.text }.implode("")
        startPaymentProcess(code: code)
    }
    
    private func showPaymentOk(response:Como.PaymentResponse){
        titleLabel.isHidden         = false
        titleLabel.text             = Como.trans("como_paymentCompleted")
        
        descriptionLabel.isHidden   = false
        descriptionLabel.text       = Como.trans("como_paymentCompletedDesc")
        
        statusIcon.isHidden         = false
        statusIcon.image            = UIImage(systemName: "checkmark.circle.fill")
        statusIcon.tintColor        = UIColor(hex: "#6BB637")
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [unowned self] in
            dismiss(animated: true) { [unowned self] in
                self.delegate?.como(onPaid: response)
            }
        }
    }
    
    private func showPaymentFailed(){
        titleLabel.isHidden         = false
        titleLabel.text             = Como.trans("como_paymentFailed")
        
        descriptionLabel.isHidden   = false
        descriptionLabel.text       = Como.trans("como_paymentFailedDesc")
        
        statusIcon.isHidden         = false
        statusIcon.image            = UIImage(systemName: "xmark.circle.fill")
        statusIcon.tintColor        = UIColor(hex: "#E44848")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [unowned self] in
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
    
    //OTP
    @IBAction func onPinTextFieldChanged(_ textField:UITextField){
        let index = pinCode.arrangedSubviews.firstIndex(of: textField) ?? 0
        (pinCode.arrangedSubviews[index + 1] as? UITextField)?.text = ""
        (pinCode.arrangedSubviews[index + 1] as? UITextField)?.becomeFirstResponder()
    }
    
    @IBAction func onLastPinTextFieldChanged(_ textField:UITextField){
        onResendCodePressed(nil)
    }
}

