//
//  RequestUtil.h
//  KissMessenger
//
//  Created by Volmacht Business Solutions Mac Mini 2 on 03/02/13.
//  Copyright (c) 2013 Volmacht Business Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "Commons.h"
#import "iToast.h"
#import "URLConstants.h"
typedef enum {
    MasterData,
    Login,
    SyncNewItem,
    SyncCategory,
    SyncColor,
    SyncSubCategory,
    DownloadItemImage,
    DownloadItemOtherImage,
    Logout,
    DeleteItem,
    SyncApprovedItem,
    SyncDisApprovedItem,
    DeleteColor,
    DeleteTrip,
    DeleteSubCat,
    SyncCurrency,
    DeleteCurrency,
    LoadUserType,
    LoadUsers,
    SyncUserType,
    DeleteUserType,
    SyncUser,
    DeleteUser,
    LoadItemDetails
    
} serverTypeRequests;
//#define baseURL @"http://ec2-18-222-248-60.us-east-2.compute.amazonaws.com/api/"

//#define baseURL @"https://extranet.stayhopper.com/api/"

#define baseURLDuplicate @""
#define baseURLAPI3 @""
#define baseURLCommon @""
@protocol WebData;@interface RequestUtil : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    id<WebData> webDataDelegate;
}
@property(nonatomic,strong)NSMutableData *reqstData;
@property(nonatomic,strong)id<WebData> webDataDelegate;
@property(nonatomic)serverTypeRequests flag;
@property(nonatomic, strong)NSMutableDictionary *requestedParams;
@property(nonatomic, strong)NSMutableDictionary *context;
@property(nonatomic, strong)NSString *requestedString;
@property(nonatomic, strong)NSData *requestedData;
@property(nonatomic)float currentProgress;
@property(nonatomic)float totalBytesToSend;
@property(nonatomic)float currentProgressBytes;
@property(nonatomic)BOOL startTimer;
@property(nonatomic)BOOL isDownload;

-(void) sendRequestWithAuthToken:(NSMutableDictionary *) params toUrl:(NSString *)url;

-(void) sendRequest:(NSMutableDictionary *) params toUrl:(NSString *)url;
-(void) postRequest:(NSMutableDictionary *) params toUrl:(NSString *)url;
-(void) postString:(NSString *)poststring toUrl:(NSString *)url type:(NSString*)type;
-(void) postMultipartRequest:(NSMutableDictionary *) params toUrl:(NSString *)url;
-(void) postMultipartRequestWithToken:(NSMutableDictionary *) params toUrl:(NSString *)url;
-(void) postRequest:(NSMutableDictionary *) params withToken:(BOOL)shouldUseToken toUrl:(NSString *)url type:(NSString*)type;
-(void) postRequestNew:(NSMutableDictionary *) params withToken:(BOOL)shouldUseToken toUrl:(NSString *)url type:(NSString*)type;

-(void) postRequest:(NSMutableDictionary *) params toUrl:(NSString *)url type:(NSString*)type;
-(void) postRequestDuplicate:(NSMutableDictionary *) params toUrl:(NSString *)url type:(NSString*)type;

-(void) postRequestAPI3:(NSMutableDictionary *) params toUrl:(NSString *)url type:(NSString*)type;

-(void) postRequestCommon:(NSMutableDictionary *) params toUrl:(NSString *)url type:(NSString*)type;


-(void)StartConnectionWithTokenandImage:(NSString *)Url_string params:(NSMutableDictionary*)imageData viewController:(UIViewController*)viewController;
-(void)StartConnectionWithTokenandImageuploadfile:(NSString *)Url_string params:(NSMutableDictionary*)imageData viewController:(UIViewController*)viewController;
-(void)StartConnectionWithTokenandImageArray:(NSString *)Url_string params:(NSMutableDictionary*)imageData viewController:(UIViewController*)viewController;
-(void)StartConnectionWithTokenandImageAPI3:(NSString *)Url_string params:(NSMutableDictionary*)imageData viewController:(UIViewController*)viewController;
-(BOOL)checkFavorites:(NSString*)propertyID;

-(NSString*)checkRating:(NSNumber*)ratingID;
-(NSString*)convertTime;


-(void)callFavoriteApi;
-(void)callRatingApi;

-(void)addOrRemoveFavorites:(NSString*)propertyID userID:(NSString*)userID;

-(void)pushRegistration;

@end

@protocol WebData <NSObject>
@optional
-(void)requestUtil:(RequestUtil *)util webDataReceived:(NSMutableArray *)dataDictionary withFalg:(serverTypeRequests)flag;

-(void)requestUtil:(RequestUtil *)util error:(NSString *)response;
-(void)requestUtil:(RequestUtil *)util authenticationErrorWithFalg:(serverTypeRequests)flag;
-(void)timerResponseOfRequestUtil:(RequestUtil *)util;
-(void)webRawDataReceived:(NSDictionary *)rawData;
-(void)webRawDataReceivedWithError:(NSString *)errorMessage;

-(void)requestUtil:(RequestUtil *)util downloadDataReceived:(NSData *)rawData withFalg:(serverTypeRequests)flag;

@end
