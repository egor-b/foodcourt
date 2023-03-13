//
//  NewStepViewController.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/26/20.
//

import UIKit

class NewStepViewController: UIViewController {

    @IBOutlet weak var addStageView: UIImageView!
    @IBOutlet weak var stepDescriptionTextView: UITextView!
    @IBOutlet weak var saveStepBarButtonItem: UIBarButtonItem!
    
    var step = StepModel()
    
    private let pickerController = UIImagePickerController()
    private var firebaseStorage: FirebaseStorageServiceManagerProtocol?
    var newRecipeViewModelProtocol: NewRecipeTableViewViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        stepDescriptionTextView.delegate = self
        pickerController.delegate = self
        saveStepBarButtonItem.isEnabled = false
        firebaseStorage = FirebaseStorageServiceManager()
        setTapGuestureRecognize()
        stepDescriptionTextView.text = step.step
        if !step.img.isEmpty {
            addStageView.image = UIImage(data: step.img)
        } else {
            firebaseStorage?.retreiveImage(step.pic, completion: { img in
                self.addStageView.image = UIImage(data: img)
            })
        }
        stepDescriptionTextView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissNavigationButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setTapGuestureRecognize() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        addStageView.isUserInteractionEnabled = true
        addStageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        presentAlertController()
    }
    
}

extension NewStepViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentAlertController() {
        
        let camTtitle = Bundle.main.localizedString(forKey: "takePhoto", value: LocalizationDefaultValues.TAKE_PHOTO.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        let alertTitle = Bundle.main.localizedString(forKey: "missCamera", value: LocalizationDefaultValues.MISS_CAMERA.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        let alertMessage = Bundle.main.localizedString(forKey: "cameraPhoto", value: LocalizationDefaultValues.CAMERA_PHOTO.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        let photoLibTitle = Bundle.main.localizedString(forKey: "chooseFromLib", value: LocalizationDefaultValues.CHOOSE_FROM_LIB.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        let cancelTitle = Bundle.main.localizedString(forKey: "cancel", value: LocalizationDefaultValues.CANCEL.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        let removePhotoTitle = Bundle.main.localizedString(forKey: "removePhoto", value: LocalizationDefaultValues.REMOVE_PHOTO.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: camTtitle, style: .default, handler: { [self] (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
            } else {
                self.showAlert(title: alertTitle, message: alertMessage)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: photoLibTitle, style: .default, handler: { [self] (action:UIAlertAction) in
            self.pickerController.sourceType = .photoLibrary
            self.present(self.pickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        if addStageView.image != nil {
            actionSheet.addAction(UIAlertAction(title: removePhotoTitle, style: .destructive, handler: { [self](_ action: UIAlertAction) -> Void in
                self.addStageView.image = nil
                step.img = Data()
                newRecipeViewModelProtocol?.deleteImage.append(step.pic)
                step.pic = ""
            }))
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            addStageView.image = image
            guard let data = image.jpegData(compressionQuality: 0.1) else { return }
            step.img = data
            if !step.pic.isEmpty {
                imageCash.removeObject(forKey: step.pic as AnyObject)
            }
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController.dismiss(animated: true, completion: nil)
    }
    
}

extension NewStepViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let text = textView.text, text.count < 5 {
            saveStepBarButtonItem.isEnabled = false
        } else {
            saveStepBarButtonItem.isEnabled = true
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 1000
    }
}
