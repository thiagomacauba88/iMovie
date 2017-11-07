//
//  Extension.swift
//  iMovies
//
//  Created by Thiago Henrique Pereira Freitas on 06/11/17.
//  Copyright © 2017 MobiMais. All rights reserved.
//

import UIKit

extension UIImageView{
    func addBlackGradientLayer(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
}
