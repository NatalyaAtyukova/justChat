//
//  SlideCollectionViewCell.swift
//  justChat
//
//  Created by Наталья Атюкова on 02.03.2023.
//

import UIKit

class SlideCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var slideImg: UIImageView!
    @IBOutlet weak var regBtn: UIButton!
    @IBOutlet weak var authBtn: UIButton!
    
    var delegate: LoginViewControllerDelegate!
    
    static let reuceId = "SlideCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    func configure(slide: Slides){
        slideImg.image = slide.img
        descriptionText.text = slide.text
        
        if slide.id == 1{
            regBtn.isHidden = false
            authBtn.isHidden = false
        }
    }
    
    @IBAction func authBtnClick(_ sender: Any) {
        delegate.openAuthVC()
    }
    
    @IBAction func regBtnClick(_ sender: Any) {
        delegate.openRegVC()
    }
}
