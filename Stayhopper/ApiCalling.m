//
//  ApiCalling.m
//  QOM
//
//  Created by Vh Papaya Qatar on 21/02/18.
//  Copyright © 2018 Papaya Qatar. All rights reserved.
//

#import "ApiCalling.h"
#import "AppDelegate.h"


@implementation ApiCalling{
    NSMutableDictionary*dic,*userDic;
    AppDelegate *a;
}


-(void)toServer:(NSString *)type :(NSString *)url :(NSString *)postString{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hudEnable" object:nil];
    BOOL isFavorite=NO,isAddComments=NO;

    
    
    NSString *requstUrl=[NSString stringWithFormat:@"http://simpletouchsa.com/mallapi/ios/ToMalls/%@",url];
    
    
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
        dispatch_async(dispatch_get_main_queue(), ^{         [[NSNotificationCenter defaultCenter]postNotificationName:@"hudDisable" object:nil];});
        
        //[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        if(data!=nil)
        {
            dic =[[NSMutableDictionary alloc]init];
            
            parsedObject = [NSJSONSerialization JSONObjectWithData:data  options:0 error:&localError];
            
            if ([parsedObject isKindOfClass:[NSDictionary class]] && parsedObject !=nil  )
            {
                if ([parsedObject objectForKey:@"status"])
                {
                    if ([[parsedObject valueForKey:@"status"] isEqualToString:@"success"])
                    {
                        if([parsedObject objectForKey:@"data"])
                        {
                            dispatch_async(dispatch_get_main_queue(),
                           ^{
                                dic=[parsedObject valueForKey:@"data"];
                                if (_delegate !=nil)
                                {
                                    //if(!isFavorite)
                                        [_delegate getData:parsedObject];
                                    //else
                                        //[_delegate getFavorite:parsedObject];
                                }
                                
                            });
                        }
                        else if([parsedObject objectForKey:@"message_en"])
                        {
                            dispatch_async(dispatch_get_main_queue(),
                           ^{
                                if (_delegate !=nil)
                                {
                                    if(isFavorite)
                                        [_delegate getFavorite:parsedObject];
                                    if(isAddComments)
                                        [_delegate getCommentResult:parsedObject];
                                    else
                                       [_delegate getData:parsedObject];

                                }
                            });
                            
                        }
                    }
                    else if([[parsedObject valueForKey:@"status"] isEqualToString:@"error"])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (_delegate !=nil)
                            {
                                [_delegate getError:parsedObject];
                            }
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

-(void)callFavoriteApi
{
    NSString* locationString=[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    NSString* postString=@" ";
    
//    RequestUtil *util = [[RequestUtil alloc]init];
//    util.webDataDelegate=(id)self;
//    [util postRequest:reqData toUrl:[NSString stringWithFormat: @"favourites/%@",locationString] type:@"POST"];
    
    
    NSString *requstUrl=[NSString stringWithFormat:@"http://simpletouchsa.com/mallapi/ios/ToMalls/%@",locationString];
    
    
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
        
        
        //[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        if(data!=nil)
        {
            dic =[[NSMutableDictionary alloc]init];
            
            parsedObject = [NSJSONSerialization JSONObjectWithData:data  options:0 error:&localError];
            
            if ([parsedObject isKindOfClass:[NSDictionary class]] && parsedObject !=nil  )
            {
                if ([parsedObject objectForKey:@"status"])
                {
                    if ([[parsedObject valueForKey:@"status"] isEqualToString:@"success"])
                    {
                        if([parsedObject objectForKey:@"data"])
                        {
                            dispatch_async(dispatch_get_main_queue(),
                                           ^{
                                               dic=[parsedObject valueForKey:@"data"];
                                               
                                               
                                           });
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
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (_delegate !=nil)
                            {
                                [_delegate getError:parsedObject];
                            }
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
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"favoriteList"])
    {
        NSArray* listArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"favoriteList"];
        
        
        for(NSString* uID in listArray)
            
            if([propertyID isEqualToString:uID])
            {
                return YES;
            }
            
        
        
    }
    
    
    return NO;
}

@end
