//
//  Example
//  man
//
//  Created by man on 11/11/2018.
//  Copyright © 2018 man. All rights reserved.
//

import UIKit

class CocoaDebugNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false //liman
        
        navigationBar.tintColor = Color.mainGreen
        navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20),
                                             .foregroundColor: Color.mainGreen]
        
        if #available(iOS 15.0, *) {
            let barAppearance = UINavigationBarAppearance.init()
            barAppearance.titleTextAttributes = navigationBar.titleTextAttributes!
            barAppearance.backgroundColor = CocoaDebug.navigationColor.hexColor
            navigationBar.scrollEdgeAppearance = barAppearance
            navigationBar.standardAppearance = barAppearance
        }

        let selector = #selector(CocoaDebugNavigationController.exit)
        
        let image = UIImage(named: "_icon_file_type_close", in: Bundle(for: CocoaDebugNavigationController.self), compatibleWith: nil)
        let leftItem = UIBarButtonItem(image: image,
                                         style: .done, target: self, action: selector)
        leftItem.tintColor = Color.mainGreen
        topViewController?.navigationItem.leftBarButtonItem = leftItem
    }
    
    
    @objc func exit() {
        dismiss(animated: true, completion: nil)
    }
}
