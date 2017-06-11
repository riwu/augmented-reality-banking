import UIKit

extension MerchantViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filterAndReload(searchText: "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else {
            assertionFailure("No text")
            return
        }
        filterAndReload(searchText: text)
    }

    private func filterAndReload(searchText: String) {
        filter(searchText: searchText)
        self.collectionView?.reloadSections(IndexSet(integer: 1))
    }
}

class MerchantViewController: UICollectionViewController {

    var originalMerchants: [MerchantData] = []
    var filteredMerchants: [MerchantData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    func tapAction(sender: UITapGestureRecognizer) {
        assertionFailure("Must be overriden in sub class")
    }

    func filter(searchText: String) {
        filteredMerchants = searchText.isEmpty ? originalMerchants : originalMerchants.filter {
            $0.brand.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 0 : filteredMerchants.count
    }

    func setToSale(textView: UITextView, price: UInt32) {
        textView.text = "Selling\n\(price) pts"
        textView.textColor = .red
    }

    func unlist(textView: UITextView, price: UInt32? = nil) {
        if let price = price {
            textView.text = "Value\n\(price) pts"
            textView.textColor = .blue
        } else {
            textView.text = "Value\nNo data"
            textView.textColor = .gray
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "searchBar",
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
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: collectionView.frame.width, height: collectionView.contentSize.height)
                            : CGSize()
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
