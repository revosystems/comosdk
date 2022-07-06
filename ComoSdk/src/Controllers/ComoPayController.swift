import UIKit

class ComoPayController : UIViewController {
    
    var amount:Int!
    
    @IBOutlet weak var payCodeInput:UITextField!
    @IBOutlet weak var errorLabel:UILabel!
    @IBOutlet weak var loading:UIActivityIndicatorView!
    
    var delegate:ComoDelegate?
    
    override func viewDidLoad() {
        isModalInPresentation = true
        errorLabel.text = ""
        loading.isHidden = true
    }
    
    @IBAction func onCancelPressed(_ sender:Any){
        dismiss(animated: true)
    }
    
    
    @IBAction func onPayPressed(_ sender:UIButton){
        Task {
            do {
                loading.start(sender)
                errorLabel.text = ""
                let paid = try await Como.shared.currentSale!.pay(amount: amount, code: payCodeInput.text)
                dismiss(animated: true) { [unowned self] in
                    self.delegate?.como(onPaid: paid)
                }
            }
            catch {
                loading.stop(sender)
                errorLabel.text = "\(error)"
                print(error)
            }
        }
    }
}

