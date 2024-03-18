import UIKit
import AVFoundation

protocol ScanCodeControllerDelegate : AnyObject {
    func scanController(onScanned code:String)
}

class ScanCodeController : UIViewController, ScanQRCodeViewDelegate {
    
    @IBOutlet weak private var scanView:ScanQRCodeView!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate:ScanCodeControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanView.setupCaptureSession(delegate:self)
        //Como.trans("como_scanYourCode")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scanView.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanView.stop()
    }
    
    
    func scanQrCode(found code:String){
        navigationController?.popToRootViewController(animated: true)
        delegate?.scanController(onScanned: code)
    }
}
