//
//  ViewController.swift
//  Article
//
//  Created by taichi on 2021/11/22.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    @IBAction func share(_ sender: Any) {
        var components = URLComponents()
        components.scheme = "https"
        //作成したドメイン
        components.host = "shareApp123.page.link"
        //任意のパス
        components.path = "/share"
        
        //アプリに戻ってきた時に受け取る値を保存
        let queryItem = URLQueryItem(name: "share", value: "Hello")
        components.queryItems = [queryItem]
        
        //リンクの作成
        guard let link = components.url else {return}
        let dynamicLinksDomainURIPrefix = "https://shareApp123.page.link"
        guard let shareLink = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix) else {return}
        
        if let bundleID = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
        }
        shareLink.iOSParameters?.appStoreID = "Your AppStoreID"
        
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Hello World"
        shareLink.socialMetaTagParameters?.descriptionText = "テストです"
        shareLink.socialMetaTagParameters?.imageURL = URL(string: "https://storage.googleapis.com/zenn-user-upload/topics/0b0064a451.jpeg")
        
        
        //ショートリンクの作成
        shareLink.shorten { url, warnings, err in
            if err != nil {
                return
            }else{
                if let warnings = warnings {
                    for warning in warnings {
                        print("\(warning)")
                    }
                }
                guard let url = url else {return}
                let activityItems: [Any] = [url,ShareActivitySource(url: url, title: "Hello World", image: self.logoImageView.image!)]
                let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: .none)
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    
    
}




import LinkPresentation

class ShareActivitySource:NSObject, UIActivityItemSource{

    private let linkMetadata:LPLinkMetadata

    init(url: URL,title:String,image:UIImage) {
        linkMetadata = LPLinkMetadata()
        super.init()

        // 完全な情報が取得できるまでプレビューに表示しておく仮の情報を入れておく
        linkMetadata.title = title
        linkMetadata.url = url
        linkMetadata.iconProvider = NSItemProvider(object: image)
    }


    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }


    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return linkMetadata
    }



}
