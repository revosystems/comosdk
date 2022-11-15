import UIKit
import RevoFoundation

class ComoPayController : UIViewController {
    
    var amount:Int!
    
    @IBOutlet weak var payCodeInput:UITextField!
    @IBOutlet weak var errorLabel:UILabel!
    @IBOutlet weak var loading:UIActivityIndicatorView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet var headerImageView: UIView!
    @IBOutlet var payButton: UIButton!
    
    @IBOutlet private var payTitle: UILabel!
    @IBOutlet private var payDesc: UILabel!
    
    var delegate:ComoDelegate?
    
    override func viewDidLoad() {
        isModalInPresentation = true
        errorLabel.text = ""
        loading.isHidden = true
        translate()
        
        appearance()
        amountLabel.text = str("%.2f €", Double(amount) / 100.0)
    }
    
    @IBAction func onCancelPressed(_ sender:Any){
        dismiss(animated: true)
    }
    
    
    @IBAction func onPayPressed(_ sender:UIButton){
        Task {
            do {
                loading.start(sender)
                errorLabel.text = ""
                let response = try await Como.shared.currentSale!.pay(amount: amount, code: payCodeInput.text)
                dismiss(animated: true) { [unowned self] in
                    self.delegate?.como(onPaid: response)
                }
            }
            catch {
                loading.stop(sender)
                errorLabel.text = Como.trans("como_\(error)")
                print(error)
            }
        }
    }
    
    func appearance(){
        headerImageView.circle()
        payButton.round(4)
    }
    
    func translate(){
        payTitle.text = Como.trans("como_payTitle")
        payDesc.text = Como.trans("como_payDesc")
        payCodeInput.placeholder = Como.trans("como_SMSValidationCode")
        payButton.setTitle(Como.trans("como_paySendAuthCode"), for: .normal)
    }
}

