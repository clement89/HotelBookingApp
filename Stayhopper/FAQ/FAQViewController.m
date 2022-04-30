//
//  FAQViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 29/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "FAQViewController.h"
#import "MessageViewController.h"
#import "FAQTableViewCell.h"
#import "URLConstants.h"

@interface FAQViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation FAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndex=-1;
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
    _lblTitle.superview.layer.shadowOpacity = 0.3;
    _lblTitle.superview.layer.shadowRadius = 2.0;
    _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    

    self.view.backgroundColor = kColorProfilePages;
    
//    listArray=[[NSArray alloc] initWithObjects:@"vcbzvhcgvkjhbkjvh cxjkhvdjkgvkjhdgliuvcnxvbxnmcbvjvbcjvbcxjkghuosfhgk;anvm,cbxvsbslvsljbvjfsbjfsljlcxm,bvncbvohsdagjlsbljcbv.mcxbv.mcxbmxbhjl lfhgjsfhghsfglgafhgjlhsfjlghs;kh hgjlfshgjlsfhljghsljbmbvmn,cbvlj sfghjfhsgljshbgjl fghljksfhgjlhsfjlgahfshgljcbvlsbcvjlfshgojfhsaljfgjlbfmn,bnmnbljhsfljghfsljbmbvsjfbfbsl;hfgfjsbncs sflmbgjsfbnmx bnbcxvfsljbvfsjzbnjpasbnmf xkn",@" vnsvbnmcvmczhkj gjgfjldfbhkdsbfgjsjgbasn.,bgsfbg.mfsbgmn.fs", nil];
    // Do any additional setup after loading the view.
   [self loadApi];
}
- (IBAction)closeBtnAction:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:^{
         
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadApi
{
    
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"";
    
    hud.mode=MBProgressHUDModeText;
    hud.margin = 0.f;
    hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-50);
    hud.removeFromSuperViewOnHide = YES;
    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
    
    
    
    
    
    [self.view endEditing:YES];
    
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    [util postRequest:reqData toUrl: [NSString stringWithFormat: @"faq"] type:@"GET"];
    
    //  apiStatus=NO;
}


-(void)webRawDataReceived:(NSDictionary *)rawData
{
    [hud hideAnimated:YES afterDelay:0];

    if([rawData objectForKey:@"data"])
    {
        listArray=[rawData objectForKey:@"data"];
    }
    [listingTableView reloadData];
    
    
}
-(IBAction)backFunction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
   
    hud.margin = 10.f;
    [hud hideAnimated:YES afterDelay:0];
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Failed";
    vc.messageString=response;
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
    
    
}
-(void)webRawDataReceivedWithError:(NSString *)errorMessage
{
    hud.margin = 10.f;
    [hud hideAnimated:YES afterDelay:0];
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Failed";
    vc.messageString=errorMessage;
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(FAQTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"FAQTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLBL.text=[[listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
 if(selectedIndex==indexPath.row)
 {
     
     
     NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
     style.lineSpacing = 4;
     NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] valueForKey:@"description"]]];
     NSInteger leng2=str2.length;
     
     [str2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaA-Regular" size:16.0] range:NSMakeRange(0, leng2)];
     [str2 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng2)];
     [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, leng2)];
     
     //        [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(5, leng1-5)];NSForegroundColorAttributeName
     
     cell.desceriptionTV.attributedText =str2;
     
    // cell.desceriptionTV.text=[[listArray objectAtIndex:indexPath.row] valueForKey:@"description"];

     cell.desceriptionTV.hidden=NO;
     
     [cell.plusButton setTitle:@"-" forState:UIControlStateNormal];
 }
    else
    {
        cell.desceriptionTV.text=@"";

   cell.desceriptionTV.hidden=YES;
        [cell.plusButton setTitle:@"+" forState:UIControlStateNormal];

    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(selectedIndex==indexPath.row)
    {
        
        NSDictionary *attributesName = @{NSFontAttributeName: [UIFont fontWithName:FontBold size:18.0f]};
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//        style.lineSpacing = 4;
//        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] valueForKey:@"description"]]];
//        NSInteger leng2=str2.length;
//
//        [str2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaA-Regular" size:16.0] range:NSMakeRange(0, leng2)];
//        [str2 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng2)];
//        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, leng2)];
//
//        //        [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(5, leng1-5)];NSForegroundColorAttributeName
//
//        cell.desceriptionTV.attributedText =str2;
        
        CGRect r1 = [[[listArray objectAtIndex:indexPath.row] valueForKey:@"description"] boundingRectWithSize:CGSizeMake((tableView.frame.size.width-40), 0)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:attributesName
                                                                         context:nil];
        
        
        return r1.size.height+(r1.size.height/4)+60;
        
        return 150;
    }
   
    return 65; //You can set height of cell here.
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row%2==0)
//        cell.transform = CGAffineTransformMakeTranslation(0.f, 100);
//    else
//        cell.transform = CGAffineTransformMakeTranslation(0, 100);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    if(selectedIndex==indexPath.row)
        selectedIndex=-1;
    else
        selectedIndex=indexPath.row;
    
    [UIView animateWithDuration:0.3 animations:^{    [listingTableView reloadData];
}];
}

@end
