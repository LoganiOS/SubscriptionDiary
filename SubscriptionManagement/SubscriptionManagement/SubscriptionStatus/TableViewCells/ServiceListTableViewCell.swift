

import UIKit

class ServiceListTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var plusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let index = UserDefaults.standard.integer(forKey: "selectedIndex")
        let customTintColor = UIColor(rgb: CustomColor.shared.themes[index].main)
        plusImageView.tintColor = customTintColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
