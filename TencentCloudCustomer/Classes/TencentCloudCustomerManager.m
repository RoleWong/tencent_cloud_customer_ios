//
//  TencentCloudCustomerConfigManager.m
//  AFNetworking
//
//  Created by Role Wong on 8/12/24.
//

#import <Foundation/Foundation.h>
#import "TencentCloudCustomerManager.h"
#import <TDeskCore/TUILogin.h>
#import "TUICustomerServicePluginPrivateConfig.h"
#import "TUIC2CChatViewController.h"
#import "TUICustomerServicePluginDataProvider.h"
#import "TDeskCore/TUIThemeManager.h"
#import "TUICustomerServicePluginConfig.h"
#import "TUICustomerServicePluginMenuView.h"
#import "TUICustomerServicePluginDataProvider.h"
#import "TUICustomerServicePluginExtensionObserver.h"
#import "TUICustomerServicePluginPrivateConfig.h"
#import "TUICustomerServicePluginProductInfo.h"
#import "TencentCloudCustomer/TencentCloudCustomerLoggerObjC.h"
#import "TUICustomerServicePluginConfigDelegate.h"
#import <TencentCloudCustomer/TencentCloudCustomer-Swift.h>

@implementation TencentCloudCustomerManager

+ (instancetype)sharedManager {
    static TencentCloudCustomerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)loginWithSdkAppID:(int)sdkAppId userID:(NSString *)userID userSig:(NSString *)userSig completion:(void(^)(NSError *error))completion {
    
    NSString *logMessage = [NSString stringWithFormat:@"Tencent Cloud Customer loginWithSdkAppID: %d, userID: %@, and userSig: %@", sdkAppId, userID, userSig];
    NSDictionary *attributes = @{
        @"sdkAppId": @(sdkAppId),
        @"userID": userID,
        @"userSig": userSig
    };
    OTSpan *loginSpan = [TencentCloudCustomerLoggerObjC.sharedLoggerManager startSpan:logMessage attributes:attributes];
    
    [self initUIKit];
    
    [TUILogin login:sdkAppId userID:userID userSig:userSig succ:^{
        NSLog(@"登录成功");
        completion(nil);
        [loginSpan end];
    } fail:^(int code, NSString *msg) {
        NSLog(@"登录失败, reason:%@", msg);
        // 登录失败，创建一个 NSError 对象并传递给 completion
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: msg};
        NSError *error = [NSError errorWithDomain:@"com.tencent.qcloud.customeruikit" code:code userInfo:userInfo];
        completion(error);
        [loginSpan end];
    }];
}

- (void)setCustomerServiceUserID:(NSString *)userID{
    TUICustomerServicePluginPrivateConfig *cusomterServiceConfig = [TUICustomerServicePluginPrivateConfig sharedInstance];
    NSArray *customerServiceUserID = @[userID];
    cusomterServiceConfig.customerServiceAccounts = customerServiceUserID;
}

- (TUIBaseChatViewController *) getCustomerServiceViewController{
    TUICustomerServicePluginPrivateConfig *cusomterServiceConfig = [TUICustomerServicePluginPrivateConfig sharedInstance];
    TUIChatConversationModel *conversationData = [[TUIChatConversationModel alloc] init];
    conversationData.userID = cusomterServiceConfig.customerServiceAccounts.firstObject;

    TUIBaseChatViewController *chatVC = nil;
    chatVC = [[TUIC2CChatViewController alloc] init];
    chatVC.conversationData = conversationData;
    return chatVC;
}

- (void)pushToCustomerServiceViewControllerFromController:(UIViewController *)controller {
    [controller.navigationController pushViewController:[self getCustomerServiceViewController] animated:YES];

    NSData *data = [TUITool dictionary2JsonData:@{@"src": BussinessID_Src_CustomerService_Request}];
    [TUICustomerServicePluginDataProvider sendCustomMessageWithoutUpdateUI:data];
}

- (void) applyTheme: (NSString *)themeID {
    NSBundle *customerBundle = [NSBundle bundleForClass:[self class]];
    NSString *customerThemePath = [customerBundle pathForResource:@"TencentCloudCustomerTheme.bundle" ofType:nil];
    
    TUIRegisterThemeResourcePath(customerThemePath, TUIThemeModuleChat);
    [TUIShareThemeManager applyTheme:themeID forModule:TUIThemeModuleChat];
    
    TUIRegisterThemeResourcePath(customerThemePath, TUIThemeModuleCustomerService);
    [TUIShareThemeManager applyTheme:themeID forModule:TUIThemeModuleCustomerService];
}

- (void)setQuickMessages:(NSArray<TUICustomerServicePluginMenuCellData *> *)menuItems{
    [TUICustomerServicePluginDelegate sharedInstance].customMenuItems = menuItems;
    [TUICustomerServicePluginConfig sharedInstance].delegate = [TUICustomerServicePluginDelegate sharedInstance];
}

- (void) initUIKit{
    [self applyTheme:@"customer_light"];
    [TUIMessageCellLayout outgoingTextMessageLayout].avatarSize = CGSizeMake(0, 0);
    [TUIMessageCellLayout incommingTextMessageLayout].avatarSize = CGSizeMake(0, 0);
    [TUICustomerServicePluginConfig sharedInstance].delegate = [TUICustomerServicePluginDelegate sharedInstance];
}

- (void)setupTelemetry {
    // 使用 OpenTelemetry 进行数据上报的代码
    // 例如，初始化 tracer
//    Tracer *tracer = [OpenTelemetry.sharedTracerProvider getTracer:@"YourTracerName"];
    // 进行数据上报
//    TracerObjc *tracer = [OpenTelemetryObjc.instance.tracerProvider getWithInstrumentationName:@"app" instrumentationVersion:@"1.0"];
}


@end
