//
//  DescribeViewController.m
//  ItemDictionary
//
//  Created by 3014 on 16/7/24.
//  Copyright © 2016年 3014. All rights reserved.
//

#import "DescribeViewController.h"
#import "describeModel.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import <FMDB.h>
#import "Sqilte3_Manager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface DescribeViewController ()<IFlySpeechSynthesizerDelegate>

{
    
    IFlySpeechSynthesizer * _iFlySpeechSynthesizer;
    UIBarButtonItem *documentBar2 ;
    UIBarButtonItem *collectBar;
    UIBarButtonItem *shareBar;
    UIBarButtonItem *placeBar;
    UIButton *collectButton;

}

@property (weak, nonatomic) IBOutlet UIImageView *beijingView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pageSegment;
@property(nonatomic,strong) UILabel *baseMessage;
@end

@implementation DescribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"a= %p",self);
    [self data];
    [self setUI];
    [self setUIToolBar];
    [self baseMessageURL];
    self.title = self.string;
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate =self;
    
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                  forKey:[IFlySpeechConstant ENGINE_TYPE]];
    
    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
    [_iFlySpeechSynthesizer setParameter:@" xiaoyan " forKey: [IFlySpeechConstant VOICE_NAME]];
    
    [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
   

    
}

- (void)setUI{
    [self.view insertSubview:self.beijingView atIndex:0];
    
    self.describeScroll.layer.contents = (id)[UIImage imageNamed:@"informatianlow"].CGImage;
    self.describeScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.baseMessage.frame.size.height * 3);
    
    self.baseMessage = [[UILabel alloc] initWithFrame:CGRectMake(35, 45, 350, 350)];
    self.pageSegment.selectedSegmentIndex = 0;
    
    [self.pageSegment addTarget:self action:@selector(segmentAction) forControlEvents:UIControlEventValueChanged];
    [self.pageSegment setBackgroundImage:[UIImage imageNamed:@"fanyi"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.pageSegment setBackgroundImage:[UIImage imageNamed:@"informatian2"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
   
    [self.pageSegment setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR(136, 44, 44),} forState:UIControlStateSelected];
    self.pageSegment.tintColor = COLOR(136, 44, 44);
    self.describeScroll.contentSize = CGSizeMake(0, self.baseMessage.frame.size.height * 2);
    
    self.baseMessage.numberOfLines = 0;
    [self.describeScroll addSubview:self.baseMessage];
    

}

- (void)setUIToolBar{
    UIToolbar *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0,SCREENHIGHT - 44, SCREENWIDTH, 44)];
    tool.barTintColor = COLOR(136, 40, 40);

    UIView *caView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,35, 44)];
    UIButton *caButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [caButton setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
    caButton.frame = CGRectMake(0, 5, 35, 20);
    [caView addSubview:caButton];
    UILabel *caLabel = [[UILabel alloc] initWithFrame:CGRectMake(1,30,44, 10)];
    [caButton addTarget:self action:@selector(CalligrapherAction) forControlEvents:UIControlEventTouchUpInside];
    caLabel.font = [UIFont systemFontOfSize:13];
    caLabel.text = @"书法家";
    caLabel.tintColor = [UIColor whiteColor];
    [caView addSubview:caLabel];
    UIBarButtonItem *CalligrapherBar = [[UIBarButtonItem alloc] initWithCustomView:caView];

    UIView *doView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 44)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"document"] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 5, 45, 20);
    [doView addSubview:button];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(7, 30, 45, 10)];
    [button addTarget:self action:@selector(documentAction) forControlEvents:UIControlEventTouchUpInside];
    lab.font = [UIFont systemFontOfSize:13];
    lab.text = @"复制";
    [lab setTintColor:[UIColor whiteColor]];
    [doView addSubview:lab];
    documentBar2 = [[UIBarButtonItem alloc] initWithCustomView:doView];
    
    UIView *collectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 44)];
    collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    collectButton.frame = CGRectMake(0, 5, 45, 20);
    [collectView addSubview:collectButton];
    UILabel *collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 30, 45, 10)];
    [collectButton addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
    collectLabel.font = [UIFont systemFontOfSize:13];
    collectLabel.text = @"收藏";
    [collectLabel setTintColor:[UIColor whiteColor]];
    [collectView addSubview:collectLabel];
    collectBar = [[UIBarButtonItem alloc] initWithCustomView:collectView];

    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 44)];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(0, 5, 45, 20);
    [shareView addSubview:shareButton];
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 30, 45, 10)];
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    shareLabel.font = [UIFont systemFontOfSize:13];
    shareLabel.text = @"分享";
    [shareLabel setTintColor:[UIColor whiteColor]];
    [shareView addSubview:shareLabel];
    shareBar = [[UIBarButtonItem alloc] initWithCustomView:shareView];
    placeBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    tool.items = @[CalligrapherBar,placeBar,documentBar2,placeBar,collectBar,placeBar,shareBar];
    
    [self.view addSubview:tool];
}

- (void)shareAction{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"1.png"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}
//收藏
- (void)collectAction{
    describeModel *describe = [describeModel new];
    Sqilte3_Manager *sqi = [Sqilte3_Manager new];
    if (documentBar2.tag == 0) {
        documentBar2.tag = 1;
        [collectButton setTintColor:[UIColor yellowColor]];
        describe.miZiTian = self.miziLabel.text;
        describe.pinYin = self.pinyinLabel.text;
        describe.shenyin = self.string;
        describe.bushou = self.bushouLabel.text;
        describe.bihua = self.bihuaLabel.text;
        [sqi collectFMDB:describe];
        NSLog(@"我被选中了");
        
    }else{
        documentBar2.tag = 0;
        if ([sqi deleteData:self.miziLabel.text]) {
            NSLog(@"删除");
        }
        
        
    }

}

