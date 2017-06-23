import Foundation

class Transaction: MerchantData {
    let brand: Brand
    let date: Date
    var coupon: Coupon?
    let amount: Double
    init(brand: Brand, date: Date, coupon: Coupon?, amount: Double) {
        self.brand = brand
        self.date = date
        self.coupon = coupon
        self.amount = amount
    }
}

struct Transactions {
    static var transactions: [Transaction] = (0...300).map { _ in
        guard let refDate = Calendar.current.date(byAdding: .month, value: -3, to: Date()) else {
            fatalError("Cant get date")
        }
        let date = Date(timeInterval: TimeInterval(arc4random_uniform(88 * 24 * 3_600)), since: refDate)
        let amount = Double(300 + arc4random_uniform(20_000)) / 100
        let coupon = arc4random_uniform(2) == 0
                   ? nil
                   : Coupons.coupons[Int(arc4random_uniform(UInt32(Coupons.coupons.count)))]
        return Transaction(brand: Brands.getRand(), date: date, coupon: coupon, amount: amount)
    }.sorted { $0.date > $1.date }
}
