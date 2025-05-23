import UIKit

class BDUIMapper: BDUIMapperProtocol {
    private struct AssociatedKeys {
        static var actionKey = "actionKey"
        static var elementIdKey = "elementIdKey"
    }
    
    private weak var actionDelegate: BDUIPresenterProtocol?
    
    init(actionDelegate: BDUIPresenterProtocol? = nil) {
        self.actionDelegate = actionDelegate
    }
    
    func mapToView(_ element: BDUIElement) -> UIView? {
        var view: UIView?
        
        switch element.type {
        case .button:
            view = createButton(from: element)
        case .card:
            view = createCard(from: element)
        case .label:
            view = createLabel(from: element)
        case .textInput:
            view = createTextInput(from: element)
        case .stackView:
            view = createStackView(from: element)
        case .contentView:
            view = createContentView(from: element)
        }
        
        if let view = view {
            applyStyles(to: view, from: element.styles)
            
            if let actions = element.actions, actions["tap"] != nil {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
                view.isUserInteractionEnabled = true
                view.addGestureRecognizer(tapGesture)
                
                objc_setAssociatedObject(view, &AssociatedKeys.actionKey, actions["tap"], .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            if let id = element.id {
                objc_setAssociatedObject(view, &AssociatedKeys.elementIdKey, id, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        
        return view
    }
    
    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let view = gestureRecognizer.view,
              let action = objc_getAssociatedObject(view, &AssociatedKeys.actionKey) as? BDUIAction else {
            return
        }
        
        actionDelegate?.handleAction(action, from: view)
    }
    
    // MARK: - UI Element Creation Methods
    
    private func createButton(from element: BDUIElement) -> UIView {
        let button = UIButton(type: .system)
        
        if let content = element.content {
            if let title = content["title"]?.stringValue {
                button.setTitle(title, for: .normal)
            }
            
            // Apply style-based colors
            if let styleValue = content["style"]?.stringValue {
                switch styleValue {
                case "primary":
                    button.backgroundColor = UIColor(hex: "#007AFF") // iOS blue
                    button.setTitleColor(.white, for: .normal)
                    button.layer.cornerRadius = 8
                case "secondary":
                    button.backgroundColor = UIColor(hex: "#E5E5EA") // Light gray
                    button.setTitleColor(UIColor(hex: "#007AFF"), for: .normal)
                    button.layer.cornerRadius = 8
                case "outlined":
                    button.backgroundColor = .clear
                    button.setTitleColor(UIColor(hex: "#007AFF"), for: .normal)
                    button.layer.borderColor = UIColor(hex: "#007AFF")?.cgColor
                    button.layer.borderWidth = 1
                    button.layer.cornerRadius = 8
                case "text":
                    button.backgroundColor = .clear
                    button.setTitleColor(UIColor(hex: "#007AFF"), for: .normal)
                default:
                    break
                }
            }
            
            // Allow explicit color to override style
            if let colorHex = content["color"]?.stringValue, let color = UIColor(hex: colorHex) {
                button.setTitleColor(color, for: .normal)
            }
            
            if let fontSize = content["fontSize"]?.doubleValue {
                button.titleLabel?.font = .systemFont(ofSize: CGFloat(fontSize))
            } else {
                // Default font size and weight for buttons
                button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            }
            
            // Add some padding to the button
            button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        }
        
        return button
    }
    
    private func createCard(from element: BDUIElement) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 8
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowOpacity = 0.1
        card.layer.shadowRadius = 4
        
        if let subviews = element.subviews {
            for subviewElement in subviews {
                if let subview = mapToView(subviewElement) {
                    card.addSubview(subview)
                    subview.translatesAutoresizingMaskIntoConstraints = false
                    
                    let padding: CGFloat = 16
                    NSLayoutConstraint.activate([
                        subview.topAnchor.constraint(equalTo: card.topAnchor, constant: padding),
                        subview.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: padding),
                        subview.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -padding),
                        subview.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -padding)
                    ])
                }
            }
        }
        
        return card
    }
    
