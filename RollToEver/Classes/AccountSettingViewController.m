//
//  AccountSettingViewController.m
//  RollToEver
//
//  Created by fifnel on 2012/02/08.
//  Copyright (c) 2012年 fifnel. All rights reserved.
//

#import "AccountSettingViewController.h"

#import "EvernoteAuthToken.h"
#import "UserSettings.h"
#import "id.h"
#import "MBProgressHUD.h"

@implementation AccountSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userId.delegate = self;
    password.delegate = self;
}

- (void)viewDidUnload
{
    [userId release];
    userId = nil;
    [password release];
    password = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [userId setText:[UserSettings sharedInstance].evernoteUserId];
    [password setText:[UserSettings sharedInstance].evernotePassword];
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [userId release];
    [password release];
    [super dealloc];
}

- (IBAction)loginEvernote:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	hud.labelText = NSLocalizedString(@"AccountSettingLogin", @"Login for AccountSetting");

    bool ret = [[EvernoteAuthToken sharedInstance] connectWithUserId:userId.text
                                                            Password:password.text
                                                          ClientName:APPLICATIONNAME
                                                         ConsumerKey:CONSUMERKEY
                                                      ConsumerSecret:CONSUMERSECRET];
    
    NSString *alertTitle = NSLocalizedString(@"AccountSettingLoginTitle", @"Login title for AccountSetting");
    if (ret) {
        // 成功
        [[UserSettings sharedInstance] setEvernoteUserId:userId.text];
        [[UserSettings sharedInstance] setEvernotePassword:password.text];
        [[UserSettings sharedInstance] setEvernoteNotebookName:@""];
        [[UserSettings sharedInstance] setEvernoteNotebookGUID:@""];

        UIAlertView *alertDone =
            [[UIAlertView alloc] initWithTitle:alertTitle
                                       message:NSLocalizedString(@"AccountSettingLoginSucceeded", @"Login succeeded for AccountSetting")
                                      delegate:self
                             cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                             otherButtonTitles: nil];
        [alertDone show];
        [alertDone release];
        // 保存する
    } else {
        // 失敗
        UIAlertView *alertDone =
        [[UIAlertView alloc] initWithTitle:alertTitle
                                   message:NSLocalizedString(@"AccountSettingLoginFailed", @"Login failed for AccountSetting")
                                  delegate:self
                         cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                         otherButtonTitles: nil];
        [alertDone show];
        [alertDone release];
    }
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end