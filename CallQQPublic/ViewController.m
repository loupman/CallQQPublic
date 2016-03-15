//
//  ViewController.m
//  CallQQPublic
//
//  Created by PhilipLee on 16/3/15.
//  Copyright © 2016年 PhilipLee. All rights reserved.
//

#import "ViewController.h"

#define PublicServiceNumber               @"4008205555"
#define UITableViewCellIdentifier         @"UITableViewCellIdentifier"


@interface ViewController ()  <UIWebViewDelegate>

@property(nonatomic, strong) NSArray *keyValues;
@property(nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _keyValues = @[@"通过网页打开QQ公众号", @"直接打开QQ公众号", @"获取直接打开QQ公众号的FKUIN"];
    
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:UITableViewCellIdentifier];
    
    NSURL *url = [NSURL URLWithString:@"mqqwpa://"];
    BOOL hasInstalled = [[UIApplication sharedApplication] canOpenURL:url];
    
    if (!hasInstalled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先安装QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _keyValues.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    cell.textLabel.text = _keyValues[section];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.25 animations:^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    if (!_webView) {
        _webView = [UIWebView new];
        _webView.alpha = 0;
    } else {
        [_webView removeFromSuperview];
    }
    _webView.delegate = nil;
    
    // 这里是一个公众号
    if (indexPath.section == 0 || indexPath.section == 2) {
        // 通过网页打开QQ公众号
        NSString *urlStr = @"http://wpa.b.qq.com/cgi/wpa.php?ln=2&uin=4008205555";
        
        if (indexPath.section == 2) {
            // this will go to shouldStartLoadWithRequest
            _webView.delegate = self;
        }
        
        NSURL *url = [NSURL URLWithString:urlStr];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:_webView];
        
        return;
    }
    
    // 直接打开QQ公众号  -- 使用 第三种获取真正的跳转uin
    NSString *urlStr = @"mqqwpa://im/chat?chat_type=crm&uin=800095555&version=1&src_type=web&web_src=http://wpa.b.qq.com";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [self.view addSubview:_webView];
    
}


#pragma UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString containsString:@"mqqwpa://im/chat?chat_type=crm&uin="]) {
        NSLog(@"--Real jump Url = %@", request.URL.absoluteString);
    }
    
    return YES;
}
@end
