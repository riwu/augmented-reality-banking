import UIKit

class InventoryViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openCouponOptions(sender:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: UICollectionViewDelegate
    @objc 
    private func openCouponOptions(sender: UITapGestureRecognizer) {
        guard let collectionView = collectionView else {
            return
        }
        guard let indexPath = collectionView.indexPathForItem(at: sender.location(in: view)) else {
            return
        }
        let cell = collectionView.cellForItem(at: indexPath)
        guard let subViews = cell?.contentView.subviews else {
            assertionFailure("No subview")
            return
        }
        guard let subView = subViews.first(where: { $0 as? UITableViewCell != nil }),
            let tableViewCell = subView as? UITableViewCell else {
                assertionFailure("Unable to find table view cell")
                return
        }
        guard let title = tableViewCell.textLabel?.text else {
            assertionFailure("Unable to get text")
            return
        }
        guard let discount = tableViewCell.detailTextLabel?.text else {
            assertionFailure("Unable to get text")
            return
        }
        let alertController = UIAlertController(title: title, message: discount, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = cell
        let applyAction = UIAlertAction(title: "Apply", style: .default) { _ in
            let applyController = UIAlertController(title: "Select transaction to apply", message: nil, 
                                                    preferredStyle: .actionSheet)
            applyController.addAction(UIAlertAction(title: "Uniqlo 5/2/2017", style: .default))
            applyController.popoverPresentationController?.sourceView = cell
            self.present(applyController, animated: true)        
        }
        alertController.addAction(applyAction)
        alertController.addAction(UIAlertAction(title: "Sell", style: .default))
        alertController.addAction(UIAlertAction(title: "Gift", style: .default))
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive))
        present(alertController, animated: true)        
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Brands.count * 4
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inventoryCell", for: indexPath)
        guard cell.contentView.subviews.isEmpty else {
            return cell
        }
        
        let brand = Brands.get(Int(arc4random_uniform(UInt32(Brands.count))))
        let tableCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        tableCell.textLabel?.text = brand.name
        tableCell.imageView?.image = brand.image
        tableCell.detailTextLabel?.text = "\(5 + arc4random_uniform(16))% discount"
        
        let width: CGFloat = 80
        let label = UITextView (frame: CGRect(x: cell.frame.width - width, y: 0, width: width, height: 44))
        label.textAlignment = .center
        label.isEditable = false
        
        let isOnSale = arc4random_uniform(3) == 0
        let randPoints = arc4random_uniform(999) + 1
        if isOnSale {
            label.text = "Selling\n\(randPoints) pts"
            label.textColor = .red
        } else {
            let hasValue = arc4random_uniform(5) != 0
            label.text = hasValue ? "Value\n\(randPoints) pts" : "Value\nNo data"
            label.textColor = hasValue ? .blue : .gray
        }

        cell.contentView.addSubview(tableCell)
        cell.contentView.addSubview(label)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                  viewForSupplementaryElementOfKind kind: String,
                                  at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "inventoryHeader",
                                                                             for: indexPath)
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension InventoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 256, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout, 
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout, 
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }   
}
