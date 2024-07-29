//
//  SliderSlides.swift
//  justChat
//
//  Created by Наталья Атюкова on 07.03.2023.
//

import Foundation
import UIKit

class SliderSlides{
    
    func getSlides()->[Slides] {
        
        var slides: [Slides] = []
        
        let slide1 = Slides(id: 1, text: "text1", img: UIImage(imageLiteralResourceName: "start"))
        let slide2 = Slides(id: 2, text: "text2", img: UIImage(imageLiteralResourceName: "start2"))
        let slide3 = Slides(id: 3, text: "text3", img: UIImage(imageLiteralResourceName: "start3"))
        
        slides.append(slide1)
        slides.append(slide2)
        slides.append(slide3)
        
        return slides
        
    }
    
}
