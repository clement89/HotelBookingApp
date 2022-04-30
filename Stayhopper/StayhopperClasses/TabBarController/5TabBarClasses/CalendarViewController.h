//
//  CalendarViewController.h
//  Stayhopper
//
//  Created by Vh iROID Technologies on 25/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CalendarViewController : UIViewController
{
    IBOutlet UIButton* nextButton;

}
- (IBAction)nextButton:(id)sender;
- (IBAction)previousButton:(id)sender;

- (IBAction)close:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *calndrView;
// Main color of numbers
@property (nonatomic, strong) UIColor *fontColor;
// Color of the headers (Year and month)
@property (nonatomic, strong) UIColor *fontHeaderColor;
// Color of selected numbers
@property (nonatomic, strong) UIColor *fontSelectedColor;
// Color of selection
@property (nonatomic, strong) UIColor *selectionColor;
// Color of today
@property (nonatomic, strong) UIColor *todayColor;
@property (strong, nonatomic)IBOutlet UILabel* selectedDateLBL;
@end
