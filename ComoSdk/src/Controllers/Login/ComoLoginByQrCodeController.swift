import UIKit
import RevoUIComponents

class ComoLoginByQrCodeController : UIViewController, ScanQRCodeViewDelegate {
    
    @IBOutlet var scanQrCodeView: ScanQRCodeView!
    
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet private weak var button: AsyncButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    weak var delegate:ComoLoginDelegate!
    
    override func viewDidLoad() {
        inputField.placeholder = Como.trans("como_enter_your_code")
        errorLabel.text = ""
        scanQrCodeView.round(8)
        button.round(4)
        button.setTitle(Como.trans("como_search_customer"), for: .normal)
        if !isiOSAppOnMac(){
            scanQrCodeView.setupCaptureSession(delegate: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isiOSAppOnMac(){
            scanQrCodeView.start()
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isiOSAppOnMac(){
            scanQrCodeView.setupPreviewLayer()
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !isiOSAppOnMac(){
            scanQrCodeView.stop()
        }
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
            return Como.Customer(commonExtId: text)
        }
        return Como.Customer(phoneNumber: text)
    }
    
    func scanQrCode(found code:String){
        inputField.text = code
        if button.isEnabled {
            onSearchCustomerPressed(nil)
        }
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
                    inputField.text = ""
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
    
    private func isiOSAppOnMac() -> Bool {
      if #available(iOS 14.0, *) {
        return ProcessInfo.processInfo.isiOSAppOnMac
      }
      return false
    }
}
