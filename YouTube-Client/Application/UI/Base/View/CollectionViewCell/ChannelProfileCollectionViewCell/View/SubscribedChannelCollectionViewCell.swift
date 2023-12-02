//
//  SubscribedChannelCollectionViewCell.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 16.06.2023.
//

import UIKit
import SnapKit

final class SubscribedChannelCollectionViewCell: BaseCollectionViewCell, ViewModelBindable {
    
    //MARK: Properties
    
    var viewModel: ChannelProfileCVCellViewModel! {
        didSet {
            loadProfileImage()
            channelTitleLabel.text = viewModel.channelTitle
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            makeHighlightAnimation()
        }
    }
    
    //MARK: - Views
    
    private let channelProfileImageView = ProfileImageView()
    
    private let channelTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Resources.Colors.secondaryText
        label.font = Resources.Fonts.helveticaNeue(size: 14, style: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var mainVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            channelProfileImageView,
            channelTitleLabel
        ])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    private var profileImageLoadTask: Task<Void, Never>?
    
    //MARK: - Overrided Methods
    
    override func prepareForReuse() {
        profileImageLoadTask?.cancel()
        channelProfileImageView.image = nil
        super.prepareForReuse()
    }
    
    override func setupSubviews() {
        contentView.addSubview(mainVStack)
    }
    
    override func makeSubviewsLayout() {
        mainVStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(5)
        }
        
        channelProfileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
    }
}

//MARK: - Private methods

private extension SubscribedChannelCollectionViewCell {
    func loadProfileImage() {
        guard let imageURL = viewModel.channelProfileImageURL else {
            channelProfileImageView.image = nil
            return
        }
        
        profileImageLoadTask = Task {
            do {
                try await channelProfileImageView.loadImage(from: imageURL)
            } catch {
                channelProfileImageView.image = nil
            }
        }
    }
    
    func makeHighlightAnimation() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self else { return }
            contentView.backgroundColor = isHighlighted ? Resources.Colors.secondaryBackground : Resources.Colors.background
        }
    }
}
