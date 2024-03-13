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
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var details:Como.MemberDetailsResponse!
    let dataSource = MembershipDataSource()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        preferredContentSize = CGSize(width: 768, height: 700)
    }
    
    override func viewDidLoad() {
        showMemberDetails()
        redeemButton.isEnabled = false
        appearance()
        translate()
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
        nameLabel.text     = details.membership.fullName ?? "--"
        phoneLabel.text    = details.membership.phoneNumber
        birthdayLabel.text = details.membership.birthday
        tagsLabel.text     = details.membership.tags?.implode(", ") ?? ""
        image.circle().gravatar(email: details.membership.email, defaultImage:"https://thumbnailer.mixcloud.com/unsafe/600x600/defaults/users/2.png")
        
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
        (cell.viewWithTag(100) as! UILabel).text = (section == 0 ? Como.trans("como_memberNotes") : Como.trans("como_assets")).uppercased()
        return cell
    }
    
    func updateRedeemButton(){
        let benefitsCount = tableView.indexPathsForSelectedRows?.filter { $0.section == 1 }.count ?? 0
        redeemButton.isEnabled = benefitsCount > 0
        redeemButton.setTitle(Como.trans("como_reedem") + " (\(benefitsCount))", for: .normal)
    }
    
    var selectedAssets:[Como.Asset]{
        tableView.indexPathsForSelectedRows?.filter {
            $0.section == 1
        }.map({ (indexPath:IndexPath) in
            details.membership.assets[indexPath.row]
        }) ?? []
    }
    
    func appearance(){
        headerView.round(12)
        tableView.round(12)
        redeemButton.round(4)
        couponsButton.round(4)
    }
    
    func translate(){
        doneButton.title = Como.trans("como_done")
        couponsButton.setTitle(Como.trans("como_couponCodes"),  for: .normal)
        redeemButton.setTitle(Como.trans("como_redeem"),        for: .normal)
        creditLabelTitle.text = Como.trans("como_credits")
        pointsLabelTitle.text = Como.trans("como_points")
    }
    
}
