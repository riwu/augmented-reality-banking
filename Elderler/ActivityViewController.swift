import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var activityCell: ActivityCell!

    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var hostLabel: UILabel!
    @IBOutlet private var signUpsLabel: UILabel!
    var activity: Activity!
    var isSchedule = false

    @IBOutlet private var signUpButton: UIButton!

    private func updateSignUpLabel() {
        if let signUps = activity.signUps,
            let vacancies = activity.vacancy {
            signUpsLabel.text = "\(signUps) / \(vacancies)"
        } else {
            signUpsLabel.text = "N/A"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        activityCell.setActivity(activity)
        imageView.image = UIImage(named: activity.title)
        hostLabel.text = activity.host
        locationLabel.text = activity.location
        updateSignUpLabel()

        if isSchedule {
            signUpButton.setTitle("Contact host", for: .normal)
        }
    }

    @IBAction private func onSignupPress(_ sender: UIButton) {
        guard !isSchedule else {
            return
        }
        activity.incrementSignUps()
        updateSignUpLabel()

        let alertController = UIAlertController(title: "Successfully signed up!", message: nil, preferredStyle: .alert)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            alertController.dismiss(animated: true)
            self.dismiss(animated: true)
        }
        present(alertController, animated: true)

    }

    @IBAction private func onBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
