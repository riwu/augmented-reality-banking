import SpriteKit
import ARKit
import Vision
import CoreImage

class Scene: SKScene {

    private var lastUpdate: TimeInterval?
    var delegateVC: UIViewController?

    override func didMove(to view: SKView) {
        // Setup your scene here
        print("loaded scne")
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        guard let lastUpdate = lastUpdate else {
            self.lastUpdate = currentTime
            return
        }
        guard currentTime > lastUpdate + 1 else {
            return
        }
        findFaces()
        self.lastUpdate = currentTime
    }

    private func detectFace(_ request: VNRequest) {
        guard let results = request.results, !results.isEmpty else {
            return
        }
        self.view!.subviews.forEach { $0.removeFromSuperview() }
        for result in results {
            guard let faceObservation = result as? VNFaceObservation else {
                continue
            }
            drawBox(faceObservation.boundingBox)
        }
    }

    private func drawBox(_ box: CGRect) {
        let actualPoint = CGPoint(x: CGFloat(box.minX) * self.view!.frame.width,
                                  y: CGFloat(box.minY) * self.view!.frame.height)
        let faceBox = UIView(frame: CGRect(x: actualPoint.x, y: actualPoint.y,
                                           width: CGFloat(box.width) * self.view!.frame.width,
                                           height: CGFloat(box.height) * self.view!.frame.height))

        faceBox.layer.borderWidth = 3
        faceBox.layer.borderColor = UIColor.red.cgColor
        faceBox.backgroundColor = .clear
        self.view!.addSubview(faceBox)
        presentView(at: faceBox.frame)
    }

    private func createButton(xPos: CGFloat, yPos: CGFloat, title: String, action: Selector) -> UIButton {
        let button = UIButton(frame: CGRect(x: xPos, y: yPos, width: 90, height: 40))
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: action, for: .allEvents)
        view!.addSubview(button)
        return button
    }

    private func presentView(at rect: CGRect) {
        let transferButton = createButton(xPos: rect.minX, yPos: rect.maxY,
                                          title: "Transfer", action: #selector(transferAction))
        let requestButton = createButton(xPos: rect.minX, yPos: transferButton.frame.maxY,
                                         title: "Request", action: #selector(requestAction))
        _ = createButton(xPos: rect.minX, yPos: requestButton.frame.maxY,
                                     title: "Add info", action: #selector(addAction))
    }

    let accountName = "John Smith"

    @objc
    private func transferAction() {
        let transferController = UIAlertController(title: "Amount to transfer to \n" + accountName,
                                                   message: "DBS Savings 4033", preferredStyle: .alert)

        transferController.addTextField { textField in
            textField.text = "$"
            textField.delegate = self
        }

        transferController.addAction(UIAlertAction(title: "Confirm", style: .destructive))
        transferController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        delegateVC?.present(transferController, animated: true)
    }

    @objc
    private func requestAction() {

    }

    @objc
    private func addAction() {

    }

    private func find(_ personciImage: CIImage) {
        //let personciImage = CIImage(cvPixelBuffer: image)

        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)!
        guard let faces = faceDetector.features(in: personciImage) as? [CIFaceFeature] else {
            assertionFailure("Unable to convert faces")
            return
        }
        for face in faces {

            print("Found bounds are \(face.bounds)")

            let faceBox = UIView(frame: face.bounds)

            faceBox.layer.borderWidth = 3
            faceBox.layer.borderColor = UIColor.blue.cgColor
            faceBox.backgroundColor = .clear
            self.view!.addSubview(faceBox)
        }
    }

    var count = 0

    private func findFaces() {
        guard let sceneView = self.view as? ARSKView,
            let currentFrame = sceneView.session.currentFrame else {
                print("No scene frame")
                return
        }
        //        let fileImage = UIImage(named: "face\(count)")!
        //        count += 1
        //        var image = CIImage(image: fileImage)!
        //        let imageView = UIImageView(image: fileImage)

        var image = CIImage(cvPixelBuffer: currentFrame.capturedImage)
        let uiImageOld = UIImage(ciImage: image)
        let uiImage = resizeImage(image: uiImageOld, newWidth: self.view!.frame.width,
                                  newHeight: self.view!.frame.height)
        image = CIImage(image: uiImage)!

        //        let imageView = UIImageView(image: uiImageOld)
        //       // imageView.transform = imageView.transform.rotated(by: .pi / 2)
        //        imageView.frame = self.view!.frame
        //        //imageView.contentMode = .scaleAspectFit
        //        self.view!.addSubview(imageView)

        //find(image)
        //let imagehandler = VNImageRequestHandler(cvPixelBuffer: currentFrame.capturedImage)
        let imagehandler = VNImageRequestHandler(cgImage: uiImage.cgImage!)

        let detectFaceRequest = VNDetectFaceRectanglesRequest { (request, _) in
            self.detectFace(request)
        }
        //DispatchQueue.global(qos: .background).async {
        do {
            try imagehandler.perform([detectFaceRequest])
        } catch {
            print(error)
            return
        }
        //}
    }

    func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

extension Scene: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let amount = textField.text else {
            return false
        }
        delegateVC?.dismiss(animated: true)
        let confirmController = UIAlertController(title: amount + " successfully transferred to " + accountName,
                                                  message: nil, preferredStyle: .alert)
        confirmController.addAction(UIAlertAction(title: "Close", style: .default))
        delegateVC?.present(confirmController, animated: true)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return false
        }
        if string == "." {
            return text.components(separatedBy: ".").count == 1
        }
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
