import Foundation

struct Transaction: MerchantData {
    let brand: Brand
    let date: Date
    let coupon: Coupon?
    
    static func random() -> Transaction {
        let date = Date(timeIntervalSinceNow: 1_000)
        return Transaction(brand: Brands.getRand(), date: date, coupon: nil)
    }
}

struct Transactions {
    static var transactions: [Transaction] = (0...100).map { _ in Transaction.random() }
}
