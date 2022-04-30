//
//  FiltersViewController.m
//  Stayhopper
//
//  Created by iROID Technologies on 10/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "FiltersViewController.h"
#import "MARKRangeSlider.h"
#import "FilterTableViewCell.h"
@interface FiltersViewController ()
{
    IBOutlet NSLayoutConstraint *spacingConstant;
    FilterTableViewCell *cell;
}
@property (nonatomic, strong) MARKRangeSlider *rangeSlider;
@end

@implementation FiltersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    filterSelectionArray=[[NSMutableArray alloc]init];
    
[self.ratingTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.rangeSlider = [[MARKRangeSlider alloc] initWithFrame:CGRectZero];
    [self.rangeSlider addTarget:self
                         action:@selector(rangeSliderValueDidChange:)
               forControlEvents:UIControlEventValueChanged];
    
    [self.rangeSlider setMinValue:[self.minString floatValue] maxValue:[self.maxString floatValue]];
    
    
    
    [self.rangeSlider setLeftValue:[[[NSUserDefaults standardUserDefaults] objectForKey:@"minSelected"] floatValue] rightValue:[[[NSUserDefaults standardUserDefaults] objectForKey:@"maxSelected"] floatValue]];
    
    self.rangeSlider.minimumDistance = 1;
    
    [self.sliderView addSubview:self.rangeSlider];
    self.slider1.hidden=YES;
    
    selectedIndex=-1;
    selectedSection=-1;
    selectedCatogary=-1;
  //  slider_right_arrow
    
    self.rangeSlider.leftThumbImage=[UIImage imageNamed:@"RADIODUMMY"];
    self.rangeSlider.rightThumbImage=[UIImage imageNamed:@"RADIODUMMY"];
    
    self.slider1.frame=CGRectMake(self.slider1.frame.origin.x, self.slider1.frame.origin.y, [[UIScreen mainScreen] bounds].size.width-40, self.slider1.frame.size.height);
    
    
    self.rangeSlider.frame=self.slider1.frame;
    self.rangeSlider.center=self.slider1.center;
    
    selectedCatogary=-1;
    [self loadApi];
    spacingConstant.constant=0;
    self.sliderLBl.text=[NSString stringWithFormat:@"%.0f AED - %.0f AED",self.rangeSlider.leftValue, self.rangeSlider.rightValue];
    currentString=[NSString stringWithFormat:@"%@price=%@",self.valueString,[NSString stringWithFormat:@"%@,%@",self.minString,self.maxString]];
    selectionString=[NSString stringWithFormat:@"AED %@-%@",self.minString,self.maxString];
}

