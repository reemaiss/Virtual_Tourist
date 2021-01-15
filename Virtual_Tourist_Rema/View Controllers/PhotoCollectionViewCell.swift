//
//  PhotoCollectionViewCell.swift
//  Virtual_Tourist_Rema
//
//  Created by Rema alsuwailm on 27/05/1442 AH.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoCell: UIImageView!
    @IBOutlet weak var load: UIActivityIndicatorView!
    
    func setImage(photo: Photo){
        
        if let ph = photo.data {
            photoCell.image = UIImage(data: ph)
            load.isHidden = true
            load.stopAnimating()
        }else{
            load.isHidden = true
            load.stopAnimating()
        }
    }
    
}
