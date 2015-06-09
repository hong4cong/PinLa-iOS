//
//  UserProfileViewController.m
//  PinLa-IOS
//
//  Created by 洪聪 on 15/4/25.
//  Copyright (c) 2015年 tenTab. All rights reserved.
//

#import "UserProfileViewController.h"
#import "PropertyCell.h"
#import "MyInfoView.h"
#import "LTBounceSheet.h"
#import "UserStorage.h"
#import <UIImageView+WebCache.h>
#import "AccountHandler.h"

@interface UserProfileViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) MyInfoView *infoView;
@property(nonatomic,strong) LTBounceSheet *sheet;
@property(nonatomic,strong) UIImagePickerController *ipc;
@property(nonatomic,strong) UIImage *uploadAvatarImage;
@property (nonatomic, strong) UIImage   *bgImage;

@property (nonatomic) NSInteger  imageChoose;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewDidDisappear:animated];
    [self actionSheetHidden:nil];
}

- (void)onCreate
{
    _ipc = [[UIImagePickerController alloc] init];
    //表示用户可编辑图片。
    _ipc.allowsEditing = YES;
    _ipc.delegate = self;
    
    UIImageView *iv_bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    iv_bg.image = [UIImage imageNamed:@"img_profile_bg"];
    iv_bg.userInteractionEnabled = YES;
    [self.view addSubview:iv_bg];
    
    //背景图片
    _iv_bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 260)];
    _iv_bgImage.userInteractionEnabled = YES;
    if ([UserStorage bgImage]) {
        _iv_bgImage.image = [UserStorage bgImage];
    }else{
        _iv_bgImage.image = [UIImage imageNamed:@"img_profile_bg2"];
    }
    [self.view addSubview:_iv_bgImage];
    
    UIImageView *iv_cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 260)];
    iv_cover.userInteractionEnabled = YES;
    iv_cover.image = [UIImage imageNamed:@"img_profile_bgcover"];
    [self.view addSubview:iv_cover];
    
    UITapGestureRecognizer *tap_bgImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editBgImageAction:)];
    tap_bgImage.numberOfTapsRequired = 1;
    [iv_cover addGestureRecognizer:tap_bgImage];
    
    //回退按钮
    _btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn_back.frame = CGRectMake(12, 20+8, 30, 30);
    [_btn_back setImage:[UIImage imageNamed:@"img_common_back"] forState:UIControlStateNormal];
    [_btn_back addTarget:self action:@selector(leftBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_back];
    
    _btn_saveEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn_saveEdit.frame = CGRectMake(271, 20, 40, 45);
    [_btn_saveEdit setTitle:@"保存" forState:UIControlStateNormal];
    [_btn_saveEdit setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
    [_btn_saveEdit addTarget:self action:@selector(saveEditAction:) forControlEvents:UIControlEventTouchUpInside];
    _btn_saveEdit.titleLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE+3];
    [self.view addSubview:_btn_saveEdit];
    
    //头像
    _iv_avatar = [[HexagonView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 160)/2, 20+13, 160, 160) image:[UIImage imageNamed: @"img_common_defaultAvatar"]];
    [_iv_avatar sd_setImageWithURL:[NSURL URLWithString:[UserStorage userIcon]] placeholderImage:[UIImage imageNamed:@"img_common_defaultAvatar"]];
    [self.view addSubview:_iv_avatar];
    
    UITapGestureRecognizer *tap_avatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editAvatarAction:)];
    tap_avatar.numberOfTapsRequired = 1;
    [_iv_avatar addGestureRecognizer:tap_avatar];
    
    //昵称
    _tf_nickname = [[UITextField alloc] initWithFrame:CGRectMake(MARGIN_LEFT, CGRectGetMaxY(_iv_avatar.frame)+11, CGRectGetWidth(self.view.frame)-MARGIN_LEFT-MARGIN_RIGHT, 31)];
    _tf_nickname.delegate = self;
    _tf_nickname.font = [UIFont systemFontOfSize:FONT_SIZE+11];
    _tf_nickname.textAlignment = NSTextAlignmentCenter;
    _tf_nickname.text = [UserStorage userNickName];
    _tf_nickname.textColor = [UIColor whiteColor];
    _tf_nickname.layer.borderColor = [[UIColor colorWithHexString:COLOR_MAIN_GREEN] CGColor];
    _tf_nickname.layer.borderWidth = 2.0f;
    _tf_nickname.keyboardAppearance = UIKeyboardAppearanceDark;
    _tf_nickname.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_tf_nickname];
    
    _infoView = [[MyInfoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tf_nickname.frame)+20 , CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - MARGIN_BOTTOM- CGRectGetMaxY(_tf_nickname.frame)-40)];
    _infoView.tv_description.delegate = self;
    _infoView.tv_description.returnKeyType = UIReturnKeyDone;
    [_infoView loadData:nil];
    [self.view addSubview:_infoView];
    
    
    //初始化actionsheet
    [self setupActionSheet];
    
    //给屏幕加手势用于隐藏Actionsheet
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSheetHidden:)];
    viewTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:viewTap];
}

