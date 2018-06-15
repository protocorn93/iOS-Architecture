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
