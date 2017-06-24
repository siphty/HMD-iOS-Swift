//
//  ADSBAnnotationView.swift
//  HMD
//
//  Created by Yi JIANG on 13/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class ADSBAnnotationView: MKAnnotationView {
    var calloutView: ADSBAnnotationCalloutView?
    var annotationImage: UIImage?{
        didSet{
            let angle = annotationImageView?.transform
            let center = annotationImageView?.center
            annotationImageView?.removeFromSuperview()
            annotationImageView = UIImageView(image: annotationImage!)
            annotationImageView?.alpha = 0.99
            annotationImageView?.transform = angle!
            annotationImageView?.center = center!
            let dotLayer : CALayer = CALayer()
            dotLayer.backgroundColor =  #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor
            dotLayer.borderColor =  #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor
            dotLayer.borderWidth = 2
            dotLayer.frame = CGRect(x: (annotationImage?.size.width )! / 2 - 1, y: (annotationImage?.size.height )! / 2 - 1, width: 2, height: 2)
//            dotLayer.frame = CGRect(x: 20, y: 20, width: 2, height: 2)
            annotationImageView?.layer.addSublayer(dotLayer)
            addSubview(annotationImageView!)
            annotationImageView?.sendSubview(toBack: self)
        }
    }
    var annotationImageView: UIView?
    
    
    
    override open var annotation: MKAnnotation? {
        willSet {
            calloutView?.removeFromSuperview()
        }
    }
    
    /// Animation duration in seconds.
    let animationDuration: TimeInterval = 0.25
    
    override public init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        if let customPin = annotation as? ADSBAnnotation {
            annotationImage = customPin.image
        }
        annotationImageView = UIImageView(image: annotationImage!)
        annotationImageView?.alpha = 0.99
//        self.layer.addSublayer(dotLayer)
        annotationImageView?.center = CGPoint(x: 0, y: 0)
        let dotLayer : CALayer = CALayer()
        dotLayer.backgroundColor =  #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor
        dotLayer.borderColor =  #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor
        dotLayer.borderWidth = 2
        dotLayer.frame = CGRect(x: (annotationImageView?.center.x )!  - 1, y: (annotationImageView?.center.y )!  - 1, width: 2, height: 2)
        annotationImageView?.layer.addSublayer(dotLayer)
        addSubview(annotationImageView!)
        image = nil
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Show and hide callout as needed
    // If the annotation is selected, show the callout; if unselected, remove it
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.calloutView?.removeFromSuperview()
            let aCalloutView = ADSBAnnotationCalloutView(annotation: annotation as? ADSBAnnotation)
//            aCalloutView.bounds = CGRect(x: 0, y: 0, width: 40, height: 200)
            aCalloutView.add(to: self)
            self.calloutView = aCalloutView
            if animated {
                self.calloutView?.alpha = 0
                UIView.animate(withDuration: animationDuration) {
                    self.calloutView?.alpha = 1
                }
            }
        } else {
            guard calloutView != nil else { return }
            if animated {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.calloutView?.alpha = 0
                }, completion: { finished in
                    self.calloutView?.removeFromSuperview()
                })
            } else {
                calloutView?.removeFromSuperview()
            }
        }
    }
}
