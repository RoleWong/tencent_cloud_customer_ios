//
//  TencentCloudCustomerManager.h
//  Pods
//
//  Created by Role Wong on 8/12/24.
//

#ifndef TUICustomerManager_h
#define TUICustomerManager_h

#import "TUICustomerServicePluginMenuView.h"

@interface TencentCloudCustomerManager : NSObject

+ (instancetype) sharedManager;

- (void)loginWithSdkAppID:(int) sdkAppId userID: (NSString *) userID userSig: (NSString *) userSig completion:(void(^)(NSError *error))completion;

- (void)setCustomerServiceUserID:(NSString *)userID;

- (void)pushToCustomerServiceViewControllerFromController:(UIViewController *)controller;

- (void) applyTheme: (NSString *)themeID;

- (void)setQuickMessages:(NSArray<TUICustomerServicePluginMenuCellData *> *)menuItems;

- (void) initUIKit;
 
@end


#endif /* TUICustomerManager_h */
