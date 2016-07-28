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
@interface DescribeViewController ()<IFlySpeechSynthesizerDelegate>

{
    
    IFlySpeechSynthesizer * _iFlySpeechSynthesizer;
    UIBarButtonItem *documentBar2 ;
    UIBarButtonItem *starBar;
    UIBarButtonItem *shareBar;
    UIBarButtonItem *placeBar;
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
    [self baseMessageURL];
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
    
    UIToolbar *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0,SCREENHIGHT - 64, SCREENWIDTH, 64)];
          tool.barTintColor = COLOR(136, 40, 40);
    UIBarButtonItem *CalligrapherBar = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"pen"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(CalligrapherAction)];
    documentBar2 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"document"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(documentAction)];
    starBar = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"star"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(starAction)];
    shareBar = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
    placeBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    tool.items = @[CalligrapherBar,placeBar,documentBar2,placeBar,starBar,placeBar,shareBar];

    [self.view addSubview:tool];
}

- (void)shareAction{
    
}
- (void)starAction{
    
}
- (void)documentAction{
    documentBar2.tintColor = [UIColor redColor];
    
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
