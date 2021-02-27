//
//  NasaCell.swift
//  NasaViewer
//
//  Created by Кирилл Дутов on 27.02.2021.
//

import UIKit

class NASAMainCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    
    @IBOutlet weak var NASAImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
}
