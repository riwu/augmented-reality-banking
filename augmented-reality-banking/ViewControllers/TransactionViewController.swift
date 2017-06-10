import UIKit

class TransactionViewController: MerchantViewController {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        originalMerchants = Transactions.transactions
        filteredMerchants = originalMerchants
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchantCell", for: indexPath)
        let transaction = filteredMerchants[indexPath.row] as! Transaction
        let tableViewCell: UITableViewCell
        if cell.contentView.subviews.isEmpty {
            tableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        } else {
            guard let subview = cell.contentView.subviews.first as? UITableViewCell else{
                fatalError("Unable to get UITableViewCell")
            }
            tableViewCell = subview
        }
        tableViewCell.textLabel?.text = transaction.brand.name
        tableViewCell.imageView?.image = transaction.brand.image
        
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
        
        if cell.contentView.subviews.isEmpty {
            tableViewCell.addSubview(textView)
            cell.contentView.addSubview(tableViewCell)
        }
        return cell
    }

}
