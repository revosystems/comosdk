import UIKit
import RevoUIComponents

class ComoLoginByQrCodeController : UIViewController, ScanQRCodeViewDelegate {
    
    @IBOutlet var scanQrCodeView: ScanQRCodeView!
    
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet private weak var button: AsyncButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    weak var delegate:ComoLoginDelegate!
    
    override func viewDidLoad() {
        errorLabel.text = ""
        scanQrCodeView.round(8)
        button.round(4)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //scanQrCodeView.setupCaptureSession(delegate:self)
    }
    
    @IBAction func onSearchCustomerPressed(_ button:UIButton?){
        guard (inputField.text?.count ?? 0) > 1 else {
            return inputField.shake()
        }
        searchCustomer(getCustomer(inputField.text ?? ""))
    }
    
    func getCustomer(_ text:String) -> Como.Customer {
        if text.count == 4 {
            return Como.Customer(appClientId: text)
        }
        
        if text.contains("@") {
            return Como.Customer(email: text)
        }
        
        if (Como.shared.hasFeature(.customIdentifier)){
            return Como.Customer(customIdentifier: text)
        }
        return Como.Customer(phoneNumber: text)
    }
    
    func scanQrCode(found code:String){
        inputField.text = code
        onSearchCustomerPressed(nil)
    }
    
    func searchCustomer(_ customer:Como.Customer) {
        errorLabel.text = ""
        button.animateProgress()
        Task {
            do {
                let details = try await Como.shared.getMemberDetails(
                    customer: customer,
                    purchase: Como.shared.currentSale!.purchase
                )
                Como.shared.currentSale?.customer = details.membership.customer
                await MainActor.run {
                    button.animateSuccess()
                    delegate?.como(onLoggedIn: details)
                }
            } catch {
                await MainActor.run {
                    button.animateFailed()
                    onError(error)
                }
            }
        }
    }
    
    private func onError(_ error:Error){
        errorLabel.text = Como.trans("como_\(error)")
        scanQrCodeView.start()
    }
}
