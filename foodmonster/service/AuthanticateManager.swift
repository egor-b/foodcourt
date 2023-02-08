//
//  AuthanticateManager.swift
//  foodster
//
//  Created by Egor Bryzgalov on 10/9/20.
//

import UIKit
import Firebase
import FirebaseCore
import GoogleSignIn
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit
import CryptoKit

protocol AuthanticateManagerProtocol {
    
    var authDidChange: ((FirebaseAuth.User?) -> Void)? { get set }
    
    func registerByEmail(user: User, pass: String, completion: @escaping(Error?) -> ())
    func resetUserPasswordByEmail(email: String, completion: @escaping (Error?) -> ())
    func changeUserPassword(password: String, completion: @escaping (Error?) -> ())
    
    func loginByEmail(credential: Credentials, completion: @escaping (Error?, TabBarViewController?) -> ())
    func loginByGoogle(view: UIViewController, completion: @escaping (Error?) -> ())
    func loginByFacebook(view: UIViewController, completion: @escaping (Error?) -> ())
    func loginByApple(idTokenString:String, isNew: Bool, completion: @escaping (Error?) -> ())
    func anonymousLogin(completion: @escaping (TabBarViewController) -> ())
    
    func sha256() -> String?
    func randomNonceString(length: Int)
    func sendEmailVerification(completion: @escaping (Error?) -> ())
    
    func getUserToken(completion: @escaping (String) -> ())
    func updateUserInfo(user: User, trigger: String, completion: @escaping (Error?) -> ())
    func findUserByid(uid: String, completion: @escaping (User?, Error?) -> ())
    func loadImage(uri: String, completion: @escaping (Data?, Error?) -> ())
    
    func checkAuthStatus()
    func checkEmailVerification() -> Bool
    func logout()
}

class AuthanticateManager: AuthanticateManagerProtocol {

    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    var authDidChange: ((FirebaseAuth.User?) -> Void)?
    fileprivate var currentNonce: String?
    
    func registerByEmail(user: User, pass: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().createUser(withEmail: user.email, password: pass) { (result, error) in
            if let error = error {
                completion(error)
            }
            var user = user
            guard let uid = result?.user.uid else { return }
            self.sendEmailVerification(completion: { _ in })
            user.uid = uid
            self.createUser(user: user) { error in
                if let error = error {
                    completion(error)
                }
                completion(nil)
            }
        }
    }
    
    func loginByEmail(credential: Credentials, completion: @escaping (Error?, TabBarViewController?) -> ()) {
        Auth.auth().signIn(withEmail: credential.email, password: credential.password) { [self] authResult, error in
            if let error = error {
                completion(error, nil)
            }
            let startupViewController = mainStoryboard.instantiateViewController(withIdentifier: "startupStoryboard") as! TabBarViewController
            startupViewController.modalPresentationStyle = .fullScreen
            completion(nil, startupViewController)
        }
    }
    
