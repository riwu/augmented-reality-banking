import UIKit

class CardTableViewController: UITableViewController {
    
    private var cards = ["Citi PremierMiles Visa Card", "AirAsia-Citi Gold Visa Credit Card", 
                         "AirAsia-Citi Platinum Visa Credit Card", "Citi Prestige Card",
                         "Citi Rewards Card", "Citi Clear Card", "Citi Simplicity+ Card",
                         "Citi Cash Back Card", "Shell-Citi Credit Card", "Citi Travel Account",
                         "Citi Business Platinum Card", "Citi Business Signature Card"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCardDetails(sender:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc 
    private func showCardDetails(sender: UITapGestureRecognizer) {
        guard let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)) else {
            return
        }
        let message = ["10% discount at Uniqlo", "5% discount at Nike", "15% discount at Ding Tai Fung",
                       "8% discount at Prada", "4% discount at Adidas"]
        let alertController = UIAlertController(title: cards[indexPath.row], message: message.joined(separator: "\n"), 
                                                preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") else {
            fatalError("Failed to deque cell")
        }
        cell.textLabel?.text = cards[indexPath.row]
        
        cell.detailTextLabel?.text = "**** " + String(format: "%04d", arc4random_uniform(10000))
        let image = UIImage(named: cards[indexPath.row])
        cell.imageView?.image = image
        return cell
    }
}
