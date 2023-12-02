//
//  VideoPreviewCollectionViewCell.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.05.2023.
//

import UIKit
import SnapKit
import GoogleAPIClientForREST_YouTube

final class VideoPreviewCollectionViewCell: BaseCollectionViewCell, ViewModelBindable {
    
    typealias ViewModel = VideoPreviewCellViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            updateUI()
            
            Task {
                try? await viewModel.getChannelInfo()
                loadChannelProfileImage()
            }
            
        }
    }
    
    @MainActor
    private var channelProfileImageLoadingTask: Task<Void, Never>?
    
    @MainActor
    private var thumbnailImageLoadingTask: Task<Void, Never>?
    
    //MARK: - Views
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = Resources.Colors.secondaryBackground
        return imageView
    }()
    
    private let channelProfileImageView: ProfileImageView = {
        let imageView = ProfileImageView(frame: .zero)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    private let bottomInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 2
        label.textColor = Resources.Colors.secondaryText
        return label
    }()
    
    private lazy var labelsVStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            bottomInfoLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var bottomHStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            channelProfileImageView,
            labelsVStack,
        ])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 14
        return stackView
    }()
    
    //MARK: - Overrided Methods
    
    override func setupSubviews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(bottomHStack)
    }
    
    override func makeSubviewsLayout() {
        makeThumbnailImageViewConstraints()
        makeChannelProfileImageViewConstraints()
        makeBottomHStackConstraints()
    }
    
    override func prepareForReuse() {
        thumbnailImageLoadingTask?.cancel()
        channelProfileImageLoadingTask?.cancel()
        super.prepareForReuse()
    }
}

//MARK: - Private methods

private extension VideoPreviewCollectionViewCell {
    func updateUI() {
        guard let viewModel else { return }
        titleLabel.text = viewModel.title
        bottomInfoLabel.text = viewModel.previewInfo
        
        loadThumbnailImage()
        loadChannelProfileImage()
    }
    
    func loadThumbnailImage() {
        thumbnailImageView.image = nil
        guard let imageURL = viewModel.thumbnailImageURL else { return }
        
        thumbnailImageLoadingTask = Task {
            await loadCellImage(for: thumbnailImageView, from: imageURL)
        }
    }
    
    func loadChannelProfileImage() {
        channelProfileImageView.image = nil
        guard let imageURL = viewModel.channelProfileThumbnailURL else { return }
        
        channelProfileImageLoadingTask = Task {
            await loadCellImage(for: channelProfileImageView, from: imageURL)
        }
    }
    
    @MainActor
    func loadCellImage(for imageView: UIImageView, from url: URL) async {
        do {
            try await imageView.loadImage(from: url)
        } catch {
            thumbnailImageView.image = nil
        }
    }
}

//MARK: - Layout

private extension VideoPreviewCollectionViewCell {
    enum UIConstants {
        static let bottomHStackTopPadding: CGFloat = 15
        static let bottomHStackBottomPadding: CGFloat = 5
        static let bottomHStackHorizontalPadding: CGFloat = 12
        static let channelProfileImageSize: CGFloat = 40
    }
    
    func makeThumbnailImageViewConstraints() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview(\.snp.width).multipliedBy(9.0 / 16.0)
        }
    }
    
    func makeChannelProfileImageViewConstraints() {
        channelProfileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(UIConstants.channelProfileImageSize)
        }
    }
    
    func makeBottomHStackConstraints() {
        bottomHStack.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(UIConstants.bottomHStackTopPadding)
            make.horizontalEdges.equalToSuperview().inset(UIConstants.bottomHStackHorizontalPadding)
            make.bottom.equalToSuperview().inset(UIConstants.bottomHStackBottomPadding)
        }
    }
}
