//
//  ViewController.swift
//  BMICalculator
//
//  Created by 여성은 on 5/21/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var heightConstraintLabel: UILabel!
    
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var weightConstraintLabel: UILabel!
    
    @IBOutlet var randomBMIButton: UIButton!
    
    @IBOutlet var resultButton: UIButton!
    
    @IBOutlet var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "BMI Calcuator"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        
        subTitleLabel.text = "당신의 BMI지수를 \n알려드릴게요."
        subTitleLabel.font = .systemFont(ofSize: 17)
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textColor = .darkGray
        
        imageView.image = UIImage(named: "image")
        
        
        
        setEntryLabel(label: heightLabel, text: "키가 어떻게 되시나요? (cm)")
        setEntryLabel(label: weightLabel, text: "몸무게는 어떻게 되시나요? (kg)")
        
        let userHeight = UserDefaults.standard.string(forKey: "height")
        heightTextField.text = userHeight
        
        let userWeight = UserDefaults.standard.string(forKey: "weight")
        weightTextField.text = userWeight
        
        setTextField(textField: heightTextField)
        setTextField(textField: weightTextField)
        setConstraintLabel()
        
        setRandomButton()
        setResetButton()
        setResultButton()
        
    }
    
    @IBAction func keyboardDismiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func textFieldClicked(_ sender: UITextField) {
        heightConstraintLabel.text = ""
        weightConstraintLabel.text = ""
    }

    
    
    
    @IBAction func resultButtonTapped(_ sender: UIButton) {
        
        var heightBool: Bool = true
        var weightBool: Bool = true
        
        // 빈칸 검열
        if heightTextField.text == "" {
            heightConstraintLabel.text = "키를 입력해 주세요"
            return
        }
        guard let heigthText = heightTextField.text else {
            return
        }
        // 앞뒤 공백 제거
        let trimHeight = heigthText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let height = Double(trimHeight) else {
            heightConstraintLabel.text = "숫자만 입력해 주세요"
            return
        }
        
        if weightTextField.text == "" {
            weightConstraintLabel.text = "몸무게를 입력해 주세요"
            return
        }
        guard let weightText = weightTextField.text, let weight = Double(weightText) else {
            weightConstraintLabel.text = "숫자만 입력해 주세요"
            return
        }
        if height < 80 || height > 250 {
            heightConstraintLabel.text = "80cm에서 250cm까지 입력 가능합니다."
            heightConstraintLabel.textColor = .red
            heightBool = false
        }
        if weight < 10 || weight > 300 {
            weightConstraintLabel.text = "10kg에서 300kg까지 입력 가능합니다."
            weightConstraintLabel.textColor = .red
            weightBool = false
        }
        
        if heightBool && weightBool {
            showResultAlert(height: height, weight: weight)
        }
        
        UserDefaults.standard.set(height, forKey: "height")
        print("userdefault에 키\(height)저장")
        UserDefaults.standard.set(weight, forKey: "weight")
        print("userdefault에 몸무게\(weight)저장")
    }
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        let randomHeight: Double = Double.random(in: 80...250)
        let randomWeight: Double = Double.random(in: 10...300)
        
        showResultAlert(height: randomHeight, weight: randomWeight)
    }
    
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
        print("userDefault초기화")
        
        heightTextField.text = ""
        weightTextField.text = UserDefaults.standard.string(forKey: "weight")
    }
    
    
    func setEntryLabel(label: UILabel, text: String) {
        label.text = text
        label.font = .systemFont(ofSize: 14)
    }
    
    func setTextField(textField: UITextField) {
        textField.borderStyle = .none
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.keyboardType = .decimalPad
        
        // 왼쪽 공백 설정
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
    }
    
    func setConstraintLabel() {
        heightConstraintLabel.text = ""
        heightConstraintLabel.font = .systemFont(ofSize: 10)
        weightConstraintLabel.text = ""
        weightConstraintLabel.font = .systemFont(ofSize: 10)
    }
    
    func setRandomButton() {
        randomBMIButton.setTitle("랜덤으로 BMI 계산하기", for: .normal)
        randomBMIButton.setTitleColor(.red, for: .normal)
        randomBMIButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        randomBMIButton.tintColor = .darkGray
    }
    
    func setResultButton() {
        resultButton.setTitle("결과 확인", for: .normal)
        resultButton.backgroundColor = .purple
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        resultButton.tintColor = .darkGray
        resultButton.layer.cornerRadius = 15
    }
    
    
    func setResetButton() {
        resetButton.setTitle("정보 초기화", for: .normal)
        resetButton.setTitleColor(.darkGray, for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    func calculateBMI(height: Double, weight: Double) -> Double {
        let heightMeter: Double = height * 0.01
        
        let bmi: Double = weight / (heightMeter * heightMeter)
        
        return bmi
    }
    
    func showResultAlert(height: Double, weight: Double) {
        let heightMeter: Double = height * 0.01
        
        let bmi: Double = weight / (heightMeter * heightMeter)
        
        var message = ""
        
        switch bmi {
        case ..<18.5 :
            message = "저체중입니다."
        case 18.5..<23.0:
            message = "정상입니다."
        case 23.0..<25.0:
            message = "과체중입니다."
        case 25...:
            message = "비만입니다."
        default:
            message = "입력값을 확인해 보세요"
        }
        
        let alert = UIAlertController(
            title: message,
            message: "키: \(String(format: "%.1f",height))cm, 몸무게: \(String(format: "%.1f",weight))kg로 \nBMI지수는 \(String(format: "%.1f", bmi))입니다.",
            preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(confirm)
        
        present(alert, animated: true)
    }
    
}

