import UIKit
import Flutter
import MLKit
import MLKitPoseDetectionAccurate
import MLKitVision
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
          GeneratedPluginRegistrant.register(with: registry)
        }

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        PlatformPoseDetectorSetup(controller.binaryMessenger, MyApi())

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
}
class MyApi:NSObject,PlatformPoseDetector{
    
    func processImageInputImage(_ inputImage: PlatformInputImage, completion: @escaping (PlatformPose?, FlutterError?) -> Void) {
        if detector == nil {
            detector = self.initialize()
        }
        let image = VisionImageUtils.visionImage(from: inputImage.planes, with: inputImage.inputImageData)
        detector.process(image!) { poses, error in
            if((error) != nil){
                completion(PlatformPose.make(withLandmarks: [:]), error as? FlutterError)
            }
            if (poses == nil || poses!.count == 0) {
                completion(PlatformPose.make(withLandmarks: [:]), error as? FlutterError)
                return
            }
            let pose = poses!.first!
            
            var landmarks = Dictionary<NSNumber,PlatformPoseLandmark>();

                for landmark in pose.landmarks {
                    landmarks[self.poseLandmarkTypeToNumber(landmarkType: landmark.type)] = PlatformPoseLandmark.make(withType: self.poseLandmarkTypeToNumber(landmarkType: landmark.type), x: landmark.position.x as NSNumber, y: landmark.position.y as NSNumber as NSNumber, z: landmark.position.z as NSNumber, likelihood: landmark.inFrameLikelihood as NSNumber)
                }
            
            completion(PlatformPose.make(withLandmarks: landmarks), nil)
        }
    }
    
    func closeWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        detector=nil;
    }
    
    typealias PoseDetector = MLKit.PoseDetector
    private var detector:PoseDetector!
    
    func initialize() -> PoseDetector! {
        return PoseDetector.poseDetector(options: AccuratePoseDetectorOptions())
    }

    func poseLandmarkTypeToNumber(landmarkType:PoseLandmarkType) -> NSNumber {
        let types:NSMutableDictionary! = NSMutableDictionary()
        types[PoseLandmarkType.nose] = 0
        types[PoseLandmarkType.leftEyeInner] = 4
        types[PoseLandmarkType.leftEye] = 5
        types[PoseLandmarkType.leftEyeOuter] = 6
        types[PoseLandmarkType.rightEyeInner] = 1
        types[PoseLandmarkType.rightEye] = 2
        types[PoseLandmarkType.rightEyeOuter] = 3
        types[PoseLandmarkType.leftEar] = 8
        types[PoseLandmarkType.rightEar] = 7
        types[PoseLandmarkType.mouthLeft] = 10
        types[PoseLandmarkType.mouthRight] = 9
        types[PoseLandmarkType.leftShoulder] = 12
        types[PoseLandmarkType.rightShoulder] = 11
        types[PoseLandmarkType.leftElbow] = 14
        types[PoseLandmarkType.rightElbow] = 13
        types[PoseLandmarkType.leftWrist] = 16
        types[PoseLandmarkType.rightWrist] = 15
        types[PoseLandmarkType.leftPinkyFinger] = 18
        types[PoseLandmarkType.rightPinkyFinger] = 17
        types[PoseLandmarkType.leftIndexFinger] = 20
        types[PoseLandmarkType.rightIndexFinger] = 19
        types[PoseLandmarkType.leftThumb] = 22
        types[PoseLandmarkType.rightThumb] = 21
        types[PoseLandmarkType.leftHip] = 24
        types[PoseLandmarkType.rightHip] = 23
        types[PoseLandmarkType.leftKnee] = 26
        types[PoseLandmarkType.rightKnee] = 25
        types[PoseLandmarkType.leftAnkle] = 28
        types[PoseLandmarkType.rightAnkle] = 27
        types[PoseLandmarkType.leftHeel] = 30
        types[PoseLandmarkType.rightHeel] = 29
        types[PoseLandmarkType.leftToe] = 32
        types[PoseLandmarkType.rightToe] = 31
        return types[landmarkType] as! NSNumber
    }
    
}
