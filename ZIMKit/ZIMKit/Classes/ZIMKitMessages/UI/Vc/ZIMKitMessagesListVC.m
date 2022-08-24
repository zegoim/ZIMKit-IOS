//
//  ZIMKitMessagesListVC.m
//  ZIMKit
//
//  Created by zego on 2022/5/30.
//

#import "ZIMKitMessagesListVC.h"
#import "ZIMKitMessagesVM.h"
#import "ZIMKitTextMessageCell.h"
#import "ZIMKitSystemMessageCell.h"
#import "ZIMKitMessageCell.h"
#import "ZIMKitImageMessageCell.h"
#import "ZIMKitUnKnowMessageCell.h"
#import "ZIMKitRefreshAutoHeader.h"
#import "ZIMKitGroupDetailController.h"
#import "NSString+ZIMKitUtil.h"
#import "ZIMKitMessagesListVC+InputBar.h"
#import "ZIMKitImageMessage.h"
#import "GKPhotoBrowser.h"
#import "ZIMKitDefine.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <SDWebImage/SDWebImage.h>

@interface ZIMKitMessagesListVC ()
            <ZIMKitMessagesVMDelegate, UITableViewDelegate, UITableViewDataSource,
            UIGestureRecognizerDelegate,TZImagePickerControllerDelegate,GKPhotoBrowserDelegate>

@property (nonatomic, copy) NSString *conversationID;

@property (nonatomic, copy) NSString *conversationName;

@property (nonatomic, assign) ZIMConversationType conversationType;

/// 历史消息加载, 消息删除....
@property (nonatomic, strong) ZIMKitMessagesVM *messageVM;

/// 消息展示
@property (nonatomic, strong) UITableView *messageTableView;

/// 是否为第一次加载数据,
@property (nonatomic, assign) BOOL isFirstLoad;

/// 记录加载群成员列表的标记
@property (nonatomic, assign) int nextFlag;

/// 群成员列表
@property (nonatomic, strong) NSMutableDictionary *memberListDic;

/// 单聊时对方的信息
@property (nonatomic, strong) ZIMUserFullInfo *otherInfo;

@end

@implementation ZIMKitMessagesListVC

- (instancetype)initWithConversationID:(NSString *)conversationID conversationType:(ZIMConversationType)conversationType conversationName:(NSString *)conversationName {
    if (self = [super init]) {
        self.conversationID = conversationID;
        self.conversationName = conversationName;
        self.conversationType = conversationType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.conversationName;
    
    self.view.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF2F2F2) lightColor:ZIMKitHexColor(0xF2F2F2)];
    [self setupViews];
    [self loadData];
    [self initLoadMoreUI];
    [self loadGroupMember];
    [self loadConversationInfo];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewController)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (UITableView *)messageTableView {
    return _messageTableView;
}

- (void)setupViews {
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.height - ZIMKitChatToolBarHeight - Bottom_SafeHeight);
    if (![UINavigationBar appearance].isTranslucent && [[[UIDevice currentDevice] systemVersion] doubleValue]<15.0) {
        rect = CGRectMake(rect.origin.x, rect.origin.y , rect.size.width, self.view.height - ZIMKitChatToolBarHeight - Bottom_SafeHeight);
    }
    
    _messageTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messageTableView.tableFooterView = [[UIView alloc] init];
    _messageTableView.estimatedRowHeight = ZIMKitMessageCell_Default_Height;
    _messageTableView.estimatedSectionFooterHeight = 0.0f;
    _messageTableView.estimatedSectionHeaderHeight = 0.0f;
    _messageTableView.delaysContentTouches = NO;
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    _messageTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _messageTableView.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xF2F2F2) lightColor:ZIMKitHexColor(0xF2F2F2)];

    [_messageTableView registerClass:[ZIMKitTextMessageCell class]
              forCellReuseIdentifier:NSStringFromClass([ZIMKitTextMessageCell class])];
    [_messageTableView registerClass:[ZIMKitImageMessageCell class] forCellReuseIdentifier:NSStringFromClass([ZIMKitImageMessageCell class])];
    [_messageTableView registerClass:[ZIMKitSystemMessageCell class] forCellReuseIdentifier:NSStringFromClass([ZIMKitSystemMessageCell class])];
    [_messageTableView registerClass:[ZIMKitUnKnowMessageCell class] forCellReuseIdentifier:NSStringFromClass([ZIMKitUnKnowMessageCell class])];
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_messageTableView];
    
    _messageToolbar = [[ZIMKitMessageSendToolbar alloc] initWithSuperView:self.view];
    _messageToolbar.delegate = self;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage zegoImageNamed:@"chat_nav_left"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton.widthAnchor constraintEqualToConstant:40].active = YES;
    [leftButton.heightAnchor constraintEqualToConstant:40].active = YES;
    [leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if (self.conversationType == ZIMConversationTypeGroup) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:[UIImage zegoImageNamed:@"chat_nav_right"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton.widthAnchor constraintEqualToConstant:40].active = YES;
        [rightButton.heightAnchor constraintEqualToConstant:40].active = YES;
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    _memberListDic = [NSMutableDictionary dictionary];
}

- (ZIMKitMessagesVM *)messageVM {
    if (!_messageVM) {
        _messageVM = [[ZIMKitMessagesVM alloc] initWith:self.conversationID];
        _messageVM.delegate = self;
    }
    return _messageVM;
}

- (void)leftBarButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)rightBarButtonClick:(UIButton *)sender {
    NSDictionary *param = @{@"conversationID" : self.conversationID, @"conversationName" : self.conversationName ?:@""};
    self.router.openUrlWithParam(router_groupDetailUrl, param);
}

#pragma mark 下拉加载更多消息
- (void)initLoadMoreUI {
      @weakify(self);
    ZIMKitRefreshAutoHeader *header  = [ZIMKitRefreshAutoHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self loadData];
        }];

        self.messageTableView.mj_header = header;
}

- (void)endRefresh
{
    [self.messageTableView.mj_header endRefreshing ];
}

#pragma mark 数据加载
- (void)loadData {
    ZIMMessageQueryConfig *config = [[ZIMMessageQueryConfig alloc] init];
    config.count = 20;
    ZIMKitMessage *lastMessage = self.messageVM.messageList.firstObject;
    config.nextMessage = lastMessage.zimMsg;
    config.reverse = YES;
    
    @weakify(self);
    [self.messageVM queryHistoryMessage:self.conversationID type:self.conversationType config:config callBack:^(NSArray<ZIMKitMessage *> * _Nullable messageList, ZIMError * _Nullable errorInfo) {
        @strongify(self);
        [self endRefresh];
        if (errorInfo.code == ZIMErrorCodeSuccess) {
            if (messageList.count) {
                
                [self.messageTableView reloadData];
                [self.messageTableView layoutIfNeeded];
                
                if (!self.isFirstLoad) {
                    [self scrollToBottom:NO];
                    self.isFirstLoad = YES;
                } else {
                    if (lastMessage) {
                        NSInteger index =  [self.messageVM.messageList indexOfObject:lastMessage];
                        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    }
                }
                
            }
        } else {
            [self.view makeToast:errorInfo.message];
        }
    }];
}

#pragma mark group Member
- (void)loadGroupMember {
    if (self.conversationType == ZIMConversationTypeGroup) {
        ZIMGroupMemberQueryConfig *config = [[ZIMGroupMemberQueryConfig alloc] init];
        config.nextFlag = self.nextFlag;
        config.count = 100;
        
        @weakify(self);
        [self.messageVM queryGroupMemberListByGroupID:self.conversationID config:config callback:^(NSString * _Nonnull groupID, NSArray<ZIMGroupMemberInfo *> * _Nonnull userList, unsigned int nextFlag, ZIMError * _Nonnull errorInfo) {
            @strongify(self);
            if (errorInfo.code == ZIMErrorCodeSuccess) {
                self.nextFlag = nextFlag;
                if (userList.count) {
                    for (ZIMGroupMemberInfo *info in userList) {
                        [self.memberListDic setObject:info forKey:info.userID];
                    }
                }
            } else {
                [self.view makeToast:[NSString stringWithFormat:@"%ld-%@",errorInfo.code, errorInfo.message]];
            }
            /// 获取群成员的全量数据
            if (nextFlag != 0) {
                [self loadGroupMember];
            } else {
                [self.messageTableView reloadData];
            }
        }];
    }
}

