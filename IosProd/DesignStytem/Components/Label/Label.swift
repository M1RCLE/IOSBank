import UIKit

public final class Label: UILabel {
    public func configure(with viewModel: LabelViewModel) {
        text = viewModel.text
        textAlignment = viewModel.alignment
        
        switch viewModel.style {
        case .largeTitle:
            font = Typography.largeTitle
        case .title:
            font = Typography.title
        case .headline:
            font = Typography.headline
        case .body:
            font = Typography.body
        case .caption:
            font = Typography.caption
        case .error:
            font = Typography.caption
        }
        
        textColor = viewModel.color ?? {
            switch viewModel.style {
            case .error: return Colors.error
            default: return Colors.onBackground
            }
        }()
        
        numberOfLines = 0
    }
}

