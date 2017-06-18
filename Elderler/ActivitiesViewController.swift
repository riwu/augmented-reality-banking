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
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        
        searchController.searchBar.scopeButtonTitles = ["All", "Sports", "Movie", "Dinner", "Other"]
        tableView.tableHeaderView = searchController.searchBar
        
 
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ActivityViewController
        }
    }
    
    // MARK: - DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredActivities.count
        }
        return activities.count
    }
    
    private func getActivity(at indexPath: IndexPath) -> Activity {
        return (searchController.isActive && searchController.searchBar.text != "") 
            ? filteredActivities[indexPath.row]
            : activities[indexPath.row]
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
            let categoryMatch = (scope == "All") || (activity.category.rawValue == scope)
            return categoryMatch && (activity.title.lowercased().contains(searchText.lowercased()) || 
                activity.description.lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }
    
    // Mark: - Delegate
//    override func tableView(_ tableView: UITableView, 
//                   heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
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
