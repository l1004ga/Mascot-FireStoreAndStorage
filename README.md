# Mascot-FireStoreAndStorage

# 데이터 구조

## 회원가입&로그인
- Firebase Authentication의 기본 기능 중 displayName, profileImage 변수를 사용하여 닉네임과 프로필이미지 저장하고자 하였음
- 이유 : Firebase Authentication에 User데이터가 저장되기 때문에, FireStore에 똑같은 User값을 또 생성하고 닉네임, 프로필이미지를 저장하는 것은 데이터구조상 불필요하다고 생각함

### <회원가입 데이터 흐름>


<img src="https://user-images.githubusercontent.com/55937627/210165463-ceeccc50-5086-4c04-997a-ff29a453c200.png"/>


### <게시물 업로드 데이터 흐름>


<img src="https://user-images.githubusercontent.com/55937627/210165602-1e9ddeb7-4c2f-42aa-9196-c4882ecad62b.png"/>


### * Firebase Authentication은 uid값만 가지고 해당하는 User의 displayName, profileImage를 불러올 수 없음
### ** 결론적으로 FireStore의 데이터 구조를 변경해야 하는 상황이 발생해버렸음


ps. 제가 현재까지 찾아본 바로는 불가능하지만 혹시 Firebase Authentication에서 uid 값만으로 Userdata를 가져올 수 있는 방법을 아시는 분들의 제보를 기다립니다... 사례해드릴게요ㅜ
근데 제 생각에 안될거라 생각하는게... 인증되지 않은 상태에서 정보값을 내어주는 방법을 과연 문제가 없는 상황이라고 판단했을지가 의문이네요...
