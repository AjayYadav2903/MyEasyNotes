//
//  AttachmentHandler.swift
//  AttachmentHandler
//
//  Created by Deepak on 25/01/18.
//  Copyright © 2018 Deepak. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos

/*
 AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
 AttachmentHandler.shared.imagePickedBlock = { (image) in
 /* get your image here */
 }
 */



class AttachmentHandler: NSObject{
    static let shared = AttachmentHandler()
    fileprivate var currentVC: UIViewController?
    
    //MARK: - Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    
    var imagePickedData: URL?
    var videoPickedData: URL?
    var filePickedData: URL?
    
    
    enum AttachmentType: String{
        case camera, video, photoLibrary,audio
    }
    
    
    //MARK: - Constants
    struct Constants {
        static let actionFileTypeHeading = "Add a File"
        static let actionFileTypeDescription = "Choose a file to Upload..."
        static let camera = "Camera"
        static let phoneLibrary = "Phone Library"
        static let video = "Video"
        static let file = "File"
        static let audio = "Audio"

        
        static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
        
        static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
        
        static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
        
        
        static let settingsBtnTitle = "Settings"
        static let cancelBtnTitle = "Cancel"
        
    }
    func showAudioList(vc:UIViewController)  {
        currentVC = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: Constants.audio, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .audio, vc: self.currentVC!)
        }))
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    func showVideoList(vc:UIViewController)  {
        currentVC = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
        }))
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    func showImageLibraryList(vc:UIViewController)  {
        currentVC = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
       actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
        }))
        actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
        }))
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    func showFileLibraryList(vc:UIViewController,fileType : String)  {
        currentVC = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: Constants.file, style: .default, handler: { (action) -> Void in
            if fileType == "pdf" {
                self.documentPickerPDF()
            }else {
                self.documentPickerTextDoc()
            }
            // completionBlock(self.filePickedData!)
        }))
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    //MARK: - showAttachmentActionSheet
    // This function is used to show the attachment sheet for image, video, photo and file.
    func showAttachmentActionSheet(vc: UIViewController) {
        
        currentVC = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
            
        }))
        