-(IBAction)proceedAction:(id)sender
{

    
    BOOL multiple=NO;;
    int kk=0;
    currentString=[NSString stringWithFormat:@"%@price=%@",self.valueString,[NSString stringWithFormat:@"%.0f,%.0f",self.rangeSlider.leftValue, self.rangeSlider.rightValue]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"price=%@",[NSString stringWithFormat:@"%.0f,%.0f",self.rangeSlider.leftValue, self.rangeSlider.rightValue]] forKey:@"priceSelected"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    selectionString=[NSString stringWithFormat:@"AED %.0f - %.0f",self.rangeSlider.leftValue, self.rangeSlider.rightValue];

    if([self.minString floatValue]!=self.rangeSlider.leftValue)
    {
        multiple=YES;
        kk=1;
    }
    if([self.maxString floatValue]!=self.rangeSlider.rightValue)
    {
        multiple=YES;
        kk=1;

    }
    NSString*serviceString=@"";
    
    BOOL servicemultiple=NO;;
    BOOL ratingmultiple=NO;;

    if(self.serviceArrayPassed.count>0)
    {
        kk=kk+1;
        selectionString=@"Services";
    }
    for(NSString* str in self.serviceArrayPassed)
    {
        
        servicemultiple=YES;
       // kk=kk+1;
        if(serviceString.length==0)
        {
            serviceString=str;;
        }
        else
        {
         serviceString=   [serviceString stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
        }
    
    
    }
    
    
    if(serviceString.length!=0)
    {
        currentString=[NSString stringWithFormat:@"%@&service=%@",currentString,serviceString];
    }
    
    
    NSString*ratingString=@"";
    
    if(self.ratingArrayPassed.count>0)
    {
        kk=kk+1;
        selectionString=@"Ratings";

    }
    for(NSString* str in self.ratingArrayPassed)
    {
        ratingmultiple=YES;

        if(ratingString.length==0)
        {
            ratingString=str;;
        }
        else
        {
            ratingString=   [ratingString stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
        }
        
        
    }
    
    
    if(ratingString.length!=0)
    {
        currentString=[NSString stringWithFormat:@"%@&rating=%@",currentString,ratingString];
    }
    if(kk>1)
    {
        selectionString=@"Multiple";
    }
    
    [self.delegate filterFunctionByString:currentString value:selectionString];
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(IBAction)closeAction:(id)sender
{
    
    currentString=[NSString stringWithFormat:@"%@",self.valueString];
    selectionString=@"No Filters";
    [self.ratingArrayPassed removeAllObjects];
    [self.serviceArrayPassed removeAllObjects];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"price=%@",[NSString stringWithFormat:@"%@,%@",self.minString, self.maxString]] forKey:@"priceSelected"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.minString forKey:@"minSelected"];
    [[NSUserDefaults standardUserDefaults] setObject:self.maxString forKey:@"maxSelected"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *code = [currentString substringFromIndex: [currentString length] - 1];
    
    if([code isEqualToString:@"&"])
    {
        currentString = [currentString substringToIndex:[currentString length]-1];
        
    }
    [self.delegate filterFunctionByString:currentString value:selectionString];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)loadApi
{
    
    
    
    
        NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
        [self.view endEditing:YES];
        RequestUtil *util = [[RequestUtil alloc]init];
        util.webDataDelegate=(id)self;
        [util postRequest:reqData toUrl: [NSString stringWithFormat: @"general/ratings_and_services"] type:@"GET"];
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(tableView==self.ratingTableView)
    {
        if(selectedCatogary==0)

    return ratingArray.count;
    } else if(tableView==self.serviceTableView)
    {
        if(selectedCatogary==1)
        
        return serviceArray.count;
    }
    return 0;

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//   // if(indexPath.row%2==0)
//        cell.transform = CGAffineTransformMakeTranslation(0.f, 100);
////    else
////        cell.transform = CGAffineTransformMakeTranslation(0, 100);    // cell.transform = CGAffineTransformMakeTranslation(50.f, 100);
//    
//    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    
//    //2. Define the final state (After the animation) and commit the animation
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:0.3];
//    cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
//    cell.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    cell=(FilterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FilterTableViewCell"];
    
//    if(indexPath.row==0)
//        return cell;
//   else
    
    if(tableView==_ratingTableView)
    {
         cell.radioBtn.selected=NO;
    if(selectedCatogary==0)
    {
        {
            BOOL status=YES;
            for(NSString* str in self.ratingArrayPassed)
            {
                if([str isEqualToString: [[ratingArray objectAtIndex:indexPath.row]valueForKey:@"_id"]])
                {
                    status=NO;
                    break;
                }
            }
            if(!status)
                cell.radioBtn.selected=YES;
            
            else
                cell.radioBtn.selected=NO;
            
            
        }    }
    if(indexPath.row==ratingArray.count)
    {
        cell.rateLbl.text=@"Clear All Filters";
    }
    else
        
       cell.rateLbl.text=[[ratingArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    }
    else
    {
        cell.radioBtn.selected=NO;
        if(selectedCatogary==1)
        {
            BOOL status=YES;
            for(NSString* str in self.serviceArrayPassed)
            {
                if([str isEqualToString: [[serviceArray objectAtIndex:indexPath.row]valueForKey:@"_id"]])
                {
                    status=NO;
                    break;
                }
            }
            if(!status)
                cell.radioBtn.selected=YES;

            else
                cell.radioBtn.selected=NO;

            
        }
        if(indexPath.row==serviceArray.count)
        {
            cell.rateLbl.text=@"Clear All Filters";
        }
        else
            
            cell.rateLbl.text=[[serviceArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex=indexPath.row;
    if(tableView==_ratingTableView)
    {
        selectedCatogary=0;

    if(indexPath.row==ratingArray.count)
    {
        currentString=[NSString stringWithFormat:@"%@",self.valueString];
        selectionString=@"No Filters";
        [filterSelectionArray removeAllObjects];
        
    }
    else
    {
        //[filterSelectionArray removeAllObjects];
        
        BOOL status=YES;
        for(NSString* str in self.ratingArrayPassed)
        {
            if([str isEqualToString: [[ratingArray objectAtIndex:indexPath.row]valueForKey:@"_id"]])
            {
                status=NO;
                break;
            }
        }
        if(status)
            [self.ratingArrayPassed addObject:[[ratingArray objectAtIndex:indexPath.row]valueForKey:@"_id"]];
        else
            [self.ratingArrayPassed removeObject:[[ratingArray objectAtIndex:indexPath.row]valueForKey:@"_id"]];
        
        NSString* filterString;
        for(NSString* str in self.ratingArrayPassed)
        {
            if(filterString.length==0)
            {
                filterString=str;
            }
            else
            {
                filterString=[filterString stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
            }
        }
        
        if(filterString!=0)
        {
            currentString=[NSString stringWithFormat:@"%@rating=%@",self.valueString,filterString];
            selectionString=@"Star rating";
        }
        else
        {
            currentString=[NSString stringWithFormat:@"%@",self.valueString];
            selectionString=@"No Filters";
        }
    }

    }
    else
    {
        selectedCatogary=1;

        if(indexPath.row==serviceArray.count)
        {
            currentString=[NSString stringWithFormat:@"%@",self.valueString];
            selectionString=@"No Filters";
            [filterSelectionArray removeAllObjects];

        }
        else
        {
            
            
            BOOL status=YES;
            for(NSString* str in self.serviceArrayPassed)
            {
                if([str isEqualToString: [[serviceArray objectAtIndex:indexPath.row]valueForKey:@"_id"]])
                {
                    status=NO;
                    break;
                }
            }
            if(status)
                [self.serviceArrayPassed addObject:[[serviceArray objectAtIndex:indexPath.row]valueForKey:@"_id"]];
            else
                [self.serviceArrayPassed removeObject:[[serviceArray objectAtIndex:indexPath.row]valueForKey:@"_id"]];
            
            NSString* filterString;
            for(NSString* str in self.serviceArrayPassed)
            {
                if(filterString.length==0)
                {
                    filterString=str;
                }
                else
                {
                    filterString=[filterString stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
                }
            }
            
            if(filterString!=0)
            {
            currentString=[NSString stringWithFormat:@"%@service=%@",self.valueString,filterString];
            selectionString=@"Services";
            }
            else
            {
                currentString=[NSString stringWithFormat:@"%@",self.valueString];
                selectionString=@"No Filters";
            }
        }

    }
    [self.ratingTableView reloadData];

    [self.serviceTableView reloadData];

}

-(void)viewDidAppear:(BOOL)animated
{
    
}
- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider
{
    self.sliderLBl.text=[NSString stringWithFormat:@"%.0f AED - %.0f AED",slider.leftValue, slider.rightValue];
    
    currentString=[NSString stringWithFormat:@"%@price=%@",self.valueString,[NSString stringWithFormat:@"%.0f,%.0f",slider.leftValue, slider.rightValue]];
    selectionString=[NSString stringWithFormat:@"AED %.0f - %.0f",slider.leftValue, slider.rightValue];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.0f",slider.leftValue] forKey:@"minSelected"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.0f@",slider.rightValue] forKey:@"maxSelected"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
    // loadingLBL.text=@"There are no available rooms with your search criteria";
    
   
    
    
}
-(void)webRawDataReceivedWithError:(NSString *)errorMessage
{
    // loadingLBL.text=@"There are no available rooms with your search criteria";
    
    
   
}
-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    if([rawData objectForKey:@"data"])
    {
        ratingArray=[[rawData objectForKey:@"data"] objectForKey:@"ratings"];
        serviceArray=[[rawData objectForKey:@"data"] objectForKey:@"services"];
    }
    
   // [self.ratingTableView reloadData];
}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
//    /* Create custom view to display section header... */
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
//    [label setFont:[UIFont fontWithName:FontBold size:15]];
//
//    if(section==0)
//        [label setText:@"Rating"];
//    if(section==1)
//        [label setText:@"Facilities"];
//    if(section==2)
//        [label setText:@"Clear All"];
//
//    /* Section header is in 0th index... */
//    [view addSubview:label];
//    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
//     if(section==0)
//    return ratingView;
//    if(section==1)
//        return serviceView;
//    return view;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0 || section == 1)
//    {
//        return 55.0;
//    }
//    else
//    {
//        return CGFLOAT_MIN;
//    }
//}
// // in viewdidload
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01f;
//}
//
//
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [[UIView alloc] initWithFrame:CGRectZero];
//}



-(IBAction)ratingFunctin:(UIButton*)sender
{
    
    if(sender.isSelected)
    {
        sender.selected=NO;
        spacingConstant.constant=0;
        serviceBUtton.selected=NO;
        selectedCatogary=-1;
        [filterSelectionArray removeAllObjects];
        
    }
    else
    {
        selectedCatogary=0;

        sender.selected=YES;
        serviceBUtton.selected=NO;
        spacingConstant.constant=ratingArray.count*45;
    }
    [self.ratingTableView reloadData];
    
    [self.serviceTableView reloadData];
}
-(IBAction)serviceFunctin:(UIButton*)sender
{
    if(sender.isSelected)
    {
        sender.selected=NO;
        spacingConstant.constant=0;
        ratingBUtton.selected=NO;
        selectedCatogary=-1;
        [filterSelectionArray removeAllObjects];

        
    }
    else
    {
        selectedCatogary=1;
        sender.selected=YES;
        ratingBUtton.selected=NO;
        spacingConstant.constant=0;

    }
    [self.ratingTableView reloadData];
    
    [self.serviceTableView reloadData];
}
-(IBAction)cancelFunctin:(UIButton*)sender
{
    currentString=[NSString stringWithFormat:@"%@",self.valueString];
    selectionString=@"No Filters";
    

    NSString *code = [currentString substringFromIndex: [currentString length] - 1];

    if([code isEqualToString:@"&"])
    {
        currentString = [currentString substringToIndex:[currentString length]-1];

    }
    [self.delegate filterFunctionByString:currentString value:selectionString];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
