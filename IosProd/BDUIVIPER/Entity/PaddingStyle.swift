import UIKit

public struct PaddingStyle: Decodable {
    public let top: CGFloat?
    public let left: CGFloat?
    public let bottom: CGFloat?
    public let right: CGFloat?
    
    public init(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
}
