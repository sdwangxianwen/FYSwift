//
//  FYNetApi.swift
//  FYBaseSwiftDemo
//
//  Created by wang on 2019/9/10.
//  Copyright © 2019 wang. All rights reserved.
//

import UIKit
import Moya

enum FYAPI {
    case homeURL //首页列表
    case login(account:String,code:String)//登录
}

extension FYAPI :TargetType {
    var baseURL: URL {
        return URL(string: readHostApi() + BASE_API_URL)!
    }
    //各个请求的具体路径
    var path: String {
        switch self {
        case .homeURL:
            return "home"
        case .login:
            return "public/login"
        }
    }
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var params = NSMutableDictionary.init()
        switch self {
        case .homeURL:
            params.setValue(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString"), forKey: "version")
            break
        case .login(let account, let code):
            params.setValue(account, forKey: "mobile")
            params.setValue(code, forKey: "code")
            params.setValue("", forKey: "device_token")
        }
        params = setParm(parm: params)
        return .requestParameters(parameters: params as! [String : Any], encoding: URLEncoding  .default)
        
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
    
// MARK: - 默认的网络提示请求插件
let spinerPlugin = NetworkActivityPlugin { (state,target) in
    if state == .began {
        print("我开始请求")
        
        IDLoading.id_show(onView: getCurrentController().view)
        //        MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
    } else {
        print("我结束请求")
        IDLoading.id_dismiss()
        //        MBProgressHUD.hide(for: UIApplication.shared.keyWindow!, animated: true)
    }
}
// MARK: - 设置请求超时时间
let requestClosure = {(endpoint: Endpoint, done: @escaping MoyaProvider<FYAPI>.RequestResultClosure) in
    do {
        var request: URLRequest = try endpoint.urlRequest()
        request.timeoutInterval = 20    //设置请求超时时间
        done(.success(request))
    } catch  {
        print("错误了 \(error)")
        IDLoading.id_dismiss()
    }
}

// MARK: - 设置请求头部信息
var endpointClosure = { (target: FYAPI) -> Endpoint in
    let sessionId =  ""
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    var endpoint: Endpoint = Endpoint(
        url: url,
        sampleResponseClosure: {.networkResponse(200, target.sampleData)},
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
    )
    return endpoint.adding(newHTTPHeaderFields: [
        "Content-Type" : "application/x-www-form-urlencoded",
        "COOKIE" : "JSESSIONID=\(sessionId)",
        "Accept": "application/json;application/octet-stream;text/html,text/json;text/plain;text/javascript;text/xml;application/x-www-form-urlencoded;image/png;image/jpeg;image/jpg;image/gif;image/bmp;image/*"
        ])
}

func sortedDictionarybyLowercaseString(dict:NSDictionary) -> NSMutableArray {
    //将所有的key放进数组
    let allKeYArr = dict.allKeys as NSArray
    let arr = allKeYArr.sortedArray(using: #selector(NSNumber.compare(_:))) as! [String]
    //通过排列的key值获取value
    let valueArray = NSMutableArray.init()
    for sortsing : String in arr {
        let valueString =  dict.object(forKey: sortsing) as! String
        valueArray.add(sortsing + "=" + valueString + "&")
    }
    return valueArray
}

func setParm(parm : NSMutableDictionary) -> NSMutableDictionary {
    parm.setValue("5", forKey: "_source")
    var arrM  = NSMutableArray.init()
    arrM = sortedDictionarybyLowercaseString(dict: parm.copy() as! NSDictionary)
    var sign : String = ""
    for substring in arrM {
        sign =  sign + (substring as! String)
    }
    sign = String(sign.prefix(sign.count - 1))
    sign = sign + "dr4JG3NOFVJvgeoBEl9mOnYF"
    sign = sign.md5
    parm.setValue(sign, forKey: "sign")
    return parm
    
}

let provider = MoyaProvider<FYAPI>(endpointClosure: endpointClosure, requestClosure : requestClosure,plugins:[spinerPlugin])



class FYNetApi: NSObject {
    //成功的闭包
    typealias SuccessJSONClosure = (_ result:Response) -> Void
    static let shared = FYNetApi()
    func post(target:FYAPI, successClosure: @escaping SuccessJSONClosure)  {
        provider.request(target) { (result) in
            switch result {
            case let .success(response):
                let dataModel : FYBaseModel = try! response.map(FYBaseModel.self)
                print(try! response.mapString())
                if dataModel.rsp_code == "0000" {
                    successClosure(response)
                } else {
                    print(dataModel.rsp_msg)
                    IDToast.id_show(msg: dataModel.rsp_msg, onView: getCurrentController().view, success: nil, duration: 2, position: .middle)
                }
                
            case .failure(_):
                break
            }
        }
    }
}
