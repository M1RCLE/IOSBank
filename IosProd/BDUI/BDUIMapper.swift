import UIKit

public class BDUIMapper: BDUIMapperProtocol {
    private let actionHandler: BDUIActionHandlerProtocol
    
    public init(actionHandler: BDUIActionHandlerProtocol) {
        self.actionHandler = actionHandler
    }
    
    public func mapToView(_ element: BDUIElement) -> UIView? {
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
    
    private struct AssociatedKeys {
        static var actionKey = "actionKey"
        static var elementIdKey = "elementIdKey"
    }
    
    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let view = gestureRecognizer.view,
              let action = objc_getAssociatedObject(view, &AssociatedKeys.actionKey) as? BDUIAction else {
            return
        }
        
        handleAction(action, from: view)
    }
    
    public func handleAction(_ action: BDUIAction, from sourceView: UIView) {
        switch action.type {
        case .navigate:
            if let route = action.payload?["route"]?.stringValue,
               let parameters = action.payload?["parameters"]?.dictionaryValue {
                actionHandler.navigate(to: route, parameters: parameters)
            }
        case .reload:
            let viewId = action.payload?["viewId"]?.stringValue
            actionHandler.reload(viewId: viewId)
        case .dismiss:
            let animated = action.payload?["animated"]?.boolValue ?? true
            actionHandler.dismiss(animated: animated)
        case .custom:
            if let name = action.payload?["name"]?.stringValue,
               let payload = action.payload?["data"]?.dictionaryValue {
                actionHandler.handleCustomAction(name: name, payload: payload)
            }
        }
    }
    
    // MARK: - View Creation Method
    private func createButton(from element: BDUIElement) -> UIButton {
        let button = Button()
        
        var title = "Button"
        var style: ButtonStyle = .primary
        var icon: UIImage? = nil
        var isEnabled = true
        
        if let content = element.content {
            if let titleValue = content["title"]?.stringValue {
                title = titleValue
            }
            
            if let styleValue = content["style"]?.stringValue {
                switch styleValue {
                case "primary": style = .primary
                case "secondary": style = .secondary
                case "outlined": style = .outlined
                case "text": style = .text
                default: break
                }
            }
            
            if let iconName = content["iconName"]?.stringValue {
                icon = UIImage(named: iconName)
            }
            
            if let enabledValue = content["isEnabled"]?.boolValue {
                isEnabled = enabledValue
            }
        }
        
        let action: (() -> Void)? = element.actions?["tap"] != nil ? { [weak self, weak button] in
            guard let self = self, let button = button, 
                  let action = element.actions?["tap"] else { return }
            self.handleAction(action, from: button)
        } : nil
        
        let viewModel = ButtonViewModel(
            title: title,
            style: style,
            icon: icon,
            isEnabled: isEnabled,
            action: action
        )
        
        button.configure(with: viewModel)
        return button
    }
    
