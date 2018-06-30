## [iOS] iOS Architecture

### 개요

사실 알고있고 직접 사용하는 아키텍쳐는 MVC가 전부였습니다. MVP, MVVM, VIPER 등등 여러 아키텍쳐에 대해 들어만 봤을 뿐 직접 공부해보고 도입해보지는 않았습니다.

하지만 Naver Hackday를 통해 프로그램 구조의 중요성을 깨달았습니다. 그리고 프로그램에 알맞는 구조를 생각하는 힘을 기르기 위해 아키텍쳐에 대해 공부해보고 이를 정리해보는 시간을 가지려 합니다. 

[iOS Architecture Patterns](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52) 글을 바탕으로 여러 레퍼런스들을 참고하며 지속적으로 업데이트할 예정입니다.

---

### Architecture

여러 아키텍쳐 패턴을 본격적으로 들어가기 전 이런 아키텍쳐가 프로그램을 작성하는데 필요한 이유와 그 효과들을 먼저 공부해보고자 합니다. 

구조를 생각하지 않고 프로그램을 작성한다고 프로그램이 돌아가지 않는 것은 아닙니다. 하지만 이런 프로그램은 가독성은 떨어지며 유지 보수에 굉장히 많은 비용이 듭니다. 또한 테스팅 단계에서는 테스팅 자체가 거의 불가능하거나 효과를 볼 수 없는 난관에 봉착할 수 있습니다.

단순히 모듈(클래스)을 역할별로 나누어 관리하는 것은 아키텍쳐라고 할 수 없습니다. 특정 기준으로 역할을 정의하며 이렇게 역할별로 나누어진 모듈(클래스)간의 관계를 유기적으로 형성시키는 것이 아키텍쳐라 할 수 있습니다. 

아키텍쳐의 정답은 없습니다. 아키텍쳐는 각 프로젝트의 성격에 맞게 선택해야 합니다. 하지만 분명 좋은 아키텍쳐의 기준과 특징은 존재합니다.

