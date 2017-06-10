import UIKit

struct Brand {
    let name: String
    let image: UIImage 
    let imageView: UIImageView
    init(_ name: String) {
        self.name = name
        guard let image = UIImage(named: name) else {
            fatalError("Unable to find image file")
        }
        self.image = image
        self.imageView = UIImageView(image: image)
    }
}

struct Brands {
    private static var brands: [Brand] = []
    private static let names = ["Nike", "H&M", "Uniqlo"]
    init() {
        Brands.names.forEach { Brands.brands.append(Brand($0)) }
    }
    subscript(index: Int) -> Brand {
        return Brands.brands[index]
    }
}
