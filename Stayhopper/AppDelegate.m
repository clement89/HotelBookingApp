//
//  AppDelegate.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 23/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "RequestUtil.h"
@import Firebase;
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "URLConstants.h"
#import "MBProgressHUD.h"

//#import "RaygunClient.h"
//#import <raygun4apple/raygun4apple_iOS.h>
@interface AppDelegate ()
{
    MBProgressHUD*hud;

}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*
   //Live Account
     //ANT changed

    RaygunClient *rgClient = [RaygunClient sharedInstanceWithApiKey:@"YPHgMvE9Q7HBLRmjXDYuiA"];
    [rgClient enableCrashReporting];
     [rgClient enableRealUserMonitoring];
   */
    
    
    //testAccount
   
//    RaygunClient *rgClient1 = [RaygunClient sharedInstanceWithApiKey:@"Oo5nQYuZVmPWUT4r8Njng"];
//    [rgClient1 enableCrashReporting];
//
//    [rgClient1 enableRealUserMonitoring];

   
    
    
    [FIRApp configure];
    
    
    //CJC added
    
    if ([UNUserNotificationCenter class] != nil) {
      // iOS 10 or later
      // For iOS 10 display notification (sent via APNS)
      [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
          UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
      [[UNUserNotificationCenter currentNotificationCenter]
          requestAuthorizationWithOptions:authOptions
          completionHandler:^(BOOL granted, NSError * _Nullable error) {
            // ...
          }];
    } else {
      // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
      UIUserNotificationType allNotificationTypes =
      (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
      UIUserNotificationSettings *settings =
      [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
      [application registerUserNotificationSettings:settings];
    }
    
    [FIRMessaging messaging].delegate = self;
    
    
    
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
//        UIUserNotificationType allNotificationTypes =
//        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings =
//        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    } else {
//        // iOS 10 or later
//#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//        // For iOS 10 display notification (sent via APNS)
//        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//        UNAuthorizationOptions authOptions =
//        UNAuthorizationOptionAlert
//        | UNAuthorizationOptionSound
//        | UNAuthorizationOptionBadge;
//        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        }];
//#endif
//    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    NSMutableDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:@"NO" forKey:@"pushClick"];
    [defaults setValue:@"" forKey:@"booking_ID"];
    [defaults setValue:@"" forKey:@"fromClickNoti"];
    [defaults synchronize];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:isWalkThroughDisplayed] == FALSE) {
     self.window.rootViewController =    [[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"WalkThroughViewController"];
    }
    if (notification)
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"YES" forKey:@"pushClick"];
        
        
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userID"])
        {
            
              if([notification objectForKey:@"notification_id"])
              {
                  RequestUtil *util1 = [[RequestUtil alloc]init];
                  NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
                  [reqData setObject:[notification objectForKey:@"notification_id"] forKey:@"id"];
                  
                  [util1 postRequest:reqData toUrl: [NSString stringWithFormat: @"notifications/read"] type:@"POST"];
                  if([UIApplication sharedApplication].applicationIconBadgeNumber>0)
                      [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber-1;
              }
            
        if([notification objectForKey:@"book_id"])
        {
            if([[[notification objectForKey:@"type"] uppercaseString] isEqualToString:@"REBOOKING"])
            {
            [defaults setValue:@"Rebooking" forKey:@"pushClick"];
            
            [defaults setValue:[notification objectForKey:@"book_id"] forKey:@"book_id"];
            
            [defaults setValue:[notification objectForKey:@"type"] forKey:@"type"];
                
                
                [defaults setValue:@"YES" forKey:@"fromClickNoti"];

          //  [[NSNotificationCenter defaultCenter] postNotificationName:@"pushClick" object:nil];
                
            }
            else
            {
               if( [notification objectForKey:@"type"])
               {
                   [defaults setValue:[notification objectForKey:@"type"] forKey:@"pushClick"];
                   
                   [defaults setValue:[notification objectForKey:@"book_id"] forKey:@"book_id"];
                   
                   [defaults setValue:[notification objectForKey:@"type"] forKey:@"type"];
                   [defaults setValue:@"YES" forKey:@"fromClickNoti"];

               }
            }

        }
        }
        
        [defaults synchronize];
        NSLog(@"%@",notification);
    }
    
    
//// AIzaSyC-QxLQ8EXN4Gr6bovi0zATyUdkRKDFH6M
    [GMSPlacesClient provideAPIKey:@"AIzaSyC-QxLQ8EXN4Gr6bovi0zATyUdkRKDFH6M"];
    [GMSServices provideAPIKey:@"AIzaSyC-QxLQ8EXN4Gr6bovi0zATyUdkRKDFH6M"];
    
//  AIzaSyDf4pG0suPTM9_c9j4cUiRoWCtkzJJzH2c
//    [GMSPlacesClient provideAPIKey:@"AIzaSyDf4pG0suPTM9_c9j4cUiRoWCtkzJJzH2c"];
//    [GMSServices provideAPIKey:@"AIzaSyDf4pG0suPTM9_c9j4cUiRoWCtkzJJzH2c"];
    

//  for (NSString *familyName in [UIFont familyNames]){
////        NSLog(@"Family name: %@", familyName);
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
////            NSLog(@"--Font name: %@", fontName);
//        }
//    }
    [UITabBarItem.appearance setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:FontBold size:10],NSForegroundColorAttributeName : [UIColor darkGrayColor]} forState:UIControlStateNormal];
   [UITabBarItem.appearance setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:FontBold size:10],NSForegroundColorAttributeName : kColorDarkBlueThemeColor} forState:UIControlStateSelected];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:FontBold size:22]}];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hudEnable)
                                                 name:@"hudEnable"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hudDisable)
                                                 name:@"hudDisable"
                                               object:nil];
    
    
    
