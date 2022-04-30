//
//  SortViewController.h
//  Stayhopper
//
//  Created by iROID Technologies on 10/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SortDelegate <NSObject>

-(void)sortFunctionByString:(NSString*)filterOption value:(NSString*)selectedString;

@end
@interface SortViewController : UIViewController
{
    NSArray *sortValueArray;
    NSString* currentString;
    NSString* selectionString;
    NSInteger selectedIndex;
}
@property (strong, nonatomic)IBOutlet UITableView* ratingTableView;
@property(nonatomic,assign)id<SortDelegate>delegate;
@property(nonatomic,retain)NSString *fromString;
@property(nonatomic,retain)NSString *valueString;

-(IBAction)proceedAction:(id)sender;
@end
