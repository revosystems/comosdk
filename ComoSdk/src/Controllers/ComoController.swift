import UIKit
import RevoFoundation

public protocol ComoDelegate {
    func como(onCustomerSelected currentSale:Como.CurrentSale, membership:Como.MemberDetailsResponse)
    func como(onCustomerUnselected:Como.MemberDetailsResponse?)
    func como(onPaid response:Como.PaymentResponse)
    func comoActionCanceled()
}

protocol ComoLoginDelegate : AnyObject {
    func como(onLoggedIn details:Como.MemberDetailsResponse)
}

public class ComoController : UIViewController, ComoLoginDelegate {
    
    enum NextController {
        case showDetails
        case pay(amount:Int)
    }
     
    @IBOutlet weak var registerLabel: UILabel!
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
        let sb = UIStoryboard(name: "Como", bundle: Bundle.module)
        let nav = sb.instantiateViewController(withIdentifier: "initialNav") as! UINavigationController
        (nav.children.first as? ComoController)?.delegate = delegate

        return nav
    }
            
    public override func viewDidLoad() {
        isModalInPresentation = true
        translate()
        preferredContentSize = CGSize(width: 700, height: 670)
        
        onSegmentedChanged(segmented)
        
        navigationItem.backButtonTitle = Como.trans("como_cancel")
        
        if !Como.shared.hasFeature(.coupons){
            segmented.removeSegment(at: 3, animated: false)
        }

        if let customer = Como.shared.currentSale?.customer {
            autoLogin(customer)
        }
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onSegmentedChanged(_ sender: UISegmentedControl) {
        let segmentViews = [loginByPhoneView, loginByEmailView, loginByQRCode, addCoupon]
        segmentViews.eachWithIndex { view, index in
            view?.isHidden = sender.selectedSegmentIndex == index ? false : true
        }
    }
    
    private func autoLogin(_ customer:Como.Customer){
        Task {
            do {
                let details = try await Como.shared.getMemberDetails(
                    customer: customer,
                    purchase: Como.shared.currentSale!.purchase
                )
                await MainActor.run {
                    como(onLoggedIn: details)
                }
            } catch {
                
            }
        }
    }
    
    func como(onLoggedIn details:Como.MemberDetailsResponse) {
        onMemberFetched(details: details)
    }

    
    func onMemberFetched(details:Como.MemberDetailsResponse){
        
        Como.shared.memberDetails = details
        navigationItem.backButtonTitle = Como.trans("como_logout")
        
        switch nextAction {
        case .showDetails: showAssets(details: details)
        case .pay(let amount): showPay(amount: amount)
        }
    }
    
    private func showAssets(details:Como.MemberDetailsResponse){
        let sb = UIStoryboard(name: "Como", bundle: Bundle.module)
        let vc = sb.instantiateViewController(withIdentifier: "memberDetails") as! ComoMemberDetailsController
        
        vc.details = details
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showPay(amount:Int){
        let sb = UIStoryboard(name: "Como", bundle: Bundle.module)
        let vc = sb.instantiateViewController(withIdentifier: "pay") as! ComoPayController
        
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
    }
    
    
    //MARK: - Appearance
    
    func translate(){
        registerLabel.text = Como.trans("como_customer_doesnt_have_account")
        registerButton      .setTitle(Como.trans("como_register"),      for:.normal)
        welcomeLabel.text     = Como.trans("como_identify_your_customer")
        backButton.title      = Como.trans("como_cancel")
        translateSegmented()
    }
    
    private func translateSegmented() {
        ["phone", "email", "qrcode"].eachWithIndex { key, index in
            guard index < segmented.numberOfSegments else { return }
            segmented.setTitle(" \(Como.trans("como_" + key)) ", forSegmentAt: index)
        }
    }
    
    deinit {
        if let sale = Como.shared.currentSale, let membership = Como.shared.memberDetails {
            delegate?.como(onCustomerSelected: sale, membership: membership)
        }else{
            delegate?.como(onCustomerUnselected: nil)
        }
        delegate = nil
    }
}
