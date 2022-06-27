import Foundation
import UIKit

class MembershipDataSource : NSObject, UITableViewDataSource {
    var membershipDetails: Como.MemberDetailsResponse?
    
    func reload(membershipDetails:Como.MemberDetailsResponse) -> Self {
        self.membershipDetails = membershipDetails
        return self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let details = membershipDetails else { return 0 }
        return section == 0 ? details.memberNotes.count : details.membership.assets.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Member Notes" : "Assets"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: indexPath.section == 0 ? "memberNote" : "asset", for: indexPath)
        if indexPath.section == 0 {
            let note = membershipDetails!.memberNotes[indexPath.row]
            (row.viewWithTag(100) as? UILabel)?.text = note.content
        }
        
        
        return row
    }
}