- (void)documentAction{
    NSLog(@"我被点击了");
    
}
- (void)CalligrapherAction{
    
}
- (void)segmentAction{
    if ([self.pageSegment selectedSegmentIndex]==0) {
        NSString *str = [NSString stringWithFormat:@"http://www.chazidian.com/service/word/%@",self.string];
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        //url数据不能为中文
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"base = %@",dic);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.baseMessage.text = dic[@"data"][@"base"];
                CGRect rect = [self.baseMessage.text boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.baseMessage.font} context:nil];
                
                self.baseMessage.frame = CGRectMake(35, 55, 330, rect.size.height);

            });
            
          
            
        }];
        [task resume];
        

    }else if (self.pageSegment.selectedSegmentIndex == 1){
        NSString *str = [NSString stringWithFormat:@"http://www.chazidian.com/service/word/%@",self.string];
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        //url数据不能为中文
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"base = %@",dic);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.baseMessage.text = dic[@"data"][@"hanyu"];
                CGRect rect = [self.baseMessage.text boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.baseMessage.font} context:nil];
                
                self.baseMessage.frame = CGRectMake(35, 55, 330, rect.size.height);

            });
            
          
            
        }];
        [task resume];

    }else if (self.pageSegment.selectedSegmentIndex == 2){
        NSString *str = [NSString stringWithFormat:@"http://www.chazidian.com/service/word/%@",self.string];
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        //url数据不能为中文
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"base = %@",dic);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.baseMessage.text = dic[@"data"][@"idiom"];
                CGRect rect = [self.baseMessage.text boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.baseMessage.font} context:nil];
                
                self.baseMessage.frame = CGRectMake(35, 55, 330, rect.size.height);

            });
            
            
        }];
        [task resume];

    }else if (self.pageSegment.selectedSegmentIndex == 3){
        NSString *str = [NSString stringWithFormat:@"http://www.chazidian.com/service/word/%@",self.string];
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        //url数据不能为中文
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"base = %@",dic);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.baseMessage.text = dic[@"data"][@"english"];
                CGRect rect = [self.baseMessage.text boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.baseMessage.font} context:nil];
                
                self.baseMessage.frame = CGRectMake(35, 55, 330, rect.size.height);

            });
            
           
            
        }];
        [task resume];

    }
    
}
- (void)baseMessageURL{
    if ([self.pageSegment selectedSegmentIndex]==0) {
        NSString *str = [NSString stringWithFormat:@"http://www.chazidian.com/service/word/%@",self.string];
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        //url数据不能为中文
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"base = %@",dic);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.baseMessage.text = dic[@"data"][@"base"];
                CGRect rect = [self.baseMessage.text boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.baseMessage.font} context:nil];
                
                self.baseMessage.frame = CGRectMake(35, 55, 330, rect.size.height);

            });
            
            NSLog(@"%@",self.baseMessage.text);
            
        }];
        [task resume];
        
    }

    
}

- (void)data{
    NSString *str = [NSString stringWithFormat:@"http://www.chazidian.com/service/word/%@",self.string];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    //url数据不能为中文
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"base = %@",dic);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.miziLabel.text = dic[@"data"][@"baseinfo"][@"simp"] ;
            self.yindiao = dic[@"data"][@"baseinfo"][@"yin"][@"pinyin"];
            self.pinyinLabel.text =[NSString stringWithFormat:@"拼音 : %@" ,dic[@"data"][@"baseinfo"][@"yin"][@"pinyin"]];
            self.fantiLabel.text = [NSString stringWithFormat:@"繁体 : %@" ,dic[@"data"][@"baseinfo"][@"tra"]];
            self.bushouLabel.text =[NSString stringWithFormat:@"部首 : %@" ,dic[@"data"][@"baseinfo"][@"bushou"]];
            self.zhu = dic[@"data"][@"baseinfo"][@"yin"][@"zhuyin"];
            self.zhuyinLabel.text = [NSString stringWithFormat:@"注音 : %@",dic[@"data"][@"baseinfo"][@"yin"][@"zhuyin"]];
            self.bishunLabel.text = [NSString stringWithFormat:@"笔顺 : %@",dic[@"data"][@"baseinfo"][@"seq"]];
            self.jiegouLabel.text =[NSString stringWithFormat:@"结构 : %@", dic[@"data"][@"baseinfo"][@"frame"]];
            self.bushouBIhuaLabel.text =[NSString stringWithFormat:@"部首笔画 : %@", dic[@"data"][@"baseinfo"][@"bsnum"]];
            self.bihuaLabel.text =[NSString stringWithFormat:@"笔画 : %@", dic[@"data"][@"baseinfo"][@"num"]];
        });
        
        
        
    }];
    [task resume];

}

- (IBAction)loud:(UIButton *)sender {
    
    [_iFlySpeechSynthesizer startSpeaking:self.string];
}
- (IBAction)zhuyinLoudButon:(UIButton *)sender {
      [_iFlySpeechSynthesizer startSpeaking:self.zhu];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) onCompleted:(IFlySpeechError *) error{}
//合成开始
- (void) onSpeakBegin{}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg{} //合成播放进度
- (void) onSpeakProgress:(int) progress{}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
