//
//  SongsCollectionVCell.swift
//  Rhythm
//
//  Created by Vrushank on 2022-07-21.
//

import UIKit

class SongsCollectionVCell: UICollectionViewCell {
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        songImage.layer.cornerRadius = 8
    }
}
