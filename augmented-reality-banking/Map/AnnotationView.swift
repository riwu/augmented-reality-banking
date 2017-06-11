/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

protocol AnnotationViewDelegate {
    func didDragToBag(_ gestureRecognizer: UIGestureRecognizer, coupon: Coupon) -> Bool
    func didTap(annotationView: AnnotationView)
}

class AnnotationView: ARAnnotationView {
    var delegate: AnnotationViewDelegate?
    private var originalCenter: CGPoint!
    private var coupon: Coupon!

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        loadUI()
    }

    func loadUI() {
        guard subviews.isEmpty else {
            return
        }

        coupon = Coupon.getRand()
        let imageView = UIImageView(image: coupon.brand.image)
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)

        let width = 100
        let labelX = Int(imageView.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: labelX, y: 0, width: width, height: 30))
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        titleLabel.textColor = UIColor.white

        let levelLabel = UILabel(frame: CGRect(x: labelX, y: 30, width: width, height: 15))
        levelLabel.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        levelLabel.textColor = UIColor.yellow
        levelLabel.font = UIFont.systemFont(ofSize: 14)

        let distanceLabel = UILabel(frame: CGRect(x: labelX, y: 45, width: width, height: 15))
        distanceLabel.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        distanceLabel.textColor = UIColor.green
        distanceLabel.font = UIFont.systemFont(ofSize: 14)

        if let annotation = annotation as? Place {
            titleLabel.text = coupon.brand.name
            levelLabel.text = "#0\(1 + arc4random_uniform(6))-" + String(format: "%02d", 1 + arc4random_uniform(99))
            distanceLabel.text = "\(Int(annotation.distanceFromUser))m"
        }
        titleLabel.textAlignment = .center
        levelLabel.textAlignment = .center
        distanceLabel.textAlignment = .center

        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(levelLabel)
        self.addSubview(distanceLabel)

        originalCenter = center
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(sender:)))
        addGestureRecognizer(panGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapGesture)
    }

    @objc
    private func panAction(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            return
        case .changed:
            let translation = sender.translation(in: self.superview)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y + translation.y)
        default:
            guard let delegate = delegate else {
                assertionFailure("No delegate")
                return
            }
            if delegate.didDragToBag(sender, coupon: coupon) {
                center = CGPoint(x: 10_000_000, y: 10_000_000) // FIXME: gets re-rendered
            } else {
                center = originalCenter
            }
        }
    }

    @objc
    private func tapAction() {
        delegate?.didTap(annotationView: self)
    }
}
