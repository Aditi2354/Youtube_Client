//
//  AuthViewController.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import UIKit
import SnapKit
import GoogleSignIn

final class AuthViewController: BaseViewController, ViewModelBindable {
    
    typealias ViewModel = AuthViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel!
    
    //MARK: - Views
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: Resources.Images.youTubeLogo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var signInButton = GoogleSignInButton(action: UIAction { [weak self] in
        self?.signInWithGoogle($0)
    })
    
    private var linesLayers: [CAShapeLayer] = []
    
    //MARK: - Overrided Methods
    
    override func setupSubviews() {
        view.addSubview(logoImageView)
        view.addSubview(signInButton)
    }
    
    override func makeSubviewsLayout() {
        makeConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBackgroundRedLines()
    }
}

//MARK: - Actions

private extension AuthViewController {
    func signInWithGoogle(_ action: UIAction) {
        Task {
            do {
                try await viewModel.signInWithGoogle(presentFrom: self)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - Private methods

private extension AuthViewController {
    func makeLinePath(startPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath {
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        linePath.close()
        return linePath
    }
    
    func makeRedLineShapeLayer(from startPoint: CGPoint, to endPoint: CGPoint) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = makeLinePath(startPoint: startPoint, endPoint: endPoint).cgPath
        shapeLayer.strokeColor = Resources.Colors.red.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.strokeEnd = 1
        return shapeLayer
    }
    
    func addBackgroundRedLines() {
        linesLayers.forEach { $0.removeFromSuperlayer() }

        let viewBounds = view.bounds
        
        let firstLine = makeRedLineShapeLayer(
            from: CGPoint(x: -10, y: viewBounds.height * 0.2),
            to: CGPoint(x: view.bounds.width, y: view.bounds.height * 0.1)
        )
        
        let secondLine = makeRedLineShapeLayer(
            from: CGPoint(x: -10, y: viewBounds.height * 0.15),
            to: CGPoint(x: view.bounds.width, y: view.bounds.height * 0.3)
        )
        
        let thirdLine = makeRedLineShapeLayer(
            from: CGPoint(x: -10, y: viewBounds.height * 0.8),
            to: CGPoint(x: view.bounds.width / 2, y: view.bounds.height)
        )
        
        let fourthLine = makeRedLineShapeLayer(
            from: CGPoint(x: -10, y: view.bounds.height),
            to: CGPoint(x: view.bounds.width, y: view.bounds.height * 0.9)
        )
        
        let lines = [firstLine, secondLine, thirdLine, fourthLine]
        applyLinesLayers(with: lines)
    }
    
    func applyLinesLayers(with lines: [CAShapeLayer]) {
        linesLayers = lines
        linesLayers.forEach(view.layer.addSublayer)
    }
}

//MARK: - Layout

private extension AuthViewController {
    enum UIConstants {
        static let logoCenterYOffset: CGFloat = -20
        static let logoWidthMultiplier: CGFloat = 0.4
        static let logoHeightMultiplier: CGFloat = 0.1
        
        static let signInButtonTopOffset: CGFloat = 10
        static let signInButtonWidthMultiplier = 0.7
    }
    
    func makeConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(UIConstants.logoCenterYOffset)
            make.width.equalToSuperview().multipliedBy(UIConstants.logoWidthMultiplier)
            make.height.equalToSuperview().multipliedBy(UIConstants.logoHeightMultiplier)
        }

        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(UIConstants.signInButtonTopOffset)
            make.width.equalToSuperview().multipliedBy(UIConstants.signInButtonWidthMultiplier)
        }
    }
}
