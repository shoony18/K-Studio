//
//  recViewController.swift
//  track_online
//
//  Created by 刈田修平 on 2019/11/12.
//  Copyright © 2019 刈田修平. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseStorage
import Photos
import MobileCoreServices
import AssetsLibrary

class recViewController: UIViewController, AVCaptureFileOutputRecordingDelegate,UIImagePickerControllerDelegate {

    let fileOutput = AVCaptureMovieFileOutput()
    let currentUid:String = Auth.auth().currentUser!.uid

    var recordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCamera()
        
    }

    func setUpCamera() {
        let captureSession: AVCaptureSession = AVCaptureSession()
        let videoDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)
        let audioDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.audio)

        // video input setting
        let videoInput: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: videoDevice!)
        captureSession.addInput(videoInput)

        // audio input setting
        let audioInput = try! AVCaptureDeviceInput(device: audioDevice!)
        captureSession.addInput(audioInput)

        captureSession.addOutput(fileOutput)

        captureSession.startRunning()

        // video preview layer
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(videoLayer)

        // recording button
        self.recordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        self.recordButton.backgroundColor = UIColor.gray
        self.recordButton.layer.masksToBounds = true
        self.recordButton.setTitle("撮影する", for: .normal)
        self.recordButton.layer.cornerRadius = 20
        self.recordButton.layer.position = CGPoint(x: self.view.bounds.width / 2, y:self.view.bounds.height - 100)
        self.recordButton.addTarget(self, action: #selector(self.onClickRecordButton(sender:)), for: .touchUpInside)
        self.view.addSubview(recordButton)
    }

    @IBAction func onClickRecordButton(sender: UIButton) {
        if self.fileOutput.isRecording {
            // stop recording
            fileOutput.stopRecording()

            self.recordButton.backgroundColor = .gray
            self.recordButton.setTitle("撮影する", for: .normal)
        } else {
            // start recording
            let tempDirectory: URL = URL(fileURLWithPath: NSTemporaryDirectory())
            let fileURL: URL = tempDirectory.appendingPathComponent("mytemp1.mov")

            fileOutput.startRecording(to: fileURL, recordingDelegate: self)

            let now = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy:MM:dd:HH:mm:ss"
            let timenow = formatter.string(from: now as Date)

            let capturingPoint: Float64 = 0.5 // capturingPoint ∈ [0,1]
            let capturingTime: CMTime = generateCMTime(movieURL: fileURL, capturingPoint: capturingPoint)
            let image: CGImage = captureImage(movieURL: fileURL, capturingTime: capturingTime)!
            let uiImage = UIImage(cgImage: image)
            let imageData = uiImage.pngData()
            //            let imageData = UIImageJPEGRepresentation(image.image!, 1.0)!
//            let data = UIImagePNGRepresentation(image.image! )
            let storageReference = Storage.storage().reference().child("\(currentUid)").child("\(timenow).jpg")
            print("\(image)")
            
                   //Storageに保存
            storageReference.putData(imageData!, metadata: nil) { (data, error) in
            if error != nil {
                print("Successful image upload")
                return
                }else {
                    print("error!")
                }
            }
            
            self.recordButton.backgroundColor = .red
            self.recordButton.setTitle("●撮影中", for: .normal)
            
            
        }
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // show alert
        let alert: UIAlertController = UIAlertController(title: "動画を保存しました", message: "1週間以内にアドバイスメッセージが送られてきます", preferredStyle:  .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
   
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy:MM:dd:HH:mm:ss"
        let timenow = formatter.string(from: now as Date)
        let storageReference = Storage.storage().reference().child("\(currentUid)").child("\(timenow).mp4")

        // Start the video storage process
        storageReference.putFile(from: outputFileURL as URL, metadata: nil, completion: { (metadata, error) in
                if error == nil {
                    print("Successful video upload")
                } else {
                    print()
                }
            }
        )
        
        let videoRef = Database.database().reference().child("\(currentUid)").childByAutoId()
        let videoObject = [
            "videoname":"\(timenow).mp4"
        ]
        
        videoRef.setValue(videoObject, withCompletionBlock:{error,ref in
            if error == nil{
                self.dismiss(animated: true, completion: nil)
            }else{
            }
        })

    }
    func generateCMTime(movieURL: URL, capturingPoint: Float64) -> CMTime {
        let asset = AVURLAsset(url: movieURL, options: nil)
        let lastFrameSeconds: Float64 = CMTimeGetSeconds(asset.duration)
        let capturingTime: CMTime = CMTimeMakeWithSeconds(lastFrameSeconds * capturingPoint, preferredTimescale: 1)
        return capturingTime
    }
    func captureImage(movieURL: URL, capturingTime: CMTime) -> CGImage? {
        let asset: AVAsset = AVURLAsset(url: movieURL, options: nil)
        let imageGenerator: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let cgImage: CGImage = try imageGenerator.copyCGImage(at: capturingTime, actualTime: nil)
            return cgImage
        } catch {
            return nil
        }
    }
}
