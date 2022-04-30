//
//  ApiCalling.h
//  QOM
//
//  Created by Vh Papaya Qatar on 21/02/18.
//  Copyright © 2018 Papaya Qatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <ifaddrs.h>
#include <arpa/inet.h>



@protocol APIPostingDelegate <NSObject>
-(void)getData:(NSDictionary*)data;
-(void)getError:(NSDictionary*)data;
-(void)getFavorite:(NSDictionary*)data;
-(void)getCommentResult:(NSDictionary*)data;

@end

@interface ApiCalling : NSObject
@property ( assign) id< APIPostingDelegate> delegate;
-(void)toServer:(NSString*)type:(NSString*)url:(NSString*)postString;
-(void)adsFilterAndSort:(NSString*)type:(NSString*)url:(NSString*)postString;
-(void)updateUserDetails:(NSString*)type:(NSString*)url:(NSString*)postString;
-(void)chatFunction:(NSString*)type:(NSString*)url:(NSString*)postString:(BOOL)indicator;
-(void)loginSocialMediaFunction:(NSString*)type:(NSString*)url:(NSString*)postString;
-(void)notificationData:(NSString*)type:(NSString*)url:(NSString*)postString;
-(void)sendDeviceTokenOrDelete:(NSString*)type:(NSString*)url:(NSString*)postString;
-(void)menuServer:(NSString*)type:(NSString*)url:(NSString*)postString;
-(void)otpVerification:(NSString*)type:(NSString*)url:(NSString*)postString;
-(void)notificationCount;

-(BOOL)checkFavorites:(NSString*)propertyID;


-(void)updateLasTSeen;
-(void)loadAds:(NSString*)type:(NSString*)url:(NSString*)postString;
@end


