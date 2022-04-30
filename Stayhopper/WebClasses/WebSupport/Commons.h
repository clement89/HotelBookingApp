//
//  Commons.h
//  cms
//
//  Created by Bryno Baby on 14/10/15.
//  Copyright (c) 2016 UGO Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface Commons : NSObject

+(UIImage *)cropImageData:(UIImage *)imageToCrop withWidth:(float)width withHeight:(float)height;
+ (BOOL) doWeHaveInternetConnection;
+(NSString*) getJSONStringFromNSDictionary:(NSDictionary *) dictionary withPrettyPrint:(BOOL) prettyPrint;
+(UIColor*)colorWithHexString:(NSString*)hex;
+ (NSString *)getUUID;
+(BOOL)isNull:(UITextField *)tf;
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
+(NSString *)stringFromDate:(NSDate *) date Format:(NSString *)format;
+(UIImage*)image:(UIImage*)image fromColor:(UIColor*)color;
+(void)removeLoaderFromViewController:(UIViewController*)vc;

+(void)showLoaderInViewController:(UIViewController*)vc;
+(float)getBottomSafeArea;
+(NSMutableDictionary *) dictionaryByReplacingNullsWithStrings:(id)dict;
+(void)paddingtoTextField:(UITextField*)textField;

+(float)getTopSafeArea;
+(NSString *)stringFromDate:(NSDate *) date Format:(NSString *)format;
+(NSDate *)getDateFromString:(NSString *) dateString Format:(NSString *)format;
+(BOOL) validateEmail:(NSString *)email;

+ (NSString *) trimWhitespacesAndGivingCorrectString:(NSString *)string;
+(BOOL)checkFavorites:(NSString*)propertyID;
+(void)addOrRomoveToFavselectedFavId:(NSString*)selectedFavId shouldAdd:(BOOL)shouldAdd;
+(void)showAlertWithMessage:(NSString*)message;

@end
