//
//  RequestUtil.m
//  KissMessenger
//
//  Created by Volmacht Business Solutions Mac Mini 2 on 03/02/13.
//  Copyright (c) 2013 Volmacht Business Solutions. All rights reserved.
//

#import "RequestUtil.h"
#import "FileUpload.h"
#import "AppDelegate.h"
//#import <raygun4apple/raygun4apple_iOS.h>
//#import "RaygunUserInformation.h"
//#import "RaygunClient.h"


@implementation RequestUtil

@synthesize reqstData;
@synthesize webDataDelegate;
@synthesize flag;
@synthesize currentProgress;
@synthesize totalBytesToSend;
@synthesize requestedParams;
@synthesize requestedData;
@synthesize requestedString;
@synthesize startTimer;
@synthesize currentProgressBytes;
@synthesize context;
@synthesize isDownload;

#define kStartTag   @"--%@\r\n"
#define kEndTag     @"\r\n"
#define kContent    @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define kBoundary   @"---------------------------14737809831466499882746641449"



-(void) sendRequest:(NSMutableDictionary *) params toUrl:(NSString *)url{
    
    self.requestedParams = params;
    
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@"No Connection"];
        
        return;
    }
    
    NSMutableString *strReqString = [[NSMutableString alloc] initWithString:@""];;
    for (NSString *key in params) {
        
        NSString *value = [params objectForKey:key];
        [strReqString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
    
    
    NSString *toRequest = [[strReqString substringToIndex:[strReqString length] - 1]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    url = [NSString stringWithFormat:@"%@?%@", url, toRequest];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:url]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:120];
    
    
    
    [request setHTTPMethod:@"POST"];
    
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    [NSURLConnection connectionWithRequest:request  delegate:self];
    
    self.reqstData=[[NSMutableData alloc]init];

    
    
}

