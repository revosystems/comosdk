import UIKit
import RevoFoundation
import RevoUIComponents

class AssetCell : UITableViewCell {
    
    @IBOutlet weak var assetImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override  func awakeFromNib() {
        assetImageView.round(4)
    }
    
    func setup(asset:Como.Asset) -> Self {
        
        titleLabel.text         = asset.name
        descriptionLabel.text   = asset.description
        statusLabel.text        = "\(asset.status)".ucFirst()
        if let image = asset.image {
            assetImageView.downloaded(from: image)
        }else{
            assetImageView.image = nil
        }
        
        return self
    }
}