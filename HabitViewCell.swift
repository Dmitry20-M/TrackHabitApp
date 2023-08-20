//
//  HabitViewCell.swift
//  TrackHabitApp
//
//  Created by iAlesha уличный on 07.04.2023.
//

import UIKit

class HabitViewCell: UICollectionViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subTitle: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var stateButton: UIButton!
    
    private var habit: Habit!
    private var onStateBtnClick: (() -> Void)!
    
    let checkedImage = UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
    let uncheckedImage = UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.contentView.layer.cornerRadius = 8
    }

    func setupCell(with habit: Habit, onStateBtnClick: @escaping () -> Void) {
        self.habit = habit
        self.onStateBtnClick = onStateBtnClick
        
        self.titleLabel.text = habit.name
        self.titleLabel.textColor = habit.color
        self.subTitle.text = habit.dateString
        self.counterLabel.text = "Счетчик \(habit.trackDates.count)"
        
        if habit.isAlreadyTakenToday {
            self.stateButton.setImage(checkedImage, for: .normal)
        } else {
            self.stateButton.setImage(uncheckedImage, for: .normal)
        }
        
        self.stateButton.tintColor = habit.color
    }
    
    // когда нажимаю завершить прогресс 
    @IBAction private func clickOnStateBtn(sender: UIButton) {
        if !habit.isAlreadyTakenToday {
            self.stateButton.setImage(checkedImage, for: .normal)
            HabitsStore.shared.track(habit)
            self.onStateBtnClick()
        }
    }
}
