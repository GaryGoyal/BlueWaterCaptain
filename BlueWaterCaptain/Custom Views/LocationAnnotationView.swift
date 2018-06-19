//
//  LocationAnnotationView.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/30/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit
import MapKit
import FBAnnotationClusteringSwift

@objc protocol AnnotationViewDoubleTappedDelegate: class {
    func showTappedAnnotationViewDetails(_ selectedLocation : Location)
    func createNewLocation(_ currentAnnotation : FBAnnotation)
}

class LocationAnnotationView: MKAnnotationView, UIGestureRecognizerDelegate {

    var location : Location?
    var delegate : AnnotationViewDoubleTappedDelegate?
    var type : String!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(LocationAnnotationView.handleTap(_:)))
        tapGR.delegate = self as UIGestureRecognizerDelegate
        tapGR.numberOfTapsRequired = 2
        self.addGestureRecognizer(tapGR)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer){
        if(self.type != "New") {
            delegate?.showTappedAnnotationViewDetails(self.location!)
        }
        else {
            delegate?.createNewLocation(self.annotation! as! FBAnnotation)
        }
    }
 
    // MARK: - life cycle
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
