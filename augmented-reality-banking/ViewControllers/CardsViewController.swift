import UIKit

class CardsViewController: UITableViewController {

    private var cards = ["Citi PremierMiles Visa Card", "AirAsia-Citi Gold Visa Credit Card",
                         "AirAsia-Citi Platinum Visa Credit Card", "Citi Prestige Card",
                         "Citi Rewards Card", "Citi Clear Card", "Citi Simplicity+ Card",
                         "Citi Cash Back Card", "Shell-Citi Credit Card", "Citi Travel Account",
                         "Citi Business Platinum Card", "Citi Business Signature Card"]

    private func showCardDetails(at indexPath: IndexPath) {
        let randIndex = Int(arc4random_uniform(UInt32(Brands.count)))
        let message = (0...(7 + Int(arc4random_uniform(5)))).map {
            "\(5 + arc4random_uniform(16))% discount at " +
                Brands.get((randIndex + $0) % Brands.count).name
        }
        let alertController = UIAlertController(title: cards[indexPath.row], message: message.joined(separator: "\n"),
                                                preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showCardDetails(at: indexPath)
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        showCardDetails(at: indexPath)
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

        cell.detailTextLabel?.text = "**** " + String(format: "%04d", arc4random_uniform(10_000))
        let image = UIImage(named: cards[indexPath.row])
        cell.imageView?.image = image
        return cell
    }
}
