//  Copyright © 2016 Saul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topView: ExpandableTextView!
    
    @IBOutlet weak var middleView: ExpandableTextView!
    
    @IBOutlet weak var bottomView: ExpandableTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topView.configureUIForComment()
        middleView.configureUIForNote()
        bottomView.configureForMessaging()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

