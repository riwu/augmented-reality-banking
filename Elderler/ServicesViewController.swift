import UIKit

class ServicesViewController: UICollectionViewController {

    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = [Category.medicalServices, 
                      Category.transport, 
                      Category.grocery, 
                      Category.laundry, 
                      Category.repair, 
                      Category.foodDelivery]
    }

 

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", 
                                                            for: indexPath) as? ServiceCell else {
            fatalError()
        }

        let category = categories[indexPath.row]
        
        cell.imageView.image = UIImage(named: category.rawValue)
        cell.imageView.frame = CGRect(x: 0, y: cell.frame.height * 0.1, 
                                      width: cell.frame.width / 2, height: cell.frame.height / 2)
        cell.imageView.center.x = cell.frame.size.width / CGFloat(2)
        
        cell.label.text = category.rawValue
        cell.label.frame = CGRect(x: 0, y: cell.imageView.frame.maxY, 
                                  width: cell.frame.width, height: cell.frame.height * 0.2)
        cell.label.center.x = cell.imageView.center.x
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, 
                                 numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
}


extension ServicesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height / 3)
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
