//
//  YTSearchBar.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 01.07.2023.
//

import UIKit

final class YTSearchBar: UIView {
    
    //MARK: Properties
    
    var keyboardSearchTapCallback: VoidClosure?
    
    //MARK: - Views

    private(set) lazy var searchTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Search YouTube"
        field.tintColor = .label
        field.borderStyle = .none
        field.leftViewMode = .unlessEditing
        field.clearButtonMode = .whileEditing
        field.enablesReturnKeyAutomatically = true
        return field
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}

//MARK: - Private methods

private extension YTSearchBar {
    func configure() {
        backgroundColor = Resources.Colors.secondaryBackground
        layer.cornerCurve = .continuous
        
        addSubview(searchTextField)
        searchTextField.delegate = self
        searchTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

//MARK: - UITextFieldDelegate

extension YTSearchBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyboardSearchTapCallback?()
        return true
    }
}
