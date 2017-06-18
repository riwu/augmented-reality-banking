import UIKit

class ActivityCell: UITableViewCell {
    
    private func setdate(_ date: Date) {
        guard let dateLabel = contentView.viewWithTag(1) as? UILabel else {
            assertionFailure()
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    private func setCost(_ price: Double) {
        guard let costLabel = contentView.viewWithTag(2) as? UILabel else {
            assertionFailure()
            return
        }
        costLabel.text = (price == 0) ? "Free" : "$" + String(format: "%.2f", price)
    }

    func setActivity(_ activity: Activity) {
        textLabel?.text = activity.title
        detailTextLabel?.text = activity.description
        imageView?.image = UIImage(named: activity.category.rawValue)
        
        setdate(activity.date)
        setCost(activity.cost)
        print("here")
    }
  
}
