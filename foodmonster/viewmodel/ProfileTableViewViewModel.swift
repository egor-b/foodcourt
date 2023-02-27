//
//  ProfileTableViewViewModel.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/18/22.
//

import UIKit

protocol ProfileTableViewViewModelProtocol {
    
    func numberOfRows(inSection section: Int) -> Int
    func viewForHeader(width: CGFloat, height: CGFloat, title: String) -> UIView
    func cellViewModel(forIndexPath indexPath: IndexPath) -> UserProfileCellViewModelProtocol?
    
    func retriveUserData(uid: String, completion: @escaping(Error?) -> ())
    func resetPassword(completion: @escaping(Error?) -> ())
    func rateApp(completion: @escaping(Error?) -> ())
    func contactUs(completion: @escaping(Error?) -> ())
    
    func getUser() -> User
    func updateUserPic(img: Data?, completion: @escaping (Error?) -> ())
    func loadUserPic(completion: @escaping (Data?, Error?) -> ())
    
}

class ProfileTableViewViewModel: ProfileTableViewViewModelProtocol {
    
    private var authManger: AuthanticateManagerProtocol?
    private var firebaseStorage: FirebaseStorageServiceManagerProtocol?

    private var user: User?
    
    init() {
        authManger = AuthanticateManager()
        firebaseStorage = FirebaseStorageServiceManager()
    }
        
    func viewForHeader(width: CGFloat, height: CGFloat, title: String) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.frame.width - 50, height: headerView.frame.height))
        label.text = title
        label.textColor = UIColor(named: "lightTextColorSet")
        headerView.addSubview(label)
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard let user = user else { return 0 }
        if section == 0 {
            if user.accountType == "EMAIL" {
                return 3
            } else {
                return 2
            }
        }
        if section == 1 {
            return 3
        }
        return 0
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> UserProfileCellViewModelProtocol? {
        guard let user = user else { return nil }
        return UserProfileCellViewModel(user: user)
    }
    
    func retriveUserData(uid: String, completion: @escaping (Error?) -> ()) {
        guard let authManger = authManger else { return }
        authManger.findUserByid(uid: uid, completion: { [weak self] user, error in
            if let error = error {
                completion(error)
            }
            self!.user = user
            completion(nil)
        })
        
    }
    
    func resetPassword(completion: @escaping (Error?) -> ()) {
        completion(nil)
    }
    
    func rateApp(completion: @escaping (Error?) -> ()) {
        completion(nil)
    }
    
    func contactUs(completion: @escaping (Error?) -> ()) {
        completion(nil)
    }
    
    func loadUserPic(completion: @escaping (Data?, Error?) -> ()) {
        guard let firebaseStorage = firebaseStorage,
              let user = user, let authManger = authManger else { return }
        
        if user.pic.contains("https:") {
            authManger.loadImage(uri: user.pic, completion: { img, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(img, nil)
                }
            })
        } else if user.accountType == "EMAIL" && !user.pic.isEmpty {
            firebaseStorage.retreiveImage(user.pic) { pic in
                completion(pic, nil)
            }
        } else {
            completion(nil, nil)
        }
        
    }
    
    func getUser() -> User {
        return user!
    }
    
    func updateUserPic(img: Data?, completion: @escaping (Error?) -> ()) {
        guard let firebaseStorage = firebaseStorage, var user = user, let authManger = authManger else { return }
        
        if let img = img {
            user.pic = "user/\(globalUserId).jpeg"
            firebaseStorage.saveImage("user/\(globalUserId).jpeg", img: img, completion: { error in
                if let error = error {
                    completion(error)
                }
                authManger.updateUserInfo(user: user, trigger: "update", completion: { error in
                    if let error = error {
                        firebaseStorage.deleteImage(imgRef: "user/\(globalUserId).jpeg")
                        completion(error)
                    }
                })
            })
        } else {
            user.pic = ""
            authManger.updateUserInfo(user: user, trigger: "update", completion: { error in
                if let error = error {
                    completion(error)
                }
                firebaseStorage.deleteImage(imgRef: "user/\(globalUserId).jpeg")
            })
        }
        imageCash.removeObject(forKey: user.pic as AnyObject)
        completion(nil)
    }
}
