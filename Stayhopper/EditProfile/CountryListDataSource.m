//
//  CountryListDataSource.m
//  Country List
//
//  Created by Pradyumna Doddala on 18/12/13.
//  Copyright (c) 2013 Pradyumna Doddala. All rights reserved.
//

#import "CountryListDataSource.h"

#define kCountriesFileName @"CountryList.plist"

@interface CountryListDataSource () {
    NSArray *countriesList;
}

@end

@implementation CountryListDataSource

- (id)init {
    self = [super init];
    if (self) {
        [self parsePLIST];
    }
    
    return self;
}

- (void)parseJSON {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    countriesList = (NSArray *)parsedObject;
}

-(void)parsePLIST
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"CountryListWithCodes" ofType:@"plist"];
    NSDictionary * values=[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *arrayValues=[[NSArray alloc] initWithArray:[values valueForKey:@"countries"]];
    
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:kCountryName ascending:YES];

    countriesList = [[NSArray alloc] initWithArray:(NSArray *)[arrayValues sortedArrayUsingDescriptors:[NSArray arrayWithObject:brandDescriptor]]];
    
   // countriesList = (NSArray *)arrayValues;

  
   
    
}
- (NSArray *)countries
{
    
    return countriesList;
}
@end
