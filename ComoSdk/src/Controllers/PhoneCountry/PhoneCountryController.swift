import Foundation
import UIKit

protocol PhoneCountryControllerDelegate : AnyObject {
    func phoneCountrySelector(countrySelected:PhoneCountry)
}

class PhoneCountryController : UITableViewController {
        
    weak var delegate:PhoneCountryControllerDelegate?
    var selectedCountry:PhoneCountry?
    
    let countries:[PhoneCountry] = PhoneCountryEnum.allCases.map { $0.country }
    
    override func viewDidLoad() {
        preferredContentSize = CGSize(width: 300, height: 300)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let country = countries[indexPath.row]
        
        (cell.viewWithTag(100) as? UILabel)?.text = "\(country.flag) \(country.name)"
        (cell.viewWithTag(101) as? UILabel)?.text = "\(country.prefix)"
        
        if selectedCountry?.name == country.name {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.phoneCountrySelector(countrySelected: countries[indexPath.row])
        dismiss(animated: true)
    }
    
}
