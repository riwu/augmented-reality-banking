import UIKit

class InventoryViewController: MerchantViewController {

    fileprivate var textView: UITextView?

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

        let textView: UITextView
        if cell.contentView.subviews.isEmpty {
            let width: CGFloat = 60
            textView = UITextView(frame: CGRect(x: 190, y: 0, width: width, height: 44))
            textView.textAlignment = .center
            textView.isEditable = false
        } else {
            guard let subview = tableViewCell.subviews.first(where: { $0 as? UITextView != nil }) as? UITextView else {
                fatalError("Unable to get UITextView")
            }
            textView = subview
        }

        if let sellingPrice = coupon.sellingPrice {
            setToSale(textView: textView, price: sellingPrice)
        } else {
            unlist(textView: textView, price: coupon.marketPrice)
        }

        if cell.contentView.subviews.isEmpty {
            tableViewCell.addSubview(textView)
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
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = true
        guard let subViews = cell?.contentView.subviews,
              let tableSubView = subViews.first(where: { $0 as? UITableViewCell != nil }),
              let tableViewCell = tableSubView as? UITableViewCell,
              let title = tableViewCell.textLabel?.text,
              let discount = tableViewCell.detailTextLabel?.text else {
            assertionFailure("No subview")
            return
        }

        guard let textSubView = tableViewCell.subviews.first(where: { $0 as? UITextView != nil }),
              let textView = textSubView as? UITextView else {
            assertionFailure("No text view")
            return
        }
        self.textView = textView

        let alertController = UIAlertController(title: title, message: discount, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = cell
        let applyAction = UIAlertAction(title: "Apply", style: .default) { _ in
            let applyController = UIAlertController(title: "Select transaction to apply", message: nil,
                                                    preferredStyle: .actionSheet)
            applyController.popoverPresentationController?.sourceView = cell
            applyController.addAction(UIAlertAction(title: "Uniqlo 5/2/2017", style: .default) { _ in
                cell?.isSelected = false
            })
            applyController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in cell?.isSelected = false })
            self.present(applyController, animated: true)
        }
        alertController.addAction(applyAction)
        alertController.addAction(UIAlertAction(title: "Sell", style: .default) { _ in
            let sellController = UIAlertController(title: "Enter price to sell at", message: nil,
                                                   preferredStyle: .alert)
            sellController.addTextField { textField in
                if let price = self.getPrice(textView.text) {
                    textField.placeholder = String(price)
                }
                textField.delegate = self
            }
            sellController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(sellController, animated: true)
            cell?.isSelected = false
        })
        alertController.addAction(UIAlertAction(title: "Sell at market value", style: .default) { _ in
            guard let price = self.getPrice(textView.text) else {
                return
            }
            self.setToSale(textView: textView, price: price)
            cell?.isSelected = false
        })
        let coupon = getCoupon(at: indexPath)
        if coupon.sellingPrice != nil {
            alertController.addAction(UIAlertAction(title: "Unlist", style: .default) { _ in
                self.unlist(textView: textView)
                cell?.isSelected = false
            })
        }
        alertController.addAction(UIAlertAction(title: "Gift", style: .default) { _ in cell?.isSelected = false })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            cell?.isSelected = false
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in cell?.isSelected = false })
        present(alertController, animated: true)
    }

    private func getPrice(_ text: String) -> UInt32? {
        return UInt32(text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}

extension InventoryViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
              let price = UInt32(text) else {
            return false
        }
        self.dismiss(animated: true)
        if let textView = textView {
            self.setToSale(textView: textView, price: price)
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

}

// MARK: UICollectionViewDelegateFlowLayout
extension InventoryViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 384, height: 50)
    }
}
