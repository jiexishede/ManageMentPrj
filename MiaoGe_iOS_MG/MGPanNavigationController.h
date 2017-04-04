//
//  LCPanNavigationController.h
//  PanBackDemo
//
//  Created by clovelu on 5/30/14.
//
//

#import <UIKit/UIKit.h>

@interface MGPanNavigationController : UINavigationController
@property (readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
- (UIViewController *)previousViewController;
- (UIViewController *)currentViewController;
- (void)setEnablePanBack:(BOOL)flag;

@end

@protocol LCPanBackProtocol <NSObject>
- (BOOL)enablePanBack:(MGPanNavigationController *)panNavigationController;
- (void)startPanBack:(MGPanNavigationController *)panNavigationController;
- (void)finshPanBack:(MGPanNavigationController *)panNavigationController;
- (void)resetPanBack:(MGPanNavigationController *)panNavigationController;

@end