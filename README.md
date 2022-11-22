# ios-wanted-VideoRecorder  
## 팀원  소개  
|Channy(김승찬)|Kuerong(유영훈)|
|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/31722496/194575712-36002fac-9426-40cb-8adf-c5898be1114d.png" width="200" height="200"/>|<img src="https://avatars.githubusercontent.com/u/33388081?v=4" width="200" height="200"/>|
|[Github](https://github.com/seungchann)|[Github](https://github.com/shadow9503)|  

## 개발 기간  
2022.10.10 ~ 10.15  

## 구조 및 기능  
## 첫 번째 페이지  
<img width="400" alt="11" src="https://user-images.githubusercontent.com/33388081/195977243-cd3e9955-5d3e-4f00-bcf9-9279a8f4b1bf.PNG">

* MVVM 패턴을 활용하여, 화면에 표시하는 부분과 (View) 데이터 연산을 처리하는 부분 (ViewModel) 으로 나누어 구현  
* viewModel 내부의 값이 변결될때마다, listener 에 담겨 있는 클로저가 실행될 수 있도록 Observable 을 활용  
```swift
class Observable<T> {
    var value: T {
        didSet {
            self.listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func subscribe(listener: @escaping (T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
```
* 2개의 열을 가진 가변형 높이의 Cell 을 구현하기 위해, FirstRowView 와 SecondRowView 를 각각 생성하고 이들을 `VideoListViewCellContentView` 에 올려서 구현  


## 두 번째 페이지  
<img width="400" alt="22" src="https://user-images.githubusercontent.com/33388081/195977257-79b1a95e-fd32-40ef-8c1f-b22ad353395c.PNG">  

* `AVFoundadtion` 활용 카메라 캡쳐, 녹화를 구현
* `FirebaseStorage` 와 `BackgroundTask` 를 이용하여 Video의 업로드 및 삭제를 구현 백업기능 마련
* `FileManager` 를 이용 JSON으로 영상에대한 정보 저장 및 불러오기, 삭제 인터페이스 구현
```swift
 func backup(_ param: StorageParameter) {
    BGTaskManager.shared.beginBackgroundTask(withName: "media_backup") { identifier in
        DispatchQueue.main.async { [weak self] in
            print("Task Resume")
            Task {
                guard let metadata = try? await self!.upload(param) else {
                    identifier.endBackgroundTask()
                    print("Task Failed But Finish")
                    return
                }
                print(metadata)
                identifier.endBackgroundTask()
                print("Task Complete")
            }
        }
    }
}
```


## 세 번째 페이지  
<img width="400" alt="22" src="https://user-images.githubusercontent.com/33388081/195977260-65d5afaf-4289-4c2d-80ed-fe1d8b53e563.PNG">  

* MVVM 패턴을 활용하여, 화면에 표시하는 부분과 (View) 데이터 연산을 처리하는 부분 (ViewModel) 으로 나누어 구현  
* `AVPlayerViewController` 를 상속받아 내부의 `AVPlayer` 를 viewModel 내부의 `AVPlayer` 와 연결하는 방식으로 구현  
* NavigationBar 의 Title 폰트 변경을 위해, `barAppearance` 를 활용하여 구현  
```swift
 func setupNavigationbar() {
        if #available(iOS 15, *) {
            let barAppearance = UINavigationBarAppearance()
            barAppearance.backgroundColor = .white
            barAppearance.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
            ]
            self.navigationItem.standardAppearance = barAppearance
            self.navigationItem.scrollEdgeAppearance = barAppearance
        } else {
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
            ]
        }
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
```


## 앱에서 기여한 부분

### Channy
- 첫 번째 페이지  
  - Model, View, ViewModel 간 관계 설계  
  - 전반적인 디자인을 담당  
  - 해당 디자인을 UI 컴포넌트들을 이용해 각 화면의 UI를 구현하는 작업 담당  
  - 행을 스와이프 할 경우 삭제 기능 구현  
  - Pagination 구현  
- 세 번째 페이지  
  - Model, View, ViewModel 간 관계 설계     
  - `url` 을 통해 영상을 불러와 재생할 수 있는 화면 구현  

### Kuerong
- 첫 번째 페이지 
  - Thumbnail 이미지가 이미지 뷰에 맞게 layer masking 작업
  - color Asset으로 다크모드, 라이트모드 대응
- 두 번째 페이지
  - UI 구현 담당
  - FireStorage 업로드, 삭제 인터페이스 구현
    - Background Task를 이용해 업로드
  - FileManager 활용한 JSON으로 데이터관리 인터페이스 구현
  - AVFoundation 활용 Camera Capture, Recording 기능 구현
- 세 번째 페이지
  - 재생을 위한 Video 데이터 저장, 불러오기 메서드 구현
