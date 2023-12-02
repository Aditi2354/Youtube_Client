//
//  VideoCategoryCollectionViewCell.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 08.05.2023.
//

import UIKit
import SnapKit

final class VideoCategoryCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: Properties
    
    override var isSelected: Bool {
        didSet {
            animateSelection()
        }
    }
    
    //MARK: - Views
    
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    //MARK: - Methods
    
    func configure(with category: String) {
        categoryTitleLabel.text = category
    }
    
    //MARK: - Overrided Methods
    
    override func configureAppearance() {
        contentView.backgroundColor = Resources.Colors.menuItem
        contentView.layer.cornerCurve = .continuous
    }
    
    override func setupSubviews() {
        contentView.addSubview(categoryTitleLabel)
    }
    
    override func makeSubviewsLayout() {
        makeConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
    }
}

//MARK: - Private methods

private extension VideoCategoryCollectionViewCell {
    func animateSelection() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }

            contentView.backgroundColor = isSelected ? .label : Resources.Colors.menuItem
            categoryTitleLabel.textColor = isSelected ? .systemBackground : .label
        }
    }
}

//MARK: - Layout

private extension VideoCategoryCollectionViewCell {
    enum UIConstants {
        static let titleLabelVerticalPadding: CGFloat = 10
        static let titleLabelHorizontalPadding: CGFloat = 12
    }

    func makeConstraints() {
        categoryTitleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(UIConstants.titleLabelVerticalPadding)
            make.horizontalEdges.equalToSuperview().inset(UIConstants.titleLabelHorizontalPadding)
        }
    }
}
