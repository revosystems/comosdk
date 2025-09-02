import UIKit
import RevoUIComponents
import RevoFoundation

class ComoRegisterByPhoneController : ComoPhoneController {
    
    weak var delegate: ComoRegisterDelegate!
    
    override var buttonTitleKey: String { "como_register_customer" }
    
    override func performAction() {
        performRegistration()
    }
    
    private func performRegistration() {
        Task {
            do {
                button.animateProgress()
                guard let phone else { throw PhoneValidationError.InvalidPhoneNumber }
                let customer = Como.Customer(phoneNumber: phone)
                let _ = try await Como.shared.quickRegister(customer: customer)
                let details = try await Como.shared.getMemberDetails(
                    customer: customer,
                    purchase: Como.shared.currentSale!.purchase
                )
                await MainActor.run {
                    button.animateSuccess()
                    delegate?.como(registered: details)
                }
            } catch {
                await MainActor.run {
                    textField.shake()
                    button.animateFailed()
                    showError(Como.trans("como_\(error)"))
                }
            }
        }
    }
}
