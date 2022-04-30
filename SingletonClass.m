//


//
//  Created by Antony Joe Mathew on 12/11/14.
//  Copyright (c) 2014 XXXX. All rights reserved.
//

#import "SingletonClass.h"
#import "URLConstants.h"
#import "Enums.h"

 @implementation SingletonClass


static SingletonClass* _sharedMySingleton = nil;


- (id)init
{
    self = [super init];
    if (self) {
      
        _currentSortSelection = @"";
        _filterListDictionary = [[NSMutableDictionary alloc] init];
        _selectedFiltersArray = [[NSMutableArray alloc] init];

        _selectedMinimumPrice = -1;
        _selectedMaximumPrice = -1;
        for (int i=0;i<kFilterCount;i++)
        {
            [_selectedFiltersArray addObject:@""];
           

        }
        _selectedFiltersArray[kFilterPropertyType] =[ @{@"title":@"Property type",
                                                   @"ids":[[NSMutableSet alloc]init],
                                                   @"key": @"propertyTypes"} mutableCopy];
        _selectedFiltersArray[kFilterStarRating] =[ @{@"title":@"Star rating",
                                                       @"ids":[[NSMutableSet alloc]init],
                                                       @"key": @"propertyRatings"} mutableCopy];
        
        _selectedFiltersArray[kFilterRoomType] =[ @{@"title":@"Room types",
                                                       @"ids":[[NSMutableSet alloc]init],
                                                       @"key": @"roomTypes"} mutableCopy];
        _selectedFiltersArray[kFilterBedType] =[ @{@"title":@"Bed types",
                                                       @"ids":[[NSMutableSet alloc]init],
                                                       @"key": @"bedTypes"} mutableCopy];
        _selectedFiltersArray[kFilterAmenities] =[ @{@"title":@"Amenities",
                                                       @"ids":[[NSMutableSet alloc]init],
                                                       @"key": @"services"} mutableCopy];
//propertyTypes Property type
//propertyRatings Star rating
//  Room types
// Bed types
    //bedTypes Bed types
//
     }
    return self;
}
+ (SingletonClass *)getInstance {
    static SingletonClass *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SingletonClass alloc] init];
    });
    return sharedInstance;
}


-(void)changingFontsAndAlignMent
{
    
  
   
    //[CommonFunction updatingTokentoServer];
    
}


@end