- (void)saveEditAction:(id)sender{
    NSString* nickname = nil;
    NSString* userSign = nil;
    NSString* uploadImageStr = nil;
    if (!_tf_nickname.text) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
        return;
    }else{
        nickname = _tf_nickname.text;
    }
    
    if (!_infoView.tv_description.text) {
        userSign = @"";
    }else{
        userSign = _infoView.tv_description.text;
    }
    if (self.bgImage) {
        [UserStorage saveBgImage:self.bgImage];
    }
    
    if (self.uploadAvatarImage) {
        NSData* data = UIImageJPEGRepresentation(self.uploadAvatarImage, (CGFloat)1.0);
        uploadImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else{
        uploadImageStr = @"";
    }
    
    [AccountHandler modifyUserInfoWithNickname:nickname avatarData:uploadImageStr userSign:userSign prepare:^{
        
    } success:^(id obj) {
        NSString* user_icon = (NSString*)obj;
        if(![uploadImageStr isEqual:@""]){
            [UserStorage saveUserIcon:user_icon];
        }
        [UserStorage saveUserNickName:nickname];
        [UserStorage saveUserSign:userSign];
        
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        [self leftBarAction:nil];
    } failed:^(NSInteger statusCode, id json) {
        
    }];
}
- (void)editBgImageAction:(UITapGestureRecognizer *)tap{
    _imageChoose = 1;
    [self.sheet toggle];
}

- (void)editAvatarAction:(UITapGestureRecognizer *)tap{
    _imageChoose = 0;
    [self.sheet toggle];
}

- (void)actionSheetHidden:(UITapGestureRecognizer *)tap{
//    self.navigationController.navigationBarHidden = YES;
    [self.sheet hide];
}

- (void)setupActionSheet{
    self.sheet = [[LTBounceSheet alloc]initWithHeight:150 bgColor:[UIColor clearColor]];
    
    UIButton * option1 = [self produceButtonWithTitle:@"拍照"];
    [option1 setBackgroundImage:[UIImage imageNamed:@"img_sheet_top"] forState:UIControlStateNormal];
    option1.tag = 10001;
    option1.frame=CGRectMake(7, 0, 306, 44);
    [self.sheet addView:option1];
    
    UIButton * option2 = [self produceButtonWithTitle:@"从相册选择"];
    [option2 setBackgroundImage:[UIImage imageNamed:@"img_sheet_bottom"] forState:UIControlStateNormal];
    option2.tag = 10002;
    option2.frame=CGRectMake(7, 45, 306, 44);
    [self.sheet addView:option2];
    
    UIButton * cancel = [self produceButtonWithTitle:@"取消"];
    [cancel setBackgroundImage:[UIImage imageNamed:@"img_sheet_middle"] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithHexString:COLOR_MAIN_GREEN] forState:UIControlStateNormal];
    cancel.tag = 10003;
    cancel.frame=CGRectMake(7, 97, 306, 44);
    [self.sheet addView:cancel];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.sheet];
}

-(UIButton *) produceButtonWithTitle:(NSString*) title
{
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionSheetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

- (void)actionSheetButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 10001:
            _ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
            
        case 10002:
            _ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
            
        case 10003:
            [self actionSheetHidden:nil];
            return;
            
        default:
            return;
    }
    [self actionSheetHidden:nil];
    [self.navigationController presentViewController:_ipc animated:YES completion:nil];
}

#pragma - mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5f animations:^{
        _infoView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        _infoView.frame = CGRectMake(0, CGRectGetMaxY(_btn_saveEdit.frame)+20 , CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - MARGIN_BOTTOM- CGRectGetMaxY(_tf_nickname.frame)-40);
    }];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5f animations:^{
        _infoView.backgroundColor = [UIColor clearColor];
        _infoView.frame = CGRectMake(0, CGRectGetMaxY(_tf_nickname.frame)+20 , CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - MARGIN_BOTTOM- CGRectGetMaxY(_tf_nickname.frame)-40);
    }];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSInteger number = [textView.text length];
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [_infoView.tv_description resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    bool isChinese;//判断当前输入法是否是中文
    if ([[[[UITextInputMode activeInputModes] firstObject] primaryLanguage] isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    
    if(textView == self.infoView.tv_description) {
        // 30位
        NSString *str = [[self.infoView.tv_description text] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (isChinese) { //中文输入法下
            UITextRange *selectedRange = [self.infoView.tv_description markedTextRange];
            //获取高亮部分
            UITextPosition *position = [self.infoView.tv_description positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                NSLog(@"汉字");
                if ( str.length>=31) {
                    NSString *strNew = [NSString stringWithString:str];
                    [self.infoView.tv_description setText:[strNew substringToIndex:30]];
                }
            }
            else
            {
                NSLog(@"输入的英文还没有转化为汉字的状态");
                
            }
        }else{
            if ([str length]>=31) {
                NSString *strNew = [NSString stringWithString:str];
                [self.infoView.tv_description setText:[strNew substringToIndex:30]];
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [_tf_nickname resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}



#pragma - mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    
    if (_imageChoose == 0) {
        self.uploadAvatarImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(160, 160)];
        _iv_avatar.image = self.uploadAvatarImage;
    }else{
        self.bgImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(640, 520)];
        _iv_bgImage.image = self.bgImage;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}
@end
