import UIKit

class SimpleExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "BDUI Example"
        
        let button = UIButton(type: .system)
        button.setTitle("Load UI from JSON", for: .normal)
        button.addTarget(self, action: #selector(loadUIFromJSON), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func loadUIFromJSON() {
        let jsonString = """
        {
            "type": "contentView",
            "styles": {
                "backgroundColor": "#F5F5F5"
            },
            "subviews": [
                {
                    "type": "stackView",
                    "content": {
                        "axis": "vertical",
                        "spacing": 20,
                        "alignment": "center"
                    },
                    "styles": {
                        "padding": {
                            "top": 20,
                            "left": 20,
                            "bottom": 20,
                            "right": 20
                        }
                    },
                    "subviews": [
                        {
                            "type": "label",
                            "content": {
                                "text": "This UI is rendered from JSON!",
                                "style": "headline",
                                "alignment": "center"
                            }
                        },
                        {
                            "type": "button",
                            "content": {
                                "title": "Close",
                                "style": "primary"
                            },
                            "actions": {
                                "tap": {
                                    "type": "dismiss",
                                    "payload": {
                                        "animated": true
                                    }
                                }
                            }
                        }
                    ]
                }
            ]
        }
        """
        
//        let bdViewController = BDUIViewController(jsonString: jsonString)
//        bdViewController.title = "JSON UI"
//        
//        let navigationController = UINavigationController(rootViewController: bdViewController)
//        present(navigationController, animated: true)
    }
}

// MARK: - Usage Example
extension SimpleExampleViewController {
    
    func createProgrammaticExample() {
        let labelElement = BDUIElement(
            type: .label,
            id: "titleLabel",
            styles: ElementStyles(
                backgroundColor: nil,
                cornerRadius: nil,
                padding: nil
            ),
            content: [
                "text": AnyCodable("Programmatically Created UI"),
                "style": AnyCodable("title"),
                "alignment": AnyCodable("center")
            ],
            subviews: nil,
            actions: nil
        )
        
        let buttonElement = BDUIElement(
            type: .button,
            id: "actionButton",
            styles: ElementStyles(
                backgroundColor: nil,
                cornerRadius: nil,
                padding: PaddingStyle(top: 16, left: nil, bottom: nil, right: nil)
            ),
            content: [
                "title": AnyCodable("Tap Me"),
                "style": AnyCodable("primary")
            ],
            subviews: nil,
            actions: [
                "tap": BDUIAction(
                    type: .custom,
                    payload: [
                        "name": AnyCodable("buttonTapped"),
                        "data": AnyCodable(["id": "123"])
                    ]
                )
            ]
        )
        
        let stackViewElement = BDUIElement(
            type: .stackView,
            id: "mainStack",
            styles: ElementStyles(
                backgroundColor: nil,
                cornerRadius: nil,
                padding: PaddingStyle(top: 20, left: 20, bottom: 20, right: 20)
            ),
            content: [
                "axis": AnyCodable("vertical"),
                "spacing": AnyCodable(16),
                "alignment": AnyCodable("center")
            ],
            subviews: [labelElement, buttonElement],
            actions: nil
        )
        
        let rootElement = BDUIElement(
            type: .contentView,
            id: "rootView",
            styles: ElementStyles(
                backgroundColor: "#FFFFFF",
                cornerRadius: nil,
                padding: nil
            ),
            content: nil,
            subviews: [stackViewElement],
            actions: nil
        )
        
        let actionHandler = BDUIActionHandler(viewController: self)
        let mapper = BDUIMapper(actionHandler: actionHandler)
        
        if let view = mapper.mapToView(rootElement) {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
} 
