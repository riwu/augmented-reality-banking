import UIKit

class ScheduleViewController: ActivitiesViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        activities = Activities.schedules + Activities.activities
        filteredActivities = activities
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
        activityVC.isSchedule = true
        present(activityVC, animated: true)
    }
}
