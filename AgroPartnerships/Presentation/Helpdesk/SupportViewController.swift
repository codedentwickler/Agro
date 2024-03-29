//
//  SupportViewController.swift
//  AgroPartnerships
//
//  Created by Kanyinsola on 31/08/2019.
//  Copyright © 2019 AgroPartnerships. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SupportViewController: BaseViewController {

    @IBOutlet weak var subjectTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var attachmentAddedView: UIView!
    @IBOutlet weak var attachmentAddedViewHeight: NSLayoutConstraint!

    private var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func userPressedUploadAttachmentButton(sender: UIButton) {
        chooseImage()
    }
    
    @IBAction func userPressedSubmit(sender: UIButton) {
        submit()
    }
    
    @IBAction func userPressedRemoveAttachedment(_ sender: Any) {
        image = nil
        attachmentAddedView.isHidden = true
        attachmentAddedViewHeight.constant = CGFloat(0.0)
    }
    
    private func submit() {
        let subject = subjectTextView.text ?? ""
        let message = bodyTextView.text ?? ""
        let email = LoginSession.shared.dashboardInformation?.profile?.email ?? ""
        
        if subject.count < 5 || message.count < 5 {
            showAlertDialog(message: "Please enter a subject with at least 2 words and a message with at least 3 words")
            return
        }
        
        let parameters = ["email": email, "subject": subject, "message": message]
        
        var imageData: Data? = nil
        if image != nil {
            let compressionRatio = CGFloat(image?.getImageSizeCompressionRatio() ?? 0)
            AgroLogger.log(":IMAGE RATIO \(compressionRatio)")
            imageData = image?.jpegData(compressionQuality: compressionRatio)
        }
       
        let headers = ["Content-type": "multipart/form-data",
                   "Content-Disposition" : "form-data"]
        
        showLoading(withMessage: "Sending your message to support . . .")
        Alamofire.upload(multipartFormData: { (data) in
            if let imageData = imageData {
                AgroLogger.log(":IMAGE DATA \(imageData)")
                data.append(imageData, withName: "attachment", fileName: "\(UUID.init().uuidString).jpg",
                    mimeType: "image/jpg")
            }
            for (key, value) in parameters {
                data.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to: ApiEndPoints.helpdesk(),
           headers: headers) {[unowned self] (result) in
            AgroLogger.log("Result \(result)")
            switch result {
            case .success(let upload, _,_):
                upload.responseJSON(completionHandler: { (response) in
                    self.dismissLoading()

                    if let result = response.result.value {
                        let json = JSON(result)
                        if json[ApiConstants.Status].stringValue == ApiConstants.Success {
                            self.resetViews()
                            self.createAlertDialog(title: "Message Delivered",
                                                   message: "A Help Desk personel would get across to you either by mail or phone",
                                                   ltrActions: [self.creatAlertAction("Done", style: .default, clicked: nil)])
                            
                        } else {
                            self.showAlertDialog(message: "An error occured, please try again.")
                        }
                    }
                })
            case .failure(let error):
                self.dismissLoading()
                self.showAlertDialog(message: "An error occured, please try again.")
                AgroLogger.log(error)
            }
        }
    }
    
    private func resetViews() {
        self.subjectTextView.text = nil
        self.bodyTextView.text = nil
        userPressedRemoveAttachedment(attachmentAddedView)
    }
    
    @objc private func chooseImage() {
        
        let cameraAction = creatAlertAction("Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self;
                myPickerController.sourceType = .camera
                myPickerController.allowsEditing = true
//                myPickerController.modalPresentationStyle = .fullScreen
                self.present(myPickerController, animated: true, completion: nil)
            }
        }
        
        let photoLibraryAction = creatAlertAction("Photo Library", style: .default) { (action) in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            pickerController.allowsEditing = true
//            pickerController.modalPresentationStyle = .fullScreen
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let cancel = creatAlertAction("Cancel", style: .cancel, clicked: nil)
        
        createActionSheet(title: "",
                          message: "Please choose one",
                          ltrActions: [cameraAction,
                                       photoLibraryAction, cancel])
    }
}

extension SupportViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = image
            self.attachmentAddedView.isHidden = false
            self.attachmentAddedViewHeight.constant = CGFloat(30.0)
            dismiss(animated: true, completion: nil)
        }
    }
}
