//
//  SchoolTableViewCell.swift
//  2019-04-26-JulioCesarAguilar-NYCSchools
//
//  Created by Julio Cesar Aguilar Jimenez on 26/04/2019.
//  Copyright © 2019 Julio C. Aguilar. All rights reserved.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {

    @IBOutlet weak var schoolLogo: UIImageView!
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var schoolInterest: UILabel!
    @IBOutlet weak var schoolCity: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // Configure the cell
    func configure(_ vm: SchoolViewModel) {
        self.schoolName.text = vm.name
        self.schoolInterest.text = vm.interest
        self.schoolCity.text = vm.city
    
        let nameSplitted = vm.name.components(separatedBy: kSPACE)
        imageFromInitials(firstName: nameSplitted[0], lastName: nameSplitted[1]) { (image) in
            self.schoolLogo.image = image.circleMasked
        }
    }

}
