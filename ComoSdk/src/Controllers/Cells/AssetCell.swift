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
            selectedBackgroundView?.backgroundColor = selected ? UIColor(hex: "#433733") : .clear
    }
    
    func setup(asset:Como.Asset) -> Self {
        
        titleLabel.text         = asset.name
        descriptionLabel.text   = asset.description
        setupStatusIcon(asset)
        
        if let image = asset.image {
            assetImageView.downloaded(from: image)
        }else{
            assetImageView.image = nil
        }
        
        self.isUserInteractionEnabled = asset.redeemable
        self.contentView.alpha = asset.redeemable ? 1 : 0.5
        
        return self
    }
    
    fileprivate func setupStatusIcon(_ asset: Como.Asset) {
        guard asset.redeemable else {
            statusLabel.text      = Como.trans("como_non_reedemable")
            statusIcon.image      = UIImage(systemName: "lock.fill")
            statusIcon.tintColor  = .systemOrange
            return
        }
        
        statusLabel.text        = Como.trans("como_\(asset.status)")
        statusIcon.image        = UIImage(systemName: asset.status == .active ? "checkmark.circle.fill" : "xmark.circle.fill")
        statusIcon.tintColor    = asset.status == .active ? .systemGreen : .systemRed
    }
}
