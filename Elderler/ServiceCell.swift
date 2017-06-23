import UIKit

class ServiceCell: UICollectionViewCell {
    let label: UILabel
    let imageView: UIImageView

    required init?(coder aDecoder: NSCoder) {
        label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(30)

        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        super.init(coder: aDecoder)

        contentView.addSubview(label)
        contentView.addSubview(imageView)
    }
}
