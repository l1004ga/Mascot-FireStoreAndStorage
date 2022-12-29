//
//  PostView.swift
//  Mascot
//
//  Created by dev on 2022/12/16.
//

import SwiftUI
//Storage에 저장된 사진을 불러오기 위해 사용
import SDWebImageSwiftUI

struct PostView: View {
    
    @EnvironmentObject private var authStore: AuthStore
    
    var body: some View {
        NavigationView {
            VStack{
                
                WebImage(url: authStore.loginedUserProfile)
                        .resizable()
                        .cornerRadius(25)
                        .frame(width: 50, height: 50)
                Text(authStore.loginedUserName ?? "익명")
                
                Button {
                    authStore.logout()
                } label: {
                    Image(systemName: "person.crop.circle.badge.xmark")
                        .resizable().frame(width: 100, height: 100)
                }
                
                
            }
        } //NavigationView
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView().environmentObject(AuthStore())
    }
}
