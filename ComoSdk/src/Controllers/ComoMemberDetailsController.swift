import UIKit
import RevoUIComponents
import RevoFoundation
import RevoHttp

class ComoMemberDetailsController : UIViewController {
    
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
    
    var details:Como.MemberDetailsResponse!
    let dataSource = MembershipDataSource()
    
    
    override func viewDidLoad() {
        showMemberDetails()
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
}
