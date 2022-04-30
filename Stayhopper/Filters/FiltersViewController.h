//
//  FiltersViewController.h
//  Stayhopper
//
//  Created by iROID Technologies on 10/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestUtil.h"
#import "MARKRangeSlider.h"

@protocol FilterDelegate <NSObject>

-(void)filterFunctionByString:(NSString*)filterOption value:(NSString*)selectedString;

@end
@interface FiltersViewController : UIViewController<WebData>
{
    NSArray *ratingArray;
    NSArray *serviceArray;
    NSMutableArray *filterSelectionArray;

    NSString* currentString;
    NSString* selectionString;
    NSInteger selectedIndex;
    NSInteger selectedSection;
    NSInteger selectedCatogary;
    IBOutlet UIView *ratingView;
    IBOutlet UIView *serviceView;
    IBOutlet UIButton* ratingBUtton;
    IBOutlet UIButton* serviceBUtton;

}
@property(strong,nonatomic)NSMutableArray*  ratingArrayPassed;
@property(strong,nonatomic)NSMutableArray*  serviceArrayPassed;
@property (strong, nonatomic)IBOutlet UITableView* ratingTableView;
@property (strong, nonatomic)IBOutlet UITableView* serviceTableView;

@property(nonatomic,assign)id<FilterDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) IBOutlet UILabel *sliderLBl;

@property (strong, nonatomic) IBOutlet UISlider *slider1;

@property(nonatomic,retain)NSString *minString;
@property(nonatomic,retain)NSString *maxString;

@property(nonatomic,retain)NSString *fromString;

@property(nonatomic,retain)NSString *valueString;

-(IBAction)proceedAction:(id)sender;

@end
