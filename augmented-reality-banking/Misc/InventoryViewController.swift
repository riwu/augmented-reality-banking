import UIKit

class InventoryViewController: UICollectionViewController {



}

// MARK: UICollectionViewDataSource
extension InventoryViewController {
        
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

        cell.contentView.addSubview(label)
        cell.contentView.addSubview(tableCell)
        return cell
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
