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
<img width="400" alt="11" src="https://user-images.githubusercontent.com/63276842/195915876-cdba4ba1-4fb4-4e8f-98ca-5496b88fcd32.png">

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


## 세 번째 페이지  
<img width="400" alt="22" src="https://user-images.githubusercontent.com/63276842/195918287-8a3fc141-c614-482d-b96e-6c36a35662ea.png">  

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
	- 4, 5 Section, PopupView
- 두 번째 페이지
	- 한글 조합
- 세 번째 페이지
	- 단축키 기능
