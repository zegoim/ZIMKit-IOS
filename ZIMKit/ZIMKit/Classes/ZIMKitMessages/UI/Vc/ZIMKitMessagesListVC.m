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
#import "ZIMKitRefreshAutoHeader.h"
#import "ZIMKitInputBar.h"
#import "ZIMKitGroupDetailController.h"
#import "NSString+ZIMKitUtil.h"

@interface ZIMKitMessagesListVC () <ZIMKitMessagesVMDelegate, UITableViewDelegate, UITableViewDataSource,
                                    ZIMKitInputBarDelegate>

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

/// 消息输入框
@property (nonatomic, strong) ZIMKitInputBar *inputBar;
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapViewController)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

    [_messageTableView registerClass:[ZIMKitTextMessageCell class] forCellReuseIdentifier:NSStringFromClass([ZIMKitTextMessageCell class])];
    [_messageTableView registerClass:[ZIMKitSystemMessageCell class] forCellReuseIdentifier:NSStringFromClass([ZIMKitSystemMessageCell class])];
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_messageTableView];
    
    CGRect inputRect = CGRectMake(0, self.view.frame.size.height - ZIMKitChatToolBarHeight - Bottom_SafeHeight, self.view.frame.size.width, ZIMKitChatToolBarHeight + Bottom_SafeHeight);
    _inputBar = [[ZIMKitInputBar alloc] initWithFrame:inputRect];
    _inputBar.delegate = self;
    [self.view addSubview:_inputBar];
    [_inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageTableView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(ZIMKitChatToolBarHeight + Bottom_SafeHeight);
    }];
    
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
//        [rightButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    _memberListDic = [NSMutableDictionary dictionary];
}

- (ZIMKitMessagesVM *)messageVM {
    if (!_messageVM) {
        _messageVM = [[ZIMKitMessagesVM alloc] init];
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
                
                BOOL isNOMoreMessage = NO;
                if (messageList.count < config.count) {
                    isNOMoreMessage = YES;
//                    self.messageTableView.mj_header = nil;
                }
                
                if (!self.isFirstLoad) {
                    [self scrollToBottom:NO];
                    self.isFirstLoad = YES;
                } else {
                    if (lastMessage) {
                        NSInteger index =  [self.messageVM.messageList indexOfObject:lastMessage];
                        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    }
//                    CGFloat visibleHeight = 0;
//                    for (NSInteger i = 0; i < messageList.count; ++i) {
//                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                        visibleHeight += [self tableView:self.messageTableView heightForRowAtIndexPath:indexPath];
//                    }
//                    if(isNOMoreMessage) {
//                        visibleHeight -= 50;
//                    }
//                    [self.messageTableView setContentOffset:CGPointMake(0, self.messageTableView.contentOffset.y + visibleHeight) animated:NO];
                
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

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messageVM.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMKitMessage *message = self.messageVM.messageList[indexPath.row];
    
    if (self.conversationType == ZIMConversationTypeGroup) {
        ZIMGroupMemberInfo *member = [self.memberListDic objectForKey:message.senderUserID];
        message.senderUsername = member.userName;
    } else if (self.conversationType == ZIMConversationTypePeer) {
        if (message.direction == ZIMMessageDirectionReceive) {
            message.senderUsername = self.conversationName;
        } else {
            message.senderUsername = ZIMKitManager.shared.userInfo.userName;
        }
    }
    
    if (message.type == ZIMKitSystemMessageType) {
        ZIMKitSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:message.reuseId];
        [cell fillWithMessage:(ZIMKitSystemMessage *)message];
        return cell;
    } else {
        ZIMKitMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:message.reuseId];
        [cell fillWithMessage:message];
        return cell;
    }
    
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

#pragma mark ZIMKitInputBarDelegate
/// 重置键盘
- (void)didTapViewController {
    [self.inputBar reset];
}

- (void)inputBar:(ZIMKitInputBar *)inputView keyboardWillShow:(CGFloat)height {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect msgFrame = self.messageTableView.frame;
//        msgFrame.size.height = self.view.frame.size.height - GetNavAndStatusHight - height - ZIMKitChatToolBarHeight;
        msgFrame.size.height = self.view.frame.size.height  - height - ZIMKitChatToolBarHeight ;
        self.messageTableView.frame = msgFrame;

        CGRect inputFrame = self.inputBar.frame;
        inputFrame.origin.y = self.view.frame.size.height - height - ZIMKitChatToolBarHeight;
        self.inputBar.frame = inputFrame;
                
        [self scrollToBottom:NO];
    } completion:nil];
}

- (void)inputBar:(ZIMKitInputBar *_Nullable)inputView keyboardWillHide:(CGFloat)height {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        self.messageTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - ZIMKitChatToolBarHeight - Bottom_SafeHeight);

        self.inputBar.frame = CGRectMake(0, self.view.frame.size.height - ZIMKitChatToolBarHeight-Bottom_SafeHeight , self.view.frame.size.width, ZIMKitChatToolBarHeight + Bottom_SafeHeight);
        [self scrollToBottom:NO];
    } completion:nil];
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
        }];
    } else if (self.conversationType == ZIMConversationTypeGroup) {
        [self.messageVM sendGroupMessage:msg toGroupID:self.conversationID config:msgConfig callBack:^(ZIMKitMessage * _Nullable message, ZIMError * _Nullable errorInfo) {
            [self reloaddataAndScrolltoBottom];
        }];
    }
    
}

- (void)reloaddataAndScrolltoBottom {
    [self.messageTableView reloadData];
    [self scrollToBottom:NO];
}

- (void)scrollToBottom:(BOOL)animate
{
//    if (self.messageVM.messageList.count > 0) {
//        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageVM.messageList.count - 1 inSection:0]
//                              atScrollPosition:UITableViewScrollPositionBottom
//                                      animated:animate];
//    }
    [self scrollToBottomWithAnimated:animate];
}

-(void)scrollToBottomWithAnimated: (BOOL)animated{
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