//    [self importantCall];
    
    
    [self callForceUpdateAPI];

    
    // Override point for customization after application launch.
    return YES;
}


-(void)hudEnable{
    hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.label.text = @"";
    hud.mode=MBProgressHUDModeText;
    hud.progress=0;
    hud.margin = 0.f;
    hud.offset = CGPointMake(0,[UIScreen mainScreen].bounds.size.height);
    hud.removeFromSuperViewOnHide = YES;
}

-(void)hudDisable{
    [hud hideAnimated:YES afterDelay:0];
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];

    return handled;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    
    {
      
    }
   
    
}

-(void)callFavoritesAPI
{
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    [util postRequest:@{} withToken:TRUE toUrl:[NSString stringWithFormat: @"users/me"] type:@"GET"];

}
//CJC 15
-(void)callForceUpdateAPI
{
        RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    [util postRequestNew:@{} withToken:FALSE toUrl:[NSString stringWithFormat: @"admin/v2/app-version"] type:@"GET"];

}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Stayhopper"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}



- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    //[[FIRInstanceID instanceID]setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeUnknown];
    [FIRMessaging messaging].APNSToken = deviceToken;
     NSLog(@"keyyydata  %@",deviceToken);
    
    NSUserDefaults* defaults1 = [NSUserDefaults standardUserDefaults];
    [defaults1 setValue:deviceToken forKey:@"DEVICE_TOKEN"];
    [defaults1 synchronize];
    
    //cjc fcm
    [[FIRMessaging messaging] tokenWithCompletion:^(NSString *token, NSError *error) {
      if (error != nil) {
        NSLog(@"Error getting FCM registration token: %@", error);
      } else {
        NSLog(@"FCM registration token: %@", token);
          NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
          [defaults setValue:token forKey:@"DEVICE_TOKENFCM"];
          [defaults synchronize];
          
      }
    }];
    
