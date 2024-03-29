//
//  CancelOrderController.swift
//  Little
//
//  Created by Gabriel John on 14/04/2020.
//  Copyright © 2020 Craft Silicon Ltd. All rights reserved.
//

import UIKit

public class CancelOrderController: UIViewController {

    let am = SDKAllMethods()
    let hc = SDKHandleCalls()
    
    var deliveryID: String?
    var restaurantName: String?
    
    @IBOutlet weak var txtReason: UITextField!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        showAnimate()
    }
    
    func commonCallParams() -> String {
        
        let version = getAppVersion()
        
        let str = ",\"SessionID\":\"\(am.getMyUniqueID() ?? "")\",\"MobileNumber\":\"\(am.getSDKMobileNumber() ?? "")\",\"IMEI\":\"\(am.getIMEI() ?? "")\",\"CodeBase\":\"\(am.getMyCodeBase() ?? "")\",\"PackageName\":\"\(am.getSDKPackageName() ?? "")\",\"DeviceName\":\"\(getPhoneType())\",\"SOFTWAREVERSION\":\"\(version)\",\"RiderLL\":\"\(am.getCurrentLocation() ?? "0.0,0.0")\",\"LatLong\":\"\(am.getCurrentLocation() ?? "0.0,0.0")\",\"TripID\":\"\",\"City\":\"\(am.getCity() ?? "")\",\"RegisteredCountry\":\"\(am.getCountry() ?? "")\",\"Country\":\"\(am.getCountry() ?? "")\",\"UniqueID\":\"\(am.getMyUniqueID() ?? "")\",\"CarrierName\":\"\(getCarrierName() ?? "")\",\"UserAdditionalData\":\(am.getSDKAdditionalData())"
        
        return str
    }
    
    func cancelOrder() {
        
        self.view.createLoadingNormal()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadCancelOrder),name:NSNotification.Name(rawValue: "DELETEDELIVERYFoodDelivery"), object: nil)
        
        let dataToSend = "{\"FormID\":\"DELETEDELIVERY\"\(commonCallParams()),\"GetRestaurantMenu\":{\"DeliveryTripID\":\"\(deliveryID ?? "")\",\"Reason\":\"\(txtReason.text!)\"}}"
        
        hc.makeServerCall(sb: dataToSend, method: "DELETEDELIVERYFoodDelivery", switchnum: 0)
        
    }
    
    @objc func loadCancelOrder(_ notification: NSNotification) {
        
        self.view.removeAnimation()
        
        let data = notification.userInfo?["data"] as? Data
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DELETEDELIVERYFoodDelivery"), object: nil)
        
        if data != nil {
            do {
                let defaultMessage = try JSONDecoder().decode([DefaultMessage].self, from: data!)
                DispatchQueue.main.async(execute: {
                    if defaultMessage[safe: 0]?.status == "000" {
                        
                        let message = "\(defaultMessage[0].message ?? "Your \(self.restaurantName ?? "") order has been cancelled successfully.")"
                        
                        self.removeAnimate()
                        
                        self.showWarningAlert(title: "", message: message, dismissOnTap: false, showCancel: false) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        self.showAlerts(title: "", message: defaultMessage[safe: 0]?.message ?? "Error occurred cancelling your selected order.")
                        
                    }
                })
            } catch {
                DispatchQueue.main.async(execute: {
                    self.showAlerts(title: "", message: "Error occurred cancelling your selected order.")
                })
            }
        }
        
    }
    
    func showAnimate(){
        self.view.alpha = 0.25
        self.view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        CATransaction.begin()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.beginFromCurrentState, .curveLinear, .allowUserInteraction], animations: {
              self.view.transform = CGAffineTransform.identity
        }, completion: nil)
        UIView.animate(withDuration: 0.3 * 0.5, delay: 0, options: [.beginFromCurrentState, .curveLinear, .allowUserInteraction], animations: {
            self.view.alpha = 1
        }, completion: nil)
        CATransaction.commit()
    }

    @objc func removeAnimate() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform.identity
        }
        UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState, .curveEaseIn, .allowUserInteraction], animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
        UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState, .curveEaseIn, .allowUserInteraction], animations: {
            self.view.alpha = 0
        }, completion: {(finished: Bool) in if (finished) {
            self.view.removeFromSuperview()
        }
        })
        CATransaction.commit()
    }
    
    @IBAction func btnDismissPressed(_ sender: UIButton) {
        removeAnimate()
    }
    
    @IBAction func btnCancelOrderPressed(_ sender: UIButton) {
        endEditSDK()
        if txtReason.text == "" || txtReason.text?.count ?? 0 < 3 {
            showAlerts(title: "", message: "Kindly include a reason for order cancellation.")
        } else {
            cancelOrder()
        }
    }
}
