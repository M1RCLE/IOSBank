import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupButtons()
    }
    
    private func setupButtons() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let demoButton = UIButton(type: .system)
        demoButton.setTitle("Show BDUI Demo", for: .normal)
        demoButton.addTarget(self, action: #selector(showBDUIDemo), for: .touchUpInside)
        
        let examplesButton = UIButton(type: .system)
        examplesButton.setTitle("Show BDUI Examples", for: .normal)
        examplesButton.addTarget(self, action: #selector(showBDUIExamples), for: .touchUpInside)
        
        stackView.addArrangedSubview(demoButton)
        stackView.addArrangedSubview(examplesButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func showBDUIExamples() {
        let examplesVC = BDUIExamplesViewController()
        let navController = UINavigationController(rootViewController: examplesVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    @objc private func showBDUIDemo() {
        let jsonString = """
        {
            "type": "contentView",
            "styles": {
                "backgroundColor": "#FFFFFF"
            },
            "subviews": [
                {
                    "type": "stackView",
                    "id": "mainStack",
                    "content": {
                        "axis": "vertical",
                        "spacing": 16,
                        "distribution": "fill",
                        "alignment": "fill"
                    },
                    "styles": {
                        "padding": {
                            "top": 16,
                            "left": 16,
                            "bottom": 16,
                            "right": 16
                        }
                    },
                    "subviews": [
                        {
                            "type": "label",
                            "content": {
                                "text": "Welcome to BDUI Demo",
                                "style": "title",
                                "alignment": "center"
                            }
                        },
                        {
                            "type": "label",
                            "content": {
                                "text": "This UI is generated from JSON using the Backend Driven UI approach",
                                "style": "body",
                                "alignment": "center"
                            },
                            "styles": {
                                "padding": {
                                    "top": 8,
                                    "bottom": 16
                                }
                            }
                        },
                        {
                            "type": "stackView",
                            "content": {
                                "axis": "horizontal",
                                "spacing": 16,
                                "distribution": "fillEqually"
                            },
                            "subviews": [
                                {
                                    "type": "button",
                                    "content": {
                                        "title": "Primary",
                                        "style": "primary"
                                    },
                                    "actions": {
                                        "tap": {
                                            "type": "custom",
                                            "payload": {
                                                "name": "buttonTapped",
                                                "buttonType": "primary"
                                            }
                                        }
                                    }
                                },
                                {
                                    "type": "button",
                                    "content": {
                                        "title": "Secondary",
                                        "style": "secondary"
                                    },
                                    "actions": {
                                        "tap": {
                                            "type": "custom",
                                            "payload": {
                                                "name": "buttonTapped",
                                                "buttonType": "secondary"
                                            }
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            "type": "stackView",
                            "content": {
                                "axis": "horizontal",
                                "spacing": 16,
                                "distribution": "fillEqually"
                            },
                            "styles": {
                                "padding": {
                                    "top": 8
                                }
                            },
                            "subviews": [
                                {
                                    "type": "button",
                                    "content": {
                                        "title": "Outlined",
                                        "style": "outlined"
                                    },
                                    "actions": {
                                        "tap": {
                                            "type": "custom",
                                            "payload": {
                                                "name": "buttonTapped",
                                                "buttonType": "outlined"
                                            }
                                        }
                                    }
                                },
                                {
                                    "type": "button",
                                    "content": {
                                        "title": "Text",
                                        "style": "text"
                                    },
                                    "actions": {
                                        "tap": {
                                            "type": "custom",
                                            "payload": {
                                                "name": "buttonTapped",
                                                "buttonType": "text"
                                            }
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            "type": "button",
                            "content": {
                                "title": "Navigate to Details",
                                "style": "primary"
                            },
                            "styles": {
                                "padding": {
                                    "top": 24
                                }
                            },
                            "actions": {
                                "tap": {
                                    "type": "navigate",
                                    "payload": {
                                        "route": "details",
                                        "itemId": "12345",
                                        "title": "Item Details"
                                    }
                                }
                            }
                        },
                        {
                            "type": "button",
                            "content": {
                                "title": "Close",
                                "style": "outlined"
                            },
                            "styles": {
                                "padding": {
                                    "top": 8
                                }
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
        
        let bdViewController = BDUIViewController(jsonString: jsonString)
        let navigationController = UINavigationController(rootViewController: bdViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

