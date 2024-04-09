import UIKit
import RevoFoundation

public class MemberSmallView : UIView {
    
    @IBOutlet weak var avatarView:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var creditsLabel:UILabel!
    
    public func reload(){
        if let details = Como.shared.memberDetails {
            isHidden = false
            nameLabel.text = details.membership.fullName
            creditsLabel.text = str("%.2f €", (Double(details.membership.creditBalance?.balance.monetary ?? 0) / 100.0))
            avatarView.circle().gravatar(email: details.membership.email, defaultImage:"https://raw.githubusercontent.com/BadChoice/handesk/dev/public/images/default-avatar.png")
        } else {
            isHidden = true
        }
        
    }
}
