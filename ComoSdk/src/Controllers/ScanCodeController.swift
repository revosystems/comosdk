import UIKit
import AVFoundation

class ScanCodeController : UIViewController, ScanQRCodeViewDelegate {
    
    @IBOutlet weak private var scanView:ScanQRCodeView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanView.setupCaptureSession(delegate:self)
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
        print(code)
    }
    
}
