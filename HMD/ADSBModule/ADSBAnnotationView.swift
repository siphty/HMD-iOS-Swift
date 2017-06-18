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
    public var calloutView: ADSBAnnotationCalloutView?
    public var annotationImage: UIImage?
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
        annotationImageView = UIImageView(image: annotationImage)
        annotationImageView?.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
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
            let aCalloutView = ADSBAnnotationCalloutView(annotation: annotation as! MKShape)
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
