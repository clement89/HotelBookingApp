//
//  Queue.m
//  cms
//
//  Created by Bryno Baby on 07/11/15.
//  Copyright © 2016 UGO Technologies. All rights reserved.
//

#import "Queue.h"

@implementation Queue
- (id)init {
    if ((self = [super init])) {
        objects = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addObject:(id)object {
    [objects addObject:object];
}

- (id)takeObject  {
    id object = nil;
    if ([objects count] > 0) {
        object = [objects objectAtIndex:0];
        [objects removeObjectAtIndex:0];
    }
    return object;
    
}

- (int)itemsCount{
    return objects.count;
    
}

- (int)itemIndex:(NSString *)itemId{
    return [objects indexOfObject:itemId];
}
@end
