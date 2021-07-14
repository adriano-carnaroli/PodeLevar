//
//  AdvertisementCell.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 18/04/21.
//

import UIKit

class AdvertisementCell: UITableViewCell {

    static let identifier = "AdvertisementCellIdentifier"

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
