//
//  Feed.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/03/17.
//

import MapKit
import RxSwift
import RxCocoa

struct Feed {
    let user: User
    let date: Date
    let postedImages: [String]
    let posetedText: String
    let likeCount: Int
    let reply: [Reply]
}

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    
    weak private(set) var locationManager: CLLocationManager?
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register {
            RxCLLocationManagerDelegateProxy(locationManager: $0)
        }
    }
}

extension Reactive where Base: CLLocationManager {
    var delegate: DelegateProxy<CLLocationManager,CLLocationManagerDelegate> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var didUpdateLocation: Observable<CLLocation> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map { $0[1] as! CLLocation }
    }
}
