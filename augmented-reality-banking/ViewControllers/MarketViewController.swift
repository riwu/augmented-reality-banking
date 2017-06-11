import UIKit

class MarketViewController: MerchantViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        originalMerchants = Coupons.coupons.sorted { $0.expiryDate > $1.expiryDate }
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

        let price = arc4random_uniform(999) + 1
        priceTextView.text = "Price\n\(price) pts"

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

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        let message = "\(coupon.discount)% discount\nExpiry: \(dateFormatter.string(from: coupon.expiryDate))"
        let alertController = UIAlertController(title: coupon.brand.name, message: message,
                                                preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = cell
        alertController.addAction(UIAlertAction(title: "Buy", style: .default) { _ in
            cell?.isSelected = false
        })
        alertController.addAction(UIAlertAction(title: "Add to wishlist", style: .default) { _ in
            cell?.isSelected = false
        })
        alertController.addAction(UIAlertAction(title: "Contact seller: John Smith", style: .default) { _ in
            cell?.isSelected = false
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cell?.isSelected = false
        })
        present(alertController, animated: true)
    }
}
