import UIKit
import RevoFoundation

public protocol ComoDelegate {
    func como(onCustomerSelected currentSale:Como.CurrentSale)
    func como(onPaid response:Como.PaymentResponse)
    func comoActionCanceled()
}

public class ComoController : UIViewController, ScanCodeControllerDelegate {
    
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
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var registerDesc: UILabel!
    @IBOutlet var headerImageBackground: UIView!
    
    @IBOutlet weak var registerView: UIView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeDescLabel: UILabel!
    
    @IBOutlet weak var labelOr1: UILabel!
    @IBOutlet weak var labelOr2: UILabel!
    
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
        isModalInPresentation = true
        appearance()
        translate()
        preferredContentSize = CGSize(width: 574, height: 670)
        
        if let customer = Como.shared.currentSale?.customer {
            inputField.text = customer.phoneNumber
        }
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
        errorLabel.text = Como.trans("como_\(error)")
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
        
        if inputField.text!.isPhoneNumber {
            return Como.Customer(phoneNumber: inputField.text!.lowercased())
        }
        
        return Como.Customer(customIdentifier: inputField.text!)
    }
    
    //MARK: - Not used
    @IBAction func onVoidPurchasePressed(_ sender: Any) {
        Task {
            do {
                try await Como.shared.currentSale!.void()
                print("Voided")
            } catch {
                print(error)
            }
        }
    }    

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?){
        (segue.destination as? ScanCodeController)?.delegate = self
    }
    
    func scanController(onScanned code:String){
        inputField.text = code
        onFindMemberPressed(findMemberButton)
    }
    
    
    //MARK: - Appearance
    func appearance(){
        headerImageBackground.circle()
        
        [findMemberButton, sendAuthCodeButton, /*scanCodeButton,*/ addCouponButton, registerButton].each {
            $0.round(4)
        }
        
        [sendAuthCodeButton, addCouponButton].each {
            $0.border(.init(hex:"#EEEEEE"))
        }
    }
    
    func translate(){
        welcomeLabel.text     = Como.trans("como_welcome")
        welcomeDescLabel.text = Como.trans("como_welcomeDesc")
        backButton.title      = Como.trans("como_cancel")
        registerDesc.text     = Como.trans("como_registerDesc")
        findMemberButton    .setTitle(Como.trans("como_findMember"),    for:.normal)
        sendAuthCodeButton  .setTitle(Como.trans("como_sendAuthCode"),  for:.normal)
        addCouponButton     .setTitle(Como.trans("como_addCouponCode"), for:.normal)
        registerButton      .setTitle(Como.trans("como_register"),      for:.normal)
        //scanCodeButton    .setTitle(Como.trans("como_"), for:.normal)
        inputField.placeholder = Como.trans("como_user_placeholder")
        labelOr1.text          = Como.trans("como_or")
        labelOr2.text          = Como.trans("como_or")
        #if DEBUG
            inputField.text = "jordi.p@revo.works"
        #endif
    }
    
    deinit {
        if let sale = Como.shared.currentSale {
            delegate?.como(onCustomerSelected: sale)
        }
        delegate = nil
    }
}

extension String {
    var isPhoneNumber: Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
        let matches = detector?.matches(in: self, range: NSRange(location: 0, length: utf16.count))

        return (matches?.count ?? 0) > 0
    }
}
