//
//  Reactive+Ext.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/10.
//

import UIKit
import RxSwift
import RxCocoa
import MobileCoreServices

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}

extension Reactive where Base: UIImagePickerController {
    var didFinishSelectImage: ControlEvent<UIImage?> {
        let selector = #selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:))
        let source = self.delegate.methodInvoked(selector)
            .map { arg -> UIImage? in
                print("Reactive custom Imagepicker")
                let picker = try castOrThrow(UIImagePickerController.self, arg[0])
                let info = try castOrThrow([UIImagePickerController.InfoKey : Any].self, arg[1])
                
                let mediaType = info[.mediaType] as! NSString
                guard UTTypeEqual(mediaType, kUTTypeImage) else { return nil }
                
                let originalImage = info[.originalImage] as! UIImage
                let editedImage = info[.editedImage] as? UIImage
                let selectedImage = editedImage ?? originalImage
                picker.dismiss(animated: true)
                
                return selectedImage
            }
        
        return ControlEvent(events: source)
    }
    
}


extension Reactive where Base: RegistrationController {
    var setProfileImageButton: Binder<UIImage?> {
        return Binder(base) { base, image in
            base.plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            base.plusPhotoButton.layer.cornerRadius = base.plusPhotoButton.frame.width / 2
            base.plusPhotoButton.layer.borderWidth = 3
            base.plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        }
    }
}
