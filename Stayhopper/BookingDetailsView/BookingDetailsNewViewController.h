//
//  BookingDetailsNewViewController.h
//  Stayhopper
//
//  Created by antony on 18/11/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookingDetailsNewViewController : UIViewController
@property(nonatomic,retain) NSString *bookingID;
@property(nonatomic,retain) NSString *propertyId;
@property(nonatomic,retain) NSString *ub_id;

@property(nonatomic,retain) NSString *hotelName;
@property(nonatomic,retain) NSString *hotelAddress;
@property(nonatomic,retain) NSString *guestCount;
@property(nonatomic,retain) NSString *timeString;
@property(nonatomic,retain) NSString *latitude;
@property(nonatomic,retain) NSString *longitude;
@property(nonatomic,retain) NSString *imageURL;
@property(nonatomic,assign) BOOL isPastBookingOrCancelled;
@property(nonatomic,assign) BOOL isForCompletion;
@property(nonatomic,retain) NSString *hoursString;

@end

NS_ASSUME_NONNULL_END
