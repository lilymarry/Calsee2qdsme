//
//  MainViewController.m
//  Calsee2qdsme
//
//  Created by SCHENK on 2020/8/21.
//  Copyright © 2020 SCHENK. All rights reserved.
//

#import "MainViewController.h"
#import<WebKit/WebKit.h>
#import "PlayViewController1.h"
#import <CommonCrypto/CommonDigest.h>
@interface MainViewController ()<WKNavigationDelegate, WKUIDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
       WKWebViewConfiguration*   _config = [[WKWebViewConfiguration alloc]init];
     _config.userContentController = [[WKUserContentController alloc]init];
     //webViewAppShare这个需保持跟服务器端的一致，服务器端通过这个name发消息，客户端这边回调接收消息，从而做相关的处理
 
     _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 44,ScreenW ,ScreenH-44)configuration: _config];
     
   _webView.navigationDelegate = self;
   _webView.UIDelegate = self;
   _webView.scrollView.delegate = self;

     NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.calseeglobal.com/web/iOS/index.aspx?exhiid=765218152561"]];
     [_webView loadRequest:request];
  [self.view addSubview:_webView];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 38, ScreenW, 5)];
       self.progressView.backgroundColor = [UIColor whiteColor];
       //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
     //  self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
       [self.view addSubview:self.progressView];
       
    
    //3.添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
   [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
//      NSDate *currentDate = [NSDate date];
//        // 指定日期声明
//      NSTimeInterval oneDay = 2 * 60 *60;  // 2H一共有多少秒
//    NSDate * appointDate = [currentDate initWithTimeIntervalSinceNow: oneDay];
//
//         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//          [formatter setDateStyle:NSDateFormatterMediumStyle];
//          [formatter setTimeStyle:NSDateFormatterShortStyle];
//          [formatter setDateFormat:@"YYY-MM-dd HH:mm:ss"];
//         NSTimeZone* timeZone = [NSTimeZone localTimeZone];
//         [formatter setTimeZone:timeZone];
//          NSString *dateStr = [formatter stringFromDate:appointDate];
//   NSString *str= [HelpCommon timeSwitchTimestamp:dateStr andFormatter:@"YYYY-MM-dd HH:mm:ss"];
//    NSString *str1=[self getHexByDecimal:[str integerValue]];
//  //  NSLog(@"wwww %@",str1);
//
//    NSString *appkey=@"2aab1d8f1639b1765d88cdd84e92e69c";
//    NSString *appName=@"calsee2m";
//    NSString *streamName=@"643325597468";
//    NSString *result=[NSString stringWithFormat:@"%@%@%@",appkey,streamName,str1];
//    NSString *url=@"livepushm.calseeglobal.com";
//    NSString *md5Str=[self md5String:result];
//
//      NSString *result2=[NSString stringWithFormat:@"rtmp://%@/%@/%@?txSecret=%@&txTime=%@",url,appName,streamName,md5Str,str1];
//    NSLog(@"www %@",result2);
 
}
- (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}
- ( NSString *)md5String:( NSString *)str {
    
    const char *myPasswd = [str UTF8String ];
    
    unsigned char mdc[ 16 ];
    
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    
    NSMutableString *md5String = [ NSMutableString string ];
    
    for ( int i = 0 ; i< 16 ; i++) {
        //(x代表以十六进制形式输出,02代表不足两位，前面补0输出，如果超过两位，则以实际输出)
        [md5String appendFormat : @"%02x" ,mdc[i]];
        
    }
    
    return md5String;
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
  
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
  
        if (_webView.estimatedProgress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;

            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

}
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
     //开始加载网页时展示出progressView
      self.progressView.hidden = NO;
      self.progressView.progress=0.1;
      //开始加载网页的时候将progressView的Height恢复为1.5倍
      self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
      //防止progressView被网页挡住
      [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    [self.webView evaluateJavaScript:@"document.getElementsByClassName(\"error-desc\")[0].innerHTML" completionHandler:^(id result, NSError * _Nullable error) {
         //result就是获取到的内容
        NSLog(@"WWW %@",result);
        
     }];
   

}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
  

}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
       NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    if (@available(iOS 12.0, *)) {//iOS11也有这种获取方式，但是我使用的时候iOS11系统可以在response里面直接获取到，只有iOS12获取不到
        WKHTTPCookieStore *cookieStore = webView.configuration.websiteDataStore.httpCookieStore;
        [cookieStore getAllCookies:^(NSArray* cookies) {
            [self setCookie:cookies];
        }];
    }else {
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
//        NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
//        [self setCookie:cookies];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
}
 
-(void)setCookie:(NSArray *)cookies {
    if (cookies.count > 0) {
        for (NSHTTPCookie *cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

       return nil;

}
- (IBAction)playPress:(id)sender {
    PlayViewController1 *play=[[PlayViewController1 alloc]init];
    [self.navigationController pushViewController:play animated:YES];
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end