    private func createCard(from element: BDUIElement) -> UIView {
        let card = Card()
        
        var title: String? = nil
        var subtitle: String? = nil
        var image: UIImage? = nil
        var style: CardStyle = .elevated
        
        if let content = element.content {
            if let titleValue = content["title"]?.stringValue {
                title = titleValue
            }
            
            if let subtitleValue = content["subtitle"]?.stringValue {
                subtitle = subtitleValue
            }
            
            if let imageName = content["imageName"]?.stringValue {
                image = UIImage(named: imageName)
            }
            
            if let styleValue = content["style"]?.stringValue {
                switch styleValue {
                case "elevated": style = .elevated
                case "outlined": style = .outlined
                case "filled": style = .filled
                default: break
                }
            }
        }
        
        let action: (() -> Void)? = element.actions?["tap"] != nil ? { [weak self, weak card] in
            guard let self = self, let card = card, 
                  let action = element.actions?["tap"] else { return }
            self.handleAction(action, from: card)
        } : nil
        
        let viewModel = CardViewModel(
            title: title,
            subtitle: subtitle,
            image: image,
            style: style,
            action: action
        )
        
        card.configure(with: viewModel)
        
        if let subviews = element.subviews, !subviews.isEmpty {
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(containerView)
            
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: card.topAnchor, constant: Spacing.large),
                containerView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: Spacing.medium),
                containerView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -Spacing.medium),
                containerView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -Spacing.medium)
            ])
            
            for subviewElement in subviews {
                if let subview = mapToView(subviewElement) {
                    containerView.addSubview(subview)
                    subview.translatesAutoresizingMaskIntoConstraints = false
                    
                    NSLayoutConstraint.activate([
                        subview.topAnchor.constraint(equalTo: containerView.topAnchor),
                        subview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                        subview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                        subview.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
                    ])
                }
            }
        }
        
        return card
    }
    
    private func createLabel(from element: BDUIElement) -> UIView {
        let label = Label()
        
        var text = ""
        var style: LabelStyle = .body
        var color: UIColor? = nil
        var alignment: NSTextAlignment = .natural
        
        if let content = element.content {
            if let textValue = content["text"]?.stringValue {
                text = textValue
            }
            
            if let styleValue = content["style"]?.stringValue {
                switch styleValue {
                case "largeTitle": style = .largeTitle
                case "title": style = .title
                case "headline": style = .headline
                case "body": style = .body
                case "caption": style = .caption
                case "error": style = .error
                default: break
                }
            }
            
            if let colorHex = content["color"]?.stringValue {
                color = UIColor(hex: colorHex)
            }
            
            if let alignmentValue = content["alignment"]?.stringValue {
                switch alignmentValue {
                case "left": alignment = .left
                case "center": alignment = .center
                case "right": alignment = .right
                case "justified": alignment = .justified
                case "natural": alignment = .natural
                default: break
                }
            }
        }
        
        let viewModel = LabelViewModel(
            text: text,
            style: style,
            color: color,
            alignment: alignment
        )
        
        label.configure(with: viewModel)
        return label
    }
    
    private func createTextInput(from element: BDUIElement) -> UIView {
        let textInput = TextInput()
        
        var placeholder: String? = nil
        var text: String? = nil
        var style: TextInputStyle = .standard
        var isSecure = false
        var leftIcon: UIImage? = nil
        var rightIcon: UIImage? = nil
        
        if let content = element.content {
            if let placeholderValue = content["placeholder"]?.stringValue {
                placeholder = placeholderValue
            }
            
            if let textValue = content["text"]?.stringValue {
                text = textValue
            }
            
            if let styleValue = content["style"]?.stringValue {
                switch styleValue {
                case "standard": style = .standard
                case "outlined": style = .outlined
                case "error": style = .error
                default: break
                }
            }
            
            if let secureValue = content["isSecure"]?.boolValue {
                isSecure = secureValue
            }
            
            if let leftIconName = content["leftIconName"]?.stringValue {
                leftIcon = UIImage(named: leftIconName)
            }
            
            if let rightIconName = content["rightIconName"]?.stringValue {
                rightIcon = UIImage(named: rightIconName)
            }
        }
        
        let onTextChange: ((String) -> Void)? = element.actions?["textChange"] != nil ? { [weak self, weak textInput] text in
            guard let self = self, let textInput = textInput,
                  let action = element.actions?["textChange"] else { return }
            var modifiedAction = action
            var payload = modifiedAction.payload ?? [:]
            payload["text"] = AnyCodable(text)
            self.handleAction(modifiedAction, from: textInput)
        } : nil
        
        let viewModel = TextInputViewModel(
            placeholder: placeholder,
            text: text,
            style: style,
            isSecure: isSecure,
            leftIcon: leftIcon,
            rightIcon: rightIcon,
            onTextChange: onTextChange
        )
        
        textInput.configure(with: viewModel)
        return textInput
    }
    
    private func createStackView(from element: BDUIElement) -> UIView {
        let stackView = StackView()
        
        var axis: NSLayoutConstraint.Axis = .vertical
        var spacing: CGFloat = Spacing.medium
        var distribution: UIStackView.Distribution = .fill
        var alignment: UIStackView.Alignment = .fill
        
        if let content = element.content {
            if let axisValue = content["axis"]?.stringValue {
                axis = axisValue == "horizontal" ? .horizontal : .vertical
            }
            
            if let spacingValue = content["spacing"]?.stringValue {
                switch spacingValue {
                case "xxSmall": spacing = Spacing.xxSmall
                case "xSmall": spacing = Spacing.xSmall
                case "small": spacing = Spacing.small
                case "medium": spacing = Spacing.medium
                case "large": spacing = Spacing.large
                case "xLarge": spacing = Spacing.xLarge
                case "xxLarge": spacing = Spacing.xxLarge
                default:
                    if let value = Double(spacingValue) {
                        spacing = CGFloat(value)
                    }
                }
            }
            
            if let distributionValue = content["distribution"]?.stringValue {
                switch distributionValue {
                case "fill": distribution = .fill
                case "fillEqually": distribution = .fillEqually
                case "fillProportionally": distribution = .fillProportionally
                case "equalSpacing": distribution = .equalSpacing
                case "equalCentering": distribution = .equalCentering
                default: break
                }
            }
            
            if let alignmentValue = content["alignment"]?.stringValue {
                switch alignmentValue {
                case "fill": alignment = .fill
                case "leading": alignment = .leading
                case "trailing": alignment = .trailing
                case "center": alignment = .center
                case "firstBaseline": alignment = .firstBaseline
                case "lastBaseline": alignment = .lastBaseline
                default: break
                }
            }
        }
        
        let config = StackViewConfig(
            axis: axis,
            spacing: spacing,
            distribution: distribution,
            alignment: alignment
        )
        
        stackView.configure(with: config)
        
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
            for subviewElement in subviews {
                if let subview = mapToView(subviewElement) {
                    contentView.addSubview(subview)
                    
                    subview.translatesAutoresizingMaskIntoConstraints = false
                    
                    if let styles = subviewElement.styles, let padding = styles.padding {
                        NSLayoutConstraint.activate([
                            subview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding.top ?? 0),
                            subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding.left ?? 0),
                            subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(padding.right ?? 0)),
                            subview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(padding.bottom ?? 0))
                        ])
                    } else {
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
    
    // MARK: - Helper Methods
    private func applyStyles(to view: UIView, from styles: ElementStyles?) {
        guard let styles = styles else { return }
        
        if let backgroundColorHex = styles.backgroundColor {
            view.backgroundColor = UIColor(hex: backgroundColorHex)
        }
        
        if let cornerRadiusValue = styles.cornerRadius {
            switch cornerRadiusValue {
            case "small":
                view.layer.cornerRadius = CornerRadius.small
            case "medium":
                view.layer.cornerRadius = CornerRadius.medium
            case "large":
                view.layer.cornerRadius = CornerRadius.large
            default:
                if let value = Double(cornerRadiusValue) {
                    view.layer.cornerRadius = CGFloat(value)
                }
            }
            view.clipsToBounds = true
        }
    }
}
