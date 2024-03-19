import Foundation
import UIKit

class MembershipDataSource : NSObject, UITableViewDataSource {
    var membershipDetails: Como.MemberDetailsResponse?
    
    func reload(membershipDetails:Como.MemberDetailsResponse) -> Self {
        self.membershipDetails = membershipDetails
        return self
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let details = membershipDetails else { return 0 }
        return details.membership.assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let row = tableView.dequeueReusableCell(withIdentifier: indexPath.section == 0 ? "memberNote" : "asset", for: indexPath) as! AssetCell
        return row.setup(asset: membershipDetails!.membership.assets[indexPath.row])
    }
}
