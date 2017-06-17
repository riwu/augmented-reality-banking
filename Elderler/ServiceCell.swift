import UIKit

class ServiceCell: UICollectionViewCell {
    var label: UILabel!
    var imageView: UIImageView!
    var size: CGSize!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        
        label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(30)
        contentView.addSubview(label)

        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }
}
