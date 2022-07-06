import UIKit
import RevoFoundation

public protocol ComoDelegate {
    func como(onCustomerSelected currentSale:Como.CurrentSale)
    func como(onPaid amount:Int)
    func comoActionCanceled()
}

public class ComoController : UIViewController {
    
    enum NextController {
        case showDetails
        case pay(amount:Int)
    }
 
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var findMemberButton: UIButton!
    @IBOutlet weak var sendAuthCodeButton: UIButton!
    @IBOutlet weak var scanCodeButton: UIButton!
    @IBOutlet weak var addCouponButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var registerView: UIView!
    
    var delegate:ComoDelegate?
    var nextAction:NextController = .showDetails
    
    public static func make(delegate:ComoDelegate?) -> UINavigationController {
        let nav:UINavigationController = SBController("Como", "nav")
        (nav.children.first as? ComoController)?.delegate = delegate
        return nav
    }
            
    public override func viewDidLoad() {
        loading.isHidden = true
        errorLabel.text = ""
        registerView.isHidden = true
        findMemberButton.round(4)
        isModalInPresentation = true
        appearance()
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onFindMemberPressed(_ sender: UIButton?) {
        guard let customer = customer() else {
            return inputField.shake()
        }
        loading.start(findMemberButton)
        
        Task {
            do {
                let details = try await Como.shared.getMemberDetails(customer: customer, purchase: Como.shared.currentSale!.purchase)
                Como.shared.currentSale?.customer = details.membership.customer
                loading.stop(self.findMemberButton)
                onMemberFetched(details: details)
            } catch {
                loading.stop(sender)
                onError(error)
            }
        }
    }
    
    @IBAction func onRegisterPressed(_ sender: UIButton?) {
        loading.start(sender)
        Task {
            do {
                try await Como.shared.quickRegister(phoneNumber: inputField.text!)
                loading.stop(sender)
                onFindMemberPressed(self.findMemberButton)
            }catch{
                loading.stop(sender)
                onError(error)
            }
        }
    }
    
    func onError(_ error:Error){
        registerView.isHidden = false
        errorLabel.text = "\(error)"
    }
    
    func onMemberFetched(details:Como.MemberDetailsResponse){
        switch nextAction {
        case .showDetails: showAssets(details: details)
        case .pay(let amount): showPay(amount: amount)
        }
    }
    
    private func showAssets(details:Como.MemberDetailsResponse){
        let vc:ComoMemberDetailsController = SBController("Como", "memberDetails")
        vc.details = details
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showPay(amount:Int){
        let vc:ComoPayController = SBController("Como", "pay")
        vc.amount = amount
        vc.delegate = delegate
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onSendAuthCodePressed(_ sender: UIButton) {
        loading.start(sender)
        Task {
            do {
                try await Como.shared.sendIdentificationCode(phoneNumber: inputField.text!)
                loading.stop(sender)
            } catch {
                loading.stop(sender)
                onError(error)
            }
        }
    }
    
    @IBAction func onScanCodePressed(_ sender: Any) {

    }
    
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
        return Como.Customer(phoneNumber: inputField.text!.lowercased())
    }
    
    @IBAction func onVoidPurchasePressed(_ sender: Any) {
        Task {
            do {
                try await Como.shared.currentSale!.void()
                print("Voided")
            }catch{
                print(error)
            }
        }
    }
    
    func appearance(){
        [findMemberButton, sendAuthCodeButton, scanCodeButton, addCouponButton, registerButton].each { $0.round(4)}
    }
    
    deinit {
        delegate?.como(onCustomerSelected: Como.shared.currentSale!)
        delegate = nil
    }
}
