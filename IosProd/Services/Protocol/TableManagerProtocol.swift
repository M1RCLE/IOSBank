import UIKit

protocol TableManagerProtocol: UITableViewDelegate, UITableViewDataSource {
    var delegate: TableManagerDelegate? { get set }
    func updateData(with items: [ProductViewModel])
    func getTableView() -> UITableView
}

protocol TableManagerDelegate: AnyObject {
    func didSelectItem(at index: Int)
}
