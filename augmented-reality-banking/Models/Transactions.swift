import Foundation

struct Transaction {
    let brand: Brand
    let date: Date

    static func random() -> Transaction {
        let date = Date(timeIntervalSinceNow: 1_000)
        print(date)
        return Transaction(brand: Brands.getRand(), date: date)
    }
}
