//
//  ContentView.swift
//  Mascot
//
//  Created by dev on 2022/12/15.
//

import SwiftUI

struct ContentView: View {
    
    // 로그인 여부에 따른 뷰 전환을 위해 사용
    @EnvironmentObject private var authStore: AuthStore
    
    var body: some View {
        VStack {
            if authStore.currentUser == nil {
                LoginView()
            } else {
                PostView()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthStore())
    }
}
