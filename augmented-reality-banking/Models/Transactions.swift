import Foundation

struct Transaction: MerchantData {
    let brand: Brand
    let date: Date
    let coupon: Coupon?
    let amount: Double
}

struct Transactions {
    static var transactions: [Transaction] = (0...100).map { _ in
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
