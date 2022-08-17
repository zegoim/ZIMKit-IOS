//
//  ZIMKitConversationListVC.m
//  ZIMKit
//
//  Created by zego on 2022/5/19.
//

#import "ZIMKitConversationListVC.h"
#import "ZIMKitConversationCell.h"
#import "ZIMKitConversationListNoDataView.h"
#import "ZIMKitConversationVM.h"
#import "ZIMKitCreateChatController.h"
#import "ZegoRefreshAutoFooter.h"
#import "ZIMKitAlertView.h"

#define kConversationCell_ReuseId @"ZIMKitConversationCell"

@interface ZIMKitConversationListVC ()<UITableViewDelegate, UITableViewDataSource,ZIMKitConversationVMDelegate>

/// 没有数据是显示的view
@property (nonatomic, strong) ZIMKitConversationListNoDataView *noDataView;

/// 会话列表 tableView
@property (nonatomic, strong) UITableView *tableView;

/// 列表界面实现数据的加载、移除等多种功能
@property (nonatomic, strong) ZIMKitConversationVM *conversationVM;

/// 记录是否为第一次加载数据失败
@property (nonatomic, assign) BOOL isFirstLoadDataFail;

@end

@implementation ZIMKitConversationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Zego IM";
    [self setupViews];
    [self loadData];
    [[ZIMKitLocalAPNS shared] setupLocalAPNS];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (ZIMKitConversationVM *)conversationVM {
    if (!_conversationVM) {
        _conversationVM = [[ZIMKitConversationVM alloc] init];
        _conversationVM.delegate = self;
    }
    return _conversationVM;
}

- (void)setupViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect rect = self.view.bounds;
//    if (![UINavigationBar appearance].isTranslucent && [[[UIDevice currentDevice] systemVersion] doubleValue]<15.0) {
//        rect = CGRectMake(rect.origin.x, rect.origin.y  + 0, rect.size.width, rect.size.height - StatusBar_Height - NavBar_Height );
//    }
    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - StatusBar_Height - NavBar_Height );
    _tableView = [[UITableView alloc] initWithFrame:rect];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    [_tableView registerClass:[ZIMKitConversationCell class] forCellReuseIdentifier:kConversationCell_ReuseId];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = ZIMKitConversationCell_Height;
    _tableView.rowHeight = ZIMKitConversationCell_Height;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delaysContentTouches = NO;
    [self.view addSubview:_tableView];
    
    _noDataView = [[ZIMKitConversationListNoDataView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _noDataView.hidden = YES;
    @weakify(self);
    _noDataView.createChatActionBlock = ^{
        @strongify(self);
        if (self.isFirstLoadDataFail) {
            [self loadData];
        } else {
            [self createChatAlert];
        }
    };
    [self.view addSubview:_noDataView];
    
    /// 上拉加载更多
    [self initUpLoadMore];
}

- (void)initUpLoadMore {
    @weakify(self);
    ZegoRefreshAutoFooter *footer = [ZegoRefreshAutoFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadData];
    }];
    self.tableView.mj_footer = footer;
}

