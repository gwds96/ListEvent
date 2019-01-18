import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var titleEventLabel: UILabel!
    @IBOutlet weak var detailEventLabel: UILabel!
    @IBOutlet weak var numberGoingLabel: UILabel!
    @IBOutlet weak var numberWentLabel: UILabel!
    @IBOutlet weak var constentView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var eventTitle: String?
    var eventImg: UIImage?
    var eventDetail: String?
    var eventGoing: String?
    var eventWent: String?
    
    var contentRect = CGRect.zero
    
    override func viewDidLoad() {
        titleEventLabel.text = eventTitle
        eventImage.image = eventImg
        detailEventLabel.text = eventDetail
        numberGoingLabel.text = eventGoing
        numberWentLabel.text = eventWent
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
