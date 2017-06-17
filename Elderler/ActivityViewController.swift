import UIKit

class ActivityViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UITextView!
        
    var activity: Activity? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = activity?.image
        titleLabel.text = activity?.title
        descriptionLabel.text = activity?.description
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

