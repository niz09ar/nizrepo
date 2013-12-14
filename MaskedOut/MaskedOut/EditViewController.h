//
//  DetailViewController.h
//  MaskedOut
//
//  Created by nizar cherkaoui on 12/9/13.
//  Copyright (c) 2013 nizar cherkaoui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import "OpenALH.h"
#import "Item.h"

@interface EditViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIPickerViewDelegate, MFMessageComposeViewControllerDelegate> {
	UILabel *lbl1, *lbl2;
	UITextField *itemName;
	UITextField *itemPrice;
	UIImageView *itemPic;
    UIButton *done, *picBtn;
	Item *item;
    
    UIPickerView *myPickerView;
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

@property(nonatomic, strong) UILabel *lbl1, *lbl2;
@property(nonatomic, strong) UIButton *done;
@property(nonatomic, strong) UITextField *itemName;
@property(nonatomic, strong) UIImageView *itemPic;
@property(nonatomic, strong) Item *item;

@property(nonatomic, strong) UIPickerView *myPickerView;

@property(nonatomic, strong) AVAudioRecorder *recorder;
@property(nonatomic, strong) AVAudioPlayer *player;

@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)recordPauseTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;
- (IBAction)playTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *sendImage;

@property (weak, nonatomic) IBOutlet UIButton *chooseMask;

- (IBAction)sendImageTapped:(id)sender;

-(void)popupWithMessage:(NSString *)message;

@property (nonatomic, strong) UIImageView *hatImgView;
@property (nonatomic, strong) UIImageView *beardImgView;
@property (nonatomic, strong) UIImageView *mouthImgView;
@property (nonatomic, strong) UIImageView *leftEyeImgView;
@property (nonatomic, strong) UIImageView *rightEyeImgView;


@end
