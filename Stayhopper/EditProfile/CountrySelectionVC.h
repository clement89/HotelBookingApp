//
//  CountrySelectionVC.h
//  HHPOManagement
//
//  Created by XXX on 8/26/18.
//  Copyright © 2018 XXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountryListViewDelegate <NSObject>
- (void)didSelectCountry:(int)clickedIndex;
- (void)didSelectCountrywithCountryCode:(NSString *)countryCode;

@end

@interface CountrySelectionVC : UIViewController
@property (nonatomic, assign) id<CountryListViewDelegate>delegate;
@property (strong, nonatomic) NSArray *dataRows;
@property (nonatomic, assign) int currentIndex;

@end
