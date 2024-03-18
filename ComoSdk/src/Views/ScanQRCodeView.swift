import UIKit
import AVFoundation

protocol ScanQRCodeViewDelegate{
    func scanQrCode(found code:String)
}

@objc class ScanQRCodeView : UIView, AVCaptureMetadataOutputObjectsDelegate {
    
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureSession: AVCaptureSession!
    var delegate:ScanQRCodeViewDelegate?
    
    func start(){
        if (captureSession?.isRunning == false) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }
        
    func stop(){
        if (captureSession?.isRunning == true) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession.stopRunning()
            }
        }
    }   

    
    func setupCaptureSession(delegate:ScanQRCodeViewDelegate? = nil){
        self.delegate = delegate
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    


    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }

    func failed() {
        /*let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)*/
        captureSession = nil
    }

    
    func found(code: String) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.scanQrCode(found: code)
        }
    }

    
}
