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

  let separationSize: CGFloat = 6.0
  let circularSize  : CGFloat = 60.0

  var imageViewOne = UIImageView()
  let imageViewTwo = UIImageView()
  let moveableView         = UIView()
  let circularMoveableView = UIView()
  var maskLayer = CALayer()
  var leadingConstraint = NSLayoutConstraint()

  var amountThroughFrame:CGFloat = 0.5
  var previousOrientation: UIDeviceOrientation!

  func orientationChanged() {
    guard previousOrientation.isPortrait != UIDevice.current.orientation.isPortrait else { return }
    previousOrientation = UIDevice.current.orientation
    leadingConstraint.constant = UIScreen.main.bounds.height * amountThroughFrame
    layoutIfNeeded()
    setPhotoSizeForCurrentMoveableViewState()
  }


  override func draw(_ rect: CGRect) {

    previousOrientation = UIDevice.current.orientation

    moveableView.translatesAutoresizingMaskIntoConstraints = false
    moveableView.frame = CGRect(x: (rect.size.width/2)-(separationSize/2),
                                y: rect.origin.y,
                                width: separationSize,
                                height: rect.size.height)
    moveableView.backgroundColor = UIColor.clear

    circularMoveableView.translatesAutoresizingMaskIntoConstraints = false
    circularMoveableView.frame = CGRect(x: (rect.size.width/2)-(circularSize/2),
                                        y: (rect.size.height/2)-(circularSize/2),
                                        width: circularSize,
                                        height: circularSize)
    circularMoveableView.layer.cornerRadius = circularSize/2
    circularMoveableView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)


    imageViewOne.translatesAutoresizingMaskIntoConstraints = false
    imageViewOne.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
    imageViewOne.contentMode = .scaleAspectFill

    imageViewTwo.translatesAutoresizingMaskIntoConstraints = false
    imageViewTwo.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
    imageViewTwo.contentMode = .scaleAspectFill

    addSubview(imageViewTwo)
    addSubview(imageViewOne)
    addSubview(moveableView)
    addSubview(circularMoveableView)

    self.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[v(==x)]|", options: .alignAllTop, metrics: nil, views: ["v": imageViewOne, "x": imageViewTwo]))
    self.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[v(==x)]|", options: .alignAllLeft, metrics: nil, views: ["v": imageViewOne, "x": imageViewTwo]))
    self.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[v(==x)]|", options: .alignAllTop, metrics: nil, views: ["v": imageViewOne, "x": imageViewTwo]))
    self.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[v(==x)]|", options: .alignAllLeft, metrics: nil, views: ["v": imageViewOne, "x": imageViewTwo]))

    let topLineConstraint = NSLayoutConstraint(item: moveableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
    let widthLineConstraint = NSLayoutConstraint(item: moveableView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: separationSize)
    let heightLineConstraint = NSLayoutConstraint(item: moveableView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
    leadingConstraint = NSLayoutConstraint(item: moveableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: frame.midX-(separationSize/2))
    addConstraints([topLineConstraint, widthLineConstraint, heightLineConstraint, leadingConstraint])
    lastWidth = frame.size.width

    let horizontalConstraint = circularMoveableView.centerXAnchor.constraint(equalTo: moveableView.centerXAnchor)
    let verticalConstraint = circularMoveableView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    let widthConstraint = circularMoveableView.widthAnchor.constraint(equalToConstant: circularSize)
    let heightConstraint = circularMoveableView.heightAnchor.constraint(equalToConstant: circularSize)
    NSLayoutConstraint.activate([horizontalConstraint,verticalConstraint,widthConstraint,heightConstraint])

    maskLayer.frame = CGRect(x: moveableView.frame.origin.x+moveableView.frame.size.width,
                             y: frame.origin.y,
                             width: frame.size.width - (moveableView.frame.origin.x+moveableView.frame.size.width),
                             height: frame.size.height)
    maskLayer.backgroundColor = UIColor.gray.cgColor
    imageViewOne.layer.mask = maskLayer

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(orientationChanged),
                                           name: NSNotification.Name.UIDeviceOrientationDidChange,
                                           object: nil)

    let pgr = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    addGestureRecognizer(pgr)


  }

  func set(originalImage: UIImage, retouchedImage: UIImage) {
    imageViewTwo.image = retouchedImage
    maskLayer.contents = imageViewTwo.image
    imageViewOne.image = originalImage
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
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
    maskLayer.frame = CGRect(x: moveableView.frame.origin.x+(separationSize/2), y: 0, width: frame.size.width-(moveableView.frame.origin.x+(separationSize/2)), height: frame.size.height)
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
      leadingConstraint.constant    += pgr.translation(in: self).x
      if leadingConstraint.constant <= frame.origin.x {
        leadingConstraint.constant = -moveableView.frame.size.width
      } else if leadingConstraint.constant + (moveableView.frame.size.width) >= frame.size.width {
        leadingConstraint.constant = frame.size.width
      }
      amountThroughFrame = leadingConstraint.constant/frame.size.width
      setPhotoSizeForCurrentMoveableViewState()
      pgr.setTranslation(CGPoint.zero, in: self)
    }
  }

}
