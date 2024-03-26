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
    
    @IBOutlet weak var registeredAtLabel:UILabel!
    @IBOutlet weak var creditLabel:UILabel!
    @IBOutlet weak var creditLabelTitle:UILabel!
    @IBOutlet weak var pointsLabel:UILabel!
    @IBOutlet weak var pointsLabelTitle:UILabel!
    
    @IBOutlet weak var tableView:ContentStatusTableView!
    
    @IBOutlet weak var redeemButton: UIButton!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    var details:Como.MemberDetailsResponse!
    let dataSource = MembershipDataSource()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.preferredContentSize = CGSize(width: 700, height: 670)
        }
    }
    
    override func viewDidLoad() {
        showMemberDetails()
        redeemButton.isEnabled = false
        appearance()
        translate()
    }
    
    @IBAction func onRedeemPressed(_ sender: Any) {
        Como.shared.currentSale?.redeemAssets = selectedAssets.map {
            Como.RedeemAsset(key: $0.key, appliedAmount: nil, code:nil)
        }
        dismiss(animated: true)
    }
    
    @IBAction func onDonePressed(_ sender: Any) {
        Como.shared.currentSale?.redeemAssets = []
        dismiss(animated: true)
    }
            
    func showMemberDetails(){
        tableView.state    = .content
        nameLabel.text     = details.membership.fullName ?? "--"
        phoneLabel.text    = (details.membership.phoneNumber ?? "--") + " - " + (details.membership.email ?? "")
        birthdayLabel.text = details.membership.birthday
        tagsLabel.text     = details.membership.tags?.implode(", ") ?? ""
        registeredAtLabel.text = "- " + Como.trans("como_from") + " " + (details.membership.createdOn?.toDeviceTimezone(.niceDate) ?? "--")
        image.circle().gravatar(email: details.membership.email, defaultImage:"https://raw.githubusercontent.com/BadChoice/handesk/dev/public/images/default-avatar.png")
        
        creditLabel.text = str("%.2f €", (Double(details.membership.creditBalance?.balance.monetary ?? 0) / 100.0))
        pointsLabel.text = "\((details.membership.pointsBalance?.balance.monetary ?? 0) / 100)"
        //TODO: gravatar
        
        statusImageView.image =  UIImage(systemName: details.membership.status == .active ? "checkmark.seal.fill" : "xmark.circle.fill")
        statusImageView.tintColor = details.membership.status == .active ? UIColor.systemGreen : UIColor.systemRed
                
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "header")!
        (cell.viewWithTag(100) as! UILabel).text = Como.trans("como_assets").uppercased()
        return cell
    }
    
    func updateRedeemButton(){
        let benefitsCount = tableView.indexPathsForSelectedRows?.count ?? 0
        redeemButton.isEnabled = benefitsCount > 0
        redeemButton.setTitle(Como.trans("como_redeem") + " (\(benefitsCount))", for: .normal)
    }
    
    var selectedAssets:[Como.Asset]{
        tableView.indexPathsForSelectedRows?.map({ (indexPath:IndexPath) in
            (details.membership.assets ?? [])[indexPath.row]
        }) ?? []
    }
    
    func appearance(){
        headerView.round(12)
        tableView.round(12)
        redeemButton.round(4)
    }
    
    func translate(){
        doneButton.title = Como.trans("como_done")
        redeemButton.setTitle(Como.trans("como_redeem"),        for: .normal)
        creditLabelTitle.text = Como.trans("como_credits")
        pointsLabelTitle.text = Como.trans("como_points")
    }
    
}