-(void) sendRequestWithAuthToken:(NSMutableDictionary *) params toUrl:(NSString *)url{
    
    self.requestedParams = params;
    
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@"No Connection"];
        
        return;
    }
    
    self.requestedParams = params;
    
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@"NO CONNECTION"];
        
       return;
    }
    
    NSMutableString *strReqString = [[NSMutableString alloc] initWithString:@""];;
    for (NSString *key in params) {
        
        NSString *value = [params objectForKey:key];
        [strReqString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
    NSString *toRequest=@"";
    if(strReqString.length==0)
    {
        
    }
    else
    {
toRequest = [[strReqString substringToIndex:[strReqString length] - 1]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,url]]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:120];
    
    [request setHTTPMethod:@"POST"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];

    NSString *authValue = [NSString stringWithFormat: @"Bearer %@",token];

    // Part Important
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];


    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(toRequest.length!=0){
     [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[toRequest length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[toRequest dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [NSURLConnection connectionWithRequest:request  delegate:self];
    
    self.reqstData=[[NSMutableData alloc]init];

    
    
    
    
    return;
 /*
//    NSMutableString *strReqString = [[NSMutableString alloc] initWithString:@""];;
//    for (NSString *key in params) {
//
//        NSString *value = [params objectForKey:key];
//        [strReqString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
//    }
    
    
//    NSString *toRequest = [[strReqString substringToIndex:[strReqString length] - 1]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//
    url = [NSString stringWithFormat:@"%@%@",baseURL,url];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:url]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:120];
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *authValue = [NSString stringWithFormat: @"Bearer %@",token];

    // Part Important
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    
    [request setHTTPMethod:@"POST"];
    
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    [NSURLConnection connectionWithRequest:request  delegate:self];
    
    self.reqstData=[[NSMutableData alloc]init];

    */
    
}

-(void) postMultipartRequestWithToken:(NSMutableDictionary *) params toUrl:(NSString *)url{
    
    self.requestedParams = params;
    
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
       // [webDataDelegate requestUtil:self error:@"NOCONNECTION" withFalg:self.flag];
        
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",baseURL,url]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:59*60.0];
     NSString* FileParamConstant = @"image";
    NSMutableData* body = [NSMutableData data];
    
    NSString* boundary = @"----boundary";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
   // [request setValue:@"multipart/form-data;" forHTTPHeaderField:@"enctype"];
  //  NSData *boundaryData = [[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
     NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];

    for (NSString *param in params) {
        if(![param isEqualToString:@"image"]){
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    // NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
    if (params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[params valueForKey:@"image"]];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];

    NSString *authValue = [NSString stringWithFormat: @"Bearer %@",token];

    // Part Important
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];


    
    
    [NSURLConnection connectionWithRequest:request  delegate:self];
    
    self.reqstData=[[NSMutableData alloc]init];
    
    
    
}

-(void) postMultipartRequest:(NSMutableDictionary *) params toUrl:(NSString *)url{
    
    self.requestedParams = params;
    
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
       // [webDataDelegate requestUtil:self error:@"NOCONNECTION" withFalg:self.flag];
        
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",baseURL,url]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:59*60.0];
     NSString* FileParamConstant = @"image";
    NSMutableData* body = [NSMutableData data];
    
    NSString* boundary = @"----boundary";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
   // [request setValue:@"multipart/form-data;" forHTTPHeaderField:@"enctype"];
  //  NSData *boundaryData = [[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
     NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];

    for (NSString *param in params) {
        if(![param isEqualToString:@"image"]){
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    // NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
    if (params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[params valueForKey:@"image"]];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection connectionWithRequest:request  delegate:self];
    
    self.reqstData=[[NSMutableData alloc]init];
    
    
    
}
-(void)StartConnectionWithTokenandImage:(NSString *)Url_string params:(NSMutableDictionary*)imageData viewController:(UIViewController*)viewController{
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@""];
        
        return;
    }
    NSString *BoundaryConstant = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    
  //  Basestring=baseURL;
    NSString* FileParamConstant = @"profile_pic";
    
   NSString* api=[NSString stringWithFormat:@"%@%@",baseURL,Url_string];
    NSMutableData *body = [NSMutableData data];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:api]];
    [request setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];

    for (NSString *param in imageData) {
        if(![param isEqualToString:@"image"]){
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [imageData objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    // NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
    
     if ([imageData objectForKey:@"profile_pic"])
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[imageData valueForKey:@"image"]];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
   
    
    [request setHTTPBody:body];

    
    
    ///// cookies
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
//    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
//    
//    [request setAllHTTPHeaderFields:headers];
    
    
    //////cookies
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        
        NSError *localError = nil;
        NSDictionary *parsedObject;
        if (!parsedObject) {
            parsedObject =[[NSDictionary alloc]init];
        }
        
        parsedObject = [NSJSONSerialization JSONObjectWithData:data  options:0 error:&localError];
        
        if ([parsedObject isKindOfClass:[NSDictionary class]] && parsedObject !=nil  ) {
            
            ////
            
            if (([[parsedObject objectForKey:@"status"] integerValue]==0 || ![parsedObject objectForKey:@"status"])) {
         
                [webDataDelegate webRawDataReceivedWithError:[parsedObject objectForKey:@"message"]  ];
            }
            else
            {
                if (webDataDelegate !=nil)
                    [webDataDelegate webRawDataReceived:parsedObject];
            }
        
            
            /// [webDataDelegate webRawDataReceived:parsedObject];

            
//            if ([[parsedObject valueForKey:@"status"] isEqualToString:@"error"]) {
//                [webDataDelegate webRawDataReceivedWithError:[parsedObject valueForKey:@"message"]];
//            }
//            else{
//                //[tempArrat addObject:[parsedObject valueForKey:@"data"] ];
//                if (webDataDelegate !=nil)
//                    [webDataDelegate webRawDataReceived:parsedObject];
//            }
        }
    
        
    }];
    
    [postDataTask resume];
    
    
    
    
}

