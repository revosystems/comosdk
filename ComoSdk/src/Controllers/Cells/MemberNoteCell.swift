import UIKit

class MemberNoteCell : UITableViewCell {
    @IBOutlet weak var noteLabel:UILabel!
    
    func setup(note:Como.MemberNote) -> Self {
        noteLabel.text = note.content
        return self
    }
}
