import UIKit

class ActivityViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UITextView!
        
    var activity: Activity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: activity.title)
        descriptionLabel.text = activity.description
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

