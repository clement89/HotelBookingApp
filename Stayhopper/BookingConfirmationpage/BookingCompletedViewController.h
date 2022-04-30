//
//  BookingCompletedViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 28/10/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookingCompletedViewController : UIViewController
{
    IBOutlet UILabel* propertyNameLBL;
    IBOutlet UILabel* dateLBL;
    IBOutlet UILabel* checkintimeLBL;
    IBOutlet UILabel* personsLBL;
    IBOutlet UILabel* hourLBL;
    IBOutlet UILabel* totalLBL;
    IBOutlet UILabel* paidLBL;
    IBOutlet UILabel* balanceLBL;
    IBOutlet UILabel* bookingIDLBL;

    IBOutlet UIButton* contineButton;
}
@property(nonatomic,retain)NSMutableDictionary* dataDIC;
@property(nonatomic,retain)NSString* rooCount;
@property(nonatomic,retain)NSString* proName;;
@property(nonatomic,retain)NSString* totalPrice;
@property(nonatomic,retain)NSString* paid;
@property(nonatomic,retain)NSString* balance;
@property(nonatomic,retain)NSString* bookingIDVAl;




@end

NS_ASSUME_NONNULL_END
