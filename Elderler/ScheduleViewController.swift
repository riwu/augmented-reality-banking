import UIKit

class ScheduleViewController: UITableViewController {
    
    var activities = Activities.schedules + Activities.activities
    
    // MARK: - DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", 
                                                       for: indexPath) as? ActivityCell else {
                                                        fatalError()
        }        
        cell.setActivity(activities[indexPath.row])
        return cell
    }
    
    
    // Mark: - Delegate
    override func tableView(_ tableView: UITableView, 
                            didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Activity", bundle: nil)
        guard let activityVC = storyboard.instantiateViewController(
            withIdentifier: "ActivityViewController") as? ActivityViewController else {
                assertionFailure("Can't segue to ActivityViewController")
                return
        }
        activityVC.activity = activities[indexPath.row]
        present(activityVC, animated: true)
    }
}