- Balanced **Distribution** : 객체들의 역할이 확실하며 이런 역할들이 균형잡혀 분배되어 있는지, 즉 각 모듈(클래스)이 독립적인지 
  - 이러한 확고한 역할의 분배는 프로그램의 복잡도를 낮춘다.
  - 객체지향의 5원칙인 **SOLID**의 [**Single Responsibility**](https://en.wikipedia.org/wiki/Single_responsibility_principle)에 기반
    - *하나의 객체는 하나의 역할만을 가져야 한다는 원칙*
  - 모듈(클래스)의 독립성이 떨어지면 테스팅을 진행하는데 어려움이 있다.
- **Testability** : 테스트를 진행할 수 있는지 
  - 테스팅 과정은 런타임 중 발생하는 이슈를 사전에 찾아내기 위해 필요한 단계
  - 테스팅에 있어서 그 자체가 문제라기보다는 테스팅을 진행하려는 아키텍쳐가 문제인 경우 많다.
- **Easy of Use** : 사용하기 쉬운지
  - 사용하기 쉬운지는 개발 속도와 관계가 있을 수 있다.
- **Unidirectional Data Flow** : 단방향성의 데이터 흐름
  - 단순한 데이터의 흐름은 코드를 쉽게 이해할 수 있게 해주며 쉬운 디버깅을 제공한다. 여러 객체들을 오가는 데이터의 흐름은 옳지 않다.
  - Shared Resource의 사용도 기피해야한다. 에러가 발생하면 원인을 찾기 힘들어진다. 

물론 이 세 가지의 기준을 완벽하게 충족시키는 아키텍쳐는 없습니다. 그렇기 때문에 진행하고 있는 프로젝트의 성격에 맞게 선택적으로 도입해야 합니다.

위의  **Distribution**은 크게 세 가지의 카테고리로 나누어 진행됩니다.

- **Model** : 프로그램에서 사용되는 데이터의 조작이 일어나고 이를 담당하는 부분
- **View** : 시각적인 부분으로 UI에 해당. (iOS 환경에서는 'UI' 접두어가 붙은 모든 것들이 이에 해당)
- **Controller / Presenter / ViewModel** : **Model**과 **View** 사이의 중재자로 일반적으로 **View**를 통해 발생한 사용자의 액션을 다루며 필요시 이에 따른 **Model**에 값의 조정을 요청하며 **Model** 값의 변화에 맞게 **View** 를 갱신하는 역할

이렇게 세 가지의 기준으로 나누어 **Distribution을** 진행하게 된다면 **재사용성이 증가**하며 그들을 **독립적으로 테스팅**할 수 있게 됩니다. 

그럼 이제 본젹적으로 많이 사용되고 유명한 아키텍쳐 패턴들을 하나씩 살펴보도록 하겠습니다.

---

### MVC

- M : Model
- V : View
- C : Controller

먼저 살펴볼 아키텍쳐 패턴은 바로 MVC입니다. 가장 유명하며 자연스럽게 사용되는 아키텍쳐이기도 합니다. 저는 두 가지의 MVC 아키텍쳐를 살펴보려 합니다. 전통적인 MVC 아키텍쳐부터 시작하겠습니다.

#### Traditional MVC

<img src="https://cdn-images-1.medium.com/max/2000/1*E9A5fOrSr0yVmc7Kly5C6A.png" width="80%"/>

위의 다이어그램을 통해 우리는 Model, View 그리고 Controller, 이 세 요소가 서로 강하게 연결되어 있음을 알 수 있습니다. View는 사용자의 액션을 Controller에게 전달하고 Controller는 이에 따른 데이터의 갱신을 Model에게 요청합니다. 이렇게 Model에서 데이터의 갱신이 일어나고 Model은 이런 상태 변화를 View에게 전달합니다. 그렇게 되면 View 역시 갱신된 데이터에 맞추어 갱신됩니다.

이렇게 강하게 연결된 셋은 독립성이 낮기 때문에 이들 각각의 재사용성은 굉장히 떨어집니다. 그렇기 때문에 현재 iOS 개발에는 전통적인 MVC 아키텍쳐는 맞지 않다고 볼 수 있습니다.

그래서 애플에서는 새로운 MVC 아키텍쳐를 제시하였습니다. 이를 살펴보도록 하겠습니다.

#### Apple's MVC

애플이 제시한 Cocoa MVC에서 Controller는 View와 Model의 중재자로 View와 Model의 직접적인 연결을 막습니다. 이는 전통적인 MVC보다 높은 독립성의 보장을 기대합니다. 하지만 이러한 기대가 실제 개발에 큰 효과를 가져올까요? 먼저 Cocoa MVC 패턴의 다이어그램을 살펴보도록 하겠습니다.

<img src="https://cdn-images-1.medium.com/max/1200/1*c0aGaDNX41qu6e8E4OEgwQ.png" width="80%"/>

위의 다이어그램을 얼핏보면 View와 Model의 독립성이 보장되는 것으로 보입니다. 실제 개발은 어떻게 이루어질까요?

Cocoa MVC 아키텍쳐에서 Controller의 역할은 `UIViewController`가 담당하게 됩니다. 그리고 `UIViewController`는 View를 소유하게 되고 View들의 Lify Cycle과 강하게 연결되게 됩니다. 그렇기 때문에 View와 Controller의 분리가 쉽지 않으며 Controller의 재사용이 어려워지고 이로인해 연관되어 있는 View의 재사용 역시 어려워집니다. 

이렇게 View와 Controller가 강하게 연결되어 있기에 테스팅의 과정 역시 굉장히 힘들어집니다. 독립적이라고 말할 수 있는 것은 Model이 전부입니다. 그리고 View 위에서의 사용자의 액션과 이에 따른 메소드뿐만 아니라 `UIViewController`에서 일어나는 각종 행위로 (네트워크 통신, Delegation 등) Controller는 방대해지고 이를 흔히 **M**assive **V**iew**C**ontroller라고 부르기도 합니다.

그래서 실제 다이어그램은 다음과 같은 흐름을 갖게 됩니다.

<img src="https://cdn-images-1.medium.com/max/1600/1*PkWjDU0jqGJOB972cMsrnA.png" width="80%"/>

이렇게 방대해진 `UIViewController`를 줄이는 행위, [View Controller Offloading](https://www.objc.io/issues/1-view-controllers/lighter-view-controllers/)은 iOS 개발자들에게 중요한 과제가 되었습니다. Cocoa MVC 아키텍쳐를 구현한 코드를 살펴보겠습니다.

```swift
import UIKit
import PlaygroundSupport

struct Person { // Model
    let firstName:String
    let lastName:String
}

class GreetingViewController: UIViewController { // Controller

    var person:Person!

    // Views are belong to Controller => tightly COUPLED
    lazy var showGreetingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Click me", for: .normal)
        button.setTitle("You badass", for: .highlighted)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.red, for: .highlighted)
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var greetingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        self.setupLayout()
    }

    // Layout codes in Controller
    func setupLayout() {
        self.setupButton()
        self.setupLabel()
    }

    private func setupButton() {
        self.view.addSubview(showGreetingButton)
        showGreetingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        showGreetingButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    private func setupLabel() {
        self.view.addSubview(greetingLabel)
        greetingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        greetingLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
    }
    
    @objc func didTapButton(sender: UIButton) { // Update View
        self.greetingLabel.text = "Hello " + self.person.firstName + " " + self.person.lastName
    }
}

let model = Person(firstName: "Wasin", lastName: "Thonkaew")
let vc = GreetingViewController()
vc.person = model

PlaygroundPage.current.liveView = vc.view
```

위의 코드를 보면 View의 생성과 배치에 관련된 코드들도 Controller안에 위치하게 되고 이들을 갱신하는 코드 역시 Controller 안에 위치하게 됩니다. 코드로만 보아도 Controller와 View가 굉장히 강하게 연결되어 있다는 것을 볼 수 있습니다. 

또한 View의 테스팅 과정 역시 Controller의 View Life Cycle 관련 메소드(`viewDidLoad`, `viewWillAppear` 등)의 호출이 없다면 진행할 수 없기 때문에 역시 이 둘이 강하게 연결되어 있다는 것을 확인할 수 있습니다.

그럼 여기서 MVC 아키텍쳐는 위에서 언급했던 좋은 아키텍쳐의 기준들에 얼마나 부합하는지 살펴보도록 하겠습니다.

- **Distribution** : View와 Model은 확실히 분리되어 있습니다. 하지만 View와 Controller는 강하게 연결되어 있습니다.
- **Testability** : View와 Controller가 강하게 연결되어 있기 때문에 오로지 Model만 테스팅을 진행할 수 있습니다.
- **Easy of Use** : 여러 아키텍쳐 중 가장 적은 코드를 필요로 하며 가장 친숙한 아키텍쳐 패턴으로 많은 경험이 없는 개발자들도 쉽게 유지 보수할 수 있습니다.

> 개발 진행 속도에 있어서는 가장 빠른 아키텍쳐 패턴이라할 수 있습니다.

iOS 개발에 있어서 아키텍쳐에 크게 신경을 쓸 수 없거나 지식이 전무하다면 가장 사용하기 쉬운 패턴이 바로 MVC입니다. 하지만  이는 아주 작은 프로젝트라 하더라도 많은 유지 보수 비용이 들어가게 됩니다.

---

### MVP

- M : Model
- V : View (`UIView` 그리고/혹은 `UIViewController`)
- P : Presenter

먼저 다이어그램을 살펴보도록 하겠습니다.

<img src="https://cdn-images-1.medium.com/max/1600/1*hKUCPEHg6TDz6gtOlnFYwQ.png"/>

위에서 살펴본 Cocoa MVC와 굉장히 비슷한 모습을 하고있는 걸 확인할 수 있습니다. 그러면 실제로도 Cocoa MVC와 유사할까요? 전혀 그렇지 않습니다.

먼저 MVC와는 다르게 `UIView`나 `UIViewController` 둘 모두 View에 해당합니다. Cocoa MVC에서 `UIViewController`는 Controller에 해당했었고 그로인해 View와 강하게 연결되어 있었습니다. 이 둘을 View로 분류하는 대신 MVP 패턴에서는 Presenter라는 것이 등장합니다. 

Presenter는 Cocoa MVC와는 다르게 View(`UIView`, `UIViewController`)의 Life Cycle에 영향을 받지 않고 레이아웃 코드 역시 Presenter에 존재하지 않습니다. 하지만 보다 Controller의 역할답게 View를 데이터와 상태에 맞추어 갱신하는 역할을 갖게 됩니다. 즉 Presenter는 Model로 부터 갱신된 데이터를 받아와 뷰를 갱신하는 역할을 합니다.

위에서 언급했듯이 Cocoa MVC와 다르게 MVP 패턴에서 `UIViewController`와 이를 상속받는 클래스들은 Presenter(Controller)가 아니라 View에 해당합니다. 이는 보다 테스팅의 효과를 높일 수 있습니다. 

코드로 살펴보도록 하겠습니다.

```swift
import UIKit
import PlaygroundSupport

struct Person { // Model
    let firstName:String
    let lastName:String
}

protocol GreetingView:class { // View Protocol
    func setGreeting(greeting:String)
}

protocol GreetingViewPresenter { // Presenter Protocol
    init(view: GreetingView, person: Person)
    func showGreeting()
}

class GreetingPresenter : GreetingViewPresenter { // Presenter
    weak var view: GreetingView?
    let person: Person

    required init(view: GreetingView, person: Person) {
        self.view = view
        self.person = person
    }
    // 3.
    func showGreeting() { // Update View
        let greeting = "Hello" + " " + self.person.firstName + " " + self.person.lastName
        self.view?.setGreeting(greeting: greeting)
    }
}

class GreetingViewController : UIViewController, GreetingView { // View
    var presenter: GreetingViewPresenter!
    ...
    // Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        setupLayout()
        self.showGreetingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    ...
    // Layout Code
    // 2. 
    @objc func didTapButton(button: UIButton) {
        self.presenter.showGreeting()  // Send Action to Presenter
    }
    // 1.
    func setGreeting(greeting: String) {
        self.greetingLabel.text = greeting
    }
    // layout code goes here
}
// Present the view controller in the Live View window
// Assembling of MVP
let model = Person(firstName: "Wasin", lastName: "Thonkaew")
let view = GreetingViewController()
let presenter = GreetingPresenter(view: view, person: model)
view.presenter = presenter

PlaygroundPage.current.liveView = view
```

다이어그램과 코드를 통해 살펴보고 가야할 몇 가지가 존재합니다. 

먼저 View는 Presenter를 소유하고 있어야 하며 Presenter는 유저 액션, 데이터 갱신, 상태 갱신에 따라 View를 갱신해주어야 합니다. 이를 코드로써 구현할 때 View는 Presenter를 강한 참조로 소유하고 있고 Presenter는 약한 참조로 View를 단순히 가리키고만 있습니다. 그렇기 때문에 View의 Life Cycle의 영향과 레이아웃 코드와 액션 코드가 공존하는 등의 의존성에서는 벗어날 수 있지만 참조에 의한 1:1 의존성에서는 벗어날 수 없다는 한계가 존재합니다.

다음으로는 `GreetingViewController`을 살펴보도록 하겠습니다. 이 곳에는 레이아웃과 유저의 액션을 전달하는 코드만이 위치하게 됩니다. 실제로 흐름을 살펴보도록 하겠습니다.

1. 프로토콜 메소드로 뷰를 갱신하는 메소드를 **정의** (***호출이 아님을 명심하자.***)
2. View 위에 존재하는 버튼에 `.touchUpInside` 액션이 들어오면 View는 `didTapButton` 메소드를 통해 Presenter에 이러한 사실을 알립니다.
3. Presenter는 유저의 액션에 대해 Model로부터 값을 가져와 뷰를 갱시하는 메소드를 **호출** (**호출**이라는 행위는 Presenter에 의해 행해진다.)

MVC와 마찬가지로 MVP는 좋은 아키텍쳐의 기준에 얼마나 부합하는지 살펴보도록 하겠습니다.

- **Distribution** : 전통적인 MVC에서 발생한 Model과 View의 의존성 문제는 해결하였다. 하지만 참조에 의한 View와 Controller의 의존성은 존재하지만 비교적 셋 모두 역할별로 적절히 나누어져 있다고 말할 수 있습니다. 
- **Testability** : 각각의 요소를 독립적으로 테스팅하기 용이합니다.
- **Easy of Use** : Presenter의 추가와 이를 구현하기 위한 프로토콜등의 추가로 코드가 MVC보다 길어집니다.

---

### MVVM

> MVVM 패턴은 RxSwift에 대한 경험이 없는 관계로 다른 프레임워크를 사용하지 않고 MVVM을 소개하고 있는 [How not to get desperate with MVVM implementation](https://medium.com/flawless-app-stories/how-to-use-a-model-view-viewmodel-architecture-for-ios-46963c67be1b)을 참고하여 작성하였습니다.

- M : Model
- V : View
- VM : ViewModel

먼저 다이어그램을 살펴보도록 하겠습니다.

<img src="https://cdn-images-1.medium.com/max/800/1*8MiNUZRqM1XDtjtifxTSqA.png" />

MVVM의 정의에 의하면 View는 오직 시각적인 요소로만 이루어져야 합니다. View에서는 레이아웃, 애니매이션 그리고 UI 요소들에 대한 초기화 작업 코드들만이 위치하게 됩니다. MVVM에서 View와 Model 사이에 ViewModel이 위치하게 됩니다. ViewModel은 View의 각 UI 요소들에 대한 인터페이스를 제공합니다. View의 UI 요소들과 ViewModel의 인터페이스를 연결시키는 작업을 "**바인딩(Binding)**" 이라고 합니다.

MVVM에서 View의 비즈니스 로직은 ViewModel에 정의되어 있으며 이에 맞춰 View가 갱신됩니다. 예를들어 `Date` 를 `String` 으로 변환하는 작업은 ViewModel에서 진행되고 View에서는 이에 맞춰 갱신만 일어나게 됩니다. 그렇기 때문에 View가 어떻게 구성되어 있는지와 상관없이 View의 비즈니스 로직에 대해서 테스팅이 가능해집니다. 

전체적인 흐름으로 보았을 때 ViewModel은 View로부터 사용자의 액션을 받아오고 Model로부턴 데이터를 받아와 이렇게 받아온 데이터를 View에서 보여줄 값(**Ready-To-Display Property**)으로 가공을 합니다. 그와 동시에 View는 ViewModel의 이러한 **Ready-To-Display Property** 값을 observing하고 있어 값이 갱신되면 이에 맞춰 View를 갱신하게 됩니다.  

MVP와 마찬가지로 `UIView`와 `UIViewController`를 View로 묶어 분류합니다. 그렇기 때문에 View에서는 다음의 작업들만 해주면 됩니다.

1. Initiate/Layout/Present UI components.
2. Bind UI components with the ViewModel.

그리고 ViewModel에서는 다음과 같은 작업을 해주면 됩니다.

1. Write controller logics such as pagination, error handling, etc.
2. Write presentational logic, provide interfaces to the View.

그럼 이제 이를 구현한 코드로 살펴보도록 하겠습니다. 코드로 바로 MVVM 아키텍쳐를 구현해보는 것이 아닌 MVC 아키텍쳐로 만들어진 프로젝트를 MVVM으로 고쳐가며 하나하나 살펴보도록 하겠습니다. 만들어 볼 예제는 기본적인 테이블 뷰와 그 셀의 세그로 연결되는 뷰 컨트롤러로 넘어가는 정도의 간단한 수준입니다. 

> 앱의 완성된 결과를 [링크](https://media.giphy.com/media/l4EoWSOY1kxeSHVvi/giphy.gif)를 통해 먼저 확인해주세요.

**MVC version**

먼저 MVC 아키텍쳐로 구현한 몇몇 코드들을 살펴보도록 하겠습니다. 이 코드들은 상당히 낯에 익을 것이라고 예상됩니다! (저도 그랬거든요!)

예제에서 Model을 담당하는 `Photo` 구조체입니다.

```swift
struct Photo {
    let id: Int
    let name: String
    let description: String?
    let created_at: Date
    let image_url: String
    let for_sale: Bool
    let camera: String?
}
```

Model을 채워줄 데이터는 예제 내의 `APIService`를 사용하여 받아와 테이블 뷰에 뿌려주게 됩니다. 그 코드는 아래와 같습니다. 패치의 행위가 완료되면 테이블 뷰를 `reloadData()` 해줌으로써 셀을 데이터에 맞추어 갱신해주는 작업입니다.

```swift
self?.activityIndicator.startAnimating()
self.tableView.alpha = 0.0
apiService.fetchPopularPhoto { [weak self] (success, photos, error) in  DispatchQueue.main.async {
    self?.photos = photos
    self?.activityIndicator.stopAnimating()
    self?.tableView.alpha = 1.0
    self?.tableView.reloadData()
  }
}
```

 그리고 `UITableViewDataSource` 프로토콜 메소드 역시 다음과 같은 모습일 것입니다.

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // ....................
    let photo = self.photos[indexPath.row]
    //Wrap the date
    let dateFormateer = DateFormatter()
    dateFormateer.dateFormat = "yyyy-MM-dd"
    cell.dateLabel.text = dateFormateer.string(from: photo.created_at)
    //.....................
}
  
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.photos.count
}
```

위의 메소드는 뷰 컨트롤러에서 정의해주었고 화면에 뿌려주고 이를 가공하는 작업까지 모두 뷰 컨트롤러에서 진행되고 있는걸 확인하실 수 있습니다.

마지막으로 다음은 `UITableViewDelegate` 프로토콜 메소드를 구현한 것입니다.

```swift
func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    let photo = self.photos[indexPath.row]
    if photo.for_sale { // If item is for sale 
        self.selectedIndexPath = indexPath
        return indexPath
    }else { // If item is not for sale 
        let alert = UIAlertController(title: "Not for sale", message: "This item is not for sale", preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return nil
    }
}
```

셀을 선택한 사용자의 액션을 받고 선택한 셀에 따라 `alert`를 띄어줄지 뷰 컨트롤러로 넘어갈 것인지를 결정하고 실행하는 역할까지 뷰 컨트롤러의 하나의 메소드안에서 진행되고 있습니다.

이 문서를 위에서부터 읽어오셨다면 무언가 너무 강하게 연결되어 있다는 것을 느끼실 수 있습니다. 위의 코드들을 간략하게 소개하는 부분에서 언급한 것들뿐만 아니라 뷰 컨트롤러는 `APIService`에 대해 의존성 문제를 갖고 있습니다.

이렇게 많은 것들이 뷰 컨트롤러 내에서 강하게 연결되어 있고 의존성이 존재한다면 테스트 코드를 작성하기가 매우 까다로워질 것이고 원하는 테스팅 성능을 뽑아낼 수 없을 것입니다. 그럼 이제 이들을 분리하여 보다 테스팅에 용이할 수 있는 MVVM 아키텍쳐로 수정해보도록 하겠습니다.

**MVVM version**

위의 문제점들을 해결하기 위해서는 가장 먼저 뷰 컨트롤러의 부담을 줄여주어야 합니다. 이를 위해 먼저 예제에서 필요한 UI 요소들을 살펴보고 그들을 비즈니스 로직과 레이아웃 로직을 분리해보도록 하겠습니다.

이 예제에서는 다음과 같이 세 가지의 UI 요소가 사용됩니다.

1. activityIndicator (Loading / Finish)
2. tableView (Show / Hide)
3. cells (title, description. created date)

이들을 View와 ViewModel로 나눈 것을 추상화한다면 다음과 같은 다이어그램으로 표현될 수 있을 것입니다.

<img src="https://cdn-images-1.medium.com/max/1600/1*ktmfaTJajU0NYrCBq8iqnA.png">

각각의 UI 요소는 ViewModel의 프로퍼티에 일대일 대응합니다. 그럼 이런 바인딩을 구현하려면 어떻게 해야 할까요? 스위프트에서는 이러한 작업을 다음의 방법들로 구현할 수 있습니다.

1. KVO (Key-Value Observing) 패턴
2. RxSwift나 ReactiveCocoa같은 FRP(Functional Reactive Programming) 라이브러를 활용.
3. Delegation
4. Property Observer

저는 참고하고 있는 블로그의 글을 따라 Property Observer와 Closure를 사용하여 구현해보았습니다. 모양새와 사용 용도만을 코드로 간단히 살펴보자면 다음과 같습니다.

***ViewModel***

```swift
var prop: T {
    didSet{ // Property Observer
        self.propChanged?()
    }
}
```

***View***

```swift
viewModel.propChanged = { [weak self] in
  DispatchQueue.main.async {
      // View의 업데이트 작업.
  }
}
```

View에서 ViewModel의 바인딩 Closure들을 구현해줌으로써 View의 갱신에 대한 코드를 정의해주고 값의 변화에 따른 뷰 갱신을 호출하는 행위는 ViewModel에 위치하게 됩니다. 즉 데이터에 따라 뷰의 갱신을 명령하는 행위는 ViewModel에서 이루어지게 됩니다. 

이렇게 바인딩 과정을 통하면 ViewModel은 MVP의 Presenter에서 프로토콜의 형태로라도 View의 존재를 알던 것과는 다르게 전혀 View에 대한 어떠한 참조도 존재하지 않게 됩니다.

예제의 전체 코드는 현재 문서와 동일한 레포지터리에 있으므로 해당 폴더를 확인해주시기 바랍니다. 여기선 위와 같은 방식의 코드가 실제 어떻게 구현되었는지를 간단하게 살펴보도록 하겠습니다. 테이블 뷰에 데이터를 뿌려주기 위한 바인딩 Closure와 호출을 살펴보도록 하겠습니다.

***ViewModel***

```swift
let apiService: APIServiceProtocol

//MARK: Initializer
init( apiService: APIServiceProtocol = APIService()) {
    self.apiService = apiService
}

...
// Activity Indicator
var isLoading: Bool = false {
    didSet{
        // notify
        self.updateLoadingStatus?()
    }
}
// Table View
private var cellViewModels:[PhotoListCellViewModel] = [PhotoListCellViewModel]() {
    didSet{
        // notify
        self.reloadTableViewClosure?()
    }
}
// Number of cells
var numberOfCells: Int {
    return cellViewModels.count
}

//MARK: Binding Closures
var reloadTableViewClosure: (()->())?
var updateLoadingStatus: (()->())?
...

// Request Data
func requestFetchData(){
    self.isLoading = true // trigger activity indicator startAnimating
    apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
        // Compelete Fetching Data
        self?.isLoading = false // trigger activity indicator stopAnimating
        if let error = error {
            self?.alertMessage = error.rawValue
        }else {
            self?.processFetchedPhoto(photos: photos)
        }
    }
}
// Generate cell's ViewModel
private func processFetchedPhoto( photos: [Photo] ) {
    self.photos = photos // Cache
    var viewModels = [PhotoListCellViewModel]() // TableViewCellViewModel
    photos.forEach({viewModels.append(createCellViewModel(photo: $0))})
    self.cellViewModels = viewModels // trigger photoListTableView reloadData
}

// Get Cell
func getCellViewModel( at indexPath: IndexPath ) -> PhotoListCellViewModel {
    return cellViewModels[indexPath.row]
}
```

가장 먼저 `APIService`는 더 이상 View(ViewController)에 위치하지 않습니다. 그다음 코드의 전체적인 흐름을 살펴보자면 `requestFetchData` 메소드가 호출되면 데이터를 받아오는 중과 끝난 상황에서 `isLoading`에 적절한 값을 할당해주어 `didSet`을 통한 View의 `activityIndicator` 행위를 조작해줄 수 있습니다. 

그리고 데이터를 받아오는 행위가 정상적으로 완료되었다면 Cell의 ViewModel을 만드는 과정을 거쳐 `cellViewModels`에 테이블 뷰 위에 뿌려줄 데이터가 할당됩니다. 이렇게 값이 할당되면 역시 `didSet`을 통해 `tableView`의 `reloadData` 작업이 진행되는 것입니다. 그럼 이에 대한 View의 코드를 살펴보도록 하겠습니다.

***View***

```swift
//MARK: Outlets
@IBOutlet weak var tableView: UITableView!
@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

//MARK: ViewModel For TableView
lazy var viewModel: PhotoListViewModel = {
    return PhotoListViewModel()
}()

//MARK: Life cycle
override func viewDidLoad() {
    super.viewDidLoad()
    ...
    initializeViewModel()
}

//MARK: Setup ViewModel
func initializeViewModel(){
    ...
    
    viewModel.updateLoadingStatus = { [weak self] in
        DispatchQueue.main.async {
            let isLoading = self?.viewModel.isLoading ?? false             
            if isLoading {
                self?.activityIndicator.startAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self?.tableView.alpha = 0
                })
            }else{
                self?.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self?.tableView.alpha = 1
                })
            }
        }
    }
        
    viewModel.reloadTableViewClosure = { [weak self] in
        DispatchQueue.main.async {
            self?.tableView.reloadData()
        }
    }
        
    viewModel.requestFetchData()
}

