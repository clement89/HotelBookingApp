//
//  Queue.h
//  cms
//
//  Created by Bryno Baby on 07/11/15.
//  Copyright © 2016 UGO Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject{
    NSMutableArray* objects;
}
- (void)addObject:(id)object;
- (id)takeObject;
- (int)itemsCount;
- (int)itemIndex:(NSString *)itemId;
@end
