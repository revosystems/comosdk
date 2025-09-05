import PhoneNumberKit
import UIKit
import SwiftUI

@available(iOS 16.0, *)
class CountryPickerViewController: UIViewController {
    weak var delegate: CountryCodePickerDelegate?
    private var selectedCountry: CountryCodePickerViewController.Country?
    
    private var hostingController: UIHostingController<CountryPickerView>?
    
    private var utility: PhoneNumberUtility
    
    init(currentRegion: String, utility: PhoneNumberUtility, delegate: CountryCodePickerDelegate? = nil) {
        self.delegate = delegate
        self.utility = utility
        self.selectedCountry = CountryCodePickerViewController.Country(for: currentRegion, with: self.utility)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUIView()
    }
    
    private func setupSwiftUIView() {
        let swiftUIView = CountryPickerView(selectedCountry: Binding(
            get: { self.selectedCountry },
            set: { newValue in
                self.selectedCountry = newValue
                if let newValue {
                    self.delegate?.countryCodePickerViewControllerDidPickCountry(newValue)
                }
            }
        ), utility: utility)
        
        hostingController = UIHostingController(rootView: swiftUIView)
        guard let hostingController else { return }
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Set up constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
