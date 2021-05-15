//
//  ViewController.m
//  ocExample
//
//  Created by yang chuang on 2021/5/2.
//

#import "ViewController.h"
#import <NPSMeter-Swift.h>
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <IQKeyboardManagerSwift-Swift.h>

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IQKeyboardManager.shared.enable = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"demo"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@24);
        make.top.equalTo(@55);
        make.width.equalTo(@100);
        make.height.equalTo(@(100*logo.image.size.height/logo.image.size.width));
    }];
    
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setTitle:@"显示问卷" forState:UIControlStateNormal];
    startButton.backgroundColor = [UIColor colorWithRed:0 green:0.54 blue:1 alpha:1];
    [startButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.view addSubview:startButton];
    [startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-64));
        make.left.equalTo(@24);
        make.right.equalTo(@(-24));
        make.height.equalTo(@48);
    }];
    startButton.layer.masksToBounds = YES;
    startButton.layer.cornerRadius = 3;
    
    self.textField = [[UITextField alloc] init];
    self.textField.text = @"9e637a54b426cc17";
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.equalTo(startButton);
        make.bottom.equalTo(startButton.mas_top).offset(-16);
    }];
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius = 3;
    self.textField.delegate = self;
    self.textField.textColor = [UIColor colorWithRed:0.165 green:0.192 blue:0.333 alpha:1];
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入问卷id" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.580 green:0.596 blue:0.667 alpha:1]}];
    [self downConfig];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"新一代应用内调研工具";
    label.font = [UIFont boldSystemFontOfSize:28];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField);
        make.bottom.equalTo(self.textField.mas_top).offset(-32);
    }];
}

- (void)downConfig {
    
    [NPSMeter downConfigWithId:self.textField.text downResult:^(BOOL success, NSString * _Nullable error) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"下载配置成功"];
        } else {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:error message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self downConfig];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertView addAction:retryAction];
            [alertView addAction:cancelAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }];
}

- (void)startButtonAction {
    [NPSMeter showWithId:self.textField.text showResult:^(BOOL success, NSString * _Nullable error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error];
        }
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self downConfig];
}

@end
