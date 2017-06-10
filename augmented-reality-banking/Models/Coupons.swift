import Foundation

protocol MerchantData {
    var brand: Brand { get }
}

struct Coupon: MerchantData {
    let brand: Brand
    let discount: UInt32
    let value: UInt32?
    let isSelling: Bool
    let expiryDate: Date
}

struct Coupons {
    
    static let sharedInstance = Coupons()
    var coupons: [Coupon] = []
    
    private init() {
        for _ in 0...100 {
            let discount = 5 + arc4random_uniform(16)
            let isSelling = arc4random_uniform(3) == 0
            let hasValue = isSelling ? true : arc4random_uniform(5) != 0
            let price = hasValue ? arc4random_uniform(999) + 1 : nil
            let date = Date(timeIntervalSinceNow: TimeInterval(2 * 24 * 3_600 +
                                                               Int(arc4random_uniform(60 * 24 * 3_600))))
            coupons.append(Coupon(brand: Brands.getRand(), discount: discount, value: price,
                                  isSelling: isSelling, expiryDate: date))
        }
    }
}
