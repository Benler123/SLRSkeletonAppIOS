//
//  CameraView.swift
//  SKRSkeletonAppIOS
//
//  Created by Tyler Kwok on 5/6/24.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    var useBackCamera: Bool
    var cameraEnabled: Bool
    var size: CGSize
    
    let captureSession = AVCaptureSession()
    
    
    func foo () {
        print("foo")
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: CGRect(origin: .zero, size: size))
        
        let deviceType: AVCaptureDevice.DeviceType = useBackCamera ? .builtInDualCamera : .builtInWideAngleCamera
        let devicePosition: AVCaptureDevice.Position = useBackCamera ? .back : .front
        
        guard let captureDevice = AVCaptureDevice.default(deviceType, for:.video , position: devicePosition) else {
            return view
        }
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return view
        }
        
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        }
        
        captureSession.sessionPreset = .high
        
        if captureSession.canAddInput(input){
            captureSession.addInput(input)
        }
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        let placeholderLayer = CALayer()
        placeholderLayer.frame = view.bounds
        placeholderLayer.backgroundColor = UIColor.gray.cgColor
        view.layer.addSublayer(placeholderLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("IN HERE")
        let placehodlerLayer = uiView.layer.sublayers?.last
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            print("Preview layer found")
            
            if let session = previewLayer.session {
                print("Session found")
                
                if cameraEnabled {
                    if !session.isRunning {
                        DispatchQueue.global().async{
                            session.startRunning()
                        }
                        placehodlerLayer?.isHidden = true
                        print("Session started")
                        
                    }
                } else {
                    if session.isRunning {
                        session.stopRunning()
                        placehodlerLayer?.isHidden = false
                        print("Session stopped")
                    }
                }
            } else {
                print("Session not found")
            }
        } else {
            print("Preview layer not found")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate{
        var parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                let ciImage = CIImage(cvPixelBuffer: imageBuffer)
                let context = CIContext(options: nil)
                
                if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                    DispatchQueue.main.async{
                        print(cgImage)
                    }
                }
            }
        }
    }
}


struct CameraButtonView: View{
    @State var cameraEnabled: Bool
    var useBackCamera: Bool
    var body: some View{
        VStack{
            
            CameraView(useBackCamera: useBackCamera, cameraEnabled: cameraEnabled, size: CGSize(width: 300, height: 300))
            
            Button(action: {
                // Perform action when the button is tapped
            }) {
                Image(systemName: cameraEnabled ? "waveform.circle" : "waveform.circle.fill")
                    .imageScale(.large)
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        cameraEnabled = true
                    }
                    .onEnded { _ in
                        cameraEnabled = false
                    }
            )
        }
    }
}

#Preview {
    CameraButtonView(cameraEnabled: false, useBackCamera: false)
}

