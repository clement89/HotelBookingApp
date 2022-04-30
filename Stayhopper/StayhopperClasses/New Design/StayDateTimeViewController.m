//
//  StayDateTimeViewController.m
//  Stayhopper
//
//  Created by antony on 12/08/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import "StayDateTimeViewController.h"
#import "SelectGuestsViewController.h"
#import <FSCalendar/FSCalendar.h>
#import "RangePickerCell.h"
#import "URLConstants.h"
#import "Commons.h"
#import "MessageViewController.h"
static NSString *kdateFormatCheckInDayFormat  = @"EEE, dd MMM";
static NSString *kdateFormatCheckInTimeFormat  = @"hh:mm a";

@interface StayDateTimeViewController ()
{
    BOOL firsTimeFlagForCalSelection;
    NSMutableArray *weekdaysArray,*timeSlotsArray;
    NSDateFormatter *dateformater;
    int selectedTimeIndexCheckin,selectedTimeIndexCheckOut;
    BOOL isCheckinTimeSelected;
    NSCalendar *calendarForFormating;
    NSString *fromTimeStringForHourly,*toTimeStringForHourly,*tempTimeStringSelected;
    NSDate *selectedFromDate,*selectedToDate,*tempDateSelectedFromCal;
    BOOL firstTimeNotClaing;
 }
