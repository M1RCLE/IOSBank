import UIKit

/// View controller showcasing different BDUI screen configurations
final class BDUIExamplesViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let examples: [(title: String, description: String, config: BDUIScreenConfig)] = [
        (
            "Simple Storage Example",
            "Basic example using the alfa-itmo.ru storage API",
            .storage(key: "simple_example", title: "Simple Example")
        ),
        (
            "Product Details",
            "Example product details screen with scrollable content",
            .productDetails(productId: "12345")
        ),
        (
            "Settings Screen",
            "Example settings screen presented modally",
            .settings()
        ),
        (
            "Complex Content",
            "Example with complex nested views and scroll",
            .complexContent()
        ),
        (
            "Custom Endpoint",
            "Example using a custom API endpoint",
            .custom(
                endpoint: "https://alfa-itmo.ru/api/custom_screen",
                parameters: ["theme": "dark"],
                title: "Custom Screen"
            )
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "BDUI Examples"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension BDUIExamplesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let example = examples[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = example.title
        content.secondaryText = example.description
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let example = examples[indexPath.row]
        openBDUIScreen(with: example.config)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Backend Driven UI Examples"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Tap any item to see a BDUI screen loaded from the server."
    }
} 