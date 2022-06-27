import UIKit
import RevoFoundation
import RevoHttp

class ComoMemberDetailsController : UIViewController {
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var phoneLabel:UILabel!
    @IBOutlet weak var birthdayLabel:UILabel!
    @IBOutlet weak var tagsLabel:UILabel!
    @IBOutlet weak var loading:UIActivityIndicatorView!
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var statusImageView:UIImageView!
    
    @IBOutlet weak var creditLabel:UILabel!
    @IBOutlet weak var creditLabelTitle:UILabel!
    @IBOutlet weak var pointsLabel:UILabel!
    @IBOutlet weak var pointsLabelTitle:UILabel!
    
    @IBOutlet weak var tableView:UITableView!
    
    let dataSource = MembershipDataSource()
    
    override func viewDidLoad() {
        
        //setupFake()
        fetchMemberDetails()
    }
    
    private func setupFake(){
        HttpFake.enable()
         HttpFake.addResponse("""
         {
          "status": "ok",
          "membership": {
              "firstName": "Jane",
              "lastName": "Smith",
              "birthday": "1995-03-03",
              "email": "jane@email.com",
              "gender": "female",
              "phoneNumber": "2128782328",
              "status": "Active",
              "createdOn": "2016-05-19T10:19:08Z",
              "allowSMS": true,
              "commonExtId": "1d722661-0a94-4a36-8dea-ae23e5e3f440",
              "mobileAppUsed": true,
              "mobileAppUsedLastDate": "2017-06-15T10:12:29Z",
              "pointsBalance": {
                  "usedByPayment": false,
                  "balance": {
                      "monetary": 2000,
                      "nonMonetary": 2000
                  }
              },
              "creditBalance": {
                  "usedByPayment": true,
                  "balance": {
                      "monetary": 1000,
                      "nonMonetary": 1000
                  }
              },
              "tags": ["VIP", "Vegetarian"],
              "assets": [
                  {
                      "key": "60y4KJDxK2zfUrcrir9D3K2OWyvorXpPJADNroNY8",
                      "name": " 10% Off - Coffee Only!",
                      "description": "10% Off for coffee products only",
                      "status": "Active",
                      "image": "https://storage-download.googleapis.com/server-prod/images/giftimg.jpg",
                      "validFrom": "2017-01-05T20:59:59Z",
                      "validUntil": "2017-08-05T20:59:59Z",
                      "redeemable": true
                  },
                  {
                      "key": "1zikFHzdF1jLPqMXdqrfEkJ2rOAXTX9Cw4BFIfq48",
                      "name": "Sandwich Coupon",
                      "description": "$5 Off Sandwich",
                      "status": "Active",
                      "image": "https://storage-download.googleapis.com/server-prod/images/giftimg.jpg",
                      "validFrom": "2017-01-05T20:59:59Z",
                      "validUntil": "2017-08-05T20:59:59Z",
                      "redeemable": false,
                      "nonRedeemableCause": {
                          "code": "5523",
                          "message": "Violation of asset conditions (no benefits)"
                      }
                  },
                  {
                      "key": "ps_6434757946179584_9f9fb0ddb9b278cbfb3d1f1bc95eaadffebb5ccc",
                      "name": "Ice Cream for 60.0 points",
                      "description": "Get free Ice Cream",
                      "status": "Active",
                      "image": "https://storage-download.googleapis.com/server-prod/images/giftimg.jpg",
                      "validUntil": "2017-08-05T20:59:59Z",
                      "redeemable": true
                  }
              ]
          },
          "memberNotes":[
              {
              "content": "Deal of the month: 20% off milkshakes",
              "type": "text"
              }
          ]
         }
         """)
    }
    
    func fetchMemberDetails(){
        loading.start()
        Como().getMemberDetails(customer: Como.Customer(phoneNumber: "612345672", email: nil), purchase: Como.Purchase.fake()) { [weak self] result in
            guard let self = self else { return }
            self.loading.stop()
            switch result {
                case .failure : self.showError(result: result)
                case .success : self.showMemberDetails(details: try! result.get())
            }
        }
    }
    
    func showError(result:Result<Como.MemberDetailsResponse, Error>){
        nameLabel.text = "\(result)"
    }
    
    func showMemberDetails(details:Como.MemberDetailsResponse){
        nameLabel.text     = details.membership.fullName
        phoneLabel.text    = details.membership.phoneNumber
        birthdayLabel.text = details.membership.birthday
        tagsLabel.text     = details.membership.tags.implode(", ")
        
        creditLabel.text = str("%.2f €", (Double(details.membership.creditBalance.balance.monetary) / 100.0))
        pointsLabel.text = "\(details.membership.pointsBalance.balance.monetary)"
        //TODO: gravatar
        
        statusImageView.image =  UIImage(systemName: details.membership.status == .active ? "checkmark.circle.fill" : "xmark.circle.fill")
                
        tableView.dataSource = dataSource.reload(membershipDetails: details)
        tableView.reloadData()
    }
}
