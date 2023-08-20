//
//  HabitsViewController.swift
//  TrackHabitApp
//
//  Created by iAlesha уличный on 06.04.2023.
//

import UIKit

enum HabitVCState {
    case create, edit
}

/// экран когда  нажал + 

class HabitsViewController: UIViewController {

    var habit: Habit?
    var habitState: HabitVCState = .create
    var guide: UILayoutGuide!
    
    private var titleLabel: UILabel!
    private var titleTF: UITextField!
    private var colorBtnLabel: UILabel!
    private var colorBtn: UIButton!
    private var dateLabel: UILabel!
    private var datePickerLabel: UILabel!
    private var datePicker: UIDatePicker!
    private var deleteHabitBtn: UIButton!
   
    private var currentTitle: String = ""
    private var currentColor: UIColor = .orange
    private var currentDate: Date = Date()
    private let picker = UIColorPickerViewController()
    
   private let img = UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))!.withRenderingMode(.alwaysTemplate)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        
        if let habit {
            currentDate = habit.date
            currentColor = habit.color
            currentTitle = habit.name
        }
        
        setupView()
        setupNavigationController()
  
    }
    
    /// название верху когда  нажали + и перешли на другой  экран
    func setupNavigationController() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(goBack(_:)))
        self.navigationItem.title = self.habitState == .create ? "Создать" : "Править"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveHabit(_:)))
    }
    
    func setupView() {
        guide = view.safeAreaLayoutGuide
        self.picker.delegate = self
        self.picker.selectedColor = currentColor
        createTitleLabel()
        createTitleTF()
        createColorBtnLabel()
        createColorBtn()
        createDateLabel()
        createDatePickerLabel()
        createDataPicker()
        
        if habitState == .edit {
            createDeleteButon()
        }
            
        
    }
    
    @objc func goBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveHabit(_ sender: UIBarButtonItem) {
        if self.habitState == .create {
            HabitsStore.shared.habits.append(
                Habit(name: currentTitle, date: currentDate, color: currentColor)
            )
            self.navigationController?.popViewController(animated: true)
            
        } else {
            let h = HabitsStore.shared.habits.first {
                $0 == habit
            }
            
            if let h {
                h.name = currentTitle
                h.date = currentDate
                h.color = currentColor
            }
            let vcs = self.navigationController!.viewControllers
            self.navigationController?.popToViewController(vcs[vcs.count - 3], animated: true)
        }
    }
    
    
}

extension HabitsViewController: UITextFieldDelegate {
    
    func createTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Название"
        titleLabel.font = titleLabel.font.withSize(13)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 21),
            titleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 15),
        ])
    }
    
    func createTitleTF() {
        titleTF = UITextField()
        titleTF.translatesAutoresizingMaskIntoConstraints = false
        titleTF.placeholder = "Бегать по утру, ходить на учебу и т.д."
        titleTF.text = currentTitle
        titleTF.delegate = self
        self.view.addSubview(titleTF)
        
        NSLayoutConstraint.activate([
            titleTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            titleTF.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            titleTF.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
        ])
    }
    
    func textFieldDidChangeSelection(_ texField: UITextField) {
        self.currentTitle = texField.text ?? ""
    }
    
    func createColorBtnLabel() {
        colorBtnLabel = UILabel()
        colorBtnLabel.text = "Цвет"
        colorBtnLabel.font = colorBtnLabel.font.withSize(13)
        colorBtnLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(colorBtnLabel)
        
        NSLayoutConstraint.activate([
            colorBtnLabel.topAnchor.constraint(equalTo: titleTF.bottomAnchor, constant: 16),
            colorBtnLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 15),
        ])
    }
    
    func createColorBtn() {
        colorBtn = UIButton()
        colorBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(colorBtn)
        colorBtn.setImage(img, for: .normal)
        colorBtn.tintColor = currentColor
        colorBtn.addTarget(self, action: #selector(showPicker(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            colorBtn.topAnchor.constraint(equalTo: colorBtnLabel.bottomAnchor, constant: 7),
            colorBtn.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
        ])
    }
    
    @objc func showPicker(_ sender: UIButton) {
        self.present(picker, animated: true)
    }
    
    func createDateLabel() {
        dateLabel = UILabel()
        dateLabel.text = "Время"
        dateLabel.font = dateLabel.font.withSize(13)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: colorBtn.bottomAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 15),
        ])
    }
    
    func createDatePickerLabel() {
        datePickerLabel = UILabel()
        let dateString = currentDate.formatted(date: .omitted, time: .shortened)
        setTextDataPickerLabel(with: dateString)
        
        
        datePickerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(datePickerLabel)
        
        NSLayoutConstraint.activate([
            datePickerLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 7),
            datePickerLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
        ])
    }
    
    func setTextDataPickerLabel(with value: String) {
        let mutableString = NSMutableAttributedString(string: "Каждый день в \(value)")
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "Purple")! , range: NSRange(location: 12, length: value.count + 2))
        self.datePickerLabel.attributedText = mutableString
    }
    
    func createDataPicker() {
        datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(setCurrentTime(_:)), for: .valueChanged)
        self.view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerLabel.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            
        ])
    }
    
    @objc func setCurrentTime(_ sender: UIDatePicker) {
        self.currentDate = sender.date
        setTextDataPickerLabel(with: sender.date.formatted(date: .omitted, time: .shortened))
    }
    
    func createDeleteButon() {
        deleteHabitBtn = UIButton()
        deleteHabitBtn.translatesAutoresizingMaskIntoConstraints = false
        deleteHabitBtn.setTitle("Удалить привычку", for: .normal)
        deleteHabitBtn.setTitleColor(.red, for: .normal)
        deleteHabitBtn.addTarget(self, action: #selector(showAlertVC(_:)), for: .touchUpInside)
        
        self.view.addSubview(deleteHabitBtn)
        
        NSLayoutConstraint.activate([
            deleteHabitBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            deleteHabitBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40),
        ])
    }
    
    @objc func showAlertVC(_ sender: UIButton) {
        let vc = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(habit!.name)", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        vc.addAction(UIAlertAction(title: "Удалить", style: .destructive) { _ in
            HabitsStore.shared.habits.removeAll {
                $0 == self.habit
            }

            let vcs = self.navigationController!.viewControllers
            self.navigationController?.popToViewController(vcs[vcs.count-3], animated: true)
        })
        self.present(vc, animated: true)
    }
}

extension HabitsViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.colorBtn.tintColor = currentColor
        dismiss(animated: true)
    
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {

        self.currentColor = color
   
    }
}
