//
//  ViewController.m
//  RollToEver
//
//  Created by fifnel on 2012/02/06.
//  Copyright (c) 2012年 fifnel. All rights reserved.
//

#import "ViewController.h"
#import "AssetsLoader.h"
#import "UserSettings.h"
#import "MBProgressHUD.h"
#import <dispatch/dispatch.h>
#import "id.h"


@interface ViewController()

@property (assign, nonatomic, readwrite) NSInteger photoCount;
@property (strong, nonatomic, readwrite) IBOutlet UILabel *photoCountInfo;

@end

@implementation ViewController
{
    __strong MBProgressHUD *_hud;
}

@synthesize photoCount           = _photoCount;
@synthesize skipUpdatePhotoCount = _skipUpdatePhotoCount;
@synthesize enableiAd            = _enableiAd;

@synthesize uploadButton    = _uploadButton;
@synthesize photoCountInfo  = _photoCountInfo;
@synthesize adBanner        = _adBanner;
@synthesize admobBanner     = _admobBanner;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _skipUpdatePhotoCount = NO;
    if (_hud != nil) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        _hud = nil;
    }
    
    // AdMob(最初表示する)
    _admobBanner = [[GADBannerView alloc]
                    initWithFrame:CGRectMake(0,
                                             self.view.frame.size.height-44-GAD_SIZE_320x50.height,
                                             GAD_SIZE_320x50.width,
                                             GAD_SIZE_320x50.height)];
    _admobBanner.adUnitID = ADMOBPUBLISHERID;
    _admobBanner.rootViewController = self;
    [self.view addSubview:_admobBanner];
    [_admobBanner loadRequest:[GADRequest request]];
    
    // iAd(最初隠す)
    [_adBanner removeFromSuperview];
    [self.view addSubview:_adBanner];
    _adBanner.frame = CGRectMake(0,
                                 self.view.frame.size.height-44,
                                 self.view.frame.size.width,
                                 _adBanner.frame.size.height);
    
    // アカウント情報が設定されていなかったら設定ページへ
    if ([UserSettings sharedInstance].evernoteUserId == nil ||
        [UserSettings sharedInstance].evernoteUserId == @"") {
        [self performSegueWithIdentifier:@"settings" sender:self];
    }
}

- (void)viewDidUnload
{
    [self setUploadButton:nil];
    [self setAdBanner:nil];
    if (_hud != nil) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        _hud = nil;
    }
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!_hud) {
        if (!_skipUpdatePhotoCount) {
            [_uploadButton setEnabled:NO];
            [self updatePhotoCount];
        } else {
            [self assetsCountDidFinish];
        }
        _skipUpdatePhotoCount = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)refreshPhotoCount:(id)sender {
    [self updatePhotoCount];
}

- (void)updatePhotoCount
{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	_hud.labelText = NSLocalizedString(@"Loading", "Now Loading");

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AssetsLoader *assetsLoader = [[AssetsLoader alloc] init];
        NSArray *assets = [assetsLoader EnumerateURLExcludeDuplication:YES];
        _photoCount = [assets count];
        
        [self performSelectorOnMainThread:@selector(assetsCountDidFinish) withObject:nil waitUntilDone:YES];
    });
}

#pragma mark - AssetsLoader delegate
- (void)assetsCountDidFinish {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    _hud = nil;

    if (_photoCount > 0) {
        NSString *photoCountStr = [NSString stringWithFormat:NSLocalizedString(@"MainViewPhotoCount", @"Photo Count for MainView"), _photoCount];
        _photoCountInfo.text = photoCountStr;
        [_uploadButton setEnabled:YES];
    } else {
        _photoCountInfo.text = NSLocalizedString(@"MainViewPhotoNotFound", @"Photo Not Found for MainView");
        [_uploadButton setEnabled:NO];
    }
}

#pragma mark ADBannerViewDelegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (self.enableiAd) {
		// すでにロードされている
	} else {
		// 50ドット上にずらして画面を可視にする
        [UIView beginAnimations:@"animate_adBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -_adBanner.frame.size.height);
        self.admobBanner.frame = CGRectOffset(self.admobBanner.frame, 0, GAD_SIZE_320x50.height);
        [UIView commitAnimations];
        
        self.enableiAd = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.enableiAd) {
		// 失敗したので画面外に出す
		[UIView beginAnimations:@"animate_adBannerOff" context:NULL];
		banner.frame = CGRectOffset(banner.frame, 0, _adBanner.frame.size.height);
        self.admobBanner.frame = CGRectOffset(self.admobBanner.frame, 0, -GAD_SIZE_320x50.height);
		[UIView commitAnimations];

        self.enableiAd = NO;
	}
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    if (_hud == nil) {
        self.skipUpdatePhotoCount = YES;
    }
    return YES;
}
@end