- (void)loadConversationInfo {
    if (self.conversationType == ZIMConversationTypePeer) {
        @weakify(self);
        [[ZIMKitManager shared] queryUsersInfo:@[self.conversationID] callback:^(NSArray<ZIMUserFullInfo *> * _Nonnull userList, NSArray<ZIMErrorUserInfo *> * _Nonnull errorUserList, ZIMError * _Nonnull errorInfo) {
            @strongify(self);
            ZIMUserFullInfo *userinfo = userList.firstObject;
            if (userinfo) {
                self.title = userinfo.baseInfo.userName;
                self.otherInfo = userinfo;
                [self.messageTableView reloadData];
            }
        }];
    } else if (self.conversationType == ZIMConversationTypeGroup && !self.title) {
        @weakify(self);
        [self.messageVM queryGroupInfoWithGroupID:self.conversationID callback:^(ZIMGroupFullInfo * _Nonnull groupInfo, ZIMError * _Nonnull errorInfo) {
            @strongify(self);
            if (groupInfo) {
                self.title = groupInfo.baseInfo.groupName;
            }
        }];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messageVM.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMKitMessage *message = self.messageVM.messageList[indexPath.row];
    
    if (self.conversationType == ZIMConversationTypeGroup) {
        ZIMGroupMemberInfo *member = [self.memberListDic objectForKey:message.senderUserID];
        message.senderUsername = member.userName;
        message.senderUserAvatar = member.memberAvatarUrl;
    } else if (self.conversationType == ZIMConversationTypePeer) {
        if (message.direction == ZIMMessageDirectionReceive) {
            message.senderUsername = self.conversationName;
            message.senderUserAvatar = self.otherInfo.userAvatarUrl;
        } else {
            message.senderUsername = ZIMKitManager.shared.userfullinfo.baseInfo.userName;
            message.senderUserAvatar = ZIMKitManager.shared.userfullinfo.userAvatarUrl;
        }
    }
    
    ZIMKitMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:message.reuseId];
    [cell fillWithMessage:message];
    
    if (message.type == ZIMMessageTypeImage) {
        ZIMKitImageMessageCell *cellImage = (ZIMKitImageMessageCell *)cell;
        @weakify(self);
        cellImage.browseImageBlock = ^(ZIMKitImageMessage * _Nonnull msg, ZIMKitImageMessageCell * _Nonnull cell) {
            @strongify(self);
            [self browseImageW:msg sourceView:cell.thumbnailImageView];
        };
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMKitMessage *message = self.messageVM.messageList[indexPath.row];
    if (indexPath.row == 0) { // UI 最顶端的数据需要顶部留20的间距
        message.isLastTop = YES;
    } else {
        message.isLastTop = NO;
    }
    return [message cellHeight];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self didTapViewController];
}

#pragma mark ZIMKitMessagesVMDelegate
/// 收到单聊消息
- (void)onReceivePeerMessage:(NSArray<ZIMKitMessage *> *)messageList fromUserID:(NSString *)fromUserID {
    if ([fromUserID isEqualToString:self.conversationID]) {
        [self reloaddataAndScrolltoBottom];
    }
}

/// 收到群聊消息
- (void)onReceiveGroupMessage:(NSArray<ZIMKitMessage *> *)messageList fromGroupID:(NSString *)fromGroupID {
    if ([fromGroupID isEqualToString:self.conversationID]) {
        [self reloaddataAndScrolltoBottom];
    }
}

/// 收到房间消息
- (void)onReceiveRoomMessage:(NSArray<ZIMKitMessage *> *)messageList fromRoomID:(NSString *)fromRoomID {
    
}

- (void)onGroupMemberStateChanged:(ZIMGroupMemberState)state event:(ZIMGroupMemberEvent)event userList:(NSArray<ZIMGroupMemberInfo *> *)userList operatedInfo:(ZIMGroupOperatedInfo *)operatedInfo groupID:(NSString *)groupID {
    if (self.conversationType == ZIMConversationTypeGroup && [self.conversationID isEqualToString:groupID]) {
        if (state == ZIMGroupMemberStateQuit) {
            for (ZIMGroupMemberInfo *memberInfo in userList) {
                if (memberInfo.userID) {
                    [self.memberListDic removeObjectForKey:memberInfo.userID];
                }
            }
        } else if (state == ZIMGroupMemberStateEnter) {
            for (ZIMGroupMemberInfo *memberInfo in userList) {
                if (memberInfo.userID) {
                    [self.memberListDic setObject:memberInfo forKey:memberInfo.userID];
                }
            }
        }
    }
}

