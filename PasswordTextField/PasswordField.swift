//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum Strength {
    case weak
    case medium
    case strong
}

class PasswordField: UIControl {
    
    // Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    private (set) var passwordStrength: Strength = .weak
    
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 50.0
    private let textFieldMargin: CGFloat = 6.0
    private let colorViewSize: CGSize = CGSize(width: 60.0, height: 5.0)
    
    private let labelTextColor = UIColor(hue: 233.0/360.0, saturation: 16/100.0, brightness: 41/100.0, alpha: 1)
    private let labelFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private let bgColor = UIColor(hue: 0, saturation: 0, brightness: 97/100.0, alpha: 1)
    
    // States of the password strength indicators
    private let unusedColor = UIColor(hue: 210/360.0, saturation: 5/100.0, brightness: 86/100.0, alpha: 1)
    private let weakColor = UIColor(hue: 0/360, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let mediumColor = UIColor(hue: 39/360.0, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let strongColor = UIColor(hue: 132/360.0, saturation: 60/100.0, brightness: 75/100.0, alpha: 1)
    
    private var titleLabel: UILabel = UILabel()
    private var textField: UITextField = UITextField()
    private var showHideButton: UIButton = UIButton()
    private var weakView: UIView = UIView()
    private var mediumView: UIView = UIView()
    private var strongView: UIView = UIView()
    private var strengthDescriptionLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        textField.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        textField.delegate = self
    }
    
    func setup() {
        // Lay out your subviews here
        
        titleLabel.text = "ENTER PASSWORD"
        titleLabel.font = labelFont
        titleLabel.textColor = labelTextColor
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        
        
        //        A textfield that accepts text with the contents hidden or shown depending on the state of the show/hide button. The textfield should have a blue border that wraps around the textfield itself and the show/hide button.
        
        textField.layer.cornerRadius = standardMargin
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = textFieldBorderColor.cgColor
        textField.center = self.center
        textField.placeholder = "Enter a strong password"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = bgColor
        textField.textColor = labelTextColor
        textField.font = labelFont
        //Setting this property to true in a UITextField object additionally enables a password-style experience, in which the text being entered is obscured.
        textField.isSecureTextEntry = true
        textField.rightView = showHideButton
        textField.rightViewMode = .always
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
        showHideButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2.0 * standardMargin, bottom: 0, right: 0)
        
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: standardMargin).isActive = true
        textField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: standardMargin).isActive = true
        textField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -standardMargin).isActive = true
        textField.heightAnchor.constraint(equalToConstant: textFieldContainerHeight).isActive = true
        
        
        //        If you set the “weak, medium, and strong” view’s color proprty to unused and then in your password checking logic change the color in each case
        //You have to set the height and width anchor’s constraints seperately and activate them
        //Essentially, your problem comes when the stack view is generated and it crushes the views to the stack view’s origin because there are no intrensic sizes saying that it cannot go below a certian height and width.
        
        weakView.backgroundColor = unusedColor
        mediumView.backgroundColor = unusedColor
        strongView.backgroundColor = unusedColor
        
        
        weakView.sizeThatFits(colorViewSize)
        mediumView.sizeThatFits(colorViewSize)
        strongView.sizeThatFits(colorViewSize)
        
        weakView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        weakView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        mediumView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        mediumView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        strongView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        strongView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        
        strengthDescriptionLabel.text = "weak password"
        strengthDescriptionLabel.font = labelFont
        strengthDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(strengthDescriptionLabel)
        
        let passwordStrengthStackView = UIStackView()
        //        passwordStrengthStackView.translatesAutoresizingMaskIntoConstraints = false
        passwordStrengthStackView.axis = .horizontal
        passwordStrengthStackView.distribution = .equalSpacing
        addSubview(passwordStrengthStackView)
        
        passwordStrengthStackView.addArrangedSubview(weakView)
        passwordStrengthStackView.addArrangedSubview(mediumView)
        passwordStrengthStackView.addArrangedSubview(strongView)
        
        passwordStrengthStackView.anchor(top: textField.bottomAnchor, leading: textField.leadingAnchor, trailing: nil, bottom: nil, padding: .init(top: standardMargin * 1.5, left: textFieldMargin - 2, bottom: 0, right: 0), size: CGSize(width: colorViewSize.width * 3 + standardMargin, height: colorViewSize.height))
        
//        strengthDescriptionLabel.leadingAnchor.constraint(equalTo: passwordStrengthStackView.trailingAnchor, constant: standardMargin).isActive = true
        strengthDescriptionLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: textFieldMargin - 1).isActive = true
        strengthDescriptionLabel.leadingAnchor.constraint(equalTo: passwordStrengthStackView.trailingAnchor, constant: standardMargin).isActive = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PasswordField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        // TODO: send new text to the determine strength method
        return true
    }
}