@property (weak, nonatomic) IBOutlet UIView *viewTimeContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *cvTime;
@property (strong, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (weak, nonatomic) IBOutlet UIView *viewWeekContainer;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UIView *viewMontHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (strong, nonatomic) NSDateFormatter *monthFormatter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriantTimeSelectionTop;

// The start date of the range
@property (strong, nonatomic) NSDate *date1;
// The end date of the range
@property (strong, nonatomic) NSDate *date2;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckinDay;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckinTime;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckoutDay;
@property (weak, nonatomic) IBOutlet UILabel *lblCeckoutTime;

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;

@property (weak, nonatomic) IBOutlet UIView *viewCheckinBottomLine;




@end

@implementation StayDateTimeViewController
@synthesize calendar;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    calendarForFormating = [[NSCalendar alloc] initWithCalendarIdentifier:currentCalendar.calendarIdentifier];

    
    selectedTimeIndexCheckin = 0;
    selectedTimeIndexCheckOut = -1;

    weekdaysArray = [[NSMutableArray alloc] init];
    [weekdaysArray addObject:@"Sun"];
    [weekdaysArray addObject:@"Mon"];
    [weekdaysArray addObject:@"Tue"];
    [weekdaysArray addObject:@"Wed"];
    [weekdaysArray addObject:@"Thu"];
    [weekdaysArray addObject:@"Fri"];
    [weekdaysArray addObject:@"Sat"];
    timeSlotsArray = [[NSMutableArray alloc] init];
    
    NSTimeZone* destinationTimeZone     = [NSTimeZone systemTimeZone];
   dateformater       = [[NSDateFormatter alloc] init];
    // [dateformater                         setLocale:[NSLocale currentLocale]];
    // [dateformater                         setDateStyle:NSDateFormatterMediumStyle];//set current locale
    // [dateformater                         setTimeStyle:NSDateFormatterShortStyle];
    [dateformater  setTimeZone:destinationTimeZone];

    
    self.monthFormatter = [[NSDateFormatter alloc] init];
    self.monthFormatter.dateFormat = @"LLL yyyy";

    
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
    _lblTitle.superview.layer.shadowOpacity = 0.3;
    _lblTitle.superview.layer.shadowRadius = 2.0;
    _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    
    
    
    // Do any additional setup after loading the view.
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
     //
    //
    
    calendar.today = [NSDate date]; // Hide the today circle
    //
    _lblMonth.textColor = kColorDarkBlueThemeColor;
    calendar.appearance.titleDefaultColor = _lblMonth.textColor;
    calendar.appearance.titleSelectionColor = [UIColor whiteColor];
    calendar.appearance.titleDefaultColor = _lblMonth.textColor;
    calendar.appearance.headerTitleColor = _lblMonth.textColor;
    
    calendar.appearance.titleTodayColor = _lblMonth.textColor;
    calendar.appearance.todaySelectionColor = [UIColor blackColor];
    
    
    
    calendar.delegate = self;
    
    calendar.dataSource = self;
    calendar.pagingEnabled = NO;
    calendar.weekdayHeight = 0;
    calendar.rowHeight = 35.0;
    
    calendar.headerHeight = calendar.rowHeight;
    //       calendar.appearance.borderRadius = 20.;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
//    calendar.allowsSelection = TRUE;
    calendar.swipeToChooseGesture.enabled = YES;
    
    [calendar registerClass:[RangePickerCell class] forCellReuseIdentifier:@"cell"];
    
//    calendar.layer.borderColor = [UIColor redColor].CGColor;
//    calendar.layer.borderWidth = 2.;
    _lblMonth.font = [UIFont fontWithName:FontRegular size:16];
    calendar.appearance.titleFont = _lblMonth.font;
    calendar.appearance.headerTitleFont = _lblMonth.font;
 
    if (_isMonthlySelected) {
        self.date1 =[NSDate date];
        self.date2 = [self.date1 dateByAddingTimeInterval:30*24*60*60];
        calendar.allowsMultipleSelection = YES;
        _lblMonth.superview.hidden = TRUE;
        self.calendarHeightConstraint.constant = _btnSearch.frame.origin.y - calendar.frame.origin.y - 15.;
        [calendar selectDate:self.date2];
        [calendar selectDate:self.date1];

    }
    else
    {
        _viewTimeContainer.hidden = FALSE;
        _lblMonth.superview.hidden = FALSE;

        self.calendarHeightConstraint.constant = calendar.rowHeight*6.+3;
         calendar.allowsMultipleSelection = NO;

        self.date2 = self.date1;
        calendar.pagingEnabled = TRUE;
        
        
        
        [self addTimeSlots:[NSDate date]];
        float yoff = calendar.frame.origin.y+self.calendarHeightConstraint.constant + _constriantTimeSelectionTop.constant + _cvTime.superview.frame.origin.y+_cvTime.superview.frame.size.height+_btnSearch.frame.origin.y+_btnSearch.frame.size.height;
        yoff = yoff+[Commons getBottomSafeArea]+17.; //17 is the bottom spacing
        if (yoff > [UIScreen mainScreen].bounds.size.height)
        {
            yoff = calendar.frame.origin.y+self.calendarHeightConstraint.constant;
            int off =0;
            while (1) {
                if (off>=_constriantTimeSelectionTop.constant) {
                    break;
                }
                yoff = calendar.frame.origin.y+self.calendarHeightConstraint.constant  + _cvTime.superview.frame.origin.y+_cvTime.superview.frame.size.height+_btnSearch.frame.origin.y+_btnSearch.frame.size.height+off;
                yoff = yoff+[Commons getBottomSafeArea]+17.+off;
                if (yoff > [UIScreen mainScreen].bounds.size.height)
                {
                    break;
                }
                off++;
            }
         /*   int pp = 0;
            while (1)
            {
                int jj=15;
                int pp = off-jj;

                if (off-jj-- <0) {
                    break;
                }
                if (jj<0) {
                    break;;
                }
            }*/
            _constriantTimeSelectionTop.constant = off;
        }
        NSDate *currentPageDate = calendar.currentPage;
        NSString *dateStr = [self.monthFormatter stringFromDate:currentPageDate];
        
        _lblMonth.text = dateStr;

        
        _cvTime.delegate = self;
        _cvTime.dataSource = self;
        [_cvTime reloadData];
       // _btnSearch.enabled = TRUE;
      //
        //[self setCheckinLabelsTitle];


    }
    [self setCheckinLabelsTitle];


    _lblMonth.textAlignment = NSTextAlignmentCenter;
    [self addingWeekViews];
    [self moveBottomSelctionToCheckin:TRUE withAnim:FALSE];
    self.view.backgroundColor = kColorProfilePages;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    
    if (!firsTimeFlagForCalSelection) {
        firsTimeFlagForCalSelection = TRUE;
        [calendar selectDate:[NSDate date]];
        
    }
    
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (_isMonthlySelected) {

           
           self.calendarHeightConstraint.constant = _btnSearch.frame.origin.y - calendar.frame.origin.y - 15.;
             
         }
}
 