#pragma mark ZIMKitInputBarDelegate
/// 重置键盘
- (void)didTapViewController {
    [self.messageToolbar hiddeKeyborad];
}

- (void)sendAction:(NSString *)text {
    /// 不能发送空消息, 和全是空格
    if ([NSString isEmpty:text]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSBundle ZIMKitlocalizedStringForKey:@"message_cant_send_empty_msg"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[NSBundle ZIMKitlocalizedStringForKey:@"common_sure"] style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:true completion:nil];
        return;
    }
    
    ZIMKitTextMessage *msg = [[ZIMKitTextMessage alloc] init];
    msg.message = text;
    msg.type = ZIMMessageTypeText;
    ZIMMessageSendConfig *msgConfig = [[ZIMMessageSendConfig alloc] init];

    if (self.conversationType == ZIMConversationTypePeer) {
        [self.messageVM sendPeerMessage:msg toUserID:self.conversationID config:msgConfig callBack:^(ZIMKitMessage * _Nullable message, ZIMError * _Nullable errorInfo) {
            [self reloaddataAndScrolltoBottom];
            if (errorInfo.code) {
                [self showErrorinfo:errorInfo];
            }
        }];
    } else if (self.conversationType == ZIMConversationTypeGroup) {
        [self.messageVM sendGroupMessage:msg toGroupID:self.conversationID config:msgConfig callBack:^(ZIMKitMessage * _Nullable message, ZIMError * _Nullable errorInfo) {
            [self reloaddataAndScrolltoBottom];
            if (errorInfo.code) {
                [self showErrorinfo:errorInfo];
            }
        }];
    }
}

- (void)sendImageMessage:(NSData *)data fileName:(NSString *)fileName{
    NSString *path = [self.messageVM getImagepath];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString getCurrentThumbFileName:fileName]];
    
    UIImage *image;
    if ([NSData sd_imageFormatForImageData:data] == SDImageFormatGIF) {
        [data writeToFile:filePath atomically:YES];
        image = [UIImage sd_imageWithGIFData:data];
        
    } else if ([NSData sd_imageFormatForImageData:data] == SDImageFormatHEIC ||
               [NSData sd_imageFormatForImageData:data] == SDImageFormatHEIF) {
        image = [UIImage imageWithData:data];
        NSData *temData = UIImageJPEGRepresentation(image, 0.75);
        filePath = [NSString stringWithFormat:@"%@.JPG", [filePath stringByDeletingPathExtension]];
        [temData writeToFile:filePath atomically:YES];
        CGSize size = image.size;
        image = [image originImage:image size:CGSizeMake(size.width/10, size.height/10)];
        
    }else  {
       image = [UIImage imageWithData:data];
       [data writeToFile:filePath atomically:YES];
       CGSize size = image.size;
       image = [image originImage:image size:CGSizeMake(size.width/10, size.height/10)];
   }
    
    [[SDImageCache sharedImageCache] storeImage:image forKey:filePath completion:nil];
    
    ZIMKitMediaMessage *imageMessage = [[ZIMKitImageMessage alloc] init];
    imageMessage.fileLocalPath = filePath;
    imageMessage.type = ZIMMessageTypeImage;
    ZIMMessageSendConfig *msgConfig = [[ZIMMessageSendConfig alloc] init];
    
    @weakify(self);
    [self.messageVM sendMeidaMessage:imageMessage conversationID:self.conversationID conversationType:self.conversationType config:msgConfig progress:^(ZIMMediaMessage * _Nonnull message, unsigned long long currentFileSize, unsigned long long totalFileSize) {
        NSLog(@"------------");
    } callBack:^(ZIMKitMessage * _Nullable message, ZIMError * _Nullable errorInfo) {
        @strongify(self);
        [self reloaddataAndScrolltoBottom];
        
        if (errorInfo.code == ZIMErrorCodeSuccess) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            [[SDImageCache sharedImageCache] removeImageForKey:filePath withCompletion:nil];
        } else {
            [self showErrorinfo:errorInfo];
        }
    }];
}