-(void)StartConnectionWithTokenandImageAPI3:(NSString *)Url_string params:(NSMutableDictionary*)imageData viewController:(UIViewController*)viewController{
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@""];
        
        return;
    }
    NSString *BoundaryConstant = @"----WebKitFormBoundaryE19zNvXGzXaLvS5C";
    
    //  Basestring=baseURL;
    NSString* FileParamConstant = @"image";
    
    NSString* api=[NSString stringWithFormat:@"%@%@",baseURLAPI3,Url_string];
    NSMutableData *body = [NSMutableData data];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:api]];
    [request setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    for (NSString *param in imageData) {
        if(![param isEqualToString:@"image"]){
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [imageData objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    // NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[imageData valueForKey:@"image"]];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [request setHTTPBody:body];
    
    
    
    ///// cookies
    //    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
    //    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //
    //    [request setAllHTTPHeaderFields:headers];
    
    
    //////cookies
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        
        NSError *localError = nil;
        NSDictionary *parsedObject;
        if (!parsedObject) {
            parsedObject =[[NSDictionary alloc]init];
        }
        
        parsedObject = [NSJSONSerialization JSONObjectWithData:data  options:0 error:&localError];
        
        if ([parsedObject isKindOfClass:[NSDictionary class]] && parsedObject !=nil  ) {
            [webDataDelegate webRawDataReceived:parsedObject];
            
            
            //            if ([[parsedObject valueForKey:@"status"] isEqualToString:@"error"]) {
            //                [webDataDelegate webRawDataReceivedWithError:[parsedObject valueForKey:@"message"]];
            //            }
            //            else{
            //                //[tempArrat addObject:[parsedObject valueForKey:@"data"] ];
            //                if (webDataDelegate !=nil)
            //                    [webDataDelegate webRawDataReceived:parsedObject];
            //            }
        }
        
        
    }];
    
    [postDataTask resume];
    
    
    
    
}


-(void)StartConnectionWithTokenandImageArray:(NSString *)Url_string params:(NSMutableDictionary*)imageData viewController:(UIViewController*)viewController{
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@""];
        
        return;
    }
    
    
    
    NSString *BoundaryConstant = @"----WebKitFormBoundaryE19zNvXGzXaLvS5C";
    
    //  Basestring=baseURL;
    NSString* FileParamConstant = @"images";
    
    NSString* api=[NSString stringWithFormat:@"%@%@",baseURL,Url_string];
    NSString *string ;
    NSData *imageData1;
    NSString*urlString=api;
    // urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSMutableData *body;
    body = [NSMutableData data];
    for(int j=0;j < [[imageData valueForKey:@"images"] count];j++) // scrollViewImageArray is images count
    {
        double my_time = [[NSDate date] timeIntervalSince1970];
        int k=j+1;
        NSString *imageName = [NSString stringWithFormat:@"%d%d",j,(int)(my_time)];
        NSString *imagetag=[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"images\"; filename=\"im.jpg\"\r\n"];
        string = [NSString stringWithFormat:@"%@%@%@", imagetag, imageName, @".jpg\"\r\n\""];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:string] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
       // UIImage *image=[[UIImage alloc]init];
        // scrollViewImageArray images array
        imageData1 = UIImageJPEGRepresentation([[imageData valueForKey:@"images"] objectAtIndex:j],90);
        [body appendData:[NSData dataWithData:imageData1]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
    } 
    [request setHTTPBody:body];
    
    for (NSString *param in imageData) {
        if(![param isEqualToString:@"images"] && ![param isEqualToString:@"deleteImages"]){
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [imageData objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
        // [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    
    
    ///// cookies
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
    
    
    //////cookies
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        
        NSError *localError = nil;
        NSDictionary *parsedObject;
        if (!parsedObject) {
            parsedObject =[[NSDictionary alloc]init];
        }
        
        parsedObject = [NSJSONSerialization JSONObjectWithData:data  options:0 error:&localError];
        
        if ([parsedObject isKindOfClass:[NSDictionary class]] && parsedObject !=nil  ) {
            
            if (([[parsedObject objectForKey:@"status"] integerValue]==0 || ![parsedObject objectForKey:@"status"])) {
                [webDataDelegate webRawDataReceivedWithError:[parsedObject valueForKey:@"message"]];
            }
            else{
                //[tempArrat addObject:[parsedObject valueForKey:@"data"] ];
                if (webDataDelegate !=nil)
                    [webDataDelegate webRawDataReceived:parsedObject];
            }
        }
        
        
    }];
    
    [postDataTask resume];
    
    
}





