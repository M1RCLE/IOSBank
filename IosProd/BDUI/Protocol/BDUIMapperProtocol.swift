import UIKit

public protocol BDUIMapperProtocol {
    func mapToView(_ element: BDUIElement) -> UIView?
    func handleAction(_ action: BDUIAction, from sourceView: UIView)
}
