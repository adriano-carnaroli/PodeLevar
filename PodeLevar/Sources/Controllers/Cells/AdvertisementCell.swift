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
        let path = UIBezierPath(roundedRect:imgPicture.bounds,
                                byRoundingCorners:[.topRight, .bottomRight],
                                cornerRadii: CGSize(width: 8, height:  8))

        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        imgPicture.layer.mask = maskLayer
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
