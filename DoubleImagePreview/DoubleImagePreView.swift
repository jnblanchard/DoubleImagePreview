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

    let buttonSize: CGFloat = 40.0

    let imageViewOne = UIImageView()
    let imageViewTwo = UIImageView()
    let moveableView = UIView()

    override func draw(_ rect: CGRect) {
        imageViewOne.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: (rect.size.width/2)-(buttonSize/2), height: rect.size.height)
        imageViewOne.backgroundColor = UIColor.green
        imageViewTwo.frame = CGRect(x: (rect.size.width/2)+(buttonSize/2), y: rect.origin.y, width: (rect.size.width/2)-(buttonSize/2), height: rect.size.height)
        imageViewTwo.backgroundColor = UIColor.blue
        moveableView.frame = CGRect(x: (rect.size.width/2)-(buttonSize/2), y: rect.origin.y, width: buttonSize, height: rect.size.height)
        moveableView.backgroundColor = UIColor.black

        addSubview(imageViewOne)
        addSubview(imageViewTwo)
        addSubview(moveableView)

        let pgr = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        moveableView.addGestureRecognizer(pgr)
    }

    func setBothImages(imageOne: UIImage, imageTwo: UIImage) {
        imageViewOne.image = imageOne
        imageViewTwo.image = imageTwo
    }

    func firstImageViewIsProminant() -> DoubleImageState {
        if moveableView.frame.origin.x > (self.frame.size.width/2)-(buttonSize/2) {
            return DoubleImageState.First
        } else if moveableView.frame.origin.x < (self.frame.size.width/2)-(buttonSize/2) {
            return DoubleImageState.Second
        } else {
            return DoubleImageState.Equal
        }
    }

    func setPhotoSizeForCurrentMoveableViewState() {
        imageViewOne.frame = CGRect(x: 0, y: 0, width: moveableView.frame.origin.x, height: imageViewOne.frame.size.height)
        imageViewTwo.frame = CGRect(x: moveableView.frame.origin.x+buttonSize, y: 0, width: self.frame.size.width-(moveableView.frame.origin.x+buttonSize) , height: imageViewTwo.frame.size.height)
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
            moveableView.frame.origin.x += pgr.translation(in: self).x
            if moveableView.frame.origin.x <= self.frame.origin.x {
                moveableView.frame.origin.x = self.frame.origin.x
            } else if moveableView.frame.origin.x + moveableView.frame.size.width >= self.frame.size.width {
                moveableView.frame.origin.x = self.frame.size.width - moveableView.frame.size.width
            }
            pgr.setTranslation(CGPoint.zero, in: self)
            setPhotoSizeForCurrentMoveableViewState()
        }
    }

}
