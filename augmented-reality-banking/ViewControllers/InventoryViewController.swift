import UIKit

class InventoryViewController: MerchantViewController {

    fileprivate var indexPathToReload: IndexPath!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        originalMerchants = Coupons.coupons
        filteredMerchants = originalMerchants
    }

    private func getCoupon(at indexPath: IndexPath) -> Coupon {
        guard let coupon = filteredMerchants[indexPath.row] as? Coupon else {
            fatalError("Unable to get coupon cell")
        }
        return coupon
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchantCell", for: indexPath)
        guard !hasReloadedForFilter || cell.contentView.subviews.isEmpty else {
            return cell
        }
        let coupon = getCoupon(at: indexPath)
        let tableViewCell: UITableViewCell
        if cell.contentView.subviews.isEmpty {
            tableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        } else {
            guard let subview = cell.contentView.subviews.first as? UITableViewCell else {
                fatalError("Unable to get UITableViewCell")
            }
            tableViewCell = subview
        }
        tableViewCell.textLabel?.text = coupon.brand.name
        tableViewCell.imageView?.image = coupon.brand.image
        tableViewCell.detailTextLabel?.text = "\(coupon.discount)% discount"

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

        if let sellingPrice = coupon.sellingPrice {
            priceTextView.text = "Selling\n\(sellingPrice) pts"
            priceTextView.textColor = .red
        } else {
            if let marketPrice = coupon.marketPrice {
                priceTextView.text = "Value\n\(marketPrice) pts"
                priceTextView.textColor = .blue
            } else {
                priceTextView.text = "Value\nNo data"
                priceTextView.textColor = .gray
            }
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        expiryTextView.text = "Expiry\n\(dateFormatter.string(from: coupon.expiryDate))"
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
        let coupon = getCoupon(at: indexPath)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = true

        let alertController = UIAlertController(title: coupon.brand.name, message: "\(coupon.discount)% discount",
                                                preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = cell
        let applyAction = UIAlertAction(title: "Apply", style: .default) { _ in
            let applyController = UIAlertController(title: coupon.brand.name, message: "Select transaction to apply to",
                                                    preferredStyle: .actionSheet)
            applyController.popoverPresentationController?.sourceView = cell
            for transaction in Transactions.transactions.filter({ $0.brand.name == coupon.brand.name }) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMM yy"
                let title = dateFormatter.string(from: transaction.date) +
                    "  Amount: $" + String(format: "%.2f", transaction.amount)
                applyController.addAction(UIAlertAction(title: title, style: .default) { _ in
                    cell?.isSelected = false
                })
            }
            applyController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in cell?.isSelected = false })
            self.present(applyController, animated: true)
        }
        alertController.addAction(applyAction)
        alertController.addAction(UIAlertAction(title: "Sell", style: .default) { _ in
            self.presentSellController(indexPath: indexPath, marketPrice: coupon.marketPrice)
            cell?.isSelected = false
        })
        alertController.addAction(UIAlertAction(title: "Sell at market value", style: .default) { _ in
            cell?.isSelected = false
            if let marketPrice = coupon.marketPrice {
                coupon.sellingPrice = marketPrice
                collectionView.reloadItems(at: [indexPath])
            } else {
                self.presentSellController(indexPath: indexPath, marketPrice: coupon.marketPrice)
            }
        })
        if coupon.sellingPrice != nil {
            alertController.addAction(UIAlertAction(title: "Unlist", style: .default) { _ in
                coupon.sellingPrice = nil
                collectionView.reloadItems(at: [indexPath])
                cell?.isSelected = false
            })
        }
        alertController.addAction(UIAlertAction(title: "Gift", style: .default) { _ in
            cell?.isSelected = false
            let giftController = UIAlertController(title: "Select friend to gift to", message: nil,
                                                   preferredStyle: .alert)
            giftController.addTextField { textField in
                textField.placeholder = "Search friends..."
            }
            giftController.addAction(UIAlertAction(title: "#2411 Bao Hui", style: .default))
            giftController.addAction(UIAlertAction(title: "#612 Aisyah", style: .default))
            giftController.addAction(UIAlertAction(title: "#153 Aaron", style: .default))
            giftController.addAction(UIAlertAction(title: "#84 Derrick", style: .default))
            giftController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(giftController, animated: true)
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            cell?.isSelected = false
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in cell?.isSelected = false })
        present(alertController, animated: true)
    }

    private func presentSellController(indexPath: IndexPath, marketPrice: UInt32?) {
        indexPathToReload = indexPath
        let sellController = UIAlertController(title: "Enter price to sell at", message: nil,
                                               preferredStyle: .alert)
        sellController.addTextField { textField in
            if let marketPrice = marketPrice {
                textField.placeholder = String(marketPrice)
            }
            textField.delegate = self
        }
        sellController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sellController, animated: true)
    }
}

extension InventoryViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
              let price = UInt32(text) else {
            return false
        }
        self.dismiss(animated: true)
        getCoupon(at: indexPathToReload).sellingPrice = price
        collectionView?.reloadItems(at: [indexPathToReload])
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

}
