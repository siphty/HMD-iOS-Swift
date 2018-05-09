//
//  ADSBAnnotationCalloutView.swift
//  HMD
//
//  Created by Yi JIANG on 13/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class ADSBAnnotationCalloutView: ADSBCalloutView {
    
    
    public var callsignLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .green
        if #available(iOS 9.0, *) {
            label.font = .preferredFont(forTextStyle: .callout)
            label.font = label.font.withSize(12)
        } else {
            // Fallback on earlier versions
            label.font = .preferredFont(forTextStyle: .caption2)
            label.font = label.font.withSize(12)
        }
        
        return label
    }()
    
    public var icaoIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .green
        if #available(iOS 9.0, *) {
            label.font = .preferredFont(forTextStyle: .callout)
            label.font = label.font.withSize(8)
        } else {
            // Fallback on earlier versions
            label.font = .preferredFont(forTextStyle: .caption2)
            label.font = label.font.withSize(8)
        }
        
        return label
    }()
    public var speedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .green
        if #available(iOS 9.0, *) {
            label.font = .preferredFont(forTextStyle: .callout)
            label.font = label.font.withSize(10)
        } else {
            // Fallback on earlier versions
            label.font = .preferredFont(forTextStyle: .caption2)
            label.font = label.font.withSize(10)
        }
        
        return label
    }()
    public var altitudeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .green
        if #available(iOS 9.0, *) {
            label.font = .preferredFont(forTextStyle: .callout)
            label.font = label.font.withSize(10)
        } else {
            // Fallback on earlier versions
            label.font = .preferredFont(forTextStyle: .caption2)
            label.font = label.font.withSize(10)
        }
        
        return label
    }()
    
    private var loadingIndicator: NVActivityIndicatorView!
    
    init(annotation: ADSBAnnotation?) {
        super.init()
        configure()
        updateContents(for: annotation)
    }
//    class func instanceFromNib() -> ADSBAnnotationCalloutView {
//        return UINib(nibName: "ADSBAnnotationCalloutView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ADSBAnnotationCalloutView
//    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Should not call init(coder:)")
    }
    /// Update callout contents
    
    private func updateContents(for annotation: ADSBAnnotation?) {
        icaoIdLabel.text = String(annotation?.aircraft?.icaoId ?? "UFO")
        if  annotation?.aircraft?.isMilitary ?? false {
            callsignLabel.text = "Military Aircraft"
        } else {
            callsignLabel.text = String(annotation?.aircraft?.callsign ?? "------")
        }
        
        if annotation?.aircraft?.isOnGround ?? false {
            altitudeLabel.text = "A: On The Ground"
        } else {
            var InDecreaseString = ""
            if (annotation?.aircraft?.vertiSpeed)! > 0 {
                InDecreaseString = "▲"
            } else if (annotation?.aircraft?.vertiSpeed)! < 0 {
                InDecreaseString = "▼"
            } else {
                InDecreaseString = ""
            }
            altitudeLabel.text = "A: " + String(annotation?.aircraft?.presAltitude ?? 0.0) + " Feet" +  InDecreaseString
        }
        speedLabel.text = "S: " + String(annotation?.aircraft?.groundSpeed ?? 0.0) + " Knots"
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(callsignLabel)
        
        contentView.addSubview(icaoIdLabel)
        
        contentView.addSubview(speedLabel)
        
        contentView.addSubview(altitudeLabel)
        
        let views: [String: UIView] = [
            "callsignLabel": callsignLabel,
            "icaoIdLabel": icaoIdLabel,
            "speedLabel": speedLabel,
            "altitudeLabel": altitudeLabel
        ]
        
        let vflStrings = [
            "V:|[callsignLabel][icaoIdLabel][speedLabel][altitudeLabel]|",
            "H:|[callsignLabel]|",
            "H:|[icaoIdLabel]|",
            "H:|[speedLabel]|",
            "H:|[altitudeLabel]|"
        ]
        
        for vfl in vflStrings {
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vfl, metrics: nil, views: views))
        }
        
        loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0,
                                                                 y: 0,
                                                                 width: 20,
                                                                 height: 20),
                                                   type: .ballBeat,
                                                   color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1),
                                                   padding: 0)
        contentView.addSubview(loadingIndicator)
//        loadingIndicator.snp.makeConstraints { (make) in
//            make.center.equalTo(contentView)
//        }
        loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    override func didTouchUpInCallout(_ sender: Any) {
        print("didTouchUpInCallout")
    }
    
    
    func didTapDetailsButton(_ sender: UIButton) {
        print("didTapDetailsButton")
    }
    open func startLoading() {
        icaoIdLabel.isHidden = true
        speedLabel.isHidden = true
        altitudeLabel.isHidden = true
        callsignLabel.isHidden = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    open func stopLoading() {
        icaoIdLabel.isHidden = false
        speedLabel.isHidden = false
        altitudeLabel.isHidden = false
        callsignLabel.isHidden = false
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
}
