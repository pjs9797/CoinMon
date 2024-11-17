import UIKit
import SnapKit

class TooltipView: UIView {
    let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10*ConstantsManager.standardHeight
        view.backgroundColor = ColorManager.common_0
        return view
    }()
    let tooltipLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B6_13
        label.textColor = ColorManager.common_100
        label.textAlignment = .center
        return label
    }()
    let triangleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    init(message: String) {
        super.init(frame: .zero)
        
        tooltipLabel.text = LocalizationManager.shared.localizedString(forKey: message)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [backView,triangleView]
            .forEach{
                addSubview($0)
            }
        
        backView.addSubview(tooltipLabel)
        
        backView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        tooltipLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12*ConstantsManager.standardWidth)
            make.top.bottom.equalToSuperview().inset(8*ConstantsManager.standardHeight)
        }
        
        triangleView.snp.makeConstraints { make in
            make.width.equalTo(14*ConstantsManager.standardWidth)
            make.height.equalTo(8*ConstantsManager.standardHeight)
            make.centerX.equalTo(backView)
            make.top.equalTo(backView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        drawTriangle()
    }
    
    private func drawTriangle() {
        // 삼각형을 그릴 경로 정의
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))// 왼쪽 위 점
        path.addLine(to: CGPoint(x: 14*ConstantsManager.standardWidth, y: 0))// 오른쪽 위 점
        path.addLine(to: CGPoint(x: 7*ConstantsManager.standardWidth, y: 8*ConstantsManager.standardHeight))// 하단 중앙 점
        path.close()// 시작점으로 닫기

        // Layer에 경로 추가
        let triangleLayer = CAShapeLayer()
        triangleLayer.path = path.cgPath
        triangleLayer.fillColor = ColorManager.common_0?.cgColor
        triangleView.layer.addSublayer(triangleLayer)
    }
}
