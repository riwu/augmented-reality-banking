import Foundation

struct Coupon: MerchantData {
    let brand: Brand
    let discount: UInt32
    let marketPrice: UInt32?
    let sellingPrice: UInt32?
    let expiryDate: Date
}

struct Coupons {
    static var coupons: [Coupon] = (0...100).map { _ in
        let discount = 5 + arc4random_uniform(16)
        let hasMarketPrice = arc4random_uniform(5) != 0
        let marketPrice = hasMarketPrice ? arc4random_uniform(999) + 1 : nil
        let sellingPrice = (arc4random_uniform(3) == 0) ? marketPrice : nil
        let date = Date(timeIntervalSinceNow: TimeInterval(2 * 24 * 3_600 + Int(arc4random_uniform(60 * 24 * 3_600))))
        return Coupon(brand: Brands.getRand(), discount: discount,
                      marketPrice: marketPrice, sellingPrice: sellingPrice, expiryDate: date)
    }
}
