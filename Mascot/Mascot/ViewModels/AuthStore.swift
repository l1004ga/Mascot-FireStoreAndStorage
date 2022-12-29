//
//  LoginResisterViewModel.swift
//  Mascot
//
//  Created by dev on 2022/12/15.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class AuthStore : ObservableObject {
    
    // 로그인 상태 확인
    @Published var currentUser: Firebase.User?
    
    // 프로필 이미지 Stirage 업로드 후 생성되는 URL
    @Published var profileImageUrls: URL?
    
    // 로그인된 계정 정보
    @Published var loginedUserName : String = ""
    @Published var loginedUserProfile : URL?
    
    
    init() {
        currentUser = Auth.auth().currentUser
    }
    
    //회원가입 
    func registerUser(email: String, password: String, nickname : String, profileImage : UIImage, completion: @escaping (Int, String) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                let code = (error as NSError).code
                print("Error \(error.localizedDescription)")
                print(code)
                completion(code, "")
            }
            else {
                
                if let user = Auth.auth().currentUser?.createProfileChangeRequest() {
                    //Auth 시 유저이름 및 포토 URL을 함께 저장
                    user.displayName = nickname
                    user.photoURL = self.profileImageUrls
                    print("여기서 잘 들어갔을까? \(String(describing: user.photoURL))")
                    user.commitChanges(completion: {error in
                        if let error = error {
                            print(error)
                        } else {
                            print("DisplayName changed")
                        }
                    })
                }
                
                let uid = result?.user.uid
                completion(200, uid ?? "") //성공 번호
            }
        }
    }
    
    //로그인
    func loginUser(email: String, password: String, completion : @escaping (Int) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                let code = (error as NSError).code
                print(code)
                print(error.localizedDescription)
                completion(code)
            } else {
                
                if let user = Auth.auth().currentUser {
                    self.loginedUserName = user.displayName ?? ""
                    print(self.loginedUserName)
                    
                    self.loginedUserProfile = user.photoURL
                    print(self.loginedUserProfile)
                }
                
                print("Successfully logged in as user: \(result?.user.uid ?? "")")
                self.currentUser = result?.user
                completion(200)
            }
        }
    }
    
    // 로그인 시 Storage에서 프로필 이미지 가져오기
    
    
    // 로그아웃
    func logout() {
        self.currentUser = nil
        try? Auth.auth().signOut()
    }
    
