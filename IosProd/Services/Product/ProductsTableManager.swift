import UIKit

class ProductsTableManager: NSObject, ProductTableManagable {
    weak var delegate: TableManagerDelegate?
    private var products: [EnhancedProductViewModel] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GenericCell<ProductView>.self, forCellReuseIdentifier: "ProductCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    func updateData(with items: [EnhancedProductViewModel]) {
        self.products = items
        tableView.reloadData()
    }
    
    func getTableView() -> UITableView {
        return tableView
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? GenericCell<ProductView> else {
            return UITableViewCell()
        }
        
        cell.configure(with: products[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Adjusted for the new cell with image
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectItem(at: indexPath.row)
    }
}
