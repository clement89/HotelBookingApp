//
//  TERMSWEBViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 21/11/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TERMSWEBViewController : UIViewController
{
    IBOutlet UIWebView* paymentWebView;

}
@property(nonatomic,retain)NSString* WEBSTRING;
@property(nonatomic,retain)NSString* titleString;
@property(nonatomic,assign) BOOL isForOffers;

@end

