//
//  DurationSelectionViewController.h
//  Stayhopper
//
//  Created by antony on 11/08/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DurationSelectionViewController : UIViewController

@property(nonatomic, retain, nullable) NSString *formattedAddress;
@property(nonatomic, retain, nullable) NSString *placeName;
@property(nonatomic, retain, nullable) NSString *latitude;
@property(nonatomic, retain, nullable) NSString *longitude;
 @property (strong, nonatomic) NSString* selectionString;
@property(nonatomic, retain, nullable) NSString *cityIdString;
@property(nonatomic, assign) BOOL isHotelSelected;
@property(nonatomic, retain, nullable) NSDictionary *selectedHotel;

@end

NS_ASSUME_NONNULL_END
