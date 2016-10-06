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
        var imageOneWidth = (frame.size.width/2)-(separationSize/2)
        if UIDevice.current.orientation.isPortrait {
            guard parentViewOne.frame.size.height != frame.size.height else { return }
            imageOneWidth = parentViewOne.frame.size.width * 0.562
        } else {
            guard parentViewOne.frame.size.height != frame.size.height else { return }
            imageOneWidth = parentViewOne.frame.size.width * 1.778
        }



        parentViewOne.frame = CGRect(x: frame.origin.x,
                                    y: frame.origin.y,
                                    width: imageOneWidth,
                                    height: frame.size.height)

        parentViewTwo.frame = CGRect(x: imageOneWidth+separationSize,
                                    y: frame.origin.y,
                                    width: frame.size.width-(imageOneWidth+separationSize),
                                    height: frame.size.height)

        imageViewOne.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        imageViewTwo.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)

        moveableView.frame = CGRect(x: parentViewTwo.frame.origin.x-separationSize,
                                    y: frame.origin.y,
                                    width: separationSize,
                                    height: frame.size.height)

        circularMoveableView.frame = CGRect(x: (parentViewTwo.frame.origin.x-(separationSize/2))-(circularSize/2),
                                            y: (frame.size.height/2)-(circularSize/2),
                                            width: circularSize,
                                            height: circularSize)
        maskLayer.frame = parentViewOne.frame

    }


    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.brown

        parentViewOne.frame = CGRect(x: rect.origin.x,
                                    y: rect.origin.y,
                                    width: (rect.size.width/2)-(separationSize/2),
                                    height: rect.size.height)
        parentViewOne.backgroundColor = UIColor.green

        parentViewTwo.frame = CGRect(x: (rect.size.width/2)+(separationSize/2),
                                    y: rect.origin.y,
                                    width: (rect.size.width/2)-(separationSize/2),
                                    height: rect.size.height)
        parentViewTwo.backgroundColor = UIColor.blue

        moveableView.frame = CGRect(x: (rect.size.width/2)-(separationSize/2),
                                    y: rect.origin.y,
                                    width: separationSize,
                                    height: rect.size.height)
        moveableView.backgroundColor = UIColor.black

        circularMoveableView.frame = CGRect(x: (rect.size.width/2)-(circularSize/2),
                                            y: (rect.size.height/2)-(circularSize/2),
                                            width: circularSize,
                                            height: circularSize)
        circularMoveableView.layer.cornerRadius = circularSize/2
        circularMoveableView.backgroundColor = UIColor.black

        imageViewOne.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
        imageViewTwo.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)

        addSubview(parentViewOne)
        addSubview(parentViewTwo)
        addSubview(imageViewTwo)
        addSubview(imageViewOne)
        addSubview(moveableView)
        addSubview(circularMoveableView)

        maskLayer.frame = parentViewOne.frame
        maskLayer.backgroundColor = UIColor.gray.cgColor
        imageViewOne.layer.mask = maskLayer
//        imageViewOne.layer.masksToBounds = true

        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(orientationChanged),
                                                         name: NSNotification.Name.UIDeviceOrientationDidChange,
                                                         object: nil)

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
        default:
            DispatchQueue.main.async {
                self.moveableView.frame.origin.x         += pgr.translation(in: self).x
                self.circularMoveableView.frame.origin.x += pgr.translation(in: self).x
                if self.moveableView.frame.origin.x <= self.frame.origin.x {
                    self.moveableView.frame.origin.x = self.frame.origin.x
                    self.circularMoveableView.frame.origin.x = self.frame.origin.x - (self.circularSize/2)
                } else if self.moveableView.frame.origin.x + self.moveableView.frame.size.width >= self.frame.size.width {
                    self.moveableView.frame.origin.x = self.frame.size.width - self.moveableView.frame.size.width
                    self.circularMoveableView.frame.origin.x = self.frame.size.width - self.moveableView.frame.size.width - (self.circularSize/2)
                }
                self.maskLayer.frame = CGRect(x: 0, y: 0, width: self.moveableView.frame.origin.x, height: self.frame.size.height)
                self.setPhotoSizeForCurrentMoveableViewState()
                pgr.setTranslation(CGPoint.zero, in: self)
            }
        }
    }

}
