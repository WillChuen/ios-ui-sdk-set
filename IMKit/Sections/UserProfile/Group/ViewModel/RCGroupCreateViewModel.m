//
//  RCGroupCreateViewModel.m
//  RongIMKit
//
//  Created by zgh on 2024/8/22.
//  Copyright © 2024 RongCloud. All rights reserved.
//

#import "RCGroupCreateViewModel.h"
#import <RongIMLibCore/RongIMLibCore.h>
#import "RCConversationViewController.h"
#import "RCAlertView.h"
#import "RCKitCommonDefine.h"
#import "RCGroupManager.h"
@interface RCGroupCreateViewModel ()

@property (nonatomic, strong) NSArray <NSString *>*inviteeUserIds;


@property (nonatomic, copy) NSString *portraitUrl;

@property (nonatomic, assign) NSInteger groupNameLimit;

@end

@implementation RCGroupCreateViewModel
@dynamic delegate;

+ (instancetype)viewModelWithInviteeUserIds:(NSArray<NSString *> *)inviteeUserIds {
    RCGroupCreateViewModel *viewModel = [self.class new];
    viewModel.inviteeUserIds = inviteeUserIds;
    viewModel.groupNameLimit = 64;
    return viewModel;
}

- (void)createGroup:(NSString *)groupName inViewController:(UIViewController *)viewController {
    if (groupName.length < 1) {
        [RCAlertView showAlertController:nil message:RCLocalizedString(@"RCGroupNameEmptyTip") hiddenAfterDelay:2];
        return;
    }
    RCGroupInfo *group = [[RCGroupInfo alloc] init];
    if ([self.delegate respondsToSelector:@selector(generateGroupId)]) {
        group.groupId = [self.delegate generateGroupId];
    }
    if (group.groupId == 0) {
        RCLogE(@"create group, groupId is empty");
        return;
    }
    group.groupName = groupName;
    group.portraitUri = self.portraitUrl;
    group.joinPermission = RCGroupJoinPermissionFree;
    [[RCCoreClient sharedCoreClient] createGroup:group inviteeUserIds:self.inviteeUserIds success:^(RCErrorCode processCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(groupCreateDidSuccess:processCode:inViewController:)]) {
                BOOL intercept = [self.delegate groupCreateDidSuccess:group processCode:processCode inViewController:viewController];
                if (intercept) {
                    return;
                }
            }
            RCConversationViewController *conversationVC = [[RCConversationViewController alloc] initWithConversationType:ConversationType_GROUP targetId:group.groupId];
            conversationVC.navigationItem.title = groupName;
            [viewController.navigationController pushViewController:conversationVC animated:YES];
            if (processCode == RC_GROUP_NEED_INVITEE_ACCEPT) {
                [RCAlertView showAlertController:nil message:RCLocalizedString(@"CreateSuccessAndNeedInviteeAcceptTip") hiddenAfterDelay:2];
            }
        });
    } error:^(RCErrorCode errorCode, NSString * _Nullable errorKey) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [RCAlertView showAlertController:nil message:RCLocalizedString(@"GroupCreateError") hiddenAfterDelay:2];
        });
    }];
}

- (void)portraitImageViewDidClick:(UIViewController *)inViewController {
    if ([self.delegate respondsToSelector:@selector(groupPortraitDidClick:resultBlock:)]) {
        [self.delegate groupPortraitDidClick:inViewController resultBlock:^(NSString * _Nonnull portraitUrl) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.portraitUrl = portraitUrl;
                if ([self.responder respondsToSelector:@selector(groupPortraitDidUpdate:)]) {
                    [self.responder groupPortraitDidUpdate:portraitUrl];
                }
            });
        }];
    }
}
@end
