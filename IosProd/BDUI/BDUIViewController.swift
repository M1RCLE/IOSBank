import UIKit

class BDUIViewController: UIViewController {
    private var bdMapper: BDUIMapperProtocol!
    private var rootView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bdMapper = BDUIMapper(actionHandler: BDUIActionHandler())
        
        loadUIFromJSON()
    }
    
    private func loadUIFromJSON() {
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
                        "spacing": "medium",
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
                            "type": "card",
                            "content": {
                                "title": "Sample Card",
                                "subtitle": "This is a card created using BDUI",
                                "imageName": "sample_image",
                                "style": "elevated"
                            },
                            "actions": {
                                "tap": {
                                    "type": "navigate",
                                    "payload": {
                                        "route": "details",
                                        "parameters": {
                                            "itemId": "12345"
                                        }
                                    }
                                }
                            }
                        },
                        {
                            "type": "textInput",
                            "content": {
                                "placeholder": "Enter your name",
                                "style": "outlined",
                                "leftIconName": "person_icon"
                            },
                            "actions": {
                                "textChange": {
                                    "type": "custom",
                                    "payload": {
                                        "name": "nameChanged"
                                    }
                                }
                            }
                        },
                        {
                            "type": "stackView",
                            "content": {
                                "axis": "horizontal",
                                "spacing": "medium",
                                "distribution": "fillEqually"
                            },
                            "subviews": [
                                {
                                    "type": "button",
                                    "content": {
                                        "title": "Cancel",
                                        "style": "outlined"
                                    },
                                    "actions": {
                                        "tap": {
                                            "type": "dismiss",
                                            "payload": {
                                                "animated": true
                                            }
                                        }
                                    }
                                },
                                {
                                    "type": "button",
                                    "content": {
                                        "title": "Submit",
                                        "style": "primary"
                                    },
                                    "actions": {
                                        "tap": {
                                            "type": "custom",
                                            "payload": {
                                                "name": "submitForm",
                                                "data": {
                                                    "formId": "registration"
                                                }
                                            }
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            ]
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert JSON string to data")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let element = try decoder.decode(BDUIElement.self, from: jsonData)
            
            if let view = bdMapper.mapToView(element) {
                rootView = view
                view.frame = self.view.bounds
                view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.view.addSubview(view)
            }
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
}

extension BDUIViewController {
    func loadUIFromAPI(for screenName: String) {
        let urlString = "https://api.example.com/ui/\(screenName)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let element = try decoder.decode(BDUIElement.self, from: data)
                
                DispatchQueue.main.async {
                    if let view = self.bdMapper.mapToView(element) {
                        self.rootView?.removeFromSuperview()
                        
                        self.rootView = view
                        view.frame = self.view.bounds
                        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        self.view.addSubview(view)
                    }
                }
            } catch {
                print("Failed to decode JSON from API: \(error)")
            }
        }.resume()
    }
}
