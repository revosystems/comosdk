import Foundation

protocol PhoneCountryControllerDelegate : AnyObject {
    func phoneCountrySelector(countrySelected:PhoneCountry)
}


struct PhoneCountry {
    let flag:String
    let name:String
    let prefix:String
    
    static var spain:PhoneCountry    { PhoneCountry(flag: "🇪🇸", name: "Spain",          prefix: "+34") }
    static var france:PhoneCountry   { PhoneCountry(flag: "🇫🇷", name: "France",         prefix: "+33") }
    static var italy:PhoneCountry    { PhoneCountry(flag: "🇮🇹", name: "Italy",          prefix: "+39") }
    static var portugal:PhoneCountry { PhoneCountry(flag: "🇵🇹", name: "Portugal",       prefix: "+351")}
    static var germany:PhoneCountry  { PhoneCountry(flag: "🇩🇪", name: "Germany",        prefix: "+40") }
    static var uk:PhoneCountry       { PhoneCountry(flag: "🇬🇧", name: "United Kingdom", prefix: "+44") }
    static var belgium:PhoneCountry  { PhoneCountry(flag: "🇧🇪", name: "Belgium",        prefix: "+32") }
}

class PhoneCountryController : UITableViewController {
        
    weak var delegate:PhoneCountryControllerDelegate?
    var selectedCountry:PhoneCountry?
    
    let countries:[PhoneCountry] = [
        PhoneCountry.belgium,
        PhoneCountry.france,
        PhoneCountry.portugal,
        PhoneCountry.spain,
        PhoneCountry.italy,
        PhoneCountry.germany,
        PhoneCountry.uk,
    ]
    
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
