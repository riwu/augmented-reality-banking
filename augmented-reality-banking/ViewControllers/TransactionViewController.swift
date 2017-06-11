import UIKit

class TransactionViewController: MerchantViewController {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        originalMerchants = Transactions.transactions
        filteredMerchants = originalMerchants
    }

    private func getTransaction(at indexPath: IndexPath) -> Transaction {
        guard let transaction = filteredMerchants[indexPath.row] as? Transaction else {
            fatalError("Unable to get transaction")
        }
        return transaction
    }
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchantCell", for: indexPath)
        let transaction = getTransaction(at: indexPath)
        let tableViewCell: UITableViewCell
        if cell.contentView.subviews.isEmpty {
            tableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        } else {
            guard let subview = cell.contentView.subviews.first as? UITableViewCell else {
                fatalError("Unable to get UITableViewCell")
            }
            tableViewCell = subview
        }
        tableViewCell.textLabel?.text = transaction.brand.name
        tableViewCell.imageView?.image = transaction.brand.image
        if let discount = transaction.coupon?.discount {
            tableViewCell.detailTextLabel?.text = "Applied \(discount)% discount"
            tableViewCell.detailTextLabel?.textColor = .red
        } else {
            tableViewCell.detailTextLabel?.text = ""
        }

        var priceTextView, expiryTextView: UITextView!
        if cell.contentView.subviews.isEmpty {
            let width: CGFloat = 80
            priceTextView = UITextView(frame: CGRect(x: 190, y: 0, width: width, height: 44))
            priceTextView.textAlignment = .center
            priceTextView.isEditable = false
            priceTextView.tag = 0

            expiryTextView = UITextView(frame: CGRect(x: 290, y: 0, width: width, height: 44))
            expiryTextView.textAlignment = .center
            expiryTextView.isEditable = false
            expiryTextView.tag = 1
        } else {
            for subview in tableViewCell.subviews {
                guard let textView = subview as? UITextView else {
                    continue
                }
                if textView.tag == 0 {
                    priceTextView = textView
                } else if textView.tag == 1 {
                    expiryTextView = textView
                }
            }
        }

        priceTextView.text = "Amount\n$" + String(format: "%.2f", transaction.amount)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yy"
        expiryTextView.text = "Date\n\(dateFormatter.string(from: transaction.date))"
        expiryTextView.textColor = .brown

        if cell.contentView.subviews.isEmpty {
            tableViewCell.addSubview(priceTextView)
            tableViewCell.addSubview(expiryTextView)
            cell.contentView.addSubview(tableViewCell)
        }
        return cell
    }

    // MARK: UICollectionViewDelegate
    @objc
    override func tapAction(sender: UITapGestureRecognizer) {
        guard let collectionView = collectionView,
            let indexPath = collectionView.indexPathForItem(at: sender.location(in: view)) else {
                return
        }
        let transaction = getTransaction(at: indexPath)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = true

        let alertController = UIAlertController(title: transaction.brand.name, message: "Select coupons to apply",
                                                preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = cell
        let tableView = UITableView()
        for coupon in Coupons.coupons.filter({ $0.brand.name == transaction.brand.name }) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM"
            let title = "Discount: \(coupon.discount)% | Expiry: \(dateFormatter.string(from: coupon.expiryDate))"
            let couponAction = UIAlertAction(title: title, style: .default) { _ in
                cell?.isSelected = false
            }
            alertController.addAction(couponAction)
        }
        present(alertController, animated: true)
    }
}