-(void)StartConnectionWithTokenandImageuploadfile:(NSString *)Url_string params:(NSMutableDictionary*)imageData viewController:(UIViewController*)viewController{
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@""];
        
        return;
    }
    // self.reqstData=[[NSMutableData alloc]init];
    NSString *BoundaryConstant = @"----WebKitFormBoundaryE19zNvXGzXaLvS5C";
    
    //  Basestring=baseURL;
    NSString* FileParamConstant = @"uploadfile";
    
    NSString* api=[NSString stringWithFormat:@"%@%@",baseURL,Url_string];
    // NSMutableData *postData = [NSMutableData data];
    NSMutableData *body = [NSMutableData data];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:api]];
    [request setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    for (NSString *param in imageData) {
        if(![param isEqualToString:@"uploadfile"]){
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [imageData objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"uploadfile.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[imageData valueForKey:@"uploadfile"]];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [request setHTTPBody:body];
  
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        
        NSError *localError = nil;
        NSDictionary *parsedObject;
        if (!parsedObject) {
            parsedObject =[[NSDictionary alloc]init];
        }
        
        parsedObject = [NSJSONSerialization JSONObjectWithData:data  options:0 error:&localError];
        
        if ([parsedObject isKindOfClass:[NSDictionary class]] && parsedObject !=nil  ) {
            
            if ([[parsedObject valueForKey:@"status"] isEqualToString:@"error"]) {
                [webDataDelegate webRawDataReceivedWithError:[parsedObject valueForKey:@"message"]];
            }
            else{
                if (webDataDelegate !=nil)
                    [webDataDelegate webRawDataReceived:parsedObject];
            }
        }
        
        
    }];
    
    [postDataTask resume];
    
    
    
    
}

-(void) postRequest:(NSMutableDictionary *) params toUrl:(NSString *)url{
    
    self.requestedParams = params;
    
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@"NO CONNECTION"];
        
       return;
    }
    
    NSMutableString *strReqString = [[NSMutableString alloc] initWithString:@""];;
    for (NSString *key in params) {
        
        NSString *value = [params objectForKey:key];
        [strReqString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
    NSString *toRequest=@"";
    if(strReqString.length==0)
    {
        
    }
    else
    {
toRequest = [[strReqString substringToIndex:[strReqString length] - 1]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,url]]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:120];
    
    [request setHTTPMethod:@"POST"];

    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(toRequest.length!=0){
     [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[toRequest length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[toRequest dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [NSURLConnection connectionWithRequest:request  delegate:self];
    
    self.reqstData=[[NSMutableData alloc]init];
    
    
    
}

-(void) postRequestDuplicate:(NSMutableDictionary *) params toUrl:(NSString *)url type:(NSString*)type {
    
    self.requestedParams = params;
    
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@"No Connection"];
        return;
    }
    
    NSMutableString *strReqString = [[NSMutableString alloc] initWithString:@""];;
    for (NSString *key in params) {
        
        NSString *value = [params objectForKey:key];
        [strReqString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
    NSString *toRequest=@"";
    if(strReqString.length==0)
    {
        
    }
    else
    {
        toRequest = [[strReqString substringToIndex:[strReqString length] - 1]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURLDuplicate,url]]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:120];
    
    [request setHTTPMethod:type];
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(toRequest.length!=0){
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[toRequest length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[toRequest dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [NSURLConnection connectionWithRequest:request  delegate:self];
    
    self.reqstData=[[NSMutableData alloc]init];
    
    
    
}


-(void) postRequest:(NSMutableDictionary *) params toUrl:(NSString *)url type:(NSString*)type {
    
 
    [self postRequest:params withToken:FALSE toUrl:url type:type];
    
    
}
-(void) postRequest:(NSMutableDictionary *) params withToken:(BOOL)shouldUseToken toUrl:(NSString *)url type:(NSString*)type {
    
    self.requestedParams = params;
    
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@"No Connection"];
        return;
    }
    
    NSMutableString *strReqString = [[NSMutableString alloc] initWithString:@""];;
    if ([type isEqualToString:@"POST"])
    {
        for (NSString *key in params)
        {
            
          NSString *value = [params objectForKey:key];
          [strReqString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
        }
    }
   
    NSString *toRequest=@"";
    if(strReqString.length==0)
    {
        
    }
    else
    {
        toRequest = [[strReqString substringToIndex:[strReqString length] - 1]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    NSLog(@"--->%@",[NSString stringWithFormat:@"%@%@",baseURL,url]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,url]]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:120];
    
    
    
    [request setHTTPMethod:type];
    if (shouldUseToken) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        if (token) {
                 
     
        NSString *authValue = [NSString stringWithFormat: @"Bearer %@",token];
            NSLog(@"auth -- %@",authValue);

        // Part Important
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        }
        

    }
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
    
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(toRequest.length!=0){
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[toRequest length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[toRequest dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [NSURLConnection connectionWithRequest:request  delegate:self];
    
    
    
    
    self.reqstData = [[NSMutableData alloc]init];
    
    
    
    
}


//CJC 15
-(void) postRequestNew:(NSMutableDictionary *) params withToken:(BOOL)shouldUseToken toUrl:(NSString *)url type:(NSString*)type {
    
    self.requestedParams = params;
    
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@"No Connection"];
        return;
    }
    
    NSMutableString *strReqString = [[NSMutableString alloc] initWithString:@""];;
    if ([type isEqualToString:@"POST"])
    {
        for (NSString *key in params)
        {
            
          NSString *value = [params objectForKey:key];
          [strReqString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
        }
    }
   
    NSString *toRequest=@"";
    if(strReqString.length==0)
    {
        
    }
    else
    {
        toRequest = [[strReqString substringToIndex:[strReqString length] - 1]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    NSLog(@"--->%@",[NSString stringWithFormat:@"%@%@",DomainUrl,url]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DomainUrl,url]]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:120];
    
    
    
    [request setHTTPMethod:type];
    if (shouldUseToken) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        if (token) {
                 
     
        NSString *authValue = [NSString stringWithFormat: @"Bearer %@",token];

        // Part Important
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        }

    }
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
    
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(toRequest.length!=0){
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[toRequest length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[toRequest dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [NSURLConnection connectionWithRequest:request  delegate:self];
    
    self.reqstData=[[NSMutableData alloc]init];
    
    
    
}


-(void) postString:(NSString *)poststring toUrl:(NSString *)url type:(NSString*)type {
    
    
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@"No Connection"];
        return;
    }
    
//    NSMutableString *strReqString =poststring;;
   NSString *toRequest=@"";
//    if(strReqString.length==0)
//    {
//
//    }
//    else
//    {
        toRequest = [poststring stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
   // }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,url]]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:120];
    
    
    
    [request setHTTPMethod:type];
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(toRequest.length!=0){
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[toRequest length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[toRequest dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [NSURLConnection connectionWithRequest:request  delegate:self];
    
    self.reqstData=[[NSMutableData alloc]init];
    
    
    
}

-(void) postRequestCommon:(NSMutableDictionary *) params toUrl:(NSString *)url type:(NSString*)type {
    
    self.requestedParams = params;
    
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@"No Connection"];
        return;
    }
    
    NSMutableString *strReqString = [[NSMutableString alloc] initWithString:@""];;
    for (NSString *key in params) {
        
        NSString *value = [params objectForKey:key];
        [strReqString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
    NSString *toRequest=@"";
    if(strReqString.length==0)
    {
        
    }
    else
    {
        toRequest = [[strReqString substringToIndex:[strReqString length] - 1]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURLCommon,url]]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:120];
    
    [request setHTTPMethod:type];
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(toRequest.length!=0){
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[toRequest length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[toRequest dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [NSURLConnection connectionWithRequest:request  delegate:self];
    
    self.reqstData=[[NSMutableData alloc]init];
    
    
    
}
-(void) postRequestAPI3:(NSMutableDictionary *) params toUrl:(NSString *)url type:(NSString*)type {
    
    self.requestedParams = params;
    
    if (![Commons doWeHaveInternetConnection]) {
        
        [[iToast makeText:NSLocalizedString(@"Cannot access server. Server is down or unreachable. Please try again later.", nil)]show];
        [webDataDelegate requestUtil:self error:@"No Connection"];
        return;
    }
    
    NSMutableString *strReqString = [[NSMutableString alloc] initWithString:@""];;
    for (NSString *key in params) {
        
        NSString *value = [params objectForKey:key];
        [strReqString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
    NSString *toRequest=@"";
    if(strReqString.length==0)
    {
        
    }
    else
    {
        toRequest = [[strReqString substringToIndex:[strReqString length] - 1]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURLAPI3,url]]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:120];
    
    [request setHTTPMethod:type];
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(toRequest.length!=0){
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[toRequest length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[toRequest dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [NSURLConnection connectionWithRequest:request  delegate:self];
    
    self.reqstData=[[NSMutableData alloc]init];
    
    
    
}
#pragma -mark NSURL DELEGATES
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  
 
    
    [self.reqstData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.reqstData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
 NSError *localError = nil;
    NSDictionary *parsedObject;
    if (!parsedObject) {
        parsedObject =[[NSDictionary alloc]init];
    }
   // parsedObject = [NSJSONSerialization JSONObjectWithData:self.reqstData  options:0 error:&localError];

//    if([[NSString stringWithUTF8String:[self.reqstData bytes]] isKindOfClass:[NSString class]])
//    {
//
//        NSLog(@"%@",[NSString stringWithUTF8String:[self.reqstData bytes]]);
//       if([[NSString stringWithUTF8String:[self.reqstData bytes]] isEqualToString:@"not available"])
//       {
//           [webDataDelegate webRawDataReceivedWithError:@"Error"];
//
//       }
//        else
//        {
//           [webDataDelegate webRawDataReceived:[NSJSONSerialization JSONObjectWithData:self.reqstData  options:0 error:&localError]];
//        }
//
//
//    }else
    
    id responseDict = [NSJSONSerialization JSONObjectWithData:self.reqstData  options:0 error:&localError];
    //NSLog(@"responseDict %@ %@",responseDict,connection.currentRequest.URL);
    
    if([responseDict isKindOfClass:[NSDictionary class]])
    {
    parsedObject = responseDict;
   
    
    if ([parsedObject isKindOfClass:[NSDictionary class]] && parsedObject !=nil  ) {
        
        if (([parsedObject objectForKey:@"status"] && [[parsedObject objectForKey:@"status"] integerValue]==0) && ![[parsedObject objectForKey:@"status"] isEqualToString:@"Success"]) {

        
          
            [webDataDelegate webRawDataReceivedWithError:[parsedObject objectForKey:@"message"]  ];
        }
        else
        {
  if (webDataDelegate !=nil)
            [webDataDelegate webRawDataReceived:parsedObject];
        }
    }
    else
    {
        

    }
    
    }
    else
    {
        
        NSLog(@"ok--- %@",self.reqstData );
        
        if (webDataDelegate !=nil)
            [webDataDelegate webRawDataReceived:[NSJSONSerialization JSONObjectWithData:self.reqstData  options:0 error:&localError]];
    }
  }
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{

    if (webDataDelegate !=nil)
               [webDataDelegate requestUtil:self error:@"Connection to the server failed"];



}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    

}

-(void)callFavoriteApi
{
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    [util postRequest:@{} withToken:TRUE toUrl:[NSString stringWithFormat: @"users/me"] type:@"GET"];
}


-(NSString*)convertTime
{
  NSString*  timeString=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"];
  NSDateFormatter*  timePicker= [[NSDateFormatter alloc]init];
    [timePicker setDateFormat:@"hh:mm"];
    [timePicker setTimeZone:[NSTimeZone localTimeZone]];
    [timePicker setDateFormat:@"HH:mm"];
    
    NSDate*datePassed=[timePicker dateFromString:timeString];
    [timePicker setDateFormat:@"hh:mm"];
    NSString*selectedTime=[timePicker stringFromDate:datePassed];
    
    [timePicker setDateFormat:@"hh:mm a"];
    NSString*amOrPm=[timePicker stringFromDate:datePassed];
//    if([amOrPm containsString:@"AM"])
//        _amPmLbl.text=@"AM";
//    else
//        _amPmLbl.text=@"PM";
    
    timePicker=nil;
    return amOrPm;
}
-(void)callRatingApi
{
    NSString* locationString=@" ";
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        
        locationString=[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    }
    // locationString=@"5b8e1555e471be1f7cbd4879";
    
    NSString* postString=@" ";
    
    //    RequestUtil *util = [[RequestUtil alloc]init];
    //    util.webDataDelegate=(id)self;
    //    [util postRequest:reqData toUrl:[NSString stringWithFormat: @"favourites/%@",locationString] type:@"POST"];
    
    
    NSString *requstUrl=[NSString stringWithFormat:@"https://extranet.stayhopper.com/api/ratings"];
    
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:requstUrl]];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postString length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setURL:[NSURL URLWithString:requstUrl]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *localError = nil;
        NSDictionary *parsedObject;
        if (!parsedObject) {
            parsedObject =[[NSDictionary alloc]init];
        }
        
        
        //[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        if(data!=nil)
        {
            // dic =[[NSMutableDictionary alloc]init];
            
            parsedObject = [NSJSONSerialization JSONObjectWithData:data  options:0 error:&localError];
            
            if ([parsedObject isKindOfClass:[NSDictionary class]] && parsedObject !=nil  )
            {
                if ([parsedObject objectForKey:@"status"])
                {
                    if ([[parsedObject valueForKey:@"status"] intValue]==1)
                    {
                        if([parsedObject objectForKey:@"data"])
                        {
                            
                            NSMutableArray* favoriteArry=[[NSMutableArray alloc]init];
                            for(NSDictionary* dicValue in [parsedObject objectForKey:@"data"])
                            {
                                [favoriteArry addObject:dicValue];
                            }
                            
                            
                            [[NSUserDefaults standardUserDefaults] setObject:[favoriteArry copy] forKey:@"ratingList"];
                            
                            [[NSUserDefaults standardUserDefaults ] synchronize];
                            
                            
                        }
                        else if([parsedObject objectForKey:@"message_en"])
                        {
                            dispatch_async(dispatch_get_main_queue(),
                                           ^{
                                               
                                           });
                            
                        }
                    }
                    else if([[parsedObject valueForKey:@"status"] isEqualToString:@"error"])
                    {
                        dispatch_async(dispatch_get_main_queue(),
                                       ^{
                                           
                                       });
                        
                    }
                    
                }
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
                
            }
        }
        else{
            
        }
        
        
    }];
    
    [postDataTask resume];
    
    
    
}


-(BOOL)checkFavorites:(NSString*)propertyID
{
    
    return [Commons checkFavorites:propertyID];
}


-(NSString*)checkRating:(NSNumber*)ratingID
{
    
  //  return [NSString stringWithFormat:@"%@", ratingID];
//    if([[NSUserDefaults standardUserDefaults]objectForKey:@"ratingList"])
//    {
//        NSArray* listArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"ratingList"];
//
//
//        for(NSDictionary* dic in listArray)
    
    
                NSString* nameString=[NSString stringWithFormat:@"%@", ratingID];
                if([nameString containsString:@"1"])
                {
                    return @"Rating-1star.png";

                }else if([nameString containsString:@"2"])
                {
                    return @"Rating-2star.png";
                    
                }else if([nameString containsString:@"3"])
                {
                    return @"Rating-3star.png";
                    
                }else if([nameString containsString:@"4"])
                {
                    return @"Rating-4star.png";
                    
                }else if([nameString containsString:@"5"])
                {
                    return @"Rating-5star.png";
                    
                }
                
                
          //  }
        
        
        
   
    
    
    return @"";
}


-(void)pushRegistration
{
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate tokenGet];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{


        NSString* locationString=@" ";
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"DEVICE_TOKENFCM"])
        {
            
            
      
            locationString=[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        
        // locationString=@"5b8e1555e471be1f7cbd4879";
        
        NSString* postString=[NSString stringWithFormat:@"user_id=%@&device_type=ios&device_token=%@",locationString,[[NSUserDefaults standardUserDefaults]objectForKey:@"DEVICE_TOKENFCM"]];
        
        //    RequestUtil *util = [[RequestUtil alloc]init];
        //    util.webDataDelegate=(id)self;
        //    [util postRequest:reqData toUrl:[NSString stringWithFormat: @"favourites/%@",locationString] type:@"POST"];
        
        
            //CJC last work
        
        NSString *requstUrl=[NSString stringWithFormat:@"%@users/notify_cred",baseURL];
        
        
        NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:requstUrl]];
        [request setHTTPMethod:@"POST"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postString length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        [request setURL:[NSURL URLWithString:requstUrl]];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSError *localError = nil;
            NSDictionary *parsedObject;
            if (!parsedObject) {
                parsedObject =[[NSDictionary alloc]init];
            }
            
            NSLog(@"okkk -- %@",data);

            NSLog(@"okkk -- %@",postString);

            
            //[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            if(data!=nil)
            {
                // dic =[[NSMutableDictionary alloc]init];
                
                parsedObject = [NSJSONSerialization JSONObjectWithData:data  options:0 error:&localError];
                
                NSLog(@"okkk -- %@",parsedObject);
                
                if ([parsedObject isKindOfClass:[NSDictionary class]] && parsedObject !=nil  )
                {
                    if ([parsedObject objectForKey:@"status"])
                    {
                        if ([[parsedObject valueForKey:@"status"] intValue]==1)
                        {
                            
                        }
                        else if([[parsedObject valueForKey:@"status"] isEqualToString:@"error"])
                        {
                            
                        }
                        else
                        {
                        }
                        
                    }
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                    
                }
            }
            else{
                
            }
            
            
        }];
        
        [postDataTask resume];
        
        }
        

    });
    
    
    
    
}


-(void)addOrRemoveFavorites:(NSString*)propertyID userID:(NSString*)userID{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hudEnable" object:nil];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"favoriteList"])
    {
           NSMutableArray* favValue=[[NSMutableArray alloc]init];
        
        for(NSString* str in [[NSUserDefaults standardUserDefaults]objectForKey:@"favoriteList"])
        {
            [favValue addObject:str];
        }
 
    BOOL status=NO;
    for(int i=0;i<favValue.count;i++)
    {
       if([[favValue objectAtIndex:i] isEqualToString:propertyID])
       {
           [favValue removeObjectAtIndex:i];
           status=YES;
       }
    }
    
    if(!status)
        [favValue addObject:propertyID];
    
    [[NSUserDefaults standardUserDefaults] setObject:favValue forKey:@"favoriteList"];
    
    [[NSUserDefaults standardUserDefaults ] synchronize];
    }
    NSString* locationString=[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
//    locationString=@"5b8e1555e471be1f7cbd4879";
//    "user_id:5b8e1555e471be1f7cbd4879
//property_id:5b718bf6b8dd036ff4bd5976"
    NSString* postString=[NSString stringWithFormat:@"user_id=%@&property_id=%@",locationString,propertyID];
    
    //    RequestUtil *util = [[RequestUtil alloc]init];
    //    util.webDataDelegate=(id)self;
    //    [util postRequest:reqData toUrl:[NSString stringWithFormat: @"favourites/%@",locationString] type:@"POST"];
    
    
    NSString *requstUrl=[NSString stringWithFormat:@"https://extranet.stayhopper.com/api/favourites"];
    
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:requstUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postString length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setURL:[NSURL URLWithString:requstUrl]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *localError = nil;
        NSDictionary *parsedObject;
        if (!parsedObject) {
            parsedObject =[[NSDictionary alloc]init];
        }
        dispatch_async(dispatch_get_main_queue(),
                       ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hudDisable" object:nil];
 });
        //[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        if(data!=nil)
        {
            // dic =[[NSMutableDictionary alloc]init];
            
            parsedObject = [NSJSONSerialization JSONObjectWithData:data  options:0 error:&localError];
            
            if ([parsedObject isKindOfClass:[NSDictionary class]] && parsedObject !=nil  )
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   [self callFavoriteApi];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSaved" object:nil];
                               });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   [self callFavoriteApi];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSaved" object:nil];
                               });
                
            }
        }
        else{
            
        }
        
        
    }];
    
    [postDataTask resume];
    
    
    
}

@end
