//
//  FarebaseStorageServiceManager.swift
//  foodmonster
//
//  Created by Egor Bryzgalov on 1/8/22.
//

import Foundation
import FirebaseStorage

protocol FirebaseStorageServiceManagerProtocol {
    
    func retreiveImage(_ ref: String, completion: @escaping (Data) -> ())
    func saveImage(_ type: String, img: Data, completion: @escaping (Error?) -> ())
    func deleteImage(imgRef: String)
}

class FirebaseStorageServiceManager: FirebaseStorageServiceManagerProtocol {
    
    let storage = Storage.storage().reference()
    let metadata = StorageMetadata()
    
    func retreiveImage(_ ref: String, completion: @escaping (Data) -> ()) {
        if let imageFromCache = imageCash.object(forKey: ref as AnyObject) as? Data {
            completion(imageFromCache)
        } else {
            self.storage.child(ref).getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("ERROR LOAD IMAGE \(error.localizedDescription)")
                    let defaultImage = UIImage(named: "cook")
                    completion((defaultImage?.pngData())!)
                } else {
                    if let data = data {
                        imageCash.setObject(data as AnyObject, forKey: ref as AnyObject)
                        completion(data)
                    } else {
                        let defaultImage = UIImage(named: "cook")
                        completion((defaultImage?.pngData())!)
                    }
                }
            }
        }
    }
    
    func saveImage(_ type: String, img: Data, completion: @escaping (Error?) -> ()) {
        metadata.contentType = "image/jpeg"
        let uploadTask = storage.child(type).putData(img, metadata: metadata) { (_, err) in
            if let err = err {
                completion(err)
            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            let uploadPersent = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            debugPrint("uploaded: \(uploadPersent)")
        }
        uploadTask.resume()
        completion(nil)
    }
    
    func deleteImage(imgRef: String) {
        storage.child(imgRef).delete { error in
            if let error = error {
                print(error)
                return
            }
            imageCash.removeObject(forKey: imgRef as AnyObject)
        }
    }
    
    func randomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< 20 {
            s.append(letters.randomElement()!)
        }
        return s
    }
}
