//
//  ViewController.m
//  TransferSolution
//
//  Created by supermap on 15-3-4.
//  Copyright (c) 2015年 supermap. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "ServerStytle.h"
#import "TransferSolutionService.h"
#import "TransferSolutionParameter.h"
#import "TransferPreference.h"
#import "TransferTactic.h"
#import "TransferLine.h"
#import "TransferLines.h"
#import "TransferSolutionResult.h"
#import "TransferSolution.h"
#import "RMMapView.h"
#import "RMMapContents.h"
#import "RMSMTileSource.h"
#import "RMSMLayerInfo.h"
#import "TransferStopInfo.h"
#import "transferGuide.h"
#import "TransferTactic.h"
#import "RMPath.h"
#import "ServerGeometry.h"
#import "TransferGuideItem.h"
#import "RMLayerCollection.h"

@interface ViewController (){
    NSString *tileThing ;
    RMSMTileSource* smSource1 ;
    TransferSolutionService *solutionService;
    TransferStopInfo *startPoint;
    TransferStopInfo *endPoint;
    ZSYPopoverListView *pupoListView;
    NSArray *transferSolutions;
    TransferGuide *guide;
    ServerGeometry *guideGeo ;
    RMPath *path ;
    NSMutableArray *CALayers;
    BOOL suggetstWalking;

}

@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    tileThing = @"http://support.supermap.com.cn:8090/iserver/services/map-changchun/rest/maps/长春市区图";
    info = [[RMSMLayerInfo alloc] initWithTile:@"Changchun" linkurl:tileThing];
    // 判断获取iServer服务配置信息失败，为NULL时失败
    NSAssert(info != NULL,@"RMSMLayerInfo Connect fail");
    //底图
    smSource1 = [[RMSMTileSource alloc] initWithInfo:info];
    newContents = [[RMMapContents alloc] initWithView:_mapView tilesource:smSource1];
    [_mapView setContents:newContents];

    RMProjectedPoint prjPnt;
    prjPnt.easting = 4503;
    prjPnt.northing = -3861;
    
    [newContents setCenterProjectedPoint:prjPnt];
    newContents.zoom = 1;
    
    NSString *url =@"http://support.supermap.com.cn:8090/iserver/services/traffictransferanalyst-sample/restjsr/traffictransferanalyst/Traffic-Changchun";
    
    // 给输入框添加监听，当文本内容发生改变是，从新请求站点
    [self.startTF addTarget:self action:@selector(textFieldValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.endTF addTarget:self action:@selector(textFieldValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    solutionService =  [[TransferSolutionService alloc] initWithUrl:url] ;
       
    pupoListView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [pupoListView.titleName setText:@"交通换乘方案"];
    [pupoListView setDatasource:self];
    [pupoListView setDelegate:self];
    CALayers = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(IBAction)solutionList:(UIButton *)sender{
    NSString *notice = nil;
    if (transferSolutions) {
         [pupoListView show];
    }else{
        if (suggetstWalking) {
            notice = @"走路啦";
        }else{
            notice =@"当前未查询换乘方案" ;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:notice delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(IBAction)onClick:(UIButton *)sender{
    if (startPoint == NULL || endPoint == NULL) {
        NSLog(@"起始点或终点为空");
        return;
    }
    
    [[_mapView.contents overlay] removeSublayers:CALayers];

    [_startTF resignFirstResponder];
    [_endTF resignFirstResponder];
    
    NSArray *points = [[NSArray alloc] initWithObjects:[NSNumber numberWithLong:[startPoint _id]], [NSNumber numberWithLong:[endPoint _id]],nil];
//    NSArray *arr = [[NSArray alloc] initWithObjects:[startPoint position], [endPoint position],nil];
    // 设置换乘分析的参数
    TransferSolutionParameter *param = [[TransferSolutionParameter alloc] initWithPoints:points solutionCount:[@"6" integerValue] walkingRatio:10 transferTactic: LESS_TIME transferPreference:NONE];
    // 设置避让站点。  避让线路，优先线路，优先站点设置类似
    
    [param setEvadelStops:[[NSMutableArray alloc] initWithObjects:@"93",@"94",@"88", nil]];
     [solutionService processAsync4SolutionWithParam:param finishBlock:^(TransferSolutionResult *transferSolutionResult){
         guide = [transferSolutionResult defaultGuide];
         transferSolutions =[transferSolutionResult transferSolution];
         [pupoListView reloadData];
         NSLog(@"%@",[transferSolutionResult transferSolution]);
         NSMutableArray *items =  [guide transferGuideItems];
//         [self performSelectorOnMainThread:@selector(addLayer:) withObject:items waitUntilDone:YES ];
         if ([transferSolutionResult suggestWalking]) {
             suggetstWalking = true;
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggest" message:@"走路过去啦" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
             [alert show];
         }
         [self addLayer:items];
         
     } failedBlock:^(NSError *connectionError) {
         
     }];
}
- (void)textFieldValueDidChange:(UITextField *)sender{
    if ([sender text]==NULL) {
        return;
    }
    
    [solutionService ProcessAsync4StopsWithKeyWord:[sender text] returnPosition:YES finishBlock:^(NSArray * transferStopsInfo) {
        if ([transferStopsInfo count] != 0) {
            if ([[sender restorationIdentifier] isEqualToString:@"startPoint"]) {
                startPoint = [transferStopsInfo objectAtIndex:0];
            }
            if ([[sender restorationIdentifier] isEqualToString:@"endPoint"]) {
                endPoint = [transferStopsInfo objectAtIndex:0];
            }
            
            
        }
    } failedBlock:^(NSError *connectionError) {
        
    }];
}

#pragma mark -实现代理

- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [transferSolutions count];
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"乘车方案%d",[indexPath row]+1];
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
}

// list回调
- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndexPath == indexPath) {
        return;
    }
    [pupoListView dismiss];
    [[_mapView.contents overlay] removeSublayers:CALayers];
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    NSArray *arr = [[NSArray alloc] initWithObjects:[NSNumber numberWithLong:[startPoint _id]], [NSNumber numberWithLong:[endPoint _id]],nil];
//    NSArray *arr = [[NSArray alloc] initWithObjects:[startPoint _id], [endPoint _id],nil];
    
    // 本案例中，每个换乘方案只显示一条线路。
    NSMutableArray *linesss = [[NSMutableArray alloc] init];
    NSArray *aaa = [[transferSolutions objectAtIndex:indexPath.row] linesItems];
    for (int i=0; i< [aaa count]; i++) {
        TransferLine *line = [[[aaa objectAtIndex:i] lineItems] objectAtIndex:0];
        [linesss addObject:line];
    }
    
    [solutionService processAsync4PathWithPoints:arr transferLines:linesss finishBlock:^(TransferGuide *transferGuide) {
        NSMutableArray *items = [transferGuide transferGuideItems];
        // 在主线程中更新ui
//        [self performSelectorOnMainThread:@selector(addLayer:) withObject:items waitUntilDone:YES ];
        [self addLayer:items];
    } failedBlock:^(NSError *connectionError) {
        
    }];
}


// 向图地图中绘制线
-(void)addLayer:(NSArray *)items{
    for (int i=0; i<[items count]; i++) {
        guideGeo = [[items objectAtIndex:i] route];
        path = [guideGeo toRMPath:newContents];
        // 加载图层
        [_mapView.contents.overlay addSublayer:path];
        [CALayers addObject:path];
    }
    
}



@end
