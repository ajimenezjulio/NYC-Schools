//
//  SchoolDetailViewController.swift
//  2019-04-26-JulioCesarAguilar-NYCSchools
//
//  Created by Julio Cesar Aguilar Jimenez on 26/04/2019.
//  Copyright © 2019 Julio C. Aguilar. All rights reserved.
//

import UIKit

class SchoolDetailViewController: UIViewController, ActivityIndicatorProtocol {
    
    // IBOutlets
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var takersLabel: UILabel!
    @IBOutlet weak var mathLabel: UILabel!
    @IBOutlet weak var writingLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scoresLeftView: UIView!
    @IBOutlet weak var scoresRightView: UIView!
    
    
    // Models
    var schoolVM: SchoolViewModel?
    private var scoresVM = SATScores()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Enabling the large title feature
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Navigation setup
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain , target: self, action: #selector(self.backAction))
        self.title = "SAT Scores"
        // Load the NYC schools
        loadScores()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateViewsTopToBottom(views: [logo, nameLabel, cityStateLabel])
        animateViewsBottomToTop(views: [overviewLabel])
        animateViewsLeftToRight(views: [scoresLeftView])
        animateViewsRightToLeft(views: [scoresRightView])
    }
    
    
    // MARK: Load Data
    func loadScores() {
        // Check if we have the school name before calling the service
        guard let _ = self.schoolVM?.dbn else { return }
        // Start animation and keeping the view references to remove them at the end and avoid mempry leaks
        let viewReferences: [UIView]
        // We need the height of the navigation bar to adjust the activity at the half
        viewReferences = self.showActivityIndicator(navigationHeight: (self.navigationController?.navigationBar.frame.height)!)
        
         // Show message if no data available or fill the fields
        self.scoresVM.fetchScores(schoolVM: schoolVM!) { (noDataMessage) in
            if let message = noDataMessage {
                self.show(message: message)
            }
            self.configureUI(scoresVM: self.scoresVM.scoresViewModel)
            // Remove views
            self.hideActivityIndicator(viewsToDismiss: viewReferences)
        }
    }
    
    
    // MARK: UISetup
    func configureUI(scoresVM: ScoresViewModel) {
        let nameSplitted = scoresVM.schoolViewModel?.name.components(separatedBy: kSPACE)
        imageFromInitials(firstName: nameSplitted![0], lastName: nameSplitted![1]) { (image) in
            self.logo.image = image.circleMasked
        }
        // Before we check for schoolName so it's safe to unwrap
        self.nameLabel.text = scoresVM.schoolViewModel?.name
        self.cityStateLabel.text = (scoresVM.schoolViewModel?.city)! + ", " + (scoresVM.schoolViewModel?.state)!
        self.overviewLabel.text = scoresVM.schoolViewModel?.overview
        
        // Fill the data
        self.takersLabel.text = scoresVM.takers
        self.readingLabel.text = scoresVM.reading
        self.mathLabel.text = scoresVM.math
        self.writingLabel.text = scoresVM.writing
    }
    
    
    // MARK: IBActions
    @objc func backAction() {
        // For going back, we just need to pop the actual VC and we will be back
        self.navigationController?.popViewController(animated: true)
    }

}
