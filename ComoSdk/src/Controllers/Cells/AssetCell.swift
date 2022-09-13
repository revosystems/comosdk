import UIKit
import RevoFoundation
import RevoUIComponents

class AssetCell : UITableViewCell {
    
    @IBOutlet weak var assetImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    
    override  func awakeFromNib() {
        assetImageView.round(4)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedBackgroundView?.backgroundColor = selected ? UIColor(hex: "#eeeeee") : .clear
    }
    
    func setup(asset:Como.Asset) -> Self {
        
        titleLabel.text         = asset.name
        descriptionLabel.text   = asset.description
        statusLabel.text        = "\(asset.status)".ucFirst()
        statusIcon.image = UIImage(systemName: asset.status == .active ? "checkmark.circle.fill" : "xmark.circle.fill")
        statusIcon.tintColor = asset.status == .active ? .systemGreen : .systemRed
        if let image = asset.image {
            assetImageView.downloaded(from: image)
        }else{
            assetImageView.image = nil
        }
        
        return self
    }
}