//        actionSheet.addAction(UIAlertAction(title: Constants.file, style: .default, handler: { (action) -> Void in
//            self.documentPickerPDF()
//            // completionBlock(self.filePickedData!)
//        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Authorisation Status
    // This is used to check the authorisation status whether user gives access to import the image, photo library, video.
    // if the user gives access, then we can import the data safely
    // if not show them alert to access from settings.
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController){
        currentVC = vc
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            if attachmentTypeEnum == AttachmentType.camera{
                openCamera()
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                photoLibrary()
            }
            if attachmentTypeEnum == AttachmentType.video{
                videoLibrary()
            }
            
            if attachmentTypeEnum == AttachmentType.audio{
                audioLibrary()
            }
            
            
        case .denied:
            print("permission denied")
            self.addAlertForSettings(attachmentTypeEnum)
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    print("access given")
                    if attachmentTypeEnum == AttachmentType.camera{
                        self.openCamera()
                    }
                    if attachmentTypeEnum == AttachmentType.photoLibrary{
                        self.photoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        self.videoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.audio{
                        self.audioLibrary()
                    }

                }else{
                    print("restriced manually")
                    self.addAlertForSettings(attachmentTypeEnum)
                }
            })
        case .restricted:
            print("permission restricted")
            self.addAlertForSettings(attachmentTypeEnum)
        default:
            break
        }
    }
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - PHOTO PICKER
    func photoLibrary(){
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            DispatchQueue.main.async {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - VIDEO PICKER
    func videoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func audioLibrary(){
           if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
               let myPickerController = UIImagePickerController()
               myPickerController.delegate = self
               myPickerController.sourceType = .photoLibrary
               myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeAudio as String]
               currentVC?.present(myPickerController, animated: true, completion: nil)
           }
       }
    
    //MARK: - FILE PICKER
    func documentPickerPDF(){
        let importMenu = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        currentVC?.present(importMenu, animated: true, completion: nil)
    }
    
    func documentPickerTextDoc(){
        let importMenu = UIDocumentPickerViewController(documentTypes: [kUTTypeText as String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        currentVC?.present(importMenu, animated: true, completion: nil)
    }
    
    //MARK: - SETTINGS ALERT
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType){
        var alertTitle: String = ""
        if attachmentTypeEnum == AttachmentType.camera{
            alertTitle = Constants.alertForCameraAccessMessage
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary{
            alertTitle = Constants.alertForPhotoLibraryMessage
        }
        if attachmentTypeEnum == AttachmentType.video{
            alertTitle = Constants.alertForVideoLibraryMessage
        }
        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(cancelAction)
        cameraUnavailableAlertController .addAction(settingsAction)
        currentVC?.present(cameraUnavailableAlertController , animated: true, completion: nil)
    }
}

//MARK: - IMAGE PICKER DELEGATE
// This is responsible for image picker interface to access image, video and then responsibel for canceling the picker
extension AttachmentHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
            var mimeType = ""
            // var dataVideo = try Data(contentsOf:  image.pngData())
            let fileurls = info[UIImagePickerController.InfoKey.imageURL] as? URL
            if fileurls == nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fileSelectionclicked"), object: nil, userInfo: ["fileData":image.pngData() as Any,"fileName" : "\(DataUtils.randomStringGenrator(length: 6).lowercased()).png" ,"mimeType" : "application/png","uploadFileKey":"post_image"])
                
            }
            
            guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
                return (currentVC?.dismiss(animated: true, completion: nil))!
            }
            print(fileUrl.lastPathComponent)
            let assetPath = fileUrl
            print(assetPath.absoluteString)
            if (assetPath.absoluteString.hasSuffix("jpeg")) {
                print("JPG")
                mimeType = "application/jpeg"
            }
            else if (assetPath.absoluteString.hasSuffix("png")) {
                mimeType = "application/png"
                print("PNG")
            }
            else if (assetPath.absoluteString.hasSuffix("jpg")) {
                mimeType = "application/jpg"
                
                print("GIF")
            }else if (assetPath.absoluteString.hasSuffix("heic")) {
                mimeType = "application/heic"
                
                print("GIF")
            }
            else if (assetPath.absoluteString.hasSuffix("heif")) {
                mimeType = "application/heif"
                
                print("GIF")
            }else {
                mimeType = "application/jpeg"
                
            }
            let imgData = NSData(contentsOf: fileUrl as URL)!
            var filename = ""
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                let assetResources = PHAssetResource.assetResources(for: asset)
                filename = assetResources.first!.originalFilename.lowercased()
                print(assetResources.first!.originalFilename)
            }
            if (filename.lowercased().hasSuffix("jpeg")) {
                print("JPG")
                mimeType = "application/jpeg"
            }
            else if (filename.lowercased().hasSuffix("png")) {
                mimeType = "application/png"
                print("PNG")
            }
            else if (filename.lowercased().hasSuffix("jpg")) {
                mimeType = "application/jpg"
                
                print("GIF")
            }
            else if (filename.lowercased().hasSuffix("heic")) {
                mimeType = "application/heic"
                
                print("GIF")
            }
            else if (filename.lowercased().hasSuffix("heif")) {
                mimeType = "application/heif"
                
                print("GIF")
            }
            else {
                mimeType = "application/jpeg"
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fileSelectionclicked"), object: nil, userInfo: ["fileData":imgData,"fileName" : filename.lowercased(),"mimeType" : mimeType,"uploadFileKey":"post_image"])
            
        } else{
            print("Something went wrong in  image")
        }
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL{
            print("videourl: ", videoUrl)
             var filename = ""
            filename = videoUrl.lastPathComponent!
            if filename.hasSuffix("mp3") || filename.hasSuffix("wav") {
                do {
                    let dataVideo = try Data(contentsOf:  videoUrl as URL)
                    //print(dataPDF.base64EncodedString())
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fileSelectionclicked"), object: nil, userInfo: ["fileData":dataVideo,"fileName" : filename,"mimeType" : "audio/mpeg","uploadFileKey":"post_audio"])
                } catch  {
                    
                }
            }else {
                //trying compression of video
                let data = NSData(contentsOf: videoUrl as URL)!
                
                print("File size before compression: \(Double(data.length / 1048576)) mb")
                compressWithSessionStatusFunc(videoUrl)
            }
        }
        else{
            print("Something went wrong in  video")
        }
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Video Compressing technique
    fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mp4")
        compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                // var dataVideo = try Data(contentsOf:  image.pngData())
               
                var filename = ""
                filename = compressedURL.lastPathComponent.lowercased()
                DispatchQueue.main.async {
                    do {
//                        var videoData = try Data(contentsOf:  compressedURL)
//
//
//                        print(videoData.base64EncodedString())
                        let dataVideo = try Data(contentsOf:  compressedURL)
                        //print(dataPDF.base64EncodedString())
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fileSelectionclicked"), object: nil, userInfo: ["fileData":dataVideo,"fileName" : filename,"mimeType" : "video/mp4","uploadFileKey":"post_video"])

                        // self.formData.pdfData = dataPDF.base64EncodedString()
                        
                    } catch  {
                        
                    }
                    self.videoPickedBlock?(compressedURL as NSURL)
                }
                
            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }
    
    // Now compression is happening with medium quality, we can change when ever it is needed
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}

//MARK: - FILE IMPORT DELEGATE
extension AttachmentHandler: UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        drawPDFfromURL(url: (urls.first)!)
        var filename = ""
        filename = (urls.first)!.lastPathComponent.lowercased()
       // filePickedData = ((urls.first!))
      //  self.filePickedBlock?((urls.first!))
        let urlPDF = (urls.first)!
        do {
            let dataPDF = try Data(contentsOf:  urlPDF)
            //print(dataPDF.base64EncodedString())
            if filename.hasSuffix("pdf") {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fileSelectionclicked"), object: nil, userInfo: ["fileData":dataPDF,"fileName" : filename,"mimeType" : "application/pdf","uploadFileKey":"post_pdf"])

            }else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fileSelectionclicked"), object: nil, userInfo: ["fileData":dataPDF,"fileName" : filename,"mimeType" : "application/rtf","uploadFileKey":"post_txt"])

            }
            
            // self.formData.pdfData = dataPDF.base64EncodedString()
            
        } catch  {
            
        }
        
    }
    
    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            ctx.cgContext.drawPDFPage(page)
        }
        
        return img
    }
    
    //    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
    //        documentPicker.delegate = self
    //        currentVC?.present(documentPicker, animated: true, completion: nil)
    //    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("url", url)
    }
    
    //    Method to handle cancel action.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
}
