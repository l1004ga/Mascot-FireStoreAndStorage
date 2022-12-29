//
//  MascotApp.swift
//  Mascot
//
//  Created by dev on 2022/12/15.
//

/*
 <swift package 목록>
 - FirebaseAuth
 - FirebaseDatabase
 - FirebaseDatabaseSwift
 - FirebaseFireStore
 - FirebaseFireStoreSwift
 - FirebaseStorage
 
 //FireStore에 저장 후 WebURL로 받아온 이미지를 보여주기 위해 필요
 - SDWebimageSwiftUI
 */

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct MascotApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthStore())
        }
    }
}
