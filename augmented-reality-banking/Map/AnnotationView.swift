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
    func didTouch(annotationView: AnnotationView)
}

class AnnotationView: ARAnnotationView {
    var delegate: AnnotationViewDelegate?

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        loadUI()
    }

    func loadUI() {
        guard subviews.isEmpty else {
            return
        }

        let brand = Brands.getRand()
        let imageView = brand.imageView

        let width = 100
        let labelX = Int(imageView.frame.width + 5)
        let titleLabel = UILabel(frame: CGRect(x: labelX, y: 0, width: width, height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        titleLabel.textColor = UIColor.white

        let discountLabel = UILabel(frame: CGRect(x: labelX, y: 20, width: width, height: 15))
        discountLabel.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        discountLabel.textColor = UIColor.red
        discountLabel.font = UIFont.systemFont(ofSize: 14)

        let levelLabel = UILabel(frame: CGRect(x: labelX, y: 35, width: width, height: 12))
        levelLabel.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        levelLabel.textColor = UIColor.yellow
        levelLabel.font = UIFont.systemFont(ofSize: 12)

        let distanceLabel = UILabel(frame: CGRect(x: labelX, y: 47, width: width, height: 12))
        distanceLabel.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        distanceLabel.textColor = UIColor.green
        distanceLabel.font = UIFont.systemFont(ofSize: 12)

        if let annotation = annotation as? Place {
            titleLabel.text = brand.name
            let discount = 5 + arc4random_uniform(16)
            discountLabel.text = "\(discount)% discount"
            levelLabel.text = "#0\(1 + arc4random_uniform(6))-" + String(format: "%02d", 1 + arc4random_uniform(99))
            distanceLabel.text = "\(Int(1 + arc4random_uniform(6)))m"
        }
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(levelLabel)
        self.addSubview(discountLabel)
        self.addSubview(distanceLabel)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTouch(annotationView: self)
    }
}
