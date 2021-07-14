//
//  ThumbnailPictureCell.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 29/04/21.
//

import UIKit

class ThumbnailPictureCell: UICollectionViewCell {

    static let identifier = "ThumbnailPictureCellId"

    @IBOutlet weak var imgThumbnail: UIImageView!
    
    var onRemove:((_ button:Any) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func remove(_ sender:UIButton) {
        guard let remove = self.onRemove else { return }
        remove(sender)
    }
}