//    [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result,
//                                                    NSError * _Nullable error) {
//    if (error != nil) {
//    NSLog(@"Error fetching remote instance ID: %@", error);
//    } else {
//    NSLog(@"Remote instance ID token: %@", result.token);
//        //NSLog(@"keyyy  %@",refreshedToken);
//        NSString *refreshedToken = result.token;
////           if(refreshedToken!=nil)
////           {
////
////
////           }
////           else
////           {
////               refreshedToken=@"";
////           }
//           NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//           [defaults setValue:refreshedToken forKey:@"DEVICE_TOKENFCM"];
//           [defaults synchronize];
//    }
//    }];
    
    
   // NSString *refreshedToken =  [[FIRInstanceID instanceID] token];
    
    
   
    
    
}


// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
  NSDictionary *userInfo = notification.request.content.userInfo;

  // With swizzling disabled you must let Messaging know about the message, for Analytics
  // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

  // ...

  // Print full message.
  NSLog(@"%@", userInfo);

  // Change this to your preferred presentation option
  completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
    
    
//  NSDictionary *userInfo = response.notification.request.content.userInfo;
//  if (userInfo[kGCMMessageIDKey]) {
//    NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
//  }

  // With swizzling disabled you must let Messaging know about the message, for Analytics
  // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

  // Print full message.
//  NSLog(@"%@", userInfo);

  completionHandler();
}




