import UIKit

class ComplexExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Complex BDUI Example"
        
        let button = UIButton(type: .system)
        button.setTitle("Show Complex UI", for: .normal)
        button.addTarget(self, action: #selector(showComplexUI), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func showComplexUI() {
        let jsonString = """
        {
            "type": "contentView",
            "styles": {
                "backgroundColor": "#F8F9FA"
            },
            "subviews": [
                {
                    "type": "stackView",
                    "id": "mainStack",
                    "content": {
                        "axis": "vertical",
                        "spacing": 24,
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
                                "text": "Product Details",
                                "style": "largeTitle",
                                "alignment": "center"
                            }
                        },
                        {
                            "type": "card",
                            "styles": {
                                "backgroundColor": "#FFFFFF",
                                "cornerRadius": "12"
                            },
                            "subviews": [
                                {
                                    "type": "stackView",
                                    "content": {
                                        "axis": "vertical",
                                        "spacing": 12
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
                                                "text": "iPhone 13 Pro",
                                                "style": "headline"
                                            }
                                        },
                                        {
                                            "type": "label",
                                            "content": {
                                                "text": "$999",
                                                "style": "title"
                                            }
                                        },
                                        {
                                            "type": "label",
                                            "content": {
                                                "text": "The iPhone 13 Pro is Apple's newest flagship phone with improved cameras, display, and battery life.",
                                                "style": "body"
                                            }
                                        }
                                    ]
                                }
                            ],
                            "actions": {
                                "tap": {
                                    "type": "navigate",
                                    "payload": {
                                        "route": "productDetails",
                                        "productId": "iphone-13-pro"
                                    }
                                }
                            }
                        },
                        {
                            "type": "stackView",
                            "content": {
                                "axis": "horizontal",
                                "spacing": 12,
                                "distribution": "fillEqually"
                            },
                            "subviews": [
                                {
                                    "type": "button",
                                    "content": {
                                        "title": "Add to Cart",
                                        "style": "primary"
                                    },
                                    "actions": {
                                        "tap": {
                                            "type": "custom",
                                            "payload": {
                                                "name": "addToCart",
                                                "productId": "iphone-13-pro"
                                            }
                                        }
                                    }
                                },
                                {
                                    "type": "button",
                                    "content": {
                                        "title": "Save for Later",
                                        "style": "secondary"
                                    },
                                    "actions": {
                                        "tap": {
                                            "type": "custom",
                                            "payload": {
                                                "name": "saveForLater",
                                                "productId": "iphone-13-pro"
                                            }
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            "type": "label",
                            "content": {
                                "text": "Customer Reviews",
                                "style": "headline",
                                "alignment": "left"
                            },
                            "styles": {
                                "padding": {
                                    "top": 16
                                }
                            }
                        },
                        {
                            "type": "stackView",
                            "content": {
                                "axis": "vertical",
                                "spacing": 16
                            },
                            "subviews": [
                                {
                                    "type": "card",
                                    "styles": {
                                        "backgroundColor": "#FFFFFF",
                                        "cornerRadius": "8"
                                    },
                                    "subviews": [
                                        {
                                            "type": "stackView",
                                            "content": {
                                                "axis": "vertical",
                                                "spacing": 8
                                            },
                                            "styles": {
                                                "padding": {
                                                    "top": 12,
                                                    "left": 12,
                                                    "bottom": 12,
                                                    "right": 12
                                                }
                                            },
                                            "subviews": [
                                                {
                                                    "type": "label",
                                                    "content": {
                                                        "text": "John Doe",
                                                        "style": "headline"
                                                    }
                                                },
                                                {
                                                    "type": "label",
                                                    "content": {
                                                        "text": "Great phone! The camera is amazing and battery life is excellent.",
                                                        "style": "body"
                                                    }
                                                }
                                            ]
                                        }
                                    ]
                                },
                                {
                                    "type": "card",
                                    "styles": {
                                        "backgroundColor": "#FFFFFF",
                                        "cornerRadius": "8"
                                    },
                                    "subviews": [
                                        {
                                            "type": "stackView",
                                            "content": {
                                                "axis": "vertical",
                                                "spacing": 8
                                            },
                                            "styles": {
                                                "padding": {
                                                    "top": 12,
                                                    "left": 12,
                                                    "bottom": 12,
                                                    "right": 12
                                                }
                                            },
                                            "subviews": [
                                                {
                                                    "type": "label",
                                                    "content": {
                                                        "text": "Jane Smith",
                                                        "style": "headline"
                                                    }
                                                },
                                                {
                                                    "type": "label",
                                                    "content": {
                                                        "text": "Love the new features, especially the ProMotion display!",
                                                        "style": "body"
                                                    }
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            "type": "button",
                            "content": {
                                "title": "Back",
                                "style": "outlined"
                            },
                            "styles": {
                                "padding": {
                                    "top": 16
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
        
//        let bdViewController = BDUIViewController(jsonString: jsonString)
//        bdViewController.title = "Product Details"
//        
//        let navigationController = UINavigationController(rootViewController: bdViewController)
//        present(navigationController, animated: true)
    }
} 
