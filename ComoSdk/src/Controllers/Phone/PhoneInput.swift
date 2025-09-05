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
        let vc = CountryPickerViewController(currentRegion: currentRegion, utility: utility, delegate: self)
        
        // Always try to push onto navigation stack first
        if let nav = parentVC?.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            // Fallback to modal only if no navigation controller
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            parentVC?.present(nav, animated: true)
        }
    }
    
    var parentVC: UIViewController? {
        var responder: UIResponder? = self
        while !(responder is UIViewController), responder != nil {
            responder = responder?.next
        }
        return (responder as? UIViewController)
    }
}