- (void)showErrorinfo:(ZIMError *)errorInfo {
    UIWindow *keyWindow = [self.view getKeyWindow];
    if (errorInfo.code == 6000104) {
        [keyWindow makeToast:[NSBundle ZIMKitlocalizedStringForKey:@"message_sendMessage_tip1"] duration:1.5 position:CSToastPositionCenter];
    } else if (errorInfo.code == 6000214) {
        [keyWindow makeToast:[NSBundle ZIMKitlocalizedStringForKey:@"message_sendMessage_image_tip"] duration:1.5 position:CSToastPositionCenter];
    } else {
        [keyWindow makeToast:errorInfo.message duration:1.5 position:CSToastPositionCenter];
    }
}

#pragma mark 浏览图片
- (void)browseImageW:(ZIMKitImageMessage*)message sourceView:(UIImageView *)sourceView {
    if (message.sentStatus == ZIMMessageSentStatusSendSuccess) {
        NSMutableArray *photos = [NSMutableArray new];
        
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:message.largeImageDownloadUrl];
        photo.originUrl = [NSURL URLWithString:message.fileDownloadUrl];
        photo.sourceImageView = sourceView;
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:message.largeImageDownloadUrl];
        photo.placeholderImage = image ? image : [UIImage zegoImageNamed:@"chat_image_fail_bg"];
        [photos addObject:photo];
        
        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:0];
        browser.showStyle = GKPhotoBrowserShowStyleZoom;
        browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
        browser.failStyle = GKPhotoBrowserFailStyleOnlyImage;
        browser.loadStyle = GKPhotoBrowserLoadStyleKit;
        browser.failureImage = [UIImage zegoImageNamed:@"chat_image_fail_bg"];
//        browser.downloadBtn.hidden = NO;
        browser.delegate = self;
        
        [browser showFromVC:self];
    }
}

#pragma mark GKPhotoBrowserDelegate
- (void)photoBrowser:(GKPhotoBrowser *)browser onDwonloadBtnClick:(NSInteger)index image:(UIImage *)image photo:(id)photo {
    GKPhoto *temPhoto = (GKPhoto *)photo;
    
    browser.loadingImageView.hidden = NO;
    browser.loadingImageView.loadingLabel.text = [NSBundle ZIMKitlocalizedStringForKey:@"message_album_downloading_txt"];
    __typeof(browser) __weak weakbrowser = browser;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:temPhoto.originUrl completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        [weakbrowser.loadingImageView removeFromSuperview];
        weakbrowser.loadingImageView = nil;
        
        if (finished && !error) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
            } error:&error];
            
            [weakbrowser.contentView makeToast:[NSBundle ZIMKitlocalizedStringForKey:@"message_album_save_success"]];
        } else {
            [weakbrowser.contentView makeToast:[NSBundle ZIMKitlocalizedStringForKey:@"message_album_save_fail"]];
        }
    }];
}

- (void)reloaddataAndScrolltoBottom {
    [self.messageTableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateTableViewLayout];
    });
}

- (void)scrollToBottom:(BOOL)animate {
    [self scrollToBottomWithAnimated:animate];
}

- (void)scrollToBottomWithAnimated: (BOOL)animated {
    if(self.messageVM.messageList.count > 0){
        NSInteger lastRowIndex = [self.messageTableView numberOfRowsInSection:0] - 1;
        if(lastRowIndex > 0){
            NSIndexPath*lastIndexPath = [NSIndexPath indexPathForRow: lastRowIndex inSection: 0];
            [self.messageTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition: UITableViewScrollPositionBottom animated:animated];
        }
    }
}



- (void)willMoveToParentViewController:(UIViewController*)parent
{
    [super willMoveToParentViewController:parent];
    if (nil == parent) {
        // 页面返回了--点击返回和滑动都会执行
        [_messageVM clearConversationUnreadMessageCount:self.conversationID conversationType:self.conversationType completeBlock:nil];
    }
}

- (void)dealloc {
    
    [_messageVM clearAllCacheData];
    _messageVM = nil;
    NSLog(@"ZIMKitMessagesListVC delloc");
}

@end
