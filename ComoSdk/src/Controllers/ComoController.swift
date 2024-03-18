import UIKit
import RevoFoundation

public protocol ComoDelegate {
    func como(onCustomerSelected currentSale:Como.CurrentSale)
    func como(onPaid response:Como.PaymentResponse)
    func comoActionCanceled()
}

protocol ComoLoginDelegate : AnyObject {
    func como(onLoggedIn details:Como.MemberDetailsResponse)
}

public class ComoController : UIViewController, ScanCodeControllerDelegate, ComoLoginDelegate {
    
    enum NextController {
        case showDetails
        case pay(amount:Int)
    }
     
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var welcomeLabel: UILabel!
        
    @IBOutlet var loginByPhoneView: UIView!
    @IBOutlet var loginByEmailView: UIView!
    @IBOutlet var loginByQRCode: UIView!
    @IBOutlet var addCoupon: UIView!
    @IBOutlet var segmented: UISegmentedControl!
    
    var delegate:ComoDelegate?
    var nextAction:NextController = .showDetails
    
    public static func make(delegate:ComoDelegate?) -> UINavigationController {
        let nav:UINavigationController = SBController("Como", "nav")
        (nav.children.first as? ComoController)?.delegate = delegate
        return nav
    }
            
    public override func viewDidLoad() {
        isModalInPresentation = true
        //appearance()
        //translate()
        preferredContentSize = CGSize(width: 700, height: 670)
        
        onSegmentedChanged(segmented)
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        delegate = nil
        dismiss(animated: true)
    }
    
    @IBAction func onSegmentedChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            loginByPhoneView.isHidden = false
            loginByEmailView.isHidden = true
            loginByQRCode.isHidden    = true
            addCoupon.isHidden        = true
        } else if sender.selectedSegmentIndex == 2 {
            loginByPhoneView.isHidden = true
            loginByEmailView.isHidden = false
            loginByQRCode.isHidden    = true
            addCoupon.isHidden        = true
        } else if sender.selectedSegmentIndex == 3 {
            loginByPhoneView.isHidden = true
            loginByEmailView.isHidden = true
            loginByQRCode.isHidden    = false
            addCoupon.isHidden        = true
        } else {
            loginByPhoneView.isHidden = true
            loginByEmailView.isHidden = true
            loginByQRCode.isHidden    = true
            addCoupon.isHidden        = false
        }
    }
    
    func como(onLoggedIn details:Como.MemberDetailsResponse) {
        onMemberFetched(details: details)
    }
    
    /*@IBAction func onRegisterPressed(_ sender: UIButton?) {
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
    }*/
    
    
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
        (segue.destination as? ComoLoginByEmailController)?.delegate = self
        (segue.destination as? ComoLoginByPhoneController)?.delegate = self
        (segue.destination as? ComoLoginByQrCodeController)?.delegate = self
        (segue.destination as? ScanCodeController)?.delegate = self
    }
    
    func scanController(onScanned code:String){
        //inputField.text = code
        //onFindMemberPressed(findMemberButton)
    }
    
    
    //MARK: - Appearance
    /*func appearance(){
        //headerImageBackground.circle()
        
        [findMemberButton, sendAuthCodeButton, /*scanCodeButton,*/ addCouponButton, registerButton].each {
            $0.round(4)
        }
        
        [sendAuthCodeButton, addCouponButton].each {
            $0.border(.init(hex:"#EEEEEE"))
        }
    }
    
    func translate(){
        welcomeLabel.text     = Como.trans("como_welcome")
        backButton.title      = Como.trans("como_cancel")
        findMemberButton    .setTitle(Como.trans("como_findMember"),    for:.normal)
        sendAuthCodeButton  .setTitle(Como.trans("como_sendAuthCode"),  for:.normal)
        addCouponButton     .setTitle(Como.trans("como_addCouponCode"), for:.normal)
        registerButton      .setTitle(Como.trans("como_register"),      for:.normal)
        //scanCodeButton    .setTitle(Como.trans("como_"), for:.normal)
        inputField.placeholder = Como.trans("como_user_placeholder")
        #if DEBUG
            inputField.text = "jordi.p@revo.works"
        #endif
    }*/
    
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
