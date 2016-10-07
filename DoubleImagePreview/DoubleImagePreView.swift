//
//  DoubleImagePreView.swift
//  DoubleImagePreview
//
//  Created by John N Blanchard on 10/4/16.
//  Copyright © 2016 John N Blanchard. All rights reserved.
//

import UIKit
import QuartzCore

enum DoubleImageState {
    case First
    case Second
    case Equal
}

class DoubleImagePreView: UIView {

    let separationSize: CGFloat = 1.0
    let circularSize  : CGFloat = 60.0

    var imageViewOne = UIImageView()
    let imageViewTwo = UIImageView()
    let parentViewOne = UIView()
    var parentViewTwo = UIView()
    let moveableView         = UIView()
    let circularMoveableView = UIView()
    var maskLayer = CALayer()


    var amountFirstImageIsOffScreen: CGFloat = 0


    func orientationChanged() {
        maskLayer.contents = imageViewTwo.image
        maskLayer.frame = CGRect(x: moveableView.frame.origin.x+moveableView.frame.size.width,
                                 y: frame.origin.y,
                                 width: frame.size.width - (moveableView.frame.origin.x+moveableView.frame.size.width),
                                 height: frame.size.height)

    }


    override func draw(_ rect: CGRect) {
        parentViewOne.frame = CGRect(x: rect.origin.x,
                                    y: rect.origin.y,
                                    width: (rect.size.width/2)-(separationSize/2),
                                    height: rect.size.height)

        parentViewTwo.frame = CGRect(x: (rect.size.width/2)+(separationSize/2),
                                    y: rect.origin.y,
                                    width: (rect.size.width/2)-(separationSize/2),
                                    height: rect.size.height)

        moveableView.frame = CGRect(x: (rect.size.width/2)-(separationSize/2),
                                    y: rect.origin.y,
                                    width: separationSize,
                                    height: rect.size.height)
        moveableView.backgroundColor = UIColor.clear

        circularMoveableView.frame = CGRect(x: (rect.size.width/2)-(circularSize/2),
                                            y: (rect.size.height/2)-(circularSize/2),
                                            width: circularSize,
                                            height: circularSize)
        circularMoveableView.layer.cornerRadius = circularSize/2
        circularMoveableView.backgroundColor = UIColor.black


        imageViewOne.translatesAutoresizingMaskIntoConstraints = false
        imageViewOne.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
        imageViewOne.contentMode = .scaleAspectFill

        imageViewTwo.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
        imageViewTwo.contentMode = .scaleAspectFill

        addSubview(parentViewOne)
        addSubview(parentViewTwo)
        addSubview(imageViewTwo)
        addSubview(imageViewOne)
        addSubview(moveableView)
        addSubview(circularMoveableView)

        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[v]|", options: .alignAllTop, metrics: nil, views: ["v": imageViewOne]))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v]|", options: .alignAllLeft, metrics: nil, views: ["v": imageViewOne]))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[v]|", options: .alignAllTop, metrics: nil, views: ["v": imageViewOne]))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v]|", options: .alignAllLeft, metrics: nil, views: ["v": imageViewOne]))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[v]|", options: .alignAllTop, metrics: nil, views: ["v": imageViewTwo]))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v]|", options: .alignAllLeft, metrics: nil, views: ["v": imageViewTwo]))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[v]|", options: .alignAllTop, metrics: nil, views: ["v": imageViewTwo]))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v]|", options: .alignAllLeft, metrics: nil, views: ["v": imageViewTwo]))

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChanged),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)

        maskLayer.frame = parentViewOne.frame
        maskLayer.backgroundColor = UIColor.gray.cgColor
        imageViewOne.layer.mask = maskLayer


        let pgr = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        circularMoveableView.addGestureRecognizer(pgr)
    }

    func setBothImages(imageOne: UIImage, imageTwo: UIImage) {
        imageViewTwo.image = imageTwo
        maskLayer.contents = imageViewTwo.image
        imageViewOne.image = imageOne

    }

    func firstImageViewIsProminant() -> DoubleImageState {
        if moveableView.frame.origin.x > (self.frame.size.width/2)-(separationSize/2) {
            return DoubleImageState.First
        } else if moveableView.frame.origin.x < (self.frame.size.width/2)-(separationSize/2) {
            return DoubleImageState.Second
        } else {
            return DoubleImageState.Equal
        }
    }

    func setPhotoSizeForCurrentMoveableViewState() {
        parentViewOne.frame = CGRect(x: 0, y: 0, width: moveableView.frame.origin.x, height: parentViewOne.frame.size.height)
        parentViewTwo.frame = CGRect(x: moveableView.frame.origin.x+separationSize, y: 0, width: self.frame.size.width-(moveableView.frame.origin.x+separationSize) , height: parentViewTwo.frame.size.height)
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        maskLayer.frame = CGRect(x: 0, y: 0, width: moveableView.frame.origin.x, height: frame.size.height)
        CATransaction.commit()
        switch firstImageViewIsProminant() {
        case .First:
            break
        case .Second:
            break
        default:
            break
        }
    }

    func handlePan(pgr: UIPanGestureRecognizer) {
        switch pgr.state {
        case .cancelled:
            break
        case .ended:
            break
        case .began:
            break
        default:
            moveableView.frame.origin.x         += pgr.translation(in: self).x
            circularMoveableView.frame.origin.x += pgr.translation(in: self).x
            if moveableView.frame.origin.x <= frame.origin.x {
                moveableView.frame.origin.x = frame.origin.x
                circularMoveableView.frame.origin.x = frame.origin.x - (circularSize/2)
            } else if moveableView.frame.origin.x + moveableView.frame.size.width >= frame.size.width {
                moveableView.frame.origin.x = frame.size.width - moveableView.frame.size.width
                circularMoveableView.frame.origin.x = frame.size.width - moveableView.frame.size.width - (circularSize/2)
            }
            setPhotoSizeForCurrentMoveableViewState()
            pgr.setTranslation(CGPoint.zero, in: self)
        }
    }

}
