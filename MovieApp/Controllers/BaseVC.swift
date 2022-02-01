//
//  ViewController.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 28/01/22.
//

import UIKit

class BaseVC: UIViewController {

    var activityIndicatorView:UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension BaseVC {
    
    func activityIndicatorView(this:UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        alert.view.tag = 100
        NSLayoutConstraint.activate([
            alert.view.widthAnchor.constraint(equalToConstant: 100),
            alert.view.heightAnchor.constraint(equalToConstant: 100),
        ])
        DispatchQueue.main.async {
            this.present(alert, animated: true, completion: nil)
        }
        return alert
    }
    
    func stopActivityIndicatorView(loader : UIAlertController?,
                                   completion:@escaping (_ successs: Bool) -> Void)  {
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            loader?.dismiss(animated: false, completion: {
                completion(true)
            })
        }
        
    }
    
    func navigationBarTransparente() {
        if let navigationController = self.navigationController {
            
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIColor.white]
            
            if #available(iOS 13.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.backgroundColor = UIColor.clear
                navBarAppearance.shadowColor = UIColor.clear
                navBarAppearance.shadowImage = UIImage()
                navigationController.navigationBar.standardAppearance = navBarAppearance
                navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
            } else {
                navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationController.navigationBar.shadowImage = UIImage()
                navigationController.view.backgroundColor = UIColor.clear
            }
        }
    }
    
    func statusBarView(color:UIColor = .black,
                       isGradient:Bool = false){
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            if keyWindow != nil {
                let statusBar = UIView(frame: (keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
                if isGradient {
                    statusBar.applyGradient(width:UIScreen.main.bounds.width, height:statusBar.bounds.height)
                } else {
                    statusBar.backgroundColor = color
                    statusBar.tintColor = .white
                }
                keyWindow?.addSubview(statusBar)
            }
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            if let statusBar = statusBar {
                if isGradient {
                    statusBar.applyGradient(width:UIScreen.main.bounds.width, height:statusBar.bounds.height)
                } else {
                    statusBar.backgroundColor = color
                    statusBar.tintColor = .white
                }
            }
        }
    }
}