//MARK: TableView DataSource
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellIdentifier", for: indexPath) as? PhotoListTableViewCell else {
        fatalError("Cell not exists in storyboard")
    }
    // get data from cellViewModel
    let cellVieWModel = viewModel.getCellViewModel(at: indexPath)
    cell.setupViews(viewModel: cellVieWModel)
    return cell
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfCells
}
```

 `initializeViewModel` 메소드를 통해 ViewModel의 바인딩 Closure들을 정의해주고 마지막에 `requestFetchData` 메소드를 호출함으로써 데이터를 받아오는 작업을 시작합니다.

`UITableViewDataSource` 프로토콜 메소드도 역시 ViewModel로부터 값을 받아와 사용하는 것을 확인할 수 있습니다.

> User Interaction은 전체 코드에서 확인하실 수 있습니다.

그리하여 전체적인 그림은 다음과 같을 것입니다.

<img src="https://cdn-images-1.medium.com/max/1600/1*w4bDvU7IlxOpQZNw49fmyQ.png">

**MVP와의 차이점**

제가 느끼기에 가장 큰 차이점은 Presenter는 View와 연결성이 약하지만 프로토콜로써 간접적으로 이를 참조하고 있고 ViewModel은 바인딩 작업을 통해 ViewModel에서 View에 관한 어떠한 의존성이나 연결성도 존재하지 않는다는 것입니다. 

MVVM이 물론 완벽하다고 할 순 없습니다. 다음은 MVVM의 단점을 소개하고 있는 글들입니다.

- [MVVM is Not Very Good - Soroush Khanlou](http://khanlou.com/2015/12/mvvm-is-not-very-good/)
- [The Problems with MVVM on iOS - Daniel Hall](http://www.danielhall.io/the-problems-with-mvvm-on-ios)

단점 중 하나가 바로 위에서 코드를 잠깐 살펴보았던 것과 마찬가지로 ViewModel에서 너무 많은 일들을 한다는 것도 하나의 문제점으로 지적되곤 합니다. 이를 해결하기 위해 실제로 Builder나 Router의 개념이 도입되었습니다. 역시 다음의 글들을 참고해주시기 바랍니다.

- [Improve your iOS Architecture with FlowControllers](http://merowing.info/2016/01/improve-your-ios-architecture-with-flowcontrollers/)
- [VIPER](https://www.objc.io/issues/13-architecture/viper/)
- [Clean by Uncle Bob](https://hackernoon.com/introducing-clean-swift-architecture-vip-770a639ad7bf)

---

### VIPER
