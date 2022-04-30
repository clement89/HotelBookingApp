//


//
//  Created by Antony Joe Mathew on 12/11/14.
//  Copyright (c) 2014 XXXX. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface SingletonClass : NSObject{

    

}


@property(strong, nonatomic) NSMutableDictionary *filterListDictionary;
 

@property(strong, nonatomic) NSString* currentSortSelection;

@property(strong, nonatomic) NSMutableArray* selectedFiltersArray;
@property(assign, nonatomic) int selectedMinimumPrice;
@property(assign, nonatomic) int selectedMaximumPrice;

+ (SingletonClass *)getInstance;

 

@end
