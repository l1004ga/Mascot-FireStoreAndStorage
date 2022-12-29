//
//  LoginView.swift
//  Mascot
//
//  Created by dev on 2022/12/15.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    //ViewModel 사용을 위한 객체 생성
    @EnvironmentObject private var authStore: AuthStore
    
    //로그인 시 필요한 변수
    @State var name : String = ""
    @State var email : String = ""
    @State var password : String = ""
    @State var passwordCheck : String = ""
    @State var nickname : String = ""
    @State var profileImage : UIImage? = nil

    //회원가입 버튼 누를 시 회원가입 뷰 전환에 사용되는 변수
    @State private var signUpIsPresented : Bool = false
    
    //로그인 실패 시 알림창을 보여주는데 사용되는 변수
    @State var creatAlert : Bool = false
    @State var alertMessage : String = ""
    
    //알림창의 contents를 만들어주기 위한 함수
    func message(alertMessage : String) -> Alert {
        Alert(
            title: Text("실패"),
            message: Text("\(alertMessage)"),
            dismissButton: .default(Text("닫기")))

    }

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                Text("로그인")
                    .font(.title2)
                    .fontWeight(.bold)
                
                TextField("이메일", text: $email)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 280, height: 45, alignment: .center)
                
                SecureField("비밀번호", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 280, height: 45, alignment: .center)
                
                Button {
                    authStore.loginUser(email: email, password: password){ codeValue in
                        switch codeValue {
                        case 200:
                            print("성공")
                        case 17008:
                            alertMessage = "이메일 형식이 아닙니다."
                            creatAlert = true
                        case 17009:
                            alertMessage = "비밀번호가 다릅니다."
                            creatAlert = true
                        default:
                            alertMessage = "고려하지 못한 에러입니다~~"
                            creatAlert = true
                        }
                    }
                } label: {
                    Text("로그인하기")
                }
                
                Button {
                    self.signUpIsPresented.toggle()
                } label: {
                    Text("회원가입")
                }
                .fullScreenCover(isPresented: $signUpIsPresented) {
                    ResisterView()
                }

            }
        } //NavigationStack
        .alert(isPresented: self.$creatAlert,
               content: { self.message(alertMessage: alertMessage) })
    }
}
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView().environmentObject(AuthStore())
        }
    }
