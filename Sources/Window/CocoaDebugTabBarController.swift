//
//  Example
//  man
//
//  Created by man on 11/11/2018.
//  Copyright © 2018 man. All rights reserved.
//

import UIKit

class CocoaDebugTabBarController: UITabBarController {

    var currentStatusBarStyle:UIStatusBarStyle = .default;
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let window = UIApplication.shared.delegate?.window {
            window?.endEditing(true)
        }
        
        setChildControllers()
        
        self.selectedIndex = CocoaDebugSettings.shared.tabBarSelectItem 
        self.tabBar.tintColor = Color.mainGreen
        self.tabBar.backgroundColor = CocoaDebug.navigationColor.hexColor
        
        if #available(iOS 15.0, *) {
            let barAppearance = UITabBarAppearance.init();
            barAppearance.backgroundColor = CocoaDebug.navigationColor.hexColor
            self.tabBar.scrollEdgeAppearance = barAppearance;
            self.tabBar.standardAppearance = barAppearance;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CocoaDebugSettings.shared.visible = true
        currentStatusBarStyle = UIApplication.shared.statusBarStyle
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CocoaDebugSettings.shared.visible = false
        UIApplication.shared.statusBarStyle = currentStatusBarStyle;
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _WindowHelper.shared.displayedList = false
    }
    
    //MARK: - private
    func setChildControllers() {

        //1.
        let logs = UIStoryboard(name: "Logs", bundle: Bundle(for: CocoaDebug.self)).instantiateViewController(withIdentifier: "Logs")
        let network = UIStoryboard(name: "Network", bundle: Bundle(for: CocoaDebug.self)).instantiateViewController(withIdentifier: "Network")
        let app = UIStoryboard(name: "App", bundle: Bundle(for: CocoaDebug.self)).instantiateViewController(withIdentifier: "App")
        
        //2.
        _Sandboxer.shared.isSystemFilesHidden = false
        _Sandboxer.shared.isExtensionHidden = false
        _Sandboxer.shared.isShareable = true
        _Sandboxer.shared.isFileDeletable = true
        _Sandboxer.shared.isDirectoryDeletable = true
        guard let sandbox = _Sandboxer.shared.homeDirectoryNavigationController() else {return}
        sandbox.tabBarItem.title = "Sandbox"
        sandbox.tabBarItem.image = UIImage.init(named: "_icon_file_type_sandbox", in: Bundle.init(for: CocoaDebug.self), compatibleWith: nil)
        
        //3.
        guard let tabBarControllers = CocoaDebugSettings.shared.tabBarControllers else {
            self.viewControllers = [logs, network, app, sandbox]
            return
        }
        
        //4.添加额外的控制器
        var temp = [logs, network, app, sandbox]
        
        for vc in tabBarControllers {
            
            let nav = UINavigationController.init(rootViewController: vc)
            nav.navigationBar.barTintColor = CocoaDebug.navigationColor.hexColor
            
            //****** 以下代码从NavigationController.swift复制 ******
            nav.navigationBar.isTranslucent = false
            
            nav.navigationBar.tintColor = Color.mainGreen
            nav.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20),
                                                     .foregroundColor: Color.mainGreen]
            
            if #available(iOS 15.0, *) {
                let barAppearance = UINavigationBarAppearance.init()
                barAppearance.titleTextAttributes = nav.navigationBar.titleTextAttributes!
                barAppearance.backgroundColor = nav.navigationBar.barTintColor
                nav.navigationBar.scrollEdgeAppearance = barAppearance
                nav.navigationBar.standardAppearance = barAppearance
            }

            let selector = #selector(CocoaDebugNavigationController.exit)
            
            
            let image = UIImage(named: "_icon_file_type_close", in: Bundle(for: CocoaDebugNavigationController.self), compatibleWith: nil)
            let leftItem = UIBarButtonItem(image: image,
                                             style: .done, target: self, action: selector)
            leftItem.tintColor = Color.mainGreen
            nav.topViewController?.navigationItem.leftBarButtonItem = leftItem
            //****** 以上代码从NavigationController.swift复制 ******
            
            temp.append(nav)
        }
        
        self.viewControllers = temp
    }
    
    //MARK: - target action
    @objc func exit() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - show more than 5 tabs by CocoaDebug
//    override var traitCollection: UITraitCollection {
//        let realTraits = super.traitCollection
//        let lieTrait = UITraitCollection.init(horizontalSizeClass: .regular)
//        return UITraitCollection(traitsFrom: [realTraits, lieTrait])
//    }
}

//MARK: - UITabBarDelegate
extension CocoaDebugTabBarController {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = self.tabBar.items else {return}
        
        for index in 0...items.count-1 {
            if item == items[index] {
                CocoaDebugSettings.shared.tabBarSelectItem = index
            }
        }
    }
}