-(void)tokenGet
{
    
    //cjc fcm
    [[FIRMessaging messaging] tokenWithCompletion:^(NSString *token, NSError *error) {
      if (error != nil) {
        NSLog(@"Error getting FCM registration token: %@", error);
      } else {
        NSLog(@"FCM registration token: %@", token);
          NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
          [defaults setValue:token forKey:@"DEVICE_TOKENFCM"];
          [defaults synchronize];
          
      }
    }];
    
//    [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result,
//                                                        NSError * _Nullable error) {
//        if (error != nil) {
//        NSLog(@"Error fetching remote instance ID: %@", error);
//        } else {
//        NSLog(@"Remote instance ID token: %@", result.token);
//            //NSLog(@"keyyy  %@",refreshedToken);
//            NSString *refreshedToken = result.token;
//    //           if(refreshedToken!=nil)
//    //           {
//    //
//    //
//    //           }
//    //           else
//    //           {
//    //               refreshedToken=@"";
//    //           }
//               NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//               [defaults setValue:refreshedToken forKey:@"DEVICE_TOKENFCM"];
//               [defaults synchronize];
//        }
//        }];

    
  /*  NSString *refreshedToken =[[FIRInstanceID instanceID] token];
    //[FIRMessaging messaging].FCMToken;
    
    
    NSLog(@"keyyy  %@",refreshedToken);
    
    if(refreshedToken!=nil)
    {
        
        
    }
    else
    {
        refreshedToken=@"";
    }
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:refreshedToken forKey:@"DEVICE_TOKENFCM"];
    [defaults synchronize];*/
    
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    
    [[FIRMessaging messaging] tokenWithCompletion:^(NSString *token, NSError *error) {
      if (error != nil) {
        NSLog(@"Error getting FCM registration token: %@", error);
      } else {
        NSLog(@"FCM registration token: %@", token);

      }
    }];
    
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
    if(application.applicationState == UIApplicationStateActive) {
        
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.title = [[userInfo objectForKey:@"notification"] objectForKey:@"title"];
        content.body = [[userInfo objectForKey:@"notification"] objectForKey:@"body"];;
        content.sound = [UNNotificationSound defaultSound];
        content.userInfo=userInfo;
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:2 repeats:NO];
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@" "
                                                                              content:content trigger:trigger];
        
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"success");
            }
        }];
        
    } else if(application.applicationState == UIApplicationStateBackground){
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"YES" forKey:@"pushClick"];
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userID"])
        {
            if([userInfo objectForKey:@"book_id"])
            {
                if([[[userInfo objectForKey:@"type"] uppercaseString] isEqualToString:@"REBOOKING"])
                {
                    
                    [defaults setValue:@"Rebooking" forKey:@"pushClick"];
                    
                    [defaults setValue:[userInfo objectForKey:@"book_id"] forKey:@"book_id"];
                    
                    [defaults setValue:[userInfo objectForKey:@"type"] forKey:@"type"];
                    [defaults synchronize];
                    
                   // [[NSNotificationCenter defaultCenter] postNotificationName:@"pushClick" object:nil];
                }else
                {
                    if( [userInfo objectForKey:@"type"])
                    {
                        [defaults setValue:[userInfo objectForKey:@"type"] forKey:@"pushClick"];
                        
                        [defaults setValue:[userInfo objectForKey:@"book_id"] forKey:@"book_id"];
                        
                        [defaults setValue:[userInfo objectForKey:@"type"] forKey:@"type"];
                        [defaults synchronize];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushClick" object:nil];
                        
                    }
                }
            }
        }
        
      
        NSLog(@"2---%@",userInfo);
        
        
    } else if(application.applicationState == UIApplicationStateInactive){
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"YES" forKey:@"pushClick"];
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userID"])
        {
        if([userInfo objectForKey:@"book_id"])
        {
            if([[[userInfo objectForKey:@"type"] uppercaseString] isEqualToString:@"REBOOKING"])
            {

            [defaults setValue:@"Rebooking" forKey:@"pushClick"];

        [defaults setValue:[userInfo objectForKey:@"book_id"] forKey:@"book_id"];
        
        [defaults setValue:[userInfo objectForKey:@"type"] forKey:@"type"];
                [defaults synchronize];

              [[NSNotificationCenter defaultCenter] postNotificationName:@"pushClick" object:nil];
            }else
            {
                if( [userInfo objectForKey:@"type"])
                {
                    [defaults setValue:[userInfo objectForKey:@"type"] forKey:@"pushClick"];
                    
                    [defaults setValue:[userInfo objectForKey:@"book_id"] forKey:@"book_id"];
                    
                    [defaults setValue:[userInfo objectForKey:@"type"] forKey:@"type"];
                    [defaults synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushClick" object:nil];

                }
            }
        }
        }





        
        
        NSLog(@"2---%@",userInfo);
        
        
    }
}
-(void)webRawDataReceived:(NSDictionary *)rawData
{
    NSLog(@"cjc logging - %@",rawData);
    
    //CJC 15
    if([rawData objectForKey:@"data"])
    {
        NSDictionary *data = [rawData objectForKey:@"data"];
        
        if([data objectForKey:@"ios"]){
            NSDictionary *ios = [data objectForKey:@"ios"];
            BOOL forceUpdate = [[ios valueForKey:@"forceUpdate"] boolValue];
            if(forceUpdate){
                
                NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                NSString *newVersion = [ios valueForKey:@"appVersion"];
                
                if([currentVersion doubleValue] < [newVersion doubleValue]){
                    //need to show alert here..
                    

                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Version Available"
                                message:@"There is a newer version is available to download. Please update the app by visiting AppStore."
                                preferredStyle:UIAlertControllerStyleAlert]; // 1
                       
    
                        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"UPDATE"
                                style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

                        
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/sa/app/stayhopper/id1439901947?mt=8"] options:@{} completionHandler:nil];

                        
                        }]; // 3

                        [alert addAction:secondAction]; // 5

                        [self.window.rootViewController presentViewController:alert animated:YES completion:nil]; // 6
                    
                    
                }
                else{

                    
                }
                

            }
            

        }


    }
  
    if([rawData objectForKey:@"user"])
    {
        NSArray *favouriteskey =[rawData[@"user"] objectForKey:@"favourites"];
        if(!favouriteskey || [favouriteskey count]==0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[@[] mutableCopy] forKey:favoriteListKey];

        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:[favouriteskey mutableCopy] forKey:favoriteListKey];

            
         
        }
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
 }
 


@end
