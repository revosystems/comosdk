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
    
    override func viewDidLoad() {
        showMemberDetails()
        redeemButton.isEnabled = false
    }
    
    @IBAction func onRedeemPressed(_ sender: Any) {
        Como.shared.currentSale?.redeemAssets = selectedAssets.map { Como.RedeemAsset(key: $0.key, appliedAmount: nil, code:nil) }
        dismiss(animated: true)
    }
    
    @IBAction func onDonePressed(_ sender: Any) {
        Como.shared.currentSale?.redeemAssets = []
        dismiss(animated: true)
    }
    
        
    func showMemberDetails(){
        Como.shared.currentSale?.customer = details.membership.customer
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
    
    var selectedAssets:[Como.Asset]{
        tableView.indexPathsForSelectedRows?.map({ (indexPath:IndexPath) in
            details.membership.assets[indexPath.row]
        }) ?? []
    }
    
}
