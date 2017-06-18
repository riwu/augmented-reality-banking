import UIKit

class ScheduleViewController: UITableViewController {
    
    var activities = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    
    
    // MARK: - DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        let activity = activities[indexPath.row]
        cell.textLabel!.text = activity.title
        cell.detailTextLabel!.text = activity.description
        cell.imageView?.image = UIImage(named: activity.title)
        return cell
    }
    
    
    // Mark: - Delegate
    override func tableView(_ tableView: UITableView, 
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, 
                            didSelectRowAt indexPath: IndexPath) {
        guard let activitiesVC = storyboard?.instantiateViewController(
            withIdentifier: "ActivityViewController") as? ActivityViewController else {
                assertionFailure("Can't segue to ActivityViewController")
                return
        }
        activitiesVC.activity = activities[indexPath.row]
        present(activitiesVC, animated: true)
    }
}
