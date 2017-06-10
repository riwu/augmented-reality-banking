import UIKit

struct Brand {
    let name: String
    let image: UIImage 
    let imageView: UIImageView
    init(_ name: String) {
        self.name = name
        guard let image = UIImage(named: name) else {
            fatalError("Unable to find image file: " + name)
        }
        self.image = image
        self.imageView = UIImageView(image: image)
    }
}

struct Brands {
    private static let names = ["4 Fingers", "7-11", "A&F", "Adidas", "Aeropostle", "Armani", "Bershka", 
                                "Calvin Klein", "Cheers", "Cold Storage", "Fila", "G2000", "Gap", "H&M", 
                                "Itacho Sushi", "Levis", "Mango", "Monster Curry", "Nara Thai", "New Balance", 
                                "Nike", "NTUC", "Pull&Bear", "Puma", "Sheng Shiong", "Swensen", "Ted Baker", 
                                "Tommy Hilfiger", "Topman", "Uniqlo", "Zara"]
    private static var brands: [Brand] = Brands.names.map { Brand($0) }
    static var count: Int {
        return Brands.names.count
    }
    
    static func get(_ index: Int) -> Brand {
        return Brands.brands[index]
    }
}
