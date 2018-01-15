//
//  LMJCollectionViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJCollectionViewController.h"
#import "BDSSpeechSynthesizer.h"

NSString *APP_ID = @"10162806";
NSString *API_KEY = @"BSyQC2PPqSFsBbRjEZXXrRZe";
NSString *SECRET_KEY = @"9307853c7104ffc3e9cd0922b7f38d99";

@interface LMJCollectionViewController ()<LMJVerticalFlowLayoutDelegate,BDSSpeechSynthesizerDelegate>

@property(nonatomic,strong) BDSSpeechSynthesizer *BDSpeech;


@end

@implementation LMJCollectionViewController

-(BDSSpeechSynthesizer *)BDSpeech
{
    if (!_BDSpeech) {
        //设置、获取日志级别
        [BDSSpeechSynthesizer setLogLevel:BDS_PUBLIC_LOG_VERBOSE];
        _BDSpeech = [BDSSpeechSynthesizer sharedInstance];
        //设置合成器代理
        [_BDSpeech setSynthesizerDelegate:self];
        //为在线合成设置认证信息
        [_BDSpeech setApiKey:API_KEY withSecretKey:SECRET_KEY];
        //设置语调
        [_BDSpeech setSynthParam:[NSNumber numberWithInt:4] forKey:BDS_SYNTHESIZER_PARAM_PITCH];
        //设置语速
        [_BDSpeech setSynthParam:[NSNumber numberWithInt:5] forKey:BDS_SYNTHESIZER_PARAM_SPEED];
    }
    return _BDSpeech;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupBaseLMJCollectionViewControllerUI];
    
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
    //初始化百度语音
    [self BDSpeech];
}

- (void)setupBaseLMJCollectionViewControllerUI
{
    
    self.collectionView.backgroundColor = self.view.backgroundColor;
    
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        
        if ([self respondsToSelector:@selector(lmjNavigationHeight:)]) {
            
            self.collectionView.contentInset  = UIEdgeInsetsMake([self lmjNavigationHeight:nil], 0, 0, 0);
        }
    }
    
    
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 26;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor yellowColor];
    
    cell.contentView.clipsToBounds = YES;
    if (![cell.contentView viewWithTag:100]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        label.tag = 100;
        label.textColor = [UIColor redColor];
        label.font = [UIFont boldSystemFontOfSize:44];
        [cell.contentView addSubview:label];
    }
    
    UILabel *label = [cell.contentView viewWithTag:100];
    
    label.text = [NSString stringWithFormat:@"%zd", indexPath.item];
    int asciiCode = indexPath.item + 65;
    NSString *string =[NSString stringWithFormat:@"%c",asciiCode]; //A
    label.text = string;
    label.textAlignment = NSTextAlignmentJustified;
    
    label.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    
    [label addGestureRecognizer:labelTapGestureRecognizer];
    
    
    
    
    
    return cell;
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    UILabel *label=(UILabel*)recognizer.view;
    
    NSLog(@"%@被点击了",label.text);
    
    
    NSString *contentStr = label.text;
    //朗读内容
    [self.BDSpeech speakSentence:contentStr withError:nil];
    
}

#pragma mark - scrollDeleggate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    contentInset.bottom -= self.collectionView.mj_footer.lmj_height;
    self.collectionView.scrollIndicatorInsets = contentInset;
    
    [self.view endEditing:YES];
}

- (UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
        
        UICollectionViewLayout *myLayout = [self collectionViewController:self layoutForCollectionView:collectionView];
        
        collectionView.collectionViewLayout = myLayout;
        
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
    }
    return _collectionView;
}


#pragma mark - LMJCollectionViewControllerDataSource
- (UICollectionViewLayout *)collectionViewController:(LMJCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView
{
    
    LMJVerticalFlowLayout *myLayout = [[LMJVerticalFlowLayout alloc] initWithDelegate:self];
    
    return myLayout;
}


#pragma mark - LMJVerticalFlowLayoutDelegate

- (CGFloat)waterflowLayout:(LMJVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    return 50;//* (arc4random() % 4 + 1);
}


@end

