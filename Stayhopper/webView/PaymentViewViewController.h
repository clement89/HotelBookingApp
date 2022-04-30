//
//  PaymentViewViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 23/10/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView* paymentWebView;
}
@property(nonatomic,retain)NSString* pauURL;
@end
