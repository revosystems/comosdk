import UIKit
import RevoFoundation

public class ComoController : UIViewController {
 
    public static func make() -> UINavigationController {
        let nav:UINavigationController = SBController("Como", "nav")
        return nav
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "memberDetails", sender: nil)
    }
}
