//
//  Commons.m
//  cms
//
//  Created by Bryno Baby on 14/10/15.
//  Copyright (c) 2016 UGO Technologies. All rights reserved.
//

#import "Commons.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "URLConstants.h"

@implementation Commons

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withImage:(UIImage *)sourceImage
{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)cropImageData:(UIImage *)imageToCrop withWidth:(float)width withHeight:(float)height{
    
    UIImage *cropped = [self imageByScalingAndCroppingForSize:CGSizeMake(width, height) withImage:imageToCrop];
    //UIImage *cropped = [self imageByCropping:imgOriginal toRect:CGRectMake(0, 0, 59, 53)];
    return cropped;
}

// check for internet connection
+ (BOOL) doWeHaveInternetConnection{
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if(remoteHostStatus == NotReachable){
        
        return FALSE;
        
    }
    
    return TRUE;
    
}

+(NSString*) sh_jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (NSString *)getUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

+(BOOL)isNull:(UITextField *)tf{
    
    return nil == tf.text || tf.text.length == 0;
}

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, M_PI_2); // + 90 degrees
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, -M_PI_2); // - 90 degrees
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI); // - 180 degrees
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

+(NSString *)stringFromDate:(NSDate *) date Format:(NSString *)format{
    if(!date){
        return @"";
    }
    
    NSTimeZone* destinationTimeZone     = [NSTimeZone systemTimeZone];
    NSDateFormatter *dateformater       = [[NSDateFormatter alloc] init];
    // [dateformater                         setLocale:[NSLocale currentLocale]];
    // [dateformater                         setDateStyle:NSDateFormatterMediumStyle];//set current locale
    // [dateformater                         setTimeStyle:NSDateFormatterShortStyle];
    [dateformater setDateFormat:format];
    [dateformater  setTimeZone:destinationTimeZone];
    return  [dateformater stringFromDate:date];
}
+(UIImage*)image:(UIImage*)image fromColor:(UIColor*)color
{

    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
    CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
    
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return coloredImg;
    
}
+(void)removeLoaderFromViewController:(UIViewController*)vc
{
    [MBProgressHUD hideHUDForView:vc.view animated:YES];
}

+(void)showLoaderInViewController:(UIViewController*)vc
{
    
    [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    
}
+(float)getTopSafeArea
{
    float safeAreaTop = 0.0;
    if (@available(iOS 11.0, *)) {
        safeAreaTop = [[UIApplication sharedApplication] keyWindow].safeAreaInsets.top;
    } else {
        // Fallback on earlier versions
    }
    return safeAreaTop;
}

+(float)getBottomSafeArea
{
    float safeAreaBottom = 0.0;
    if (@available(iOS 11.0, *)) {
        safeAreaBottom = [[UIApplication sharedApplication] keyWindow].safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    return safeAreaBottom;
}
+(NSMutableArray *)arrayByReplacingNullsWithStrings:(id)sourceArray
{
    
    NSMutableArray *replaced = [[NSMutableArray alloc] initWithArray:sourceArray];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    int cnt=0;;
    for (id  key in sourceArray) {
        
        if ([key isKindOfClass:[NSDictionary class]])
        {
            [replaced replaceObjectAtIndex:[replaced indexOfObject:key] withObject:[self dictionaryByReplacingNullsWithStrings:key]];
            
            
        }
        
        else if (key == nul || [key isKindOfClass:[NSNull class]]) {
            
            [replaced replaceObjectAtIndex:cnt withObject:blank];
        }
        
        else if ([key isKindOfClass: [NSArray class]]) {
            
            [replaced replaceObjectAtIndex:[replaced indexOfObject:key] withObject:[self arrayByReplacingNullsWithStrings:key]];
        }
        
        cnt++;
    }
    
    
    
    return replaced;
}
+(NSMutableDictionary *) dictionaryByReplacingNullsWithStrings:(id)dict {
    
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: dict];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in dict) {
        const id object = [dict objectForKey: key];
        if (object == nul || [object isKindOfClass:[NSNull class]]) {
            [replaced setObject: blank forKey: key];
        }
        
        else if ([object isKindOfClass: [NSArray class]]) {
            
            [replaced setObject: [self arrayByReplacingNullsWithStrings:object] forKey: key];
            
            
            /* NSMutableArray *newArr=[NSMutableArray arrayWithArray:object];
             int cnt=0;
             for (id vl in newArr) {
             if([vl isKindOfClass:[NSString class]])
             {
             if (vl==nul|| [vl isEqualToString:@"<null>"]) {
             [newArr replaceObjectAtIndex:cnt++ withObject:blank];
             
             }
             
             }
             else if ([vl isKindOfClass: [NSDictionary class]]) {
             [replaced setObject: [self dictionaryByReplacingNullsWithStrings:vl] forKey: key];
             [newArr replaceObjectAtIndex:cnt++ withObject:replaced];
             }
             
             ;
             }*/
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [self dictionaryByReplacingNullsWithStrings:object] forKey: key];
        }
    }
    return replaced;
}
+(void)paddingtoTextField:(UITextField*)textField
{
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView *paddingView11 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];

    {
        textField.leftView = paddingView1;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
     {
        textField.rightView = paddingView11;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
}

+(NSDate *)getDateFromString:(NSString *) dateString Format:(NSString *)format{
    
    NSTimeZone* destinationTimeZone     = [NSTimeZone systemTimeZone];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter  setTimeZone:destinationTimeZone];
    
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:dateString];
    
    return  date;
}

+ (NSString *) trimWhitespacesAndGivingCorrectString:(NSString *)string
{
    NSString *trimmedString             = [string stringByTrimmingCharactersInSet:
                                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}
+(BOOL) validateEmail:(NSString *)email
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)checkFavorites:(NSString*)propertyID
{
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:favoriteListKey])
    {
        NSArray* listArray=[[NSUserDefaults standardUserDefaults]objectForKey:favoriteListKey];
        
        if ([listArray containsObject:propertyID]) {
            return TRUE;
        }
       
        
        
    }
    
    
    return NO;
}
+(void)addOrRomoveToFavselectedFavId:(NSString*)selectedFavId shouldAdd:(BOOL)shouldAdd
{
    NSArray *fav =[[NSUserDefaults standardUserDefaults] objectForKey:favoriteListKey];
    if (fav) {
        NSMutableArray *favListAr =[fav mutableCopy];
        if (shouldAdd) {
            if ([favListAr containsObject:selectedFavId]) {
            }
            else{
                [favListAr addObject:selectedFavId];
            }
            [[NSUserDefaults standardUserDefaults] setObject:favListAr forKey:favoriteListKey];

            
        }
        else{
            
            if ([favListAr containsObject:selectedFavId]) {
                [favListAr removeObject:selectedFavId];
                [[NSUserDefaults standardUserDefaults] setObject:favListAr forKey:favoriteListKey];
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
  
}
+(void)showAlertWithMessage:(NSString*)message
{
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Commons getAppName] message:message preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // continue your work

        // important to hide the window after work completed.
        // this also keeps a reference to the window until the action is invoked.
        topWindow.hidden = YES; // if you want to hide the topwindow then use this
    }]];

    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];

}
+(NSString*)getAppName
{
    NSString *appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    
    if (![appname isKindOfClass:[NSString class]]) {
        appname = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        if (![appname isKindOfClass:[NSString class]]) {
            appname = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        }
        if (![appname isKindOfClass:[NSString class]]) {
            appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        }
        if (![appname isKindOfClass:[NSString class]]) {
            appname = @"";
        }
        
    }
    return appname;
}
@end
