//
//  ViewController.swift
//  barcode-scan
//
//  Created by John Thompson on 02/18/18
//  Copyright © 2018 John Thompson. All rights reserved.
//

import AVKit
import UIKit
import Vision

class ViewController: UIViewController {
    
    @IBOutlet var previewView: VideoPreviewView!
    
    @IBAction func selectPreview(_ sender: UITapGestureRecognizer) {
        snapPhoto()
    }
    
    var sku: String!
    var captureSession: AVCaptureSession!
    var capturePhotoOutput: AVCapturePhotoOutput!
    var isCaptureSessionConfigured = false
    
    private func configureCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Unable to find capture device")
            return
        }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            print("Unable to obtain video input")
            return
        }
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput.isHighResolutionCaptureEnabled = true
        capturePhotoOutput.isLivePhotoCaptureEnabled = capturePhotoOutput.isLivePhotoCaptureSupported
        guard captureSession.canAddInput(videoInput) else {
            print("Unable to add input")
            return
        }
        guard captureSession.canAddOutput(capturePhotoOutput) else {
            print("Unable to add output")
            return
        }
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        captureSession.addInput(videoInput)
        captureSession.addOutput(capturePhotoOutput)
        captureSession.commitConfiguration()
    }
    
    private func snapPhoto() {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        guard let captureConnection = previewView.videoPreviewLayer.connection else { return }
        if let photoOutputConnection = capturePhotoOutput.connection(with: AVMediaType.video) {
            photoOutputConnection.videoOrientation = captureConnection.videoOrientation
        }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    private func scanImage(cgImage: CGImage) {
        let barcodeRequest = VNDetectBarcodesRequest(completionHandler: { request, error in
            self.reportResults(results: request.results)
        })
        barcodeRequest.symbologies = [VNBarcodeSymbology.EAN8, VNBarcodeSymbology.EAN13, VNBarcodeSymbology.UPCE, VNBarcodeSymbology.code128, VNBarcodeSymbology.code93, VNBarcodeSymbology.QR];
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [.properties : ""])
        guard let _ = try? handler.perform([barcodeRequest]) else {
            return print("Could not perform barcode-request!")
        }
    }
    
    private func showFirstLaunchAlert() {
        let alertShown = UserDefaults.standard.bool(forKey: "alertShown")
        guard !alertShown else {
            return
        }
        let alert = UIAlertController(title: String(localized: "welcome_title", comment: "Welcome alert title"),
                                      message: String(localized: "welcome_message", comment: "Welcome alert instructions"),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(localized: "got_it", comment: "Confirmation button text"), style: .default, handler: { _ in
            UserDefaults.standard.set(true, forKey: "alertShown")
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func reportResults(results: [Any]?) {
        for result in results! {
            if let barcode = result as? VNBarcodeObservation {
                if let payload = barcode.payloadStringValue {
                    
                    if barcode.symbology == VNBarcodeSymbology.EAN13 && payload.hasPrefix("0") && payload.count > 0 {
                        let index = payload.index(payload.startIndex, offsetBy: 1)
                        self.sku = String(payload[index...])
                    } else {
                        self.sku = payload
                    }
                    DispatchQueue.main.async() {
                        [unowned self] in
                        self.performSegue(withIdentifier: "ItemSegue", sender: self)
                    }
                }
            }
        }
    }
}

// MARK: UIViewControllerDelegate

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession = AVCaptureSession()
        previewView.session = captureSession
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isCaptureSessionConfigured {
            if !captureSession.isRunning {
                captureSession.startRunning()
            }
        } else {
            configureCaptureSession()
            isCaptureSessionConfigured = true
            captureSession.startRunning()
            previewView.updateVideoOrientationForDeviceOrientation()
        }
        showFirstLaunchAlert()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemSegue" {
            let secondView: ItemViewController = segue.destination as! ItemViewController;
            secondView.sku = self.sku
        }
    }
}

// MARK: AVCapturePhotoCaptureDelegate

extension ViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let cgImageRef = photo.cgImageRepresentation() else {
            return print("Could not get image representation")
        }
        let cgImage = cgImageRef.takeUnretainedValue()
        scanImage(cgImage: cgImage)
    }
}

