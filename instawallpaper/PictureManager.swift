//
//  PictureManager.swift
//  instawallpaper
//
//  Created by 佐藤健一朗 on 2015/06/06.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

import Foundation
import Photos

public class PictureManager {
    
    static private let ALBUM_NAME = "InstaWallpaper"

    enum PhotoAlbumUtilResult {
        case SUCCESS, ERROR, DENIED
    }
    
    class func requestAnthorization() {
        PHPhotoLibrary.requestAuthorization{ status in
            if status == .Authorized {
                println("authorized")
            }
        }
    }
    
    class func isAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized || PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.NotDetermined
    }
    
    class func saveImage(image: UIImage, completion: ((result: PhotoAlbumUtilResult) -> ())?) {
        
        if  !isAuthorized() {
            completion?(result: .DENIED)
            return
        }
        
        if let album = getAlbum() {
            doSave(album, image: image, completion: completion)
        } else {
            createAlbum({ (isSccess, error) in
                if (isSccess) {
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
    
    private class func doSave(album: PHAssetCollection, image: UIImage, completion: ((result: PhotoAlbumUtilResult) -> ())?) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let result = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            let assetPlaceholder = result.placeholderForCreatedAsset
            let albumChangeRequset = PHAssetCollectionChangeRequest(forAssetCollection: album)
            albumChangeRequset.addAssets([assetPlaceholder])
            }, completionHandler: { (isSuccess: Bool, error: NSError!) in
                if isSuccess {
                    completion?(result: .SUCCESS)
                } else{
                    println(error.localizedDescription)
                    completion?(result: .ERROR)
                }
        })
    }
    
    private class func createAlbum(completion: ((Bool, NSError!) -> Void)!) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(PictureManager.ALBUM_NAME)
            }, completionHandler: completion)
    }

}





