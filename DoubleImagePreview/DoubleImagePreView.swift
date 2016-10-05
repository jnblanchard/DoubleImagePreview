//
//  DoubleImagePreView.swift
//  DoubleImagePreview
//
//  Created by John N Blanchard on 10/4/16.
//  Copyright © 2016 John N Blanchard. All rights reserved.
//

import UIKit

enum DoubleImageState {
    case First
    case Second
    case Equal
}

class DoubleImagePreView: UIView {

    let separationSize: CGFloat = 1.0
    let circularSize  : CGFloat = 60.0

    let imageViewOne = UIImageView()
    let imageViewTwo = UIImageView()
    let moveableView         = UIView()
    let circularMoveableView = UIView()


    func orientationChanged() {
        var imageOneWidth = (frame.size.width/2)-(separationSize/2)
        if UIDevice.current.orientation.isPortrait {
            guard imageViewOne.frame.size.height != frame.size.height else { return }
            imageOneWidth = imageViewOne.frame.size.width * 0.562
        } else {
            guard imageViewOne.frame.size.height != frame.size.height else { return }
            imageOneWidth = imageViewOne.frame.size.width * 1.778
        }
        imageViewOne.frame = CGRect(x: frame.origin.x,
                                    y: frame.origin.y,
                                    width: imageOneWidth,
                                    height: frame.size.height)

        imageViewTwo.frame = CGRect(x: imageOneWidth+separationSize,
                                    y: frame.origin.y,
                                    width: frame.size.width-(imageOneWidth+separationSize),
                                    height: frame.size.height)

        moveableView.frame = CGRect(x: imageViewTwo.frame.origin.x-separationSize,
                                    y: frame.origin.y,
                                    width: separationSize,
                                    height: frame.size.height)

        circularMoveableView.frame = CGRect(x: (imageViewTwo.frame.origin.x-(separationSize/2))-(circularSize/2),
                                            y: (frame.size.height/2)-(circularSize/2),
                                            width: circularSize,
                                            height: circularSize)
    }

    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.brown

        imageViewOne.frame = CGRect(x: rect.origin.x,
                                    y: rect.origin.y,
                                    width: (rect.size.width/2)-(separationSize/2),
                                    height: rect.size.height)
        imageViewOne.backgroundColor = UIColor.green

        imageViewTwo.frame = CGRect(x: (rect.size.width/2)+(separationSize/2),
                                    y: rect.origin.y,
                                    width: (rect.size.width/2)-(separationSize/2),
                                    height: rect.size.height)
        imageViewTwo.backgroundColor = UIColor.blue

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


        addSubview(imageViewOne)
        addSubview(imageViewTwo)
        addSubview(moveableView)
        addSubview(circularMoveableView)

        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(orientationChanged),
                                                         name: NSNotification.Name.UIDeviceOrientationDidChange,
                                                         object: nil)

        let pgr = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        circularMoveableView.addGestureRecognizer(pgr)
    }

    func setBothImages(imageOne: UIImage, imageTwo: UIImage) {
        imageViewOne.image = imageOne
        imageViewTwo.image = imageTwo
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
        imageViewOne.frame = CGRect(x: 0, y: 0, width: moveableView.frame.origin.x, height: imageViewOne.frame.size.height)
        imageViewTwo.frame = CGRect(x: moveableView.frame.origin.x+separationSize, y: 0, width: self.frame.size.width-(moveableView.frame.origin.x+separationSize) , height: imageViewTwo.frame.size.height)
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
            moveableView.frame.origin.x         += pgr.translation(in: self).x
            circularMoveableView.frame.origin.x += pgr.translation(in: self).x
            if moveableView.frame.origin.x <= self.frame.origin.x {
                moveableView.frame.origin.x = self.frame.origin.x
                circularMoveableView.frame.origin.x = self.frame.origin.x - (circularSize/2)
            } else if moveableView.frame.origin.x + moveableView.frame.size.width >= self.frame.size.width {
                moveableView.frame.origin.x = self.frame.size.width - moveableView.frame.size.width
                circularMoveableView.frame.origin.x = self.frame.size.width - moveableView.frame.size.width - (circularSize/2)
            }
            pgr.setTranslation(CGPoint.zero, in: self)
            setPhotoSizeForCurrentMoveableViewState()
        }
    }

}