    func loginByGoogle(view: UIViewController, completion: @escaping (Error?) -> ()) {
        GIDSignIn.sharedInstance.signIn(withPresenting: view) { [unowned self] user, error in
            if let error = error {
              print ("Error Google log in: %@", error.localizedDescription)
              completion(error)
            }
            guard let authentication = user?.user, let idToken = authentication.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Authentication error: ", error.localizedDescription)
                    completion(error)
                }
                guard let auth = authResult else { return }
                let pic = auth.user.photoURL?.absoluteString
                let newUser = User(uid: auth.user.uid, email: auth.user.email!, name: auth.user.displayName!, lastName: "", pic: pic ?? "", accountType: AccountType.GOOGLE.rawValue)
                self.createUser(user: newUser, completion: { _ in completion(nil)})
            }
        }
    }
    
    func loginByFacebook(view: UIViewController, completion: @escaping (Error?) -> ()) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: view) { (result, error) in
            if let error = error {
                completion(error)
            }
            guard let accessToken = AccessToken.current else {
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    completion(error)
                } else {
                    guard let auth = user else { return }
                    let pic = auth.user.photoURL?.absoluteString
                    let newUser = User(uid: auth.user.uid, email: auth.user.email!, name: auth.user.displayName ?? "", lastName: "", pic: pic ?? "", accountType: AccountType.FACEBOOK.rawValue)
                    self.createUser(user: newUser, completion: { _ in completion(nil)})
                }
            })
        }
    }
    
    func loginByApple(idTokenString: String, isNew: Bool, completion: @escaping (Error?) -> ()) {
        if let currentNonce = currentNonce {
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: currentNonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    completion(error)
                } else {
                    if isNew {
                        guard let auth = authResult else { return }
                        let newUser = User(uid: auth.user.uid, email: auth.user.email!, name: auth.user.displayName ?? "", lastName: "", pic: "", accountType: AccountType.APPLE.rawValue)
                        self.createUser(user: newUser, completion: { _ in completion(nil)})
                    }else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func anonymousLogin(completion: @escaping (TabBarViewController) -> ()) {
        UserDefaults.standard.set(Anon.ANON.rawValue, forKey: Anon.ANON.rawValue)
        let startupViewController = mainStoryboard.instantiateViewController(withIdentifier: "startupStoryboard") as! TabBarViewController
        startupViewController.modalPresentationStyle = .fullScreen
        completion(startupViewController)
    }
    
    func checkAuthStatus() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.authDidChange?(user)
        }
    }
    
    func getUserToken(completion: @escaping (String) -> ()) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
              print(error.localizedDescription)
            return;
          }
            completion(idToken ?? "none")
        }
    }
    
    func checkEmailVerification() -> Bool {
        guard let auth = Auth.auth().currentUser else { return false }
        return auth.isEmailVerified
    }
    
    func sendEmailVerification(completion: @escaping (Error?) -> ()) {
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            if let error = error {
                completion(error)
            }
        }
    }
    
    func createUser(user: User, completion: @escaping (Error?) -> ()) {
        getHeader(completion: { header in
            AF.request("\(host)/v1/user/create", method: .post, parameters: user, encoder: JSONParameterEncoder.default, headers: header).validate().response { response in
                switch response.result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    if let status = response.response {
                        if status.statusCode > 226 {
                            print("Alamofire failed: ", error.localizedDescription)
                            completion(error)
                        }
                    }
                    completion(nil)
                }
            }
        })
    }
    
    func updateUserInfo(user: User, trigger: String, completion: @escaping (Error?) -> ()) {
        var uri: URL = URL(string: host)!
        if trigger == "updateEmail" {
            uri = URL(string: "\(host)/v1/user/updateEmail")!
        } else {
            uri = URL(string: "\(host)/v1/user/update")!
        }
        getHeader { header in
            AF.request(uri, method: .put, parameters: user, encoder: JSONParameterEncoder.default, headers: header).validate().response { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value ?? "")
                    print("JSON: \(json)")
                    completion(nil)
                case .failure(let error):
                    print("Alamofire failed: ", error.localizedDescription)
                    completion(error)
                }
            }
        }
    }
    
    func findUserByid(uid: String, completion: @escaping (User?, Error?) -> ()) {
        getHeader { header in
            AF.request("\(host)/v1/user/find/\(uid)", headers: header).validate().responseDecodable(of: [User].self) { response in
                switch response.result {
                case .success(let success):
                    completion(success[0], nil)
                case .failure(let error):
                    print("Alamofire failed: ", error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
    }
    
    func resetUserPasswordByEmail(email: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }
    
    func changeUserPassword(password: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().currentUser?.updatePassword(to: password) { error in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }
    
    func loadImage(uri: String, completion: @escaping (Data?, Error?) -> ()) {
        AF.request(uri).responseData { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func logout() {
        do {
            globalUserId = String()
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: ", signOutError)
        }
    }
    
    func getHeader(completion: (HTTPHeaders) -> ()) {
        var headers = HTTPHeaders()
        getUserToken { token in
            headers = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
        }
        completion(headers)
    }
    
    func prepareAppleSignIn() {
        
    }
    
    
    func randomNonceString(length: Int = 32) {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      currentNonce = result
    }
    
    func sha256() -> String? {
        guard let currentNonce = currentNonce else { return nil }
        let inputData = Data(currentNonce.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func getCurrentNonce() -> String? {
        return currentNonce
    }
    
}
