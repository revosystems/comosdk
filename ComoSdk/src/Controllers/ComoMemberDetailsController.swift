import UIKit
import RevoUIComponents
import RevoFoundation
import RevoHttp

class ComoMemberDetailsController : UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var phoneLabel:UILabel!
    @IBOutlet weak var birthdayLabel:UILabel!
    @IBOutlet weak var tagsLabel:UILabel!
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var statusImageView:UIImageView!
    
    @IBOutlet weak var creditLabel:UILabel!
    @IBOutlet weak var creditLabelTitle:UILabel!
    @IBOutlet weak var pointsLabel:UILabel!
    @IBOutlet weak var pointsLabelTitle:UILabel!
    
    @IBOutlet weak var tableView:ContentStatusTableView!
    
    @IBOutlet weak var redeemButton: UIButton!
    
    var details:Como.MemberDetailsResponse!
    let dataSource = MembershipDataSource()
        
    var delegate:ComoDelegate?
    var purchase:Como.Purchase!
    
    
    override func viewDidLoad() {
        showMemberDetails()
        redeemButton.isEnabled = false
    }
    
    @IBAction func onRedeemPressed(_ sender: Any) {
        let benefits = selectedBenefits.map { Como.RedeemAsset(key: $0.key, appliedAmount: nil, code:nil) }
        getBenefits(redeem: benefits)
    }
    
    @IBAction func onDonePressed(_ sender: Any) {
        getBenefits(redeem: [])
    }
    
    func getBenefits(redeem:[Como.RedeemAsset]){
        Como().getBenefits(customers: [details.membership.customer], purchase: purchase, redeemAssets: redeem) { [weak self] result in
            switch result {
            case .failure(let error)    : print("Error")
            case .success(let response) : self?.redeem(response)
            }
        }
    }
    
    func redeem(_ response:Como.GetBenefitsResponse){
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.como(onBenefitsSelected: response, customer:self.details.membership.customer)
        }
    }
        
    func showMemberDetails(){
        tableView.state    = .content
        nameLabel.text     = details.membership.fullName
        phoneLabel.text    = details.membership.phoneNumber
        birthdayLabel.text = details.membership.birthday
        tagsLabel.text     = details.membership.tags?.implode(", ") ?? ""
        
        creditLabel.text = str("%.2f €", (Double(details.membership.creditBalance.balance.monetary) / 100.0))
        pointsLabel.text = "\(details.membership.pointsBalance.balance.monetary / 100)"
        //TODO: gravatar
        
        statusImageView.image =  UIImage(systemName: details.membership.status == .active ? "checkmark.circle.fill" : "xmark.circle.fill")
                
        tableView.dataSource = dataSource.reload(membershipDetails: details)
        tableView.reloadData()
    }
    
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateRedeemButton()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateRedeemButton()
    }
    
    func updateRedeemButton(){
        let benefitsCount = tableView.indexPathsForSelectedRows?.count ?? 0
        redeemButton.isEnabled = benefitsCount > 0
        redeemButton.setTitle("Reedem (\(benefitsCount))", for: .normal)
    }
    
    var selectedBenefits:[Como.Asset]{
        tableView.indexPathsForSelectedRows?.map({ (indexPath:IndexPath) in
            details.membership.assets[indexPath.row]
        }) ?? []
    }

}