    private func createLabel(from element: BDUIElement) -> UIView {
        let label = UILabel()
        label.numberOfLines = 0
        
        if let content = element.content {
            if let text = content["text"]?.stringValue {
                label.text = text
            }
            
            if let colorHex = content["color"]?.stringValue, let color = UIColor(hex: colorHex) {
                label.textColor = color
            }
            
            if let fontSize = content["fontSize"]?.doubleValue {
                label.font = .systemFont(ofSize: CGFloat(fontSize))
            }
            
            if let style = content["style"]?.stringValue {
                switch style {
                case "largeTitle":
                    label.font = .systemFont(ofSize: 34, weight: .bold)
                case "title":
                    label.font = .systemFont(ofSize: 28, weight: .bold)
                case "headline":
                    label.font = .systemFont(ofSize: 20, weight: .semibold)
                case "body":
                    label.font = .systemFont(ofSize: 17, weight: .regular)
                case "caption":
                    label.font = .systemFont(ofSize: 13, weight: .regular)
                case "error":
                    label.font = .systemFont(ofSize: 13, weight: .regular)
                    label.textColor = .red
                default:
                    break
                }
            }
            
            if let alignment = content["alignment"]?.stringValue {
                switch alignment {
                case "left": label.textAlignment = .left
                case "center": label.textAlignment = .center
                case "right": label.textAlignment = .right
                default: break
                }
            }
        }
        
        return label
    }
    
    private func createTextInput(from element: BDUIElement) -> UIView {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        if let content = element.content {
            if let placeholder = content["placeholder"]?.stringValue {
                textField.placeholder = placeholder
            }
            
            if let text = content["text"]?.stringValue {
                textField.text = text
            }
            
            if let isSecure = content["isSecure"]?.boolValue {
                textField.isSecureTextEntry = isSecure
            }
        }
        
        return textField
    }
    
    private func createStackView(from element: BDUIElement) -> UIView {
        let stackView = UIStackView()
        
        if let content = element.content {
            if let axis = content["axis"]?.stringValue {
                stackView.axis = axis == "horizontal" ? .horizontal : .vertical
            } else {
                stackView.axis = .vertical
            }
            
            if let spacing = content["spacing"]?.doubleValue {
                stackView.spacing = CGFloat(spacing)
            } else if let spacing = content["spacing"]?.stringValue, let spacingValue = Double(spacing) {
                stackView.spacing = CGFloat(spacingValue)
            }
            
            if let alignment = content["alignment"]?.stringValue {
                switch alignment {
                case "fill": stackView.alignment = .fill
                case "leading": stackView.alignment = .leading
                case "center": stackView.alignment = .center
                case "trailing": stackView.alignment = .trailing
                default: break
                }
            }
            
            if let distribution = content["distribution"]?.stringValue {
                switch distribution {
                case "fill": stackView.distribution = .fill
                case "fillEqually": stackView.distribution = .fillEqually
                case "fillProportionally": stackView.distribution = .fillProportionally
                case "equalSpacing": stackView.distribution = .equalSpacing
                case "equalCentering": stackView.distribution = .equalCentering
                default: break
                }
            }
        }
        
        if let subviews = element.subviews {
            for subviewElement in subviews {
                if let subview = mapToView(subviewElement) {
                    stackView.addArrangedSubview(subview)
                }
            }
        }
        
        return stackView
    }
    
    private func createContentView(from element: BDUIElement) -> UIView {
        let contentView = UIView()
        
        if let subviews = element.subviews {
            for (index, subviewElement) in subviews.enumerated() {
                if let subview = mapToView(subviewElement) {
                    contentView.addSubview(subview)
                    subview.translatesAutoresizingMaskIntoConstraints = false
                    
                    if index == 0 {
                        // First subview fills the content view
                        NSLayoutConstraint.activate([
                            subview.topAnchor.constraint(equalTo: contentView.topAnchor),
                            subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                            subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                            subview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                        ])
                    }
                }
            }
        }
        
        return contentView
    }
    
    // MARK: - Styling
    
    private func applyStyles(to view: UIView, from styles: ElementStyles?) {
        guard let styles = styles else { return }
        
        if let backgroundColor = styles.backgroundColor, let color = UIColor(hex: backgroundColor) {
            view.backgroundColor = color
        }
        
        if let cornerRadius = styles.cornerRadius {
            // Handle both numeric values and string descriptors
            if let radius = Double(cornerRadius) {
                view.layer.cornerRadius = CGFloat(radius)
            } else {
                // Handle named radius sizes
                switch cornerRadius {
                case "small":
                    view.layer.cornerRadius = 4
                case "medium":
                    view.layer.cornerRadius = 8
                case "large":
                    view.layer.cornerRadius = 16
                default:
                    break
                }
            }
        }
        
        // Apply padding using layout margins if available
        if let padding = styles.padding {
            var margins = UIEdgeInsets.zero
            
            if let top = padding.top {
                margins.top = top
            }
            if let left = padding.left {
                margins.left = left
            }
            if let bottom = padding.bottom {
                margins.bottom = bottom
            }
            if let right = padding.right {
                margins.right = right
            }
            
            view.layoutMargins = margins
        }
    }
}

// MARK: - Helper Extensions

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
} 