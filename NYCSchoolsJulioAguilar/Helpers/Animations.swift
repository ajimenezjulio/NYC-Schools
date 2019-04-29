//
//  Animations.swift
//  2019-04-26-JulioCesarAguilar-NYCSchools
//
//  Created by Julio Cesar Aguilar Jimenez on 26/04/2019.
//  Copyright © 2019 Julio C. Aguilar. All rights reserved.
//

import Foundation
import UIKit

func animateTable(tableView: UITableView){
    // First reload the table
    tableView.reloadData()
    // Just perform the animation over the visible cells
    let cells = tableView.visibleCells
    
    let tableViewHeight = tableView.bounds.size.height
    
    // Affine transform to every cell, they will traverse the whole table height
    for cell in cells {
        cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
    }
    
    var delayCounter = 0
    
    // Build the animation
    for cell in cells{
        UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform.identity
        }, completion: nil)
        delayCounter += 1
    }
}

// Animates multiple views (from top to bottom)
func animateViewsTopToBottom(views: [UIView]) {
    for view in views {
        view.transform = CGAffineTransform(translationX: 0, y: -100)
    }
    
    for view in views {
        UIView.animate(withDuration: 1.45, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            view.transform = .identity
        }, completion: nil)
    }
}

// Animates multiple views (from bottom to top)
func animateViewsBottomToTop(views: [UIView]) {
    for view in views {
        view.transform = CGAffineTransform(translationX: 0, y: 100)
    }
    for view in views {
        UIView.animate(withDuration: 1.45, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            view.transform = .identity
        }, completion: nil)
    }
}

// Animates multiple views (from left to right)
func animateViewsLeftToRight(views: [UIView]) {
    for view in views {
        view.transform = CGAffineTransform(translationX: -100, y: 0)
    }
    for view in views {
        UIView.animate(withDuration: 1.45, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            view.transform = .identity
        }, completion: nil)
    }
}

// Animates multiple views (from right to left)
func animateViewsRightToLeft(views: [UIView]) {
    for view in views {
        view.transform = CGAffineTransform(translationX: 100, y: 0)
    }
    for view in views {
        UIView.animate(withDuration: 1.45, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            view.transform = .identity
        }, completion: nil)
    }
}

