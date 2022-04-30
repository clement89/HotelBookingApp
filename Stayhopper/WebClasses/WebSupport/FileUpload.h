//
//  FileUpload.h
//  cms
//
//  Created by Bryno Baby on 01/11/15.
//  Copyright (c) 2016 UGO Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUpload : NSObject

@property(nonatomic, strong)NSString *fileName;
-(NSString *)localName;
-(NSData *)loadData;
@end
