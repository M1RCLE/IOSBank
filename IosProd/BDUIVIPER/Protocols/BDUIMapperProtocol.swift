import UIKit

protocol BDUIMapperProtocol: AnyObject {
    func mapToView(_ element: BDUIElement) -> UIView?
} 