//
//  BookingCompletedViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 28/10/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "BookingCompletedViewController.h"

@interface BookingCompletedViewController ()

@end

@implementation BookingCompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    contineButton.clipsToBounds=YES;
    contineButton.layer.cornerRadius=4;
    
    
    [self loadBasicInfo];
    
    // Do any additional setup after loading the view.
}

-(IBAction)continueFunction:(id)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"NO" forKey:@"pushClick"];
    [defaults synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"bookingDone" object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)loadBasicInfo
{
    bookingIDLBL.text=_bookingIDVAl;
    propertyNameLBL.text=self.proName;
    
    
    
    
    NSString *roomsString=@"ROOM";
    NSString *adultsString=@"ADULT";
    NSString *childString=@"CHILD";
    
if([self.rooCount integerValue]>1)
{
    roomsString=@"ROOMS";
}
if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"] integerValue]>1)
{
    adultsString=@"ADULTS";
}
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedChild"] integerValue]>1)
    {
        childString=@"CHILDREN'S";
    }
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedChild"] integerValue]!=0)
    
    personsLBL.text= [NSString stringWithFormat:@"%@ %@, %@ %@, %@ %@",self.rooCount,roomsString,[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"],adultsString,[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedChild"],childString];
    else
          personsLBL.text= [NSString stringWithFormat:@"%@ %@, %@ %@",self.rooCount,roomsString,[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"],adultsString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *selectedDate=[dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedDate"] ];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MMM dd"];
    [dateFormatter2 setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc]init];
    [dateFormatter3 setDateFormat:@"MMMM dd, yyyy"];
    [dateFormatter3 setTimeZone:[NSTimeZone localTimeZone]];
    NSString* nextDayString2=[dateFormatter3 stringFromDate:selectedDate];
    dateLBL.text=nextDayString2;
    
    NSString* checkinTime=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"];
    checkinTime= [checkinTime stringByReplacingOccurrencesOfString:@":" withString:@"."];
    
    [dateFormatter3 setDateFormat:@"HH:mm"];
    
    NSDate*datePassed=[dateFormatter3 dateFromString:checkinTime];
    [dateFormatter3 setDateFormat:@"hh:mm"];
    NSString*selectedTime=[dateFormatter3 stringFromDate:datePassed];
    
    [dateFormatter3 setDateFormat:@"hh:mm a"];
    NSString*amOrPm=[dateFormatter3 stringFromDate:datePassed];
    if([amOrPm containsString:@"AM"])
        checkintimeLBL.text=[NSString stringWithFormat:@"%@ AM",selectedTime];
    else
        checkintimeLBL.text=[NSString stringWithFormat:@"%@ PM",selectedTime];
    
    hourLBL.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"] ];
    
    //   chekinTimeLBL.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"];
   
    totalLBL.text=self.totalPrice;
    paidLBL.text=self.paid;
    balanceLBL.text=self.balance;
    
    
    
    
}
@end
