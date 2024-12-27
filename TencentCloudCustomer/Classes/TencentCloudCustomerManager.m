//
//  TencentCloudCustomerConfigManager.m
//  AFNetworking
//
//  Created by Role Wong on 8/12/24.
//

#import <Foundation/Foundation.h>
#import "TencentCloudCustomerManager.h"
#import <TDeskCore/TDesk_TUILogin.h>
#import "TUICustomerServicePluginPrivateConfig.h"
#import <TDeskChat/TDesk_TUIC2CChatViewController.h>
#import "TUICustomerServicePluginDataProvider.h"
#import "TDeskCore/TDesk_TUIThemeManager.h"
#import "TUICustomerServicePluginConfig.h"
#import "TUICustomerServicePluginMenuView.h"
#import "TUICustomerServicePluginDataProvider.h"
#import "TUICustomerServicePluginExtensionObserver.h"
#import "TUICustomerServicePluginPrivateConfig.h"
#import "TUICustomerServicePluginProductInfo.h"
#import "TDeskChat/TDesk_TUIChatConfig.h"
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
    
    OTSpan *loginSpan = [TencentCloudCustomerLoggerObjC.sharedLoggerManager reportLogin:sdkAppId userID:userID userSig:userSig];
    
    [self initUIKit];
    
    [TDeskLogin login:sdkAppId userID:userID userSig:userSig succ:^{
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

- (TDeskBaseChatViewController *) getCustomerServiceViewController{
    TUICustomerServicePluginPrivateConfig *cusomterServiceConfig = [TUICustomerServicePluginPrivateConfig sharedInstance];
    TDeskChatConversationModel *conversationData = [[TDeskChatConversationModel alloc] init];
    conversationData.userID = cusomterServiceConfig.customerServiceAccounts.firstObject;
    conversationData.conversationID = [NSString stringWithFormat:@"c2c_%@", conversationData.userID];

    TDeskBaseChatViewController *chatVC = nil;
    chatVC = [[TDeskC2CChatViewController alloc] init];
    chatVC.conversationData = conversationData;
    
    return chatVC;
}

- (void)pushToCustomerServiceViewControllerFromController:(UIViewController *)controller {
    [controller.navigationController pushViewController:[self getCustomerServiceViewController] animated:YES];

    NSData *data = [TDeskTool dictionary2JsonData:@{@"src": BussinessID_Src_CustomerService_Request}];
    [TUICustomerServicePluginDataProvider sendCustomMessageWithoutUpdateUI:data];
}

- (void) applyTheme: (NSString *)themeID {
    NSBundle *customerBundle = [NSBundle bundleForClass:[self class]];
    NSString *customerThemePath = [customerBundle pathForResource:@"TencentCloudCustomerTheme.bundle" ofType:nil];
    
    TDeskRegisterThemeResourcePath(customerThemePath, TUIThemeModuleChat);
    [TDeskShareThemeManager applyTheme:themeID forModule:TUIThemeModuleChat];
    
    TDeskRegisterThemeResourcePath(customerThemePath, TUIThemeModuleCustomerService);
    [TDeskShareThemeManager applyTheme:themeID forModule:TUIThemeModuleCustomerService];
    
    [TDeskShareThemeManager applyTheme:@"light" forModule:TUIThemeModuleTIMCommon];
}

- (void)setQuickMessages:(NSArray<TUICustomerServicePluginMenuCellData *> *)menuItems{
    [TUICustomerServicePluginDelegate sharedInstance].customMenuItems = menuItems;
    [TUICustomerServicePluginConfig sharedInstance].delegate = [TUICustomerServicePluginDelegate sharedInstance];
}

- (void) initUIKit{
    [self applyTheme:@"customer_light"];
    [TDeskMessageCellLayout incommingMessageLayout].avatarSize = CGSizeMake(0, 0);
    [TDeskMessageCellLayout outgoingMessageLayout].avatarSize = CGSizeMake(0, 0);
    
    [TDeskMessageCellLayout incommingTextMessageLayout].avatarSize = CGSizeMake(0, 0);
    [TDeskMessageCellLayout outgoingTextMessageLayout].avatarSize = CGSizeMake(0, 0);
    
    [TDeskMessageCellLayout incommingImageMessageLayout].avatarSize = CGSizeMake(0, 0);
    [TDeskMessageCellLayout outgoingImageMessageLayout].avatarSize = CGSizeMake(0, 0);
    
    [TDeskMessageCellLayout incommingVideoMessageLayout].avatarSize = CGSizeMake(0, 0);
    [TDeskMessageCellLayout outgoingVideoMessageLayout].avatarSize = CGSizeMake(0, 0);
    
    [TDeskMessageCellLayout incommingVoiceMessageLayout].avatarSize = CGSizeMake(0, 0);
    [TDeskMessageCellLayout outgoingVoiceMessageLayout].avatarSize = CGSizeMake(0, 0);
    
    [TDeskChatConfig defaultConfig].enablePopMenuReplyAction = NO;
    [TDeskChatConfig defaultConfig].enablePopMenuEmojiReactAction = NO;
    
    [TUICustomerServicePluginConfig sharedInstance].delegate = [TUICustomerServicePluginDelegate sharedInstance];
}

@end
