//
//  RZDebugMenu.m
//  RZDebugMenu
//
//  Created by Clayton Rieck on 6/11/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZDebugMenu.h"

#import "RZDebugMenuWindow.h"
#import "RZDebugMenuSettingsInterface.h"

#import "RZDebugMenuModalViewController.h"

static NSString * const kRZSettingsFileExtension = @"plist";

@interface RZDebugMenu ()

@property (strong, nonatomic) RZDebugMenuSettingsInterface *interface;
@property (strong, nonatomic) RZDebugMenuWindow *topWindow;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeUpGesture;
@property (strong, nonatomic) UIViewController *clearRootViewController;
@property (copy, nonatomic) NSString *settingsFileName;
@property (assign, nonatomic) BOOL enabled;

@end

@implementation RZDebugMenu

+ (instancetype)privateSharedInstance
{
    static RZDebugMenu *s_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_sharedInstance = [[RZDebugMenu alloc] init_internal];
    });
    return s_sharedInstance;
}

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"RZDebugMenu cannot be instantiated. Please use the class method interface."
                                 userInfo:nil];
}

- (RZDebugMenu *)init_internal
{
    self = [super init];
    if ( self ) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(createWindowAndGesture:)
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

+ (void)enableWithSettingsPlist:(NSString *)fileName
{
    [[self privateSharedInstance] setSettingsFileName:fileName];
    [[self privateSharedInstance] setEnabled:YES];
}

- (void)showDebugMenu
{
    RZDebugMenuModalViewController *settingsMenu = [[RZDebugMenuModalViewController alloc] initWithInterface:self.interface];
    UINavigationController *modalNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsMenu];
    [self.clearRootViewController presentViewController:modalNavigationController animated:YES completion:nil];
}

- (void)createWindowAndGesture:(NSNotification *)message
{
    if ( self.enabled ) {
        UIApplication *application = [UIApplication sharedApplication];
        self.swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showDebugMenu)];
        self.swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
        self.swipeUpGesture.numberOfTouchesRequired = 3;
        self.swipeUpGesture.delegate = self;
        UIWindow *applicationWindow = application.keyWindow;
        [applicationWindow addGestureRecognizer:self.swipeUpGesture];
        
        self.clearRootViewController = [[UIViewController alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeOrientation)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        
        UIScreen *mainScreen = [UIScreen mainScreen];
        self.topWindow = [[RZDebugMenuWindow alloc] initWithFrame:mainScreen.bounds];
        self.topWindow.windowLevel = UIWindowLevelStatusBar - 1.0;
        self.topWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.topWindow.rootViewController = _clearRootViewController;
        self.topWindow.hidden = NO;
    }
}

// NOTE: Add a runtime version check to disable the gesture update when this is needed in an iOS 8 app. Gesutres with a 'direction' property automatically change direction relative to the device orientation in iOS 8.
- (void)changeOrientation
{
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ( statusBarOrientation == UIDeviceOrientationLandscapeLeft ) {
        self.swipeUpGesture.direction = UISwipeGestureRecognizerDirectionRight;
    }
    else if ( statusBarOrientation == UIDeviceOrientationLandscapeRight ) {
        self.swipeUpGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    else if ( statusBarOrientation == UIDeviceOrientationPortraitUpsideDown ) {
        self.swipeUpGesture.direction = UISwipeGestureRecognizerDirectionDown;
    }
    else {
        self.swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    }
}

#pragma mark - gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - setter override

- (void)setSettingsFileName:(NSString *)settingsFileName
{
    _settingsFileName = settingsFileName;
    _settingsFileName = [_settingsFileName stringByDeletingPathExtension];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:_settingsFileName ofType:kRZSettingsFileExtension];
    if ( !plistPath ) {
        NSString *exceptionName = [_settingsFileName stringByAppendingString:@".plist doesn't exist"];
        @throw [NSException exceptionWithName:exceptionName
                                       reason:@"Make sure you have a settings plist file in the Resources directory of your application"
                                     userInfo:nil];
    }
    
    NSDictionary *plistData = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    _interface = [[RZDebugMenuSettingsInterface alloc] initWithDictionary:plistData];
}

@end