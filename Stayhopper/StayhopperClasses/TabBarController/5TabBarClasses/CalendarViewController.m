//
//  CalendarViewController.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 25/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarView.h"
#import "FSCalendar.h"
#import "URLConstants.h"
@interface CalendarViewController ()<CalendarViewDelegate,FSCalendarDelegate,FSCalendarDataSource>{
    NSDateFormatter *dateFormatter;
    CalendarView *calendarView;

}
@property (weak , nonatomic) FSCalendar *calendar;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    
    
dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [super viewDidLoad];
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    
    
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.appearance.weekdayFont=[UIFont fontWithName:@"ProximaNovaA-Regular" size:13];
    calendar.appearance.titleFont=[UIFont fontWithName:@"ProximaNovaA-Regular" size:13];
    calendar.appearance.weekdayTextColor=[UIColor darkGrayColor];
    calendar.appearance.headerTitleFont=[UIFont fontWithName:FontBold size:15];
    calendar.appearance.headerTitleColor=[UIColor darkGrayColor];
    calendar.appearance.selectionColor=[UIColor colorWithRed: 0.043 green: 0.090 blue: 0.298 alpha:1.000];
   // calendar.appearance.
  // calendar.minimumDate=[NSDate date];
//    [calendar minimumDate];
   // calendar.minimumDate;
    


  
    [self.calndrView addSubview:calendar];

    
    self.calendar = calendar;
    
  
//   calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(5, 40, self.view.frame.size.width, self.view.frame.size.width)];
//    [calendarView setShouldShowHeaders:YES];
//    calendarView.layer.cornerRadius=0;
//    calendarView.clipsToBounds=YES;
//    [calendarView setDayCellWidth:self.view.frame.size.width/8];
//   [calendarView setDayCellHeight:self.view.frame.size.width/8];
//    [self.calndrView addSubview:calendarView];
//    calendarView.calendarDelegate = self;
//    [calendarView refresh];
//    calendarView.fontName=@"ProximaNovaA-Regular";
//    calendarView.headerFontSize=17;
//    calendarView.dayFontSize=15;
//    calendarView.currentDate=[NSDate date];
    
    calendarView.selectionColor = [UIColor colorWithRed: 0.043 green: 0.090 blue: 0.298 alpha:1.000];
    
    calendarView.fontHeaderColor = [UIColor colorWithRed: 0.043 green: 0.553 blue: 0.953 alpha:1.000];
    NSString* currentdateString=[dateFormatter stringFromDate:[NSDate date]];

    self.selectedDateLBL.text=[NSString stringWithFormat:@"%@",currentdateString];
}
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    
    int timeToAdd=24*60*60*30;
        return  [[NSDate date] dateByAddingTimeInterval:timeToAdd];
    
    
}
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate date];
}
- (IBAction)onNextMonthButtonClick:(UIButton *)sender {
   // [self.calendar setCurrentPage:[self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:self.calendar.currentPage options:0] animated:YES];
}
- (void)didChangeCalendarDate:(NSDate *)date
{
    NSString* selecteddateString=[dateFormatter stringFromDate:date];
    NSString* currentdateString=[dateFormatter stringFromDate:[NSDate date]];

    if ([[dateFormatter dateFromString:selecteddateString] compare:[dateFormatter dateFromString:currentdateString]] == NSOrderedDescending || [[dateFormatter dateFromString:selecteddateString] compare:[dateFormatter dateFromString:currentdateString]] == NSOrderedSame) {
        
        NSString* nextDayString=[dateFormatter stringFromDate:date];
        
        [[NSUserDefaults standardUserDefaults]setObject:nextDayString forKey:@"selectedDate"];
        
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDateLBL" object:nil];
        
        NSLog(@"didChangeCalendarDate:%@", date);
        self.selectedDateLBL.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];

    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


//- (void)didChangeCalendarDate:(NSDate *)date withType:(NSInteger)type withEvent:(NSInteger)event;
//- (void)didDoubleTapCalendar:(NSDate *)date withType:(NSInteger)type;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    NSString* selecteddateString=[dateFormatter stringFromDate:date];
    NSString* currentdateString=[dateFormatter stringFromDate:[NSDate date]];
    
    if ([[dateFormatter dateFromString:selecteddateString] compare:[dateFormatter dateFromString:currentdateString]] == NSOrderedDescending || [[dateFormatter dateFromString:selecteddateString] compare:[dateFormatter dateFromString:currentdateString]] == NSOrderedSame) {
        
        NSString* nextDayString=[dateFormatter stringFromDate:date];
        
        [[NSUserDefaults standardUserDefaults]setObject:nextDayString forKey:@"selectedDate"];
        
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDateLBL" object:nil];
        
        NSLog(@"didChangeCalendarDate:%@", date);
        self.selectedDateLBL.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
        [self dismissViewControllerAnimated:YES completion:nil];

        
    }
    
    
}
@end
