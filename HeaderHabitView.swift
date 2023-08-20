//
//  HeaderHabitView.swift
//  TrackHabitApp
//
//  Created by iAlesha уличный on 07.04.2023.
//

import UIKit

class HeaderHabitView: UICollectionReusableView {

    @IBOutlet weak private var procentLabel: UILabel!
    @IBOutlet weak private var progressiView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
    }
    
    func setProgress(with value: Float) {
        self.procentLabel.text = "\(value * 100)%"
        self.progressiView.setProgress(value, animated: true)
    }
    
}
