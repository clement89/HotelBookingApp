//
//  SortViewController.m
//  Stayhopper
//
//  Created by iROID Technologies on 10/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "SortViewController.h"
#import "SortTableViewCell.h"

@interface SortViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    SortTableViewCell *cell;
}

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sortValueArray=[[NSArray alloc]initWithObjects:@"Distance",@"Popularity",@"Stars (5 to 0)",@"Price (low to high)",nil];
    currentString=[NSString stringWithFormat:@"%@sort_rating=%@",self.valueString,@"0"];
    selectionString=@"Distance";
    
    //   [[NSUserDefaults standardUserDefaults] setObject:sortString forKey:@"sortValue"];
    
    NSString* selectedStringVal= [[NSUserDefaults standardUserDefaults] objectForKey:@"sortValue"];
    
    if([self.fromString isEqualToString:@"popular"])
    {
        sortValueArray=[[NSArray alloc]initWithObjects:@"Popularity",@"Stars (5 to 0)",@"Price (low to high)",nil];
        currentString=[NSString stringWithFormat:@"%@sort_rating=%@",self.valueString,@"1"];
        selectionString=@"Popularity";
        
        //   [[NSUserDefaults standardUserDefaults] setObject:sortString forKey:@"sortValue"];
        
        selectedStringVal= [[NSUserDefaults standardUserDefaults] objectForKey:@"sortValue"];
    }
    
    
   
    
    
    if([selectedStringVal containsString:@"0"])
    {
        selectedIndex=0;
        selectionString=@"Distance";
        if([self.fromString isEqualToString:@"popular"])
        {
            
            
        }
        
    }else if([selectedStringVal containsString:@"1"])
    {
        selectedIndex=1;
        selectionString=@"Popularity";

    }else if([selectedStringVal containsString:@"2"])
    {
        selectedIndex=2;
        selectionString=@"Stars (5 to 0)";
        
    }else if([selectedStringVal containsString:@"3"])
    {
        selectedIndex=3;
        selectionString=@"Price (low to high)";
        
    }
    if([self.fromString isEqualToString:@"popular"])
    {
        
        selectedIndex=selectedIndex-1;
    }
    
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sortValueArray.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    // if(indexPath.row%2==0)
//    cell.transform = CGAffineTransformMakeTranslation(0.f, 100);
//    //  else
//    //     cell.transform = CGAffineTransformMakeTranslation(0, 100);    // cell.transform = CGAffineTransformMakeTranslation(50.f, 100);
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
    cell=(SortTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SortTableViewCell"];
    
//    if(indexPath.row==sortValueArray.count)
//    {
//        cell.sortLbl.text=@"Default";
//    }
//    else
//    {
        cell.sortLbl.text=[sortValueArray objectAtIndex:indexPath.row];
  //  }
    
    cell.radioBtn.selected=NO;
    if(indexPath.row==selectedIndex)
        cell.radioBtn.selected=YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex=indexPath.row;
  
        
    if(indexPath.row==0)
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"sort_rating=0" forKey:@"sortValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        currentString=[NSString stringWithFormat:@"%@sort_rating=%@",self.valueString,@"0"];
        selectionString=@"Distance";
        if([self.fromString isEqualToString:@"popular"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"sort_rating=1" forKey:@"sortValue"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            currentString=[NSString stringWithFormat:@"%@sort_rating=%@",self.valueString,@"1"];
            selectionString=@"Popularity";
        }
        
    }else if(indexPath.row==1){
            [[NSUserDefaults standardUserDefaults] setObject:@"sort_rating=1" forKey:@"sortValue"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            currentString=[NSString stringWithFormat:@"%@sort_rating=%@",self.valueString,@"1"];
            selectionString=@"Popularity";
        
        if([self.fromString isEqualToString:@"popular"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"sort_rating=2" forKey:@"sortValue"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            currentString=[NSString stringWithFormat:@"%@sort_rating=%@",self.valueString,@"2"];
            selectionString=@"Stars (5 to 0)";
        }
    }else  if(indexPath.row==2)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"sort_rating=2" forKey:@"sortValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        currentString=[NSString stringWithFormat:@"%@sort_rating=%@",self.valueString,@"2"];
        selectionString=@"Stars (5 to 0)";
        if([self.fromString isEqualToString:@"popular"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"sort_rating=3" forKey:@"sortValue"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            currentString=[NSString stringWithFormat:@"%@sort_rating=%@",self.valueString,@"3"];
            selectionString=@"Price (low to high)";
        }
    }else if(indexPath.row==3)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"sort_rating=3" forKey:@"sortValue"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            currentString=[NSString stringWithFormat:@"%@sort_rating=%@",self.valueString,@"3"];
            selectionString=@"Price (low to high)";
        }
    
    
    
    [self.ratingTableView reloadData];
    
}

-(IBAction)proceedAction:(id)sender
{
    [self.delegate sortFunctionByString:currentString value:selectionString];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(IBAction)closeAction:(id)sender
{
    currentString=[NSString stringWithFormat:@"%@",self.valueString];
    selectionString=@"Distance";
    if([self.fromString isEqualToString:@"popular"])
    {
        currentString=[NSString stringWithFormat:@"%@",self.valueString];
        selectionString=@"Popularity";
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"sort_rating=0" forKey:@"sortValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *code = [currentString substringFromIndex: [currentString length] - 1];
    
    if([code isEqualToString:@"&"])
    {
        currentString = [currentString substringToIndex:[currentString length]-1];
        
    }
    [self.delegate sortFunctionByString:currentString value:selectionString];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
