//
//  PictureManager.swift
//  instawallpaper
//
//  Created by Kenichiro Sato on 2015/06/06.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation
import Photos

public class PictureManager {
    
    static private let ALBUM_NAME = NSBundle.mainBundle().infoDictionary!["CFBundleName"]
        as? String ?? "Wallpapers from Instagram"

    class func isAuthorizationDenied() -> Bool {
        return (PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Denied)
    }
    
    class func isAuthorizationNotDetermined() -> Bool {
        return (PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.NotDetermined)
    }
    
    class func requestAuthorization(completion: (authorized :Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization({ status in
            if (status == PHAuthorizationStatus.Authorized) {
                completion(authorized:true)
            } else {
                completion(authorized: false)
            }
        })
    }
    
    //Before call this method, Photo Authorization must be requested
    class func saveImage(image: UIImage, completion: ((success: Bool) -> ())?) {
        if let album = getAlbum() {
            doSave(album, image: image, completion: completion)
        } else {
            createAlbum({ (success, error) in
                if (success) {
                    self.saveImage(image, completion: completion)
                }
            })
        }
    }
    
    private class func getAlbum() -> PHAssetCollection? {
        var assetAlbum: PHAssetCollection?
        let list = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.Album, subtype: PHAssetCollectionSubtype.Any, options: nil)
        list.enumerateObjectsUsingBlock{ (album, index, isStop) in
            let assetCollection = album as! PHAssetCollection
            if PictureManager.ALBUM_NAME == assetCollection.localizedTitle {
                assetAlbum = assetCollection
                isStop.memory = true
            }
        }
        return assetAlbum
    }
    
    private class func doSave(album: PHAssetCollection, image: UIImage, completion: ((success: Bool) -> ())?) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let result = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            if let assetPlaceholder = result.placeholderForCreatedAsset,
               let albumChangeRequset = PHAssetCollectionChangeRequest(forAssetCollection: album) {
                albumChangeRequset.addAssets([assetPlaceholder])
            }
            }, completionHandler: { (success, error) in
                completion?(success:success)
        })
    }
    
    private class func createAlbum(completion: ((Bool, NSError?) -> Void)?) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(PictureManager.ALBUM_NAME)
            }, completionHandler: completion)
    }

}





