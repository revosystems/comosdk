import UIKit
import RevoUIComponents
import RevoFoundation

class ComoLoginByPhoneController : ComoPhoneController, OTPViewDelegate {
    
    @IBOutlet var loginOtpView: UIView!
    
    weak var delegate: ComoLoginDelegate!
    
    override var buttonTitleKey: String { "como_search_customer" }
    
    override func setupController() {
        loginOtpView.isHidden = true
    }
    
    override func performAction() {
        sendAuthCode()
    }
    
    private func sendAuthCode() {
        Task {
            do {
                button.animateProgress()
                guard let phone else { throw PhoneValidationError.InvalidPhoneNumber }
                try await Como.shared.sendIdentificationCode(
                    customer: Como.Customer(phoneNumber: phone)
                )
                await MainActor.run {
                    button.animateSuccess()
                    onCodeSent()
                }
            } catch {
                await MainActor.run {
                    button.animateFailed()
                    onError(error)
                }
            }
        }
    }
    
    private func onCodeSent() {
        loginOtpView.isHidden = false
        button.isHidden = true
        textField.isHidden = true
        loginOtpView.subviews.first?.subviews.first {
            $0 is OTPView
        }?.becomeFirstResponder()
    }
    
    private func resetView() {
        loginOtpView.isHidden = true
        button.isHidden = false
        textField.isHidden = false
        button.reset()
    }
    
    // MARK: - OTP Delegate
    func otp(codeEntered code: String) {
        Task {
            do {
                let customer = Como.Customer(appClientId: code)
                let details = try await Como.shared.getMemberDetails(
                    customer: customer,
                    purchase: Como.shared.currentSale!.purchase
                )
                Como.shared.currentSale?.customer = details.membership.customer
                await MainActor.run {
                    resetView()
                    delegate?.como(onLoggedIn: details)
                }
            } catch {
                await MainActor.run {
                    loginOtpView.shake()
                    button.animateFailed()
                    onError(error, asOtp: true)
                }
            }
        }
    }
    
    private func onError(_ error: Error, asOtp: Bool = false) {
        if let error = error as? PhoneValidationError {
            return errorLabel.text = "Número de teléfono inválido"
        }
        if "\(error)".contains("4001012") && !asOtp { //Customer not found
            return askToRegister()
        }
        
        showError(error)
    }
    
    private func askToRegister() {
        Task {
            if case .ok = await Alert(Como.trans("como_wantToRegister"), message:Como.trans("como_wantToRegisterDesc"), cancelText: Como.trans("como_no")).show() {
                do {
                    button.animateProgress()
                    guard let phone else { throw PhoneValidationError.InvalidPhoneNumber }
                    let customer = Como.Customer(phoneNumber: phone)
                    try await Como.shared.quickRegister(customer: customer)
                    let details = try await Como.shared.getMemberDetails(customer: customer, purchase: Como.shared.currentSale!.purchase)
                    
                    Como.shared.currentSale?.customer = details.membership.customer
                    
                    button.animateSuccess()
                    delegate?.como(onLoggedIn: details)
                } catch {
                    button.animateFailed()
                    onError(error)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? ComoControllerLoginOTPController)?.delegate = self
    }
}
