import UIKit

struct Brand {
    let name: String
    let image: UIImageView
    init(_ name: String) {
        self.name = name
        image = UIImageView(image: UIImage(named: name))
    }
}

struct Brands {
    var brands: [Brand] = []
    static private let names = ["Nike", "H&M", "Uniqlo"]
    init() {
        Brands.names.forEach { brands.append(Brand($0)) }
    }
}
