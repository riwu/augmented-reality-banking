import UIKit

class MerchantViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    func tapAction(sender: UITapGestureRecognizer) {
        assertionFailure("Must be overriden in sub class")
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Brands.count * 4
    }

    func setToSale(textView: UITextView, price: UInt32) {
        textView.text = "Selling\n\(price) pts"
        textView.textColor = .red
    }

    func unlist(textView: UITextView, price: UInt32? = nil) {
        let hasValue = arc4random_uniform(5) != 0
        textView.text = hasValue ? "Value\n\(price ?? getRandomPrice()) pts" : "Value\nNo data"
        textView.textColor = hasValue ? .blue : .gray
    }

    private func getRandomPrice() -> UInt32 {
        return arc4random_uniform(999) + 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inventoryCell", for: indexPath)
        guard cell.contentView.subviews.isEmpty else {
            return cell
        }

        let brand = Brands.getRand()
        let tableCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        tableCell.textLabel?.text = brand.name
        tableCell.imageView?.image = brand.image
        tableCell.detailTextLabel?.text = "\(5 + arc4random_uniform(16))% discount"

        let width: CGFloat = 80
        let textView = UITextView(frame: CGRect(x: cell.frame.width - width, y: 0, width: width, height: 44))
        textView.textAlignment = .center
        textView.isEditable = false

        let isOnSale = arc4random_uniform(3) == 0
        let randPoints = getRandomPrice()
        if isOnSale {
            setToSale(textView: textView, price: randPoints)
        } else {
            unlist(textView: textView, price: randPoints)
        }

        cell.contentView.addSubview(tableCell)
        cell.contentView.addSubview(textView)
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
extension MerchantViewController: UICollectionViewDelegateFlowLayout {
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
