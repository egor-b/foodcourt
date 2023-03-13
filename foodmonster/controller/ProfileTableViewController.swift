//
//  ProfileTableViewController.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 2/28/21.
//

import UIKit
import StoreKit
import LinkPresentation
import Photos
import Firebase

class ProfileTableViewController: UITableViewController {
    
    let metadata = LPLinkMetadata()
    private let constant = Constant()
    private var auth: AuthanticateManagerProtocol?
    private var firebase: FirebaseStorageServiceManagerProtocol?
    private var profileTableViewModel: ProfileTableViewViewModelProtocol?
    private let activityView = UIActivityIndicatorView(style: .large)
    private let pickerController = UIImagePickerController()
    
    @IBOutlet weak var updateAvatarImageView: UIImageView!
    
    private var isReload = false
    private let alertTitle = Bundle.main.localizedString(forKey: "ops", value: LocalizationDefaultValues.OPS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let account = Bundle.main.localizedString(forKey: "account", value: LocalizationDefaultValues.ACCOUNT.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let extras = Bundle.main.localizedString(forKey: "extras", value: LocalizationDefaultValues.EXTRAS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    
    private let accDeletionTitle = Bundle.main.localizedString(forKey: "accDeletionTitle", value: LocalizationDefaultValues.ACC_DELETION_TITLE.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let accDeletionMessage = Bundle.main.localizedString(forKey: "accDeletionMessage", value: LocalizationDefaultValues.ACC_DELETION_MESSAGE.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let delete = Bundle.main.localizedString(forKey: "delete", value: LocalizationDefaultValues.DELETE.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    private let cancelTitle = Bundle.main.localizedString(forKey: "cancel", value: LocalizationDefaultValues.CANCEL.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    
    let camTtitle = Bundle.main.localizedString(forKey: "takePhoto", value: LocalizationDefaultValues.TAKE_PHOTO.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    let missCamTitle = Bundle.main.localizedString(forKey: "missCamera", value: LocalizationDefaultValues.MISS_CAMERA.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    let missCamMessage = Bundle.main.localizedString(forKey: "cameraPhoto", value: LocalizationDefaultValues.CAMERA_PHOTO.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    let photoLibTitle = Bundle.main.localizedString(forKey: "chooseFromLib", value: LocalizationDefaultValues.CHOOSE_FROM_LIB.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    let removePhotoTitle = Bundle.main.localizedString(forKey: "removePhoto", value: LocalizationDefaultValues.REMOVE_PHOTO.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    
    let noPermission = Bundle.main.localizedString(forKey: "noPermission", value: LocalizationDefaultValues.NO_PERMISSION.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    let moveToSettings = Bundle.main.localizedString(forKey: "moveToSettings", value: LocalizationDefaultValues.MOVE_TO_SETTINGS.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    let go = Bundle.main.localizedString(forKey: "go", value: LocalizationDefaultValues.GO.rawValue, table: LocalizationDefaultValues.LOCALIZATION_FILE.rawValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerController.delegate = self
        auth = AuthanticateManager()
        firebase = FirebaseStorageServiceManager()
        registerCells()
        profileTableViewModel = ProfileTableViewViewModel()
        configureNavigationBar()
        userImageStyle()
        setTapGuestureRecognize()
        fillOutController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if isReload || globalUserId.isEmpty {
            fillOutController()
        }
    }
    
    private func setTapGuestureRecognize() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentAlertController(tapGestureRecognizer:)))
        updateAvatarImageView.isUserInteractionEnabled = true
        updateAvatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func fillOutController() {
        guard let profileTableViewModel = profileTableViewModel else { return }
        if !globalUserId.isEmpty {
            showActivityIndicatory(activityView: activityView)
            profileTableViewModel.retriveUserData(uid: globalUserId) { [weak self] error in
                if let error = error {
                    
                    self?.showAlert(title: self!.alertTitle, message: error.localizedDescription)
                }
                self?.loadUserImage()
            }
        } else {
            self.stopActivityIndicatory(activityView: self.activityView)
            showUnknownUserAlert()
        }
        isReload = false
    }
    
    func loadUserImage() {
        guard let profileTableViewModel = profileTableViewModel else { return }
        profileTableViewModel.loadUserPic { img, error in
            if let error = error {
                self.showAlert(title: self.alertTitle, message: error.localizedDescription)
            } else {
                self.updateAvatarImageView.image = UIImage(data: img ?? Data())
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.stopActivityIndicatory(activityView: self.activityView)
            }
        }
    }
    
    func userImageStyle() {
        updateAvatarImageView.layer.masksToBounds = true
        updateAvatarImageView.layer.cornerRadius = 30
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "NameTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.PROFILE_NAME_CELL.rawValue)
        tableView.register(UINib(nibName: "EmailTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.PROFILE_EMAIL_CELL.rawValue)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileTableViewModel?.numberOfRows(inSection: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let profileTableViewModel = profileTableViewModel else { return UIView() }
        switch section {
        case 0:
            return profileTableViewModel.viewForHeader(width: tableView.bounds.size.width, height: 40, title: account)
        case 1:
            return profileTableViewModel.viewForHeader(width: tableView.bounds.size.width, height: 40, title: extras)
        default:
            return UIView()
        }
    }
    
    @IBAction func logoutBarButton(_ sender: Any) {
        self.dismiss(animated: true) { [self] in
            auth?.logout()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileTableViewModel = profileTableViewModel else { return UITableViewCell() }
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.PROFILE_NAME_CELL.rawValue, for: indexPath) as? NameTableViewCell else { return UITableViewCell() }
                cell.viewModel = profileTableViewModel.cellViewModel(forIndexPath: indexPath)
                return cell
            }
            if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.PROFILE_EMAIL_CELL.rawValue, for: indexPath) as? EmailTableViewCell else { return UITableViewCell() }
                cell.viewModel = profileTableViewModel.cellViewModel(forIndexPath: indexPath)
                return cell
            }
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !globalUserId.isEmpty {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    performSegue(withIdentifier: Segue.EDIT_NAME_SEQUE.rawValue, sender: nil)
                }
                if profileTableViewModel?.getUser().accountType == "EMAIL" {
                    if indexPath.row == 1 {
                        performSegue(withIdentifier: Segue.CHANGE_EMAIL_SEGUE.rawValue, sender: nil)
                    }
                    if indexPath.row == 2 {
                        performSegue(withIdentifier: Segue.CHANGE_PASS_SEQUE.rawValue, sender: nil)
                    }
                } else {
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    performSegue(withIdentifier: Segue.ABOUT_SEGUE.rawValue, sender: nil)
                }
                if indexPath.row == 1 {
                    SKStoreReviewController.requestReview()
                }
                if indexPath.row == 2 {
                    let activityView = UIActivityViewController(activityItems: [self], applicationActivities: nil)
                    present(activityView, animated: true)
                }
                if indexPath.row == 3 {
                    print("CONTACT US")
                }
            }
            if indexPath.section == 2 {
                if indexPath.row == 0 {
                    customAlertWithHandler(title: accDeletionTitle, message: accDeletionMessage, submitTitle: delete, declineTitle: cancelTitle) {
                        self.showActivityIndicatory(activityView: self.activityView)
                        self.profileTableViewModel?.deleteUser(completion: { error in
                            if let error = error {
                                self.showAlert(title: self.alertTitle, message: error.localizedDescription)
                            } else {
                                self.dismiss(animated: true) { [self] in
                                    self.stopActivityIndicatory(activityView: activityView)
                                    auth?.logout()
                                }
                            }
                        })
                    } declineHandler: { }
                }
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
              let indexPath = tableView.indexPathForSelectedRow,
              let profileTableViewModel = profileTableViewModel else { return }
        if !globalUserId.isEmpty {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    if identifier == Segue.EDIT_NAME_SEQUE.rawValue {
                        if let destinationVC = segue.destination as? NameLastNameViewController {
                            destinationVC.user = profileTableViewModel.getUser()
                            isReload = true
                        }
                    }
                }
                if profileTableViewModel.getUser().accountType == "EMAIL" {
                    if indexPath.row == 1 {
                        if identifier == Segue.CHANGE_EMAIL_SEGUE.rawValue {
                            if let destinationVC = segue.destination as? ChangeEmailViewController {
                                destinationVC.user = profileTableViewModel.getUser()
                                isReload = true
                            }
                        }
                    }
                    if indexPath.row == 2 {
                        if identifier == Segue.CHANGE_PASS_SEQUE.rawValue {
                            if segue.destination is ChangePasswordViewController {
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension ProfileTableViewController {
    
    func configureNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: constant.darkTitleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: constant.darkTitleColor]
        navBarAppearance.backgroundColor = constant.backgoundColor
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = constant.darkTitleColor
        tableView.tableFooterView = UIView()
    }
    
}

extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func presentAlertController(tapGestureRecognizer: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: camTtitle, style: .default, handler: { [self] (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
            } else {
                self.showAlert(title: missCamTitle, message: missCamMessage)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: photoLibTitle, style: .default, handler: { [self] (action:UIAlertAction) in
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { s in
                    if s == .authorized {
                        DispatchQueue.main.async {
                            self.pickerController.sourceType = .photoLibrary
                            self.present(self.pickerController, animated: true, completion: nil)
                        }
                    }
                }
            case .authorized:
                self.pickerController.sourceType = .photoLibrary
                self.present(self.pickerController, animated: true, completion: nil)
            default:
                let alertController = UIAlertController (title: noPermission, message: moveToSettings, preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: go, style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: camTtitle, style: .default, handler: nil)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        if updateAvatarImageView.image != nil {
            actionSheet.addAction(UIAlertAction(title: removePhotoTitle, style: .destructive, handler: { [self](_ action: UIAlertAction) -> Void in
                profileTableViewModel?.updateUserPic(img: nil, completion: { error in
                    if let error = error {
                        self.showAlert(title: self.alertTitle, message: error.localizedDescription)
                    } else {
                        self.updateAvatarImageView.image = nil
                    }
                })
            }))
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            updateAvatarImageView.image = image
            guard let data = image.jpegData(compressionQuality: 0.1) else { return }
            profileTableViewModel?.updateUserPic(img: data, completion: { [self] error in
                if let error = error {
                    self.showAlert(title: alertTitle, message: error.localizedDescription)
                    self.updateAvatarImageView.image = nil
                }
            })
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController.dismiss(animated: true, completion: nil)
    }
    
}

extension ProfileTableViewController: UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return metadata.url ?? ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return metadata.url
    }
    
    func activityViewControllerLinkMetadata(_: UIActivityViewController) -> LPLinkMetadata? {
        metadata.title = "Food Monster"
        metadata.originalURL = URL(string: "https://itunes.apple.com/app/id1662192971")
        metadata.url = metadata.originalURL
        // Using a locally stored item
        metadata.iconProvider = NSItemProvider(object: UIImage(named: "Logo")!)
        metadata.imageProvider = NSItemProvider(object: UIImage(named: "Logo")!)
        return metadata
    }
}
