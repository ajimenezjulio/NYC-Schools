//
//  ActivityIndicatorProtocol.swift
//  2019-04-26-JulioCesarAguilar-NYCSchools
//
//  Created by Julio Cesar Aguilar Jimenez on 26/04/2019.
//  Copyright © 2019 Julio C. Aguilar. All rights reserved.
//

import Foundation
import UIKit

// Using a protocol we avoid to rewrite the function every time we need to present an activity view controller. Instead of a singletone, every view will be in charge for creating and removing the views automatically
public protocol ActivityIndicatorProtocol {
    // Show the activity indicator in the view, requires the navigationBarHeight for a good fit
    func showActivityIndicator(navigationHeight: CGFloat) -> [UIView]
    // Remove the activity indicator in the view, also removes every custom view used in the activity
    func hideActivityIndicator(viewsToDismiss: [UIView])
}

// Extension of the protocol to run the process automatically every time
extension ActivityIndicatorProtocol where Self: UIViewController {
    
    func showActivityIndicator(navigationHeight: CGFloat) -> [UIView] {
        // Views for creating a custom activity Indicator
        let container = UIView()
        let loadingView = UIView()
        let activityIndicator = UIActivityIndicatorView()
        
        DispatchQueue.main.async {
            // Setup of the entire container
            container.frame = self.view.frame
            container.center = self.view.center
            container.center.y = container.center.y - navigationHeight
            container.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2947078339)
            
            // Container of the activity indicator
            loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            loadingView.center = self.view.center
            loadingView.backgroundColor = #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 0.7040346747)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            
            // Create the frame for the activity
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
            activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
            
            // Adding subviews
            loadingView.addSubview(activityIndicator)
            container.addSubview(loadingView)
            self.view.addSubview(container)
            
            // Start the animation
            activityIndicator.startAnimating()
        }
        // Return the view references
        return [activityIndicator, loadingView, container]
    }
    
    func hideActivityIndicator(viewsToDismiss: [UIView]) {
        DispatchQueue.main.async {
            (viewsToDismiss[0] as! UIActivityIndicatorView).stopAnimating()
            for view in viewsToDismiss {
                view.removeFromSuperview()
            }
        }
    }
    
}
    

