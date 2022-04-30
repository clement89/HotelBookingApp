//
//  FileUpload.m
//  cms
//
//  Created by Bryno Baby on 01/11/15.
//  Copyright (c) 2016 UGO Technologies. All rights reserved.
//

#import "FileUpload.h"
#import "AppDelegate.h"

@implementation FileUpload

-(NSString *)localName{
    return self.fileName;
}

-(NSData *)loadData{
    
   // NSString *path = [[AppDelegate currentModel]getFullPathOfFileSystem:self.fileName];
    NSString *path ;
    return [NSData dataWithContentsOfFile:path];
}
@end
