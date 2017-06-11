import UIKit

class TransactionViewController: MerchantViewController {
    private var tableView: UITableView?
    private var selectedCell: UICollectionViewCell?
    private var applyButton: UIButton?
    private var headerView: UITextView!

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
        self.tableView?.removeFromSuperview()
        self.applyButton?.removeFromSuperview()
        selectedCell?.isSelected = false

        let location = sender.location(in: collectionView)
        guard let collectionView = collectionView,
              let indexPath = collectionView.indexPathForItem(at: location) else {
            return
        }
        selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell?.isSelected = true

        let tableView = UITableView(frame: CGRect(origin: sender.location(in: view),
                                                  size: CGSize(width: 320, height: 44 * 6)))
        self.tableView = tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHandler)))
        view.addSubview(tableView)

        let applyButton = UIButton(frame: CGRect(x: tableView.frame.minX, y: tableView.frame.maxY,
                                                 width: tableView.frame.width, height: 30))
        self.applyButton = applyButton
        applyButton.setTitle("Apply", for: .normal)
        applyButton.setTitleColor(.red, for: .normal)
        applyButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(applyButtonPressed)))
        let grayIntensity: CGFloat = 0.97
        applyButton.backgroundColor = UIColor(red: grayIntensity, green: grayIntensity, blue: grayIntensity, alpha: 1)
        view.addSubview(applyButton)
    }

    @objc
    private func applyButtonPressed() {
        tableView?.removeFromSuperview()
        applyButton?.removeFromSuperview()
        selectedCell?.isSelected = false
        guard let selectedCell = selectedCell,
              let indexPath = collectionView?.indexPath(for: selectedCell),
              let transaction = filteredMerchants[indexPath.row] as? Transaction,
              let discount = calculateDiscount() else {
            return
        }
        transaction.coupon = Coupon(brand: transaction.brand, discount: discount,
                                    marketPrice: nil, sellingPrice: nil, expiryDate: Date())
        collectionView?.reloadItems(at: [indexPath])
    }

    @objc
    private func tapHandler(sender: UITapGestureRecognizer) {
        let location = sender.location(in: tableView)
        guard let indexPath = tableView?.indexPathForRow(at: location),
              let cell = tableView?.cellForRow(at: indexPath) else {
            return
        }
        cell.isSelected = !cell.isSelected
        cell.accessoryType = cell.isSelected ? .checkmark : .none

        if let discount = calculateDiscount() {
            headerView?.text = "Total discount: \(discount)%\nDiscount cap at: 25%"
        } else {
            headerView?.text = "Additional coupon discounts are halved\nDiscount cap at: 25%"
        }
    }

    private func calculateDiscount() -> UInt32? {
        var discounts: [UInt32] = []
        tableView?.visibleCells.forEach {_l in
            guard let indexPath = tableView?.indexPath(for: cell) else {
                assertionFailure()
                return
            }
            if cell.isSelected {
                discounts.append(Coupons.coupons[(indexPath.row * 50) % Coupons.coupons.count].discount)
            }
        }
        if let highest = discounts.max() {
            return min(25, highest + (discounts.reduce(0, +) - highest) / 2)
        } else {
            return nil
        }
    }
}

extension TransactionViewController: UITableViewDataSource {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let coupon = Coupons.coupons[(indexPath.row * 50) % Coupons.coupons.count]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        cell.textLabel?.text = "Discount: \(coupon.discount)%  Expiry: \(dateFormatter.string(from: coupon.expiryDate))"
        cell.textLabel?.textAlignment = .center
        return cell
    }
}

extension TransactionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        headerView = UITextView()
        headerView.text = "Additional coupon discounts are halved\nDiscount cap at: 25%"
        headerView.font = headerView.font?.withSize(16)
        headerView.textColor = .red
        headerView.textAlignment = .center
        return headerView
    }
}
