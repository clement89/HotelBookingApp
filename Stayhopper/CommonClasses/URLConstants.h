

#ifndef URLConstants_h
#define URLConstants_h
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kColorRedThemeColor UIColorFromRGB(0xff4a4a)
#define kColorDarkBlueThemeColor UIColorFromRGB(0x1b2066)
#define  kColorTabNormalColor [UIColor grayColor]
#define kColorRedFadedColor UIColorFromRGB(0xffeded)
#define kColorCommonBG UIColorFromRGB(0xf0f0f0)
#define kColorProfilePages UIColorFromRGB(0xfafafa)
#define kColorHotelDetailsBG kColorProfilePages//UIColorFromRGB(0xE5E5E5)

#define kNotificationFilterItemsChanges     @"NotificationFilterItemsChanges"
#define favoriteListKey     @"favoriteListArray"

#define FontLight     @"ProximaNovaT-Thin"
#define FontRegular   @"ProximaNovaA-Regular"
#define FontMedium    @"ProximaNova-Semibold"//@"ProximaNovaACond-Semibold"
#define FontBold      @"ProximaNovaA-Bold"
#define FontSemiBold  @"ProximaNova-Semibold"

#define isWalkThroughDisplayed  @"isWalkThroughDisplayed"

#define DomainUrl @"https://api.stayhopper.com/"//CJC baseurl

//#define DomainUrl @"https://api-staging.stayhopper.com/"//CJC baseurl

//#define DomainUrl @"https://api.admin.sh.rahulv.com/"
#define kImageBaseUrl DomainUrl
#define baseURL [NSString stringWithFormat:@"%@api/",DomainUrl]//https://goo.gl/G5Pd2a



#ifndef NSExtension
//... app-only code here ...

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

#endif

//-------********************-----------------******************-----------------------------************************------------------//

#endif