-(void)addingWeekViews
{
    float wdth = [UIScreen mainScreen].bounds.size.width - 2*_viewWeekContainer.frame.origin.x;
    wdth = wdth/weekdaysArray.count;
    
    for (int i=0;i<weekdaysArray.count;i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(i*wdth, 0, wdth, _viewWeekContainer.frame.size.height)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = weekdaysArray[i];
        lbl.font = _lblMonth.font;
        lbl.textColor = _lblMonth.textColor;
        [_viewWeekContainer addSubview:lbl];
        
    }
}
- (IBAction)backBtnClikd:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
-(void)moveBottomSelctionToCheckin:(BOOL)isCheckin withAnim:(BOOL)isAnim
{
    CGRect frame = _viewCheckinBottomLine.frame;
    frame.size.height = 2.;
    frame.origin.y= _viewCheckinBottomLine.superview.frame.size.height-frame.size.height;
    if (isCheckin) {
        frame.origin.x = _lblCheckinDay.superview.frame.origin.x;

    }
    else
    {
        frame.origin.x = _lblCheckoutDay.superview.frame.origin.x;

    }
    frame.size.width  = _lblCheckoutDay.superview.frame.size.width;
    
    if (!isAnim) {
        _viewCheckinBottomLine.frame = frame;
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
                    _viewCheckinBottomLine.frame = frame;

        }];
    }
    isCheckinTimeSelected = isCheckin;
    if (!_isMonthlySelected) {
         
  
    int indx = 0;
    if (isCheckin) {
        tempTimeStringSelected = fromTimeStringForHourly;

        if (firstTimeNotClaing) {
            [self addTimeSlots:selectedFromDate];

        }
        if (!_isMonthlySelected) {
            if (self.date1) {
                [calendar deselectDate:self.date1];

            }

        }
        self.date1 = selectedFromDate;
     //   if ([timeSlotsArray containsObject:fromTimeStringForHourly])
        {
            NSArray *ar =[timeSlotsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"time == %@",fromTimeStringForHourly]];
            if (ar.count>0) {
                indx = (int)[timeSlotsArray indexOfObject:[ar firstObject]];

            }
        }

    }
    else{
        tempTimeStringSelected = toTimeStringForHourly;

        if (firstTimeNotClaing) {

        [self addTimeSlots:selectedToDate];
        }
        if (!_isMonthlySelected) {
            if (self.date1) {
                [calendar deselectDate:self.date1];

            }
        }
        self.date1 = selectedToDate;
        
        //if ([timeSlotsArray containsObject:toTimeStringForHourly])
        {
            NSArray *ar =[timeSlotsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"time == %@",toTimeStringForHourly]];

            if (ar.count>0) {
                indx = (int)[timeSlotsArray indexOfObject:[ar firstObject]];

            }
            
        }

    }
    if (firstTimeNotClaing) {

    [calendar reloadInputViews];

    [calendar reloadData];
        if (!_isMonthlySelected) {
            if (self.date1) {
                [calendar selectDate:self.date1];

            }
        }
    }
    firstTimeNotClaing = TRUE;
    [_cvTime reloadData];
        [_cvTime scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indx inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:FALSE];  }
    else
    {
        if (isCheckinTimeSelected) {
            tempDateSelectedFromCal = selectedFromDate;
        }
        else
        {
            tempDateSelectedFromCal = selectedToDate;

        }
    }
}
- (IBAction)checkoutTimeSelectionClikd:(id)sender {
    [self moveBottomSelctionToCheckin:FALSE withAnim:TRUE];

}
- (IBAction)checkinTimeSelctionClikd:(id)sender {
    [self moveBottomSelctionToCheckin:TRUE withAnim:TRUE];

}
- (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day]+1;
}
-(void)settingTheTitles
{
    if (_isMonthlySelected)
    {
        if (self.date1) {
                _lblCheckinDay.text = [self stringFromDate:self.date1 Format:kdateFormatCheckInDayFormat];

        }
        if (self.date2) {
             _lblCheckoutDay.text = [self stringFromDate:self.date2 Format:kdateFormatCheckInDayFormat];

        }
    }
    else{
        _lblCheckinDay.text = [self stringFromDate:selectedFromDate Format:kdateFormatCheckInDayFormat];
        _lblCheckoutDay.text =[self stringFromDate:selectedToDate Format:kdateFormatCheckInDayFormat];
        _lblCheckinTime.text =[self stringFromDate:selectedFromDate Format:kdateFormatCheckInTimeFormat];
        _lblCeckoutTime.text =[self stringFromDate:selectedToDate Format:kdateFormatCheckInTimeFormat];
    }
}
-(void)setCheckinLabelsTitle
{
    _lblCeckoutTime.text = @"";
    _lblCheckinTime.text = @"";
    _lblCheckinDay.text = @"";
    _lblCheckoutDay.text = @"";
    if (_isMonthlySelected)
    {
        _lblCeckoutTime.text = @"";
        _lblCheckinTime.text = @"";
     /*   if (self.date1&&self.date2) {
            if([self.date1 compare: self.date2] == NSOrderedDescending) // if start is later in time than end
            {
                NSDate *date;

                date = self.date1;
                self.date1 = self.date2;
                self.date2 = date;
                // do something
            }
        }*/
     //   [self settingTheTitles];
        if ([_lblCheckinDay.text isEqualToString:_lblCheckoutDay.text]) {
            _lblCheckoutDay.text = @"";
        }
        int days = [self daysBetween:self.date1 and:self.date2];
        if (days<30)
        {
            if (isCheckinTimeSelected)
            {
                [calendar deselectDate:self.date2];

                self.date2 = [self.date1 dateByAddingTimeInterval:30*24*60*60];
              //  selectedToDate = self.date2;
                [calendar selectDate:self.date2];
                _btnSearch.enabled = TRUE;


            }
            else{
                [calendar deselectDate:self.date2];
                self.date2 = tempDateSelectedFromCal;
                [calendar selectDate:self.date2];
                _btnSearch.enabled = TRUE;

            }
            [calendar reloadInputViews];
            [calendar reloadData];

            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"For monthly bookings Check-out date should be 30 days later than the Check-in date";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }
        else
        {
            _btnSearch.enabled = TRUE;


        }

    }
    else
    {
  
      //  int days = [self daysBetween:self.date1 and:self.date2];
        NSTimeInterval secondsBetween = [selectedToDate timeIntervalSinceDate:selectedFromDate];
        int indx = 0;

       if (secondsBetween>=3*60*60)
       // if (secondsBetween>=0.5*60)
    {
            _btnSearch.enabled = TRUE;
 
        }
        else{
         //   [calendar deselectDate:self.date1];
            if (isCheckinTimeSelected)
            {
               // [calendar deselectDate:selectedToDate];

                selectedToDate =[selectedFromDate dateByAddingTimeInterval:3*60*60];

                toTimeStringForHourly = [self stringFromDate:selectedToDate Format:kdateFormatCheckInTimeFormat];
                self.date1 = selectedFromDate;
//                if (calendar.selectedDates) {
//                    for (NSDate *dt in  calendar.selectedDates) {
//                        [calendar deselectDate:dt];
//
//                    }
//                }
 
                 _btnSearch.enabled = TRUE;
                NSArray *ar =[timeSlotsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"time == %@",fromTimeStringForHourly]];

                if (ar.count>0) {
                    indx = (int)[timeSlotsArray indexOfObject:[ar firstObject]];

                }

                
            }
            else{
               // [calendar deselectDate:selectedToDate];

             //   toTimeStringForHourly = tempTimeStringSelected ;
            //    selectedToDate = [self getDateFromSelectedDate:tempDateSelectedFromCal time:toTimeStringForHourly];;

                selectedToDate =[selectedFromDate dateByAddingTimeInterval:3*60*60];

                toTimeStringForHourly = [self stringFromDate:selectedToDate Format:kdateFormatCheckInTimeFormat];

             //   [calendar deselectDate:self.date1];

                 self.date1 = selectedToDate;
//                if (calendar.selectedDates) {
//                    for (NSDate *dt in  calendar.selectedDates) {
//                        [calendar deselectDate:dt];
//
//                    }
//                }
                 _btnSearch.enabled = TRUE;
                [self addTimeSlots:self.date1];

                NSArray *ar =[timeSlotsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"time == %@",toTimeStringForHourly]];

                if (ar.count>0) {
                    indx = (int)[timeSlotsArray indexOfObject:[ar firstObject]];

                }

            }
                            if (calendar.selectedDates) {
                                for (NSDate *dt in  calendar.selectedDates) {
                                    [calendar deselectDate:dt];
            
                                }
                            }
            [calendar selectDate:self.date1];
            [calendar reloadInputViews];
            [calendar reloadData];

            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
          //  vc.messageString=@"Check-out date should be later than the Check-in date";
            vc.messageString=@"For hourly bookings Check-out time should be minimum 3 hours later than the Check-in time";
           // vc.messageString=@"For hourly bookings Check-out time should be later than the Check-in time";

            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
            [_cvTime reloadData];
            [_cvTime scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indx inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:FALSE];

 
        }

    }
    [self settingTheTitles];

}
-(void)gotoSelectGuestPage{
    SelectGuestsViewController *sd =[self.storyboard instantiateViewControllerWithIdentifier:@"SelectGuestsViewController"];
    sd.placeName = _placeName;
    sd.latitude = _latitude;
    sd.longitude = _longitude;
    sd.formattedAddress = _formattedAddress;
    sd.isMonthlySelected = _isMonthlySelected;
    sd.isHotelSelected = _isHotelSelected;
       sd.selectedHotel = _selectedHotel;
    if (_isMonthlySelected ==TRUE) {
        BOOL today = [[NSCalendar currentCalendar] isDateInToday:self.date1];
        if (today)
        {
            sd.startTime = [self getDateFromSelectedDate:self.date1 time:[self getNextNearestTime:self.date1]];

        }
        else
        {
            sd.startTime = [self getDateFromSelectedDate:self.date1 time:@"00:00"];

        }
        sd.endTime = [self getDateFromSelectedDate:self.date2 time:@"23:30"];

       //  sd.endTime = self.date2;

    }
    else{
        sd.startTime = selectedFromDate;
        sd.endTime = selectedToDate;;

    }
    sd.cityIdString =_cityIdString;
    sd.selectionString = _selectionString;

    [self.navigationController pushViewController:sd animated:TRUE];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)searchHotelCLikd:(id)sender {
    
    if (_isMonthlySelected == FALSE) {
         NSLog(@"start %@ end %@",selectedFromDate,selectedToDate);

    }
    else
        
    {
        NSLog(@"start %@ end %@",self.date1,self.date2);

    }
    [self gotoSelectGuestPage];

}
-(NSDate*)getDateFromSelectedDate:(NSDate*)dt time:(NSString*)time
{
    NSDate *dateInitial = dt;
  //  NSLog(@"%@", dateInitial); // 2014-02-20 11:36:20 +0000
  //  calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSUInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [calendarForFormating components:flags fromDate:dateInitial];
    NSArray *timeAr =[time componentsSeparatedByString:@":"];
    [components setHour:[[timeAr firstObject] intValue]];
    [components setMinute:[[timeAr lastObject] intValue]];
    [components setSecond:0];

    dateInitial = [Commons getDateFromString:[NSString stringWithFormat:@"%@ %@",[self stringFromDate:dt Format:@"yyyy-MM-dd"],time] Format:@"yyyy-MM-dd HH:mm"];
    if (!dateInitial) {
        dateInitial = [Commons getDateFromString:[NSString stringWithFormat:@"%@ %@",[self stringFromDate:dt Format:@"yyyy-MM-dd"],time] Format:@"yyyy-MM-dd hh:mm a"];

    }
    return dateInitial;
}
-(NSString*)getNextNearestTime:(NSDate*)date1
{
    NSDate *dateInitial = date1;
  //  NSLog(@"%@", dateInitial); // 2014-02-20 11:36:20 +0000
  //  calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSUInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* components = [calendarForFormating components:flags fromDate:dateInitial];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];

    dateInitial = [calendarForFormating dateFromComponents:components];
    NSString *dt =    [self stringFromDate:dateInitial Format:@"dd"];
   // NSLog(@"111 dateInitial %@", dateInitial); // 2014-02-20 00:00:00 +0000
    NSDate *curDate =[NSDate date];
    NSString *timeStringL=@"";
    while (1)
    {
        if (![[self stringFromDate:dateInitial Format:@"dd"] isEqualToString:dt]) {
            break;
        }
        if([dateInitial compare: curDate] == NSOrderedDescending) // if dateInitial is later in time than curnt date
        {
            timeStringL = [self stringFromDate:dateInitial Format:@"HH:mm"];
            // do something
           // NSLog(@" adding---- dateInitial %@", dateInitial); // 2014-02-20 00:00:00 +0000

        }
       else
       {
          // NSLog(@"not adding---- dateInitial %@", dateInitial); // 2014-02-20 00:00:00 +0000

       }
        dateInitial = [dateInitial dateByAddingTimeInterval:30*60];
        if (timeStringL.length>0) {
            break;
        }
    }
   // NSLog(@"222 dateInitial %@", dateInitial); // 2014-02-20 00:00:00 +0000

    if (timeStringL.length==0) {
        timeStringL = @"23:30";


    }
    return timeStringL;
}
-(void)addTimeSlots:(NSDate*)date1
{
    
    if(!date1)
        return;
      
    [timeSlotsArray removeAllObjects];
    NSDate *dateInitial = date1;
    NSDate *curDate =[NSDate date];

    
  //  NSLog(@"%@", dateInitial); // 2014-02-20 11:36:20 +0000
  //  calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSUInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay| NSCalendarUnitHour| NSCalendarUnitMinute;
    NSDateComponents* components = [calendarForFormating components:flags fromDate:dateInitial];
    
//    NSLog(@"111 hour %d", [components hour]);
//    NSLog(@"111 hour %d", [components minute]);

    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    

    dateInitial = [calendarForFormating dateFromComponents:components];
    NSString *dt =    [self stringFromDate:dateInitial Format:@"dd"];
    NSLog(@"111 dateInitial %@", dateInitial);// 2014-02-20 00:00:00 +0000
    NSLog(@"111 curDate %@", curDate);
    
    
    
    

    while (1)
    {
        if (![[self stringFromDate:dateInitial Format:@"dd"] isEqualToString:dt]) {
            break;
        }
        if([dateInitial compare: curDate] == NSOrderedDescending) // if dateInitial is later in time than curnt date
        {
            // do something
            [timeSlotsArray addObject:@{@"time":[self stringFromDate:dateInitial Format:kdateFormatCheckInTimeFormat],@"date":dateInitial}];
            NSLog(@" adding---- dateInitial %@", dateInitial); // 2014-02-20 00:00:00 +0000

        }
       else
       {
           NSLog(@"not adding---- dateInitial %@", dateInitial); // 2014-02-20 00:00:00 +0000

       }
        dateInitial = [dateInitial dateByAddingTimeInterval:30*60];

    }
   // NSLog(@"222 dateInitial %@", dateInitial); // 2014-02-20 00:00:00 +0000


    if (timeSlotsArray.count==0) {
        [components setDay: [components day]+1];
            [components setHour:00];
            [components setMinute:00];
        //CJC 13 commented..
        dateInitial = [calendarForFormating dateFromComponents:components];
        [timeSlotsArray addObject:@{@"time":[self stringFromDate:dateInitial Format:kdateFormatCheckInTimeFormat],@"date":dateInitial}];

        NSLog(@"kk dateInitial %@", dateInitial);// 2014-02-20 00:00:00 +0000

        NSLog(@"kk dateInitial %@", timeSlotsArray);// 2014-02-20 00:00:00 +0000

    }
    if (!selectedFromDate && [timeSlotsArray count]> 0)//CJC 13
    {
        selectedFromDate = [self getDateFromSelectedDate:[timeSlotsArray firstObject][@"date"] time:[timeSlotsArray firstObject][@"time"]];
        selectedToDate =[selectedFromDate dateByAddingTimeInterval:3*60*60];
        
        NSLog(@"kk dateInitial %@", selectedFromDate);// 2014-02-20 00:00:00 +0000
        NSLog(@"kk dateInitial %@", selectedToDate);// 2014-02-20 00:00:00 +0000

        
        fromTimeStringForHourly =timeSlotsArray[0][@"time"];
        toTimeStringForHourly = [self stringFromDate:selectedToDate Format:kdateFormatCheckInTimeFormat];
        self.date1 = selectedFromDate;
        [_cvTime setContentOffset:CGPointZero];
    }
    [_cvTime reloadData];
    

   // NSLog(@"%@", timeSlotsArray); // 2014-02-20 00:00:00 +0000

}
#pragma mark - FSCalendarDataSource

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    self.calendarHeightConstraint.constant = CGRectGetHeight(bounds);
    // Do other updates here
    [self.view layoutIfNeeded];
}



- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate date];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:12 toDate:[NSDate date] options:0];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        // return @"今";
    }
    return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    RangePickerCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return NO;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    //    self.date1 = date;
    //    self.date2 = date;
    //    if (self.date1) {
    //         [calendar deselectDate:self.date1];
    //
    //    }
    //    if (self.date2) {
    //            [calendar deselectDate:self.date2];
    //
    //       }
    if (_isMonthlySelected==FALSE)
    {
        for (NSDate *dt in  calendar.selectedDates) {
            [calendar deselectDate:dt];

        }
        if (isCheckinTimeSelected) {
         //   [calendar deselectDate:selectedFromDate];

            selectedFromDate = [self getDateFromSelectedDate:date time:fromTimeStringForHourly];;

        }
        else
        {

            selectedToDate = [self getDateFromSelectedDate:date time:toTimeStringForHourly];;

        }
        self.date1 = date;
        [calendar selectDate:self.date1];

        [self addTimeSlots:date];
        [self moveBottomSelctionToCheckin:isCheckinTimeSelected withAnim:FALSE];

    }
    else{

        if (self.date1&&isCheckinTimeSelected) {
            tempDateSelectedFromCal  = self.date1;

            [calendar deselectDate:self.date1];

        }
        if (self.date2&&!isCheckinTimeSelected) {
            tempDateSelectedFromCal  = self.date2;

            [calendar deselectDate:self.date2];

        }
        
    if (calendar.swipeToChooseGesture.state == UIGestureRecognizerStateChanged) {
        // If the selection is caused by swipe gestures
        if (!self.date1) {
            self.date1 = date;
        } else {
            if (self.date2) {
                [calendar deselectDate:self.date2];
            }
            self.date2 = date;
        }
    } else {
       
        if (isCheckinTimeSelected) {
            self.date1 = date;

        }
        else{
            self.date2 = date;

        }
       /* if (self.date2) {
            [calendar deselectDate:self.date1];
            [calendar deselectDate:self.date2];
            self.date1 = date;
            self.date2 = nil;
        } else if (!self.date1) {
            self.date1 = date;
        } else {
            self.date2 = date;
        }*/
    }
    }

  
    if (self.date1 && self.date2) {
       /* if([self.date1 compare: self.date2] == NSOrderedDescending) // if start is later in time than end
        {
            NSDate *date;

            date = self.date1;
            self.date1 = self.date2;
            self.date2 = date;
            // do something
        }*/
    }
  
    NSLog(@"self.date1 %@ self.date2 %@",self.date1,self.date2);
    [self configureVisibleCells];
    [self setCheckinLabelsTitle];
    if (_isMonthlySelected) {
//        [calendar reloadInputViews];
//
//        [calendar reloadData];
        
   }
    
    
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor redColor]];
    }
    return @[appearance.eventDefaultColor];
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
        
        
    }];
    
    //   NSLog(@"configureVisibleCells deselect date1 %@ self.date2 %@",self.date1,self.date2);
    
}

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    
    RangePickerCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent) {
        rangeCell.middleLayer.hidden = YES;
        rangeCell.selectionLayer.hidden = YES;
        return;
    }
    CGRect frame = cell.contentView.bounds;
      float sizzz = MIN(frame.size.height, frame.size.width);
      
      frame.origin.x = frame.size.width/2. - sizzz/2.;
      frame.origin.y = frame.size.height/2. - sizzz/2.;

      frame.size.width = sizzz;
      frame.size.height = sizzz;
      rangeCell.selectionLayer.frame = frame;
    rangeCell.selectionLayer.masksToBounds = TRUE;
    rangeCell.selectionLayer.cornerRadius = frame.size.height/2.;
    
    if (self.date1 && self.date2) {
        NSDate *date1 = self.date1;
        NSDate *date2 = self.date2;

        if([date1 compare: date2] == NSOrderedDescending) // if start is later in time than end
         {
             NSDate *datetemp;

             datetemp = date1;
             date1 = date2;
             date2 = datetemp;
             // do something
         }
        
        if (_isMonthlySelected==FALSE)
        {
            rangeCell.middleLayer.hidden = YES;

        }
        else{
        // The date is in the middle of the range
        BOOL isMiddle = [date compare:date1] != [date compare:date2];
       rangeCell.middleLayer.hidden = !isMiddle;
        CGRect frame  = rangeCell.middleLayer.frame;
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
         //   BOOL sameDay = [currentCalendar isDate:self.date1 inSameDayAsDate:date];

        if ([currentCalendar isDate:date1 inSameDayAsDate:date]) {

            frame.size.width = cell.contentView.bounds.size.width/2.;
            frame.origin.x = cell.contentView.bounds.size.width/2.;
            rangeCell.middleLayer.hidden = FALSE;

        }
        else if ([currentCalendar isDate:date2 inSameDayAsDate:date]) {
            frame.size.height = sizzz;

            frame.size.width = cell.contentView.bounds.size.width/2.;
            frame.origin.x = 0;
            rangeCell.middleLayer.hidden = FALSE;


        }
        else{
            frame.size.width = cell.contentView.bounds.size.width;
            frame.origin.x = 0.;

        }
            
        frame.origin.y = cell.contentView.bounds.size.height/2. - sizzz/2.;

        frame.size.height = sizzz;
        rangeCell.middleLayer.frame = frame;
        }

    } else {
        rangeCell.middleLayer.hidden = YES;
    }
    BOOL isSelected = NO;
    isSelected |= self.date1 && [self.gregorian isDate:date inSameDayAsDate:self.date1];
    isSelected |= self.date2 && [self.gregorian isDate:date inSameDayAsDate:self.date2];
    rangeCell.selectionLayer.hidden = !isSelected;
    
    
}
  - (void)calendarCurrentMonthDidChange:(FSCalendar *)calendar
    {
        // Do something
        
        NSDate *currentPageDate = calendar.currentPage;
        
        NSString *dateStr = [self.monthFormatter stringFromDate:currentPageDate];
        
        _lblMonth.text = dateStr;
 
    }
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSDate *currentPageDate = calendar.currentPage;
    
    NSString *dateStr = [self.monthFormatter stringFromDate:currentPageDate];
    
    _lblMonth.text = dateStr;
 
    
}
-(NSString *)stringFromDate:(NSDate *) date Format:(NSString *)format{
    if(!date){
        return @"";
    }
    [dateformater setDateFormat:format];

    return  [dateformater stringFromDate:date];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return timeSlotsArray.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"timecellNew" forIndexPath:indexPath];
    UILabel *lbl = [cell viewWithTag:1];
    lbl.text = timeSlotsArray[indexPath.row][@"time"];
    BOOL issel =FALSE;
    if (isCheckinTimeSelected) {
        if ([lbl.text isEqualToString:fromTimeStringForHourly]) {
            issel = TRUE;

        }
        else{
            issel = FALSE;

        }

    }
    else{
        if ([lbl.text isEqualToString:toTimeStringForHourly]) {
            issel = TRUE;

        }
        else{
            issel = FALSE;

        }
    }

    if (issel) {
         lbl.backgroundColor = kColorRedThemeColor;
        cell.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];

    }
    else
    {
        lbl.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor blackColor];

    }
 

    cell.clipsToBounds =TRUE;
    cell.layer.cornerRadius = 5.0;
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    tempTimeStringSelected =timeSlotsArray[indexPath.item][@"time"];
    if (isCheckinTimeSelected) {
        tempDateSelectedFromCal  = selectedFromDate;

        fromTimeStringForHourly =timeSlotsArray[indexPath.item][@"time"];

        selectedFromDate = [self getDateFromSelectedDate:selectedFromDate time:fromTimeStringForHourly];

    }
    else
    {
        tempDateSelectedFromCal  = selectedToDate;

        toTimeStringForHourly =timeSlotsArray[indexPath.item][@"time"];
        selectedToDate = [self getDateFromSelectedDate:selectedToDate time:toTimeStringForHourly];

    }
    [self setCheckinLabelsTitle];
   
    [collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(68., collectionView.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 35;
}

@end
