//
//  BookingConfirmationNewViewController.h
//  Stayhopper
//
//  Created by antony on 21/11/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookingConfirmationNewViewController : UIViewController
@property(nonatomic,retain)NSDictionary *selectedHotel;
@property(nonatomic,retain)NSDictionary *selectedDetails;
@property(nonatomic,retain)NSDictionary *selectedRooms;
@property(nonatomic,assign)BOOL isFullAMountPay;

@end

NS_ASSUME_NONNULL_END
