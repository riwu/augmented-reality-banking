import UIKit

class ActivitiesViewController: UITableViewController {
    
    // MARK: - Properties
    var detailViewController: ActivityViewController? = nil
    var activities = Activities.activities
    var filteredActivities = [Activity]()
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredActivities = activities
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        
        searchController.searchBar.scopeButtonTitles = ["All", Category.sports.rawValue, Category.dining.rawValue,
                Category.boardGame.rawValue, Category.celebration.rawValue, "Others"]
        tableView.tableHeaderView = searchController.searchBar
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ActivityViewController
        }
    }
    
    // MARK: - DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredActivities.count
    }
    
    private func getActivity(at indexPath: IndexPath) -> Activity {
        return filteredActivities[indexPath.row]
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", 
                                                       for: indexPath) as? ActivityCell else {
            fatalError()
        }
        let activity = getActivity(at: indexPath)
        cell.setActivity(activity)
        return cell
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredActivities = activities.filter { activity  in
            guard let scopeTitles = searchController.searchBar.scopeButtonTitles else {
                assertionFailure()
                return true
            }
            let categoryMatch = (scope == "All") || (activity.category.rawValue == scope) || 
                (scope == "Others" && !scopeTitles.contains(activity.category.rawValue))
            let match = categoryMatch && (searchText.isEmpty || 
                (activity.title.lowercased().contains(searchText.lowercased()) || 
                    activity.description.lowercased().contains(searchText.lowercased())))
            return match
        }
        tableView.reloadData()
    }
    
    // Mark: - Delegate
    override func tableView(_ tableView: UITableView, 
                   didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Activity", bundle: nil)
        guard let activitiesVC = storyboard.instantiateViewController(
            withIdentifier: "ActivityViewController") as? ActivityViewController else {
                assertionFailure("Can't segue to ActivityViewController")
                return
        }
        activitiesVC.activity = getActivity(at: indexPath)
        present(activitiesVC, animated: true)
    }
}

extension ActivitiesViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension ActivitiesViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
