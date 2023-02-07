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
    
    var step = StepModel()
    var byteImageArray = Data()
    
    private let pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerController.delegate = self
        setTapGuestureRecognize()
        stepDescriptionTextView.text = step.step
        if step.pic.count > 1 {
            addStageView.image = UIImage(data: step.img)
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
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [self] (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
            } else {
                self.showAlert(title: "Missing camera", message: "You can't take photo, there is no camera.")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: { [self] (action:UIAlertAction) in
            self.pickerController.sourceType = .photoLibrary
            self.present(self.pickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if addStageView.image != nil {
            actionSheet.addAction(UIAlertAction(title: "Remove Photo", style: .destructive, handler: { [self](_ action: UIAlertAction) -> Void in
                self.addStageView.image = nil
            }))
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            addStageView.image = image
            guard let data = image.jpegData(compressionQuality: 0.2) else { return }
            byteImageArray = data
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController.dismiss(animated: true, completion: nil)
    }
    
}
