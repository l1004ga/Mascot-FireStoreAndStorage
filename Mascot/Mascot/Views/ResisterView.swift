//
//  ResiterView.swift
//  Mascot
//
//  Created by dev on 2022/12/15.
//

import SwiftUI

struct ResisterView: View {
    
    //ViewModel 사용을 위한 객체 생성
    @EnvironmentObject private var authStore: AuthStore
    
    //회원가입에 필요한 변수
    @State var name : String = ""
    @State var email : String = ""
    @State var password : String = ""
    @State var passwordCheck : String = ""
    @State var nickname : String = ""
    @State var profileImage : UIImage?
    
    //회원가입 실패 시 알림창을 보여주는데 사용되는 변수
    @State var creatAlert : Bool = false
    @State var alertMessage : String = ""
    
    //알림창의 contents를 만들어주기 위한 함수
    func message(alertMessage : String) -> Alert {
        Alert(
            title: Text("실패"),
            message: Text("\(alertMessage)"),
            dismissButton: .default(Text("닫기")))

    }
    
    //프로필 이미지 선택 시 사용되는 변수
    @State private var imagePickerSelected: Bool = false
    
    //현재 인스턴스를 해제하기 위해 사용
    @Environment(\.dismiss) private var dismiss
            
            var body: some View {
                NavigationStack {
                    VStack(spacing: 16) {
                        
                        Text("회원가입")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Button {
                            imagePickerSelected.toggle()
                        } label: {
                            //이미지를 선택한 경우 선택된 이미지를 보여줌
                            if let profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .cornerRadius(100)
                                    .frame(width: 100, height: 100)
                            } else {
                                Image(systemName: "person.circle")
                                    .cornerRadius(100)
                                    .font(.system(size: 100))
                                    .foregroundColor(Color(.label))
                            }
                        }
                        
                        
                        TextField("이름", text: $name)
                            .disableAutocorrection(true) //자동수정 금지
                            .autocapitalization(.none)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 280, height: 45, alignment: .center)
                        
                        TextField("닉네임", text: $nickname)
                            .disableAutocorrection(true) //자동수정 금지
                            .autocapitalization(.none)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 280, height: 45, alignment: .center)
                        
                        
                        TextField("이메일", text: $email)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 280, height: 45, alignment: .center)
                        
                        SecureField("비밀번호", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 280, height: 45, alignment: .center)
                        
                        SecureField("비밀번호 확인", text: $passwordCheck)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 280, height: 45, alignment: .center)
                        
                        Button {
                            
                            if profileImage == nil {
                                alertMessage = "프로필 이미지를 선택해주세요."
                                creatAlert = true
                            } else {
                                let task = authStore.storeImageToStorage_Sync(profileImage: profileImage!)
                                if task == nil {
                                    print("에러!")
                                }
                                task!.observe(.success) { snapshot in
                                    print("storeImageToStorage_Sync Done")
                                    authStore.registerUser(email: email, password: password, nickname: nickname, profileImage: profileImage!) { intValue, uidValue  in
                                        switch intValue {
                                        case 200: //회원가입 성공
                                            print("성공")
                                            dismiss()
                                        case 17007:
                                            print("이미 가입한 계정")
                                            alertMessage = "이미 가입된 계정입니다."
                                            creatAlert = true
                                        case 17008:
                                            print("맞지 않는 포맷")
                                            alertMessage = "이메일 형식이 올바르지 않습니다."
                                            creatAlert = true
                                        case 17026:
                                            print("비밀번호를 6자리 이상 입력")
                                            alertMessage = "비밀번호를 6자리 이상 입력해주세요."
                                            creatAlert = true
                                        default:
                                            print("오류")
                                        }
                                    }
                                }
                                // while authStore.profileImageUrls == nil {
                                //    print("엥")
                                //    sleep(1)
                                //}
                            }
                        } label: {
                            Text("가입완료")
                        }
                    }
                    
                }//NavigationStack
                .fullScreenCover(isPresented: $imagePickerSelected) {
                    ImagePicker(image: $profileImage)
                }
                .alert(isPresented: self.$creatAlert,
                       content: { self.message(alertMessage: alertMessage) })
                
                
            }
        }
        
        struct ResisterView_Previews: PreviewProvider {
            static var previews: some View {
                ResisterView().environmentObject(AuthStore())
            }
        }
