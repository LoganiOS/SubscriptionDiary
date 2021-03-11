

import UIKit

class SubscriptionStatusTableViewCell: UITableViewCell {
    
    static let identifier: String = "SubscriptionStatusTableViewCell"
    @IBOutlet weak var logoImageView: BorderImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
