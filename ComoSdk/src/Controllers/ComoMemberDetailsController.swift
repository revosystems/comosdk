import UIKit
import RevoUIComponents
import RevoFoundation
import RevoHttp

class ComoMemberDetailsController : UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
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
    @IBOutlet weak var couponsButton: UIButton!
    
    var details:Como.MemberDetailsResponse!
    let dataSource = MembershipDataSource()
    
    override func viewDidLoad() {
        showMemberDetails()
        redeemButton.isEnabled = false
        appearance()
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && details.memberNotes?.count == 0 { return nil }
        let cell = tableView.dequeueReusableCell(withIdentifier: "header")!
        (cell.viewWithTag(100) as! UILabel).text = (section == 0 ? "Member notes" : "Assets").uppercased()
        return cell
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
    
    func appearance(){
        headerView.round(12)
        tableView.round(12)
        redeemButton.round(4)
        couponsButton.round(4)
    }
    
}