/// 数据加载
- (void)loadData {
    @weakify(self);
    [self.conversationVM loadConversation:^(NSArray<ZIMKitConversationModel *> * _Nullable dataList, BOOL isFirstLoad, BOOL isFinished ,ZIMError * _Nullable errorInfo) {
        if (self.isFirstLoadDataFail) {
            self.isFirstLoadDataFail = isFirstLoad;
        }
        
        [self.tableView.mj_footer endRefreshing];
        if (isFinished) {
            self.tableView.mj_footer = nil;
        }
        
        @strongify(self);
        if (errorInfo.code == ZIMErrorCodeSuccess) {
            NSLog(@"---------------dataList is %@", dataList);
            [self.tableView reloadData];
        } else {
            NSLog(@"--------------- error mesage is %@", errorInfo.message);
            self.isFirstLoadDataFail = isFirstLoad;
            if (isFirstLoad) {
                [self.noDataView setTitle:[NSBundle ZIMKitlocalizedStringForKey:@"conversation_reload"]];
            } else {
                [self.view makeToast:errorInfo.message];
            }
        }
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.conversationVM.coversationList.count;
    self.noDataView.hidden = self.conversationVM.coversationList.count;
    if (self.isFirstLoadDataFail) {
        self.noDataView.hidden = NO;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZIMKitConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kConversationCell_ReuseId];
    ZIMKitConversationModel *data = self.conversationVM.coversationList[indexPath.row];
    [cell fillWithData:data];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ZIMKitConversationModel *data = self.conversationVM.coversationList[indexPath.row];
    
    NSDictionary *param = @{@"conversationID" : data.conversationID, @"conversationType" : @(data.type), @"conversationName" : data.conversationName ?:@""};
    self.router.openUrlWithParam(router_chatListUrl, param);
    
    [self runInMainThreadAsync:^{
        [self.conversationVM clearConversationUnreadMessageCount:data.conversationID conversationType:data.type completeBlock:^(ZIMError * _Nullable errorInfo) {
            NSLog(@"clearConversationUnreadMessageCount -%lu", (unsigned long)errorInfo.code);
        }];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *rowActions = [NSMutableArray array];
    ZIMKitConversationModel *data = self.conversationVM.coversationList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:[NSBundle ZIMKitlocalizedStringForKey:@"conversation_delete"] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [tableView beginUpdates];
            [weakSelf.conversationVM removeData:data completeBlock:^(ZIMError * _Nullable errorInfo) {
                if (!errorInfo.code) {
                    [self.view makeToast:errorInfo.message];
                }
            }];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [tableView endUpdates];
        }];
        action.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFF4A50) lightColor:ZIMKitHexColor(0xFF4A50)];;
        [rowActions addObject:action];
    }
    return rowActions;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    __weak typeof(self) weakSelf = self;
    ZIMKitConversationModel *data = self.conversationVM.coversationList[indexPath.row];
    NSMutableArray *arrayM = [NSMutableArray array];
    [arrayM addObject:({
        UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:[NSBundle ZIMKitlocalizedStringForKey:@"conversation_delete"] handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [tableView beginUpdates];
            [weakSelf.conversationVM removeData:data completeBlock:^(ZIMError * _Nullable errorInfo) {
                if (!errorInfo.code) {
                    [self.view makeToast:errorInfo.message];
                }
            }];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            [tableView endUpdates];
        }];
        action.backgroundColor = [UIColor dynamicColor:ZIMKitHexColor(0xFF4A50) lightColor:ZIMKitHexColor(0xFF4A50)];
        action;
    })];
    
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:[NSArray arrayWithArray:arrayM]];
    configuration.performsFirstActionWithFullSwipe = NO;
    return configuration;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [self loadData];
}
#pragma mark ZIMKitConversationVMDelegate
/// 会话更新(
- (void)onConversationListChange:(NSArray<ZIMKitConversationModel *> *_Nullable)conversationList {
    [self.tableView reloadData];
}

///总未读数的更新
- (void)onTotalUnreadMessageCountChange:(unsigned int)totalUnreadMessageCount {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTotalUnreadMessageCountChange:)]) {
        [self.delegate onTotalUnreadMessageCountChange:totalUnreadMessageCount];
    }
}

/// 连接状态
- (void)onConnectionStateChange:(ZIMConnectionState)state event:(ZIMConnectionEvent)event extendedData:(NSDictionary *)extendedData {
    [self setTitleContent:state];
    
    if (event == ZIMConnectionEventKickedOut) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(userAccountKickedOut)]) {
            [self.delegate userAccountKickedOut];
        }
    }
}

- (void)setTitleContent:(ZIMConnectionState)state {
    NSString *title = @"Zego IM";
    if (state == ZIMConnectionStateConnecting || state == ZIMConnectionStateReconnecting) {
        title = [NSString stringWithFormat:@"%@(%@)",title,[NSBundle ZIMKitlocalizedStringForKey:@"conversation_connecting"]];
    } else if (state == ZIMConnectionStateDisconnected) {
        title = [NSString stringWithFormat:@"%@(%@)",title,[NSBundle ZIMKitlocalizedStringForKey:@"conversation_disconnected"]];
    } else {
        title = @"Zego IM";
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleContentChange:)]) {
        [self.delegate titleContentChange:title];
    }
}

- (void)createChatAlert {
    NSArray *titles = @[[NSBundle ZIMKitlocalizedStringForKey:@"conversation_start_single_chat"],
                        [NSBundle ZIMKitlocalizedStringForKey:@"conversation_start_group_chat"],
                        [NSBundle ZIMKitlocalizedStringForKey:@"conversation_join_group_chat"]];
    ZIMKitAlertView *alertView = [[ZIMKitAlertView alloc] initWithFrame:self.navigationController.view.bounds superView:self.navigationController.view contentSize:CGSizeZero titles:titles];
    @weakify(self);
    alertView.actionBlock = ^(NSInteger index) {
        @strongify(self);
        [self createChatWithIndex:index];
    };
    [alertView show];
}

- (void)createChatWithIndex:(NSInteger)index {
    
    if (index == 1) {
        self.router.openUrlWithParam(router_CreateChatUrl,@{@"createType" : @(ZIMKitCreateChatTypeSingle)});
        
    } else if (index == 2){
        self.router.openUrlWithParam(router_CreateChatUrl,@{@"createType" : @(ZIMKitCreateChatTypeGroup)});
        
    } else if(index == 3) {
        self.router.openUrlWithParam(router_CreateChatUrl,@{@"createType" : @(ZIMKitCreateChatTypeJoin)});
    }
}


- (void)dealloc {
    [_conversationVM clearAllCacheData];
    _conversationVM = nil;
    NSLog(@"ZIMKitConversationListVC delloc");
}

@end
