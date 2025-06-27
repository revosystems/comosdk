import Foundation
import UIKit


protocol PhoneCountryControllerDelegate : AnyObject {
    func phoneCountrySelector(countrySelected:PhoneCountry)
}


struct PhoneCountry {
    let flag:String
    let name:String
    let prefix:String
}

enum PhoneCountryEnum: CaseIterable {
    case spain
    case france
    case italy
    case portugal
    case germany
    case uk
    case belgium
    
    var country:PhoneCountry {
        switch self {
        case .spain:        PhoneCountry(flag: "🇪🇸", name: "Spain",          prefix: "+34")
        case .france:       PhoneCountry(flag: "🇫🇷", name: "France",         prefix: "+33")
        case .italy:        PhoneCountry(flag: "🇮🇹", name: "Italy",          prefix: "+39")
        case .portugal:     PhoneCountry(flag: "🇵🇹", name: "Portugal",       prefix: "+351")
        case .germany:      PhoneCountry(flag: "🇩🇪", name: "Germany",        prefix: "+40")
        case .uk:           PhoneCountry(flag: "🇬🇧", name: "United Kingdom", prefix: "+44")
        case .belgium:      PhoneCountry(flag: "🇧🇪", name: "Belgium",        prefix: "+32")
            
        }
    }
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
