//
//  TencentCloudCustomerConfigManager.m
//  AFNetworking
//
//  Created by Role Wong on 8/12/24.
//

#import <Foundation/Foundation.h>
#import "TencentCloudCustomerManager.h"
#import <TUICore/TUILogin.h>
#import "TUICustomerServicePluginPrivateConfig.h"
#import "TUIC2CChatViewController.h"
#import "TUICustomerServicePluginDataProvider.h"
#import "TUICore/TUIThemeManager.h"
#import "TUICustomerServicePluginConfig.h"
#import "TUICustomerServicePluginMenuView.h"
#import "TUICustomerServicePluginDataProvider.h"
#import "TUICustomerServicePluginExtensionObserver.h"
#import "TUICustomerServicePluginPrivateConfig.h"
#import "TUICustomerServicePluginProductInfo.h"

#import "TUICustomerServicePluginConfigDelegate.h"

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
    
    [self initUIKit];
    
    [TUILogin login:sdkAppId userID:userID userSig:userSig succ:^{
        NSLog(@"登录成功");
        completion(nil);
    } fail:^(int code, NSString *msg) {
        NSLog(@"登录失败, reason:%@", msg);
        // 登录失败，创建一个 NSError 对象并传递给 completion
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: msg};
        NSError *error = [NSError errorWithDomain:@"com.tencent.qcloud.customeruikit" code:code userInfo:userInfo];
        completion(error);
    }];
}

- (void)setCustomerServiceUserID:(NSString *)userID{
    TUICustomerServicePluginPrivateConfig *cusomterServiceConfig = [TUICustomerServicePluginPrivateConfig sharedInstance];
    NSArray *customerServiceUserID = @[userID];
    cusomterServiceConfig.customerServiceAccounts = customerServiceUserID;
}

- (void)pushToCustomerServiceViewControllerFromController:(UIViewController *)controller {
    TUICustomerServicePluginPrivateConfig *cusomterServiceConfig = [TUICustomerServicePluginPrivateConfig sharedInstance];
    TUIChatConversationModel *conversationData = [[TUIChatConversationModel alloc] init];
    conversationData.userID = cusomterServiceConfig.customerServiceAccounts.firstObject;

    TUIBaseChatViewController *chatVC = nil;
    chatVC = [[TUIC2CChatViewController alloc] init];
    chatVC.conversationData = conversationData;

    [controller.navigationController pushViewController:chatVC animated:YES];

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

@end
