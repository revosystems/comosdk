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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedBackgroundView?.backgroundColor = selected ? .black : .clear        
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