//    //Storage에 프로필사진 업로드
//    fileprivate func downloadImageURL_Sync(_ ref: StorageReference) {
//        let semaphore2 = DispatchSemaphore(value: 0)                //스위프트 내부적으로 wait()와 signal()의 동작 프로세스
//        ref.downloadURL() { url, error in
//            print("downloadURL1")
//            if let error = error {
//                print(error)
//                semaphore2.signal()
//                return
//            }
//            print("downloadURL2")
//
//            print(url?.absoluteString ?? "")
//
//            self.profileImageUrls = url!
//            print("이거이거 \(self.profileImageUrls)")
//            print("downloadURL3")
//
//            guard let url = url else {
//                semaphore2.signal()
//                return
//            }
//            print("downloadURL4")
//
//            //                self.postToStore(imageProfileUrl: url, uid: uid)
//            semaphore2.signal()
//            print("downloadURL5")
//
//            return
//        }
//        print("downloadURL6")
//
//        semaphore2.wait()
//        print("downloadURL7")
//
//    }
//
//    func storeImageToStorage_deprecated(profileImage : UIImage) {
//
//        //이미지값의 고유 uid
//        //reference의 withpath가 없으면 아래 putData 등 기능 오류가 나기 때문에 꼭 생성해 줘야 함
//        let uid = UUID().uuidString
//        let ref = Storage.storage().reference(withPath: uid)
//
//        guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else {
//            return
//        }
//
//        let semaphore1 = DispatchSemaphore(value: 0)                //스위프트 내부적으로 wait()와 signal()의 동작 프로세스
//        ref.putData(imageData) { metadata, error in
//            print("putData1")
//            if let error = error {
//                print("\(error)")
//                semaphore1.signal()
//                return
//            }
//            print("putData2")
//
//            self.downloadImageURL_Sync(ref)
//            print("putData3")
//
//            semaphore1.signal()
//            print("putData4")
//
//            return
//        }.resume()
//        print("putData5")
//
//        semaphore1.wait()
//        print("putData6")
//
//    }
//
//
//    //Storage에 프로필사진 업로드
//    func storeImageToStorage_deprecated2(profileImage : UIImage) {
//        print("storeImageToStorage_Sync1")
//
//        //이미지값의 고유 uid
//        //reference의 withpath가 없으면 아래 putData 등 기능 오류가 나기 때문에 꼭 생성해 줘야 함
//        let uid = UUID().uuidString
//        let ref = Storage.storage().reference(withPath: uid)
//        print("storeImageToStorage_Sync12")
//
//        guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else {
//            return
//        }
//        print("storeImageToStorage_Sync13")
//
//        let semaphore1 = DispatchSemaphore(value: 0)                //스위프트 내부적으로 wait()와 signal()의 동작 프로세스
//        ref.putData(imageData) { metadata, error in
//            print("storeImageToStorage_Sync14")
//
//            if let error = error {
//                print("\(error)")
//                print("storeImageToStorage_Sync15")
//
//                semaphore1.signal()
//                return
//            }
//            print("storeImageToStorage_Sync16")
//
//            let semaphore2 = DispatchSemaphore(value: 0)                //스위프트 내부적으로 wait()와 signal()의 동작 프로세스
//            print("storeImageToStorage_Sync17")
//
//            ref.downloadURL() { url, error in
//                print("storeImageToStorage_Sync18")
//
//                if let error = error {
//                    print(error)
//                    print("storeImageToStorage_Sync19")
//
//                    semaphore2.signal()
//                    return
//                }
//                print("storeImageToStorage_Sync111")
//
//                print(url?.absoluteString ?? "")
//
//                self.profileImageUrls = url!
//                print("이거이거 \(self.profileImageUrls)")
//
//                print("storeImageToStorage_Sync112")
//
//                guard let url = url else {
//                    print("storeImageToStorage_Sync113")
//
//                    semaphore2.signal()
//                    print("storeImageToStorage_Sync114")
//
//                    return }
//                print("storeImageToStorage_Sync115")
//
//                semaphore2.signal()
//                print("storeImageToStorage_Sync116")
//
//                //                self.postToStore(imageProfileUrl: url, uid: uid)
//            }
//            print("storeImageToStorage_Sync171")
//
//            semaphore2.wait()
//            print("storeImageToStorage_Sync118")
//
//            semaphore1.signal()
//            print("storeImageToStorage_Sync119")
//
//        }
//        print("storeImageToStorage_Sync121")
//
//        semaphore1.wait()
//        print("storeImageToStorage_Sync122")
//
//    }
    func storeImageToStorage_Sync(profileImage : UIImage) -> StorageUploadTask? {
        //이미지값의 고유 uid
        //reference의 withpath가 없으면 아래 putData 등 기능 오류가 나기 때문에 꼭 생성해 줘야 함
        let uid = UUID().uuidString
        let ref = Storage.storage().reference(withPath: uid)

        guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else {
            return nil
        }

        let task = ref.putData(imageData) { metadata, error in
            guard let metadata = metadata else {
              // Uh-oh, an error occurred!
              return
            }

            if let error = error {
                print("\(error)")

                return
            }
            ref.downloadURL() { url, error in
                if let error = error {
                    print(error)
                    return
                }
                print(url?.absoluteString ?? "")
                
                self.profileImageUrls = url!
                print("이거이거 \(self.profileImageUrls)")
                
                guard let url = url else {
                    return }
                //                self.postToStore(imageProfileUrl: url, uid: uid)
            }
        }
        return task
    }

}

