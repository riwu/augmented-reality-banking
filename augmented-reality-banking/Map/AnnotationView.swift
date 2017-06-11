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
        if subviews.isEmpty {

        let brand = Brands.getRand()
        let imageView = brand.imageView

        let titleLabel = UILabel(frame: CGRect(x: 50, y: 0, width: self.frame.size.width, height: 15))
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        titleLabel.textColor = UIColor.white

        let discountLabel = UILabel(frame: CGRect(x: 50, y: 15, width: self.frame.size.width, height: 10))
        discountLabel.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        discountLabel.textColor = UIColor.red
        discountLabel.font = UIFont.systemFont(ofSize: 10)

        let distanceLabel = UILabel(frame: CGRect(x: 50, y: 25, width: self.frame.size.width, height: 10))
        distanceLabel.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        distanceLabel.textColor = UIColor.green
        distanceLabel.font = UIFont.systemFont(ofSize: 10)

        if let annotation = annotation as? Place {
            titleLabel.text = brand.name
            let discount = 5 + arc4random_uniform(16)
            discountLabel.text = "\(discount)% discount"
            distanceLabel.text = String(format: "%.2f km", annotation.distanceFromUser / 1_000)
        }
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(discountLabel)
        self.addSubview(distanceLabel)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTouch(annotationView: self)
    }
}
