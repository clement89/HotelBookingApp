//
//  CountryListViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 14/11/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol countryDelegate <NSObject>

-(void)countryFunctionByString:(NSString*)countryString value:(NSString*)countryCode;

@end
@interface CountryListViewController : UIViewController
{
    NSDictionary *codes;
    NSMutableArray* countryList;
    NSUInteger selectedIndex;
    IBOutlet UITableView* listingtable;
    NSString* countryString;
    NSString*  codeString;
}
@property(nonatomic,retain)NSString* existingMobileNumber;

@property(nonatomic,assign)id<countryDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
