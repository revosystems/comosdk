import Foundation
import RevoFoundation
import UIKit
import PhoneNumberKit
import SwiftUI

class PhoneInput: PhoneNumberTextField {
    private var _withCustomPickerUI: Bool = false {
        didSet {
            if flagButton.actions(forTarget: self, forControlEvent: .touchUpInside) == nil {
                flagButton.addTarget(self, action: #selector(didPressPickerButton), for: .touchUpInside)
            }
        }
    }

    public var withCustomPickerUI: Bool {
        get { _withCustomPickerUI }
        set { _withCustomPickerUI = newValue }
    }
    
    @objc func didPressPickerButton() {
        guard withCustomPickerUI else { return }
        let vc = getAppropriateVC()
        
        if let nav = parentVC?.navigationController {
            return nav.pushViewController(vc, animated: true)
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        parentVC?.present(nav, animated: true)
    }
    
    private func getAppropriateVC() -> UIViewController {
        if #available(iOS 16.0, *) {
            return CountryPickerViewController(currentRegion: currentRegion, utility: utility, delegate: self)
        }
        return CountryCodePickerViewController(utility: utility, options: withDefaultPickerUIOptions)
    }
    
    var parentVC: UIViewController? {
        var responder: UIResponder? = self
        while !(responder is UIViewController), responder != nil {
            responder = responder?.next
        }
        return (responder as? UIViewController)
    }
}
