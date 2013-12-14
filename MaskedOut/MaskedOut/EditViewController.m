//
//  DetailViewController.m
//  MaskedOut
//
//  Created by nizar cherkaoui on 12/9/13.
//  Copyright (c) 2013 nizar cherkaoui. All rights reserved.
//

//#import <CoreImage/CoreImage.h>
//#import <QuartzCore/QuartzCore.h>

#import "EditViewController.h"

#define frameWidth self.view.frame.size.width
#define frameHeight self.view.frame.size.height

@implementation EditViewController
@synthesize lbl1, lbl2;
@synthesize itemName;
@synthesize itemPic;
@synthesize done;
@synthesize item;
@synthesize myPickerView;
@synthesize recorder;
@synthesize player;

@synthesize stopButton, playButton, recordPauseButton;
@synthesize sendImage, chooseMask;

@synthesize hatImgView, beardImgView, mouthImgView, leftEyeImgView, rightEyeImgView;

bool isFirstPlay;
bool hasChosenMask;
float pitch;

- (id) init
{
    if (self = [super init])
    {
        self.view.backgroundColor = [UIColor colorWithRed: .05 green: .25 blue: .55 alpha: 1.0];
        
        lbl1 = [[UILabel alloc] initWithFrame: CGRectMake(1, 70, 100, 30)];
        lbl1.text = @"MOMENT TITLE:";
        lbl1.font = [UIFont fontWithName: @"Helvetica" size: 12];
        lbl1.textColor = [UIColor colorWithRed: .55 green: .55 blue: .55 alpha: 1.0];
        [self.view addSubview: lbl1];
        
        itemName = [[UITextField alloc] initWithFrame: CGRectMake(95, 70, 210, 30)];
        itemName.borderStyle = UITextBorderStyleRoundedRect;
        itemName.textColor = [UIColor purpleColor];
        itemName.delegate = self;
        [self.view addSubview: itemName];
        
        
        lbl2 = [[UILabel alloc] initWithFrame: CGRectMake(10, 165, 110, 30)];
        lbl2.text = @"CHOOSE MASK";
        lbl2.font = [UIFont fontWithName: @"Helvetica" size: 14];
        lbl2.textColor = [UIColor colorWithRed: .55 green: .55 blue: .55 alpha: 1.0];
        lbl2.alpha = 0;
        [self.view addSubview: lbl2];
        
        itemPic = [[UIImageView alloc] initWithFrame: CGRectMake(frameWidth-160, 175, 150, 210)];
        //itemPic.center = CGPointMake(frameWidth/2.0, frameHeight/2.0);
        [self.view addSubview: itemPic];
        
        
        picBtn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        picBtn.frame = CGRectMake(frameWidth-145, frameHeight - 70, 120, 40);
        picBtn.opaque = YES;
        picBtn.layer.cornerRadius = 12;
        picBtn.clipsToBounds = YES;
        picBtn.backgroundColor = [UIColor purpleColor];
        picBtn.tintColor = [UIColor whiteColor];
        [picBtn setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [picBtn.titleLabel setFont:[UIFont systemFontOfSize: 22]];
        [picBtn setTitle:@"Snapshot" forState:UIControlStateNormal];
        [picBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: picBtn];
        
        
        done = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        done.frame = CGRectMake(25, frameHeight - 70, 120, 40);
        done.opaque = YES;
        done.layer.cornerRadius = 12;
        done.clipsToBounds = YES;
        done.backgroundColor = [UIColor purpleColor];
        done.tintColor = [UIColor whiteColor];
        [done setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [done.titleLabel setFont:[UIFont systemFontOfSize: 22]];
        [done setTitle:@"Done" forState:UIControlStateNormal];
        [done addTarget:self action:@selector(finishedEditing) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: done];
        
        
        stopButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        stopButton.frame = CGRectMake(130, 120, 60, 40);
        stopButton.opaque = YES;
        stopButton.layer.cornerRadius = 12;
        stopButton.clipsToBounds = YES;
        stopButton.backgroundColor = [UIColor purpleColor];
        stopButton.tintColor = [UIColor whiteColor];
        [stopButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [stopButton.titleLabel setFont:[UIFont systemFontOfSize: 16]];
        [stopButton setTitle:@"Stop" forState:UIControlStateNormal];
        [stopButton addTarget:self action:@selector(stopTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: stopButton];
        
        playButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        playButton.frame = CGRectMake(200, 120, 60, 40);
        playButton.opaque = YES;
        playButton.layer.cornerRadius = 12;
        playButton.clipsToBounds = YES;
        playButton.backgroundColor = [UIColor purpleColor];
        playButton.tintColor = [UIColor whiteColor];
        [playButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [playButton.titleLabel setFont:[UIFont systemFontOfSize: 16]];
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(playTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: playButton];
        
        recordPauseButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        recordPauseButton.frame = CGRectMake(60, 120, 60, 40);
        recordPauseButton.opaque = YES;
        recordPauseButton.layer.cornerRadius = 12;
        recordPauseButton.clipsToBounds = YES;
        recordPauseButton.backgroundColor = [UIColor purpleColor];
        recordPauseButton.tintColor = [UIColor whiteColor];
        [recordPauseButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [recordPauseButton.titleLabel setFont:[UIFont systemFontOfSize: 15]];
        [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
        [recordPauseButton addTarget:self action:@selector(recordPauseTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: recordPauseButton];
        
        sendImage = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        sendImage.frame = CGRectMake(25, frameHeight - 120, 120, 40);
        sendImage.opaque = YES;
        sendImage.layer.cornerRadius = 12;
        sendImage.clipsToBounds = YES;
        sendImage.backgroundColor = [UIColor purpleColor];
        sendImage.tintColor = [UIColor whiteColor];
        [sendImage setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [sendImage.titleLabel setFont:[UIFont systemFontOfSize: 22]];
        [sendImage setTitle:@"Send" forState:UIControlStateNormal];
        [sendImage addTarget:self action:@selector(sendImageTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: sendImage];
        
        chooseMask = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        chooseMask.frame = CGRectMake(25, frameHeight - 170, 120, 40);
        chooseMask.opaque = YES;
        chooseMask.layer.cornerRadius = 12;
        chooseMask.clipsToBounds = YES;
        chooseMask.backgroundColor = [UIColor purpleColor];
        chooseMask.tintColor = [UIColor whiteColor];
        [chooseMask setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        [chooseMask.titleLabel setFont:[UIFont systemFontOfSize: 18]];
        [chooseMask setTitle:@"Choose Mask" forState:UIControlStateNormal];
        [chooseMask addTarget:self action:@selector(chooseMaskTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: chooseMask];
        
    }
    
    return self;
}

- (void) finishedEditing
{
	[self viewWillDisappear: YES];
}



- (void) viewWillAppear: (BOOL) animated
{
	[super viewWillAppear: animated];
	itemName.text = item.name;
    itemPic.image = [self getImage];
    
    // Setup audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    //init openAl
    [OpenALH initOpenAL];
    isFirstPlay = true;
    
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 150, frameWidth, 200)];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.alpha = 0;
    [self.view addSubview:myPickerView];
    
    if (item.selectedMask != nil) {
        [myPickerView selectRow:[item.selectedMask integerValue] inComponent:0 animated:true];
    }
    
    if (item.selectedMask == [NSNumber numberWithInteger:0])
    {
        self.hatImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pirate_hat"]];
        self.mouthImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pirate_mustache"]];
        self.beardImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pirate_beard"]];
        self.leftEyeImgView = nil;
        self.rightEyeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pirateEyePatch"]];
        pitch = 0.7;
    }
    else if (item.selectedMask == [NSNumber numberWithInteger:1])
    {
        self.hatImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"christmas_hat"]];
        self.mouthImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mustache"]];
        self.beardImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beard"]];
        self.leftEyeImgView = nil;
        self.rightEyeImgView = nil;
        pitch = 0.9;
    }
    else if (item.selectedMask == [NSNumber numberWithInteger:2])
    {
        self.hatImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diva_hair"]];
        self.mouthImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diva_lips"]];
        self.beardImgView = nil;
        self.leftEyeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diva_sunglasses"]];
        self.rightEyeImgView = nil;
        pitch = 1.4;
    }
    else if (item.selectedMask == [NSNumber numberWithInteger:3])
    {
        self.hatImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"batman_mask"]];
        self.mouthImgView = nil;
        self.beardImgView = nil;
        self.leftEyeImgView = nil;
        self.rightEyeImgView = nil;
        pitch = 0.6;
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
	item.name = itemName.text;
	NSManagedObjectContext *context = item.managedObjectContext;
    
    [self resetRecorder];
    [self resetPlayer];
    
    [OpenALH cleanUpOpenAL];
    
    myPickerView.alpha = 0;
    lbl2.alpha = 0;
    myPickerView = nil;
    
	NSError *error = nil;
	[context save: &error];
	[self.navigationController popViewControllerAnimated: YES];
    
}



- (void) textFieldDidEndEditing: (UITextField *) txtField
{
	if (txtField == itemName)
		item.name = txtField.text;
}



- (BOOL) textFieldShouldReturn: (UITextField *) txtField {
	[txtField resignFirstResponder];
	return YES;
}



- (void) takePhoto:(UIButton *)sender {
    
    myPickerView.alpha = 0;
    lbl2.alpha = 0;
    itemPic.alpha = 1;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"testIm.jpg"]];
        [self markFaces:image];
        
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                              message:@"Device has no camera"
//                                                             delegate:nil
//                                                    cancelButtonTitle:@"OK"
//                                                    otherButtonTitles: nil];
//        
//        [myAlertView show];
    }
    else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.preferredContentSize = CGSizeMake(480, 672);
        
        [self presentViewController: picker animated: YES completion: NULL];
    }
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    viewController.preferredContentSize = CGSizeMake(480, 672);
//}

#pragma mark - Image Picker Controller delegate methods

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *img = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:img];
    
    [self markFaces:image];
    
//    itemPic.image = img;
    
//    NSData* imgData = UIImageJPEGRepresentation(img, 1.0);
//    
//    NSArray *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docsDir = [docsPath objectAtIndex: 0];
//    NSString *loc = [NSString stringWithFormat:@"%@/%@.jpg", docsDir, item.name];
//    [imgData writeToFile:loc atomically:NO];
    
    [picker dismissViewControllerAnimated: YES completion: nil];
}



- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated: YES completion: nil];
    
}

- (UIImage *) getImage
{
    NSArray *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [docsPath objectAtIndex: 0];
    NSString *loc = [NSString stringWithFormat:@"%@/%@.jpg", docsDir, item.name];
    return[UIImage imageWithContentsOfFile: loc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordPauseTapped:(id)sender {
    
    [OpenALH stopSoundNamed:item.dateTime];
    isFirstPlay = true;
    
    if (self.recorder != nil && self.recorder.isRecording) {
        [recorder pause];
        [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
        return;
    }
    
    NSError *	error = nil;
    
    if (error) {
        [self popupWithMessage:[error localizedDescription]];
        return;
    }
    
    if (self.recorder == nil)
    {
        NSDictionary *	settings = @{
#if	0
                                     [NSNumber numberWithInt:kAudioFormatLinearPCM] : AVFormatIDKey,
                                     [NSNumber numberWithInt:16] : AVLinearPCMBitDepthKey,
                                     [NSNumber numberWithBool:NO] : AVLinearPCMIsBigEndianKey,
                                     [NSNumber numberWithBool:NO] : AVLinearPCMIsFloatKey,
#else
                                     [NSNumber numberWithInt:kAudioFormatAppleLossless] : AVFormatIDKey,
#endif
                                     [NSNumber numberWithFloat:44100.0] : AVSampleRateKey,
                                     [NSNumber numberWithInt:1] : AVNumberOfChannelsKey,
                                     [NSNumber numberWithInt:AVAudioQualityMax] : AVEncoderAudioQualityKey
                                     };
        
        AVAudioRecorder *	audioRecorder;
        
        audioRecorder = [[AVAudioRecorder alloc]
                         initWithURL:item.outputFileURL
                         settings:settings
                         error:&error];
        recorder = audioRecorder;
        audioRecorder = nil;
        if (error) {
            recorder = nil;
            [self popupWithMessage:[error localizedDescription]];
            return;
        }
    }
    
    BOOL	ready = [recorder prepareToRecord];
    if (ready) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:YES error:nil];
        
        self.playButton.enabled = NO;
        [self.recordPauseButton setTitle:NSLocalizedString(@"Pause", @"")
                                forState:UIControlStateNormal];
        
        [recorder setDelegate:self];
        [recorder setMeteringEnabled:YES];
        [recorder record];
        
        //audioRecorder = nil;
        
    }
    
    
}

-(void)resetRecorder
{
    self.playButton.enabled = YES;
    self.recorder = nil;
    
    [self.recordPauseButton setTitle:NSLocalizedString(@"Record", @"")
                            forState:UIControlStateNormal];
}


#pragma mark AVAudioRecorderDelegate
/*
 * audioRecorderDidFinishRecording:successfully: is called when a recording has
 * been finished or stopped. This method is NOT called if the recorder
 * is stopped due to an interruption.
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)audioRecorder
                          successfully:(BOOL)flag
{
    [self resetRecorder];
}

#pragma mark AVAudioRecorderDelegate
/* if an error occurs while encoding it will be reported to the delegate. */
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)audioRecorder
                                  error:(NSError *)error
{
    [self popupWithMessage:[error localizedDescription]];
    [audioRecorder stop];
    [audioRecorder deleteRecording];
    [self resetRecorder];
}

#pragma mark AVAudioRecorderDelegate
/*
 * audioRecorderBeginInterruption: is called when the audio session has been
 * interrupted while the recorder was recording. The recorded file will be
 * closed.
 */
-(void)audioRecorderBeginInterruption:(AVAudioRecorder *)audioRecorder
{
}

#pragma mark AVAudioRecorderDelegate
/*
 * audioRecorderEndInterruption:withOptions: is called when the audio session
 * interruption has ended and this recorder had been interrupted while
 * recording.
 * Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume.
 */
-(void)audioRecorderEndInterruption:(AVAudioRecorder *)audioRecorder
                        withOptions:(NSUInteger)flags
{
}

#if	0
#pragma mark AVAudioRecorderDelegate
-(void)audioRecorderEndInterruption:(AVAudioRecorder *)audioRecorder
                          withFlags:(NSUInteger)flags
{
}

#pragma mark AVAudioRecorderDelegate
/*
 * audioRecorderEndInterruption: is called when the preferred method,
 * audioRecorderEndInterruption:withFlags:, is not implemented.
 */
-(void)audioRecorderEndInterruption:(AVAudioRecorder *)audioRecorder
{
}
#endif

// thread that changes the button to Play when sound is done playing
-(void)isDonePlaying
{
    while ([OpenALH isPlaying]);
    [self.playButton setTitle:NSLocalizedString(@"Play", @"") forState:UIControlStateNormal];
}

- (IBAction)playTapped:(id)sender
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[item.outputFileURL path]]) {
        [self popupWithMessage:NSLocalizedString(@"NotFound", @"")];
        return;
    }
    
    if (self.player != nil && self.player.isPlaying) {
        [self.player stop];
        return;
    }
    
    NSError *	error = nil;
    
    AVAudioPlayer *	audioPlayer;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:item.outputFileURL
                   error:&error];
    self.player = audioPlayer;
    audioPlayer = nil;
    if (error) {
        self.player = nil;
        [self popupWithMessage:[error localizedDescription]];
        return;
    }
    
    if ([OpenALH isPlaying] == false)
    {
        if (isFirstPlay == true)
        {
            [OpenALH loadSoundNamed:item.dateTime withFileName:item.outputFileURL withPitch:pitch];
            [OpenALH playSoundNamed:item.dateTime withIsFirst:isFirstPlay];
            isFirstPlay = false;
        }
        else
            [OpenALH playSoundNamed:item.dateTime withIsFirst:isFirstPlay];
        
        [self.playButton setTitle:NSLocalizedString(@"Pause", @"") forState:UIControlStateNormal];
        
        // run thread to change button to Play when the sound is done playing
        [self performSelectorInBackground:@selector(isDonePlaying) withObject:nil];
        
    }
    else
    {
        [OpenALH pauseSoundNamed:item.dateTime];
        [self.playButton setTitle:NSLocalizedString(@"Play", @"") forState:UIControlStateNormal];
    }
    
    //    [OpenALH loadSoundNamed:item.dateTime withFileName:item.outputFileURL];
    //
    //    BOOL	ready = [self.player prepareToPlay];
    //    if (ready) {
    //        [player setDelegate:self];
    //        [player setMeteringEnabled:YES];
    //        [player play];
    //        self.recordPauseButton.enabled = NO;
    //        [self.playButton setTitle:NSLocalizedString(@"Stop", @"")
    //                         forState:UIControlStateNormal];
    //    }
    //audioPlayer = nil;
}

-(void)resetPlayer
{
    self.recordPauseButton.enabled = YES;
    self.player = nil;
    
    [self.playButton setTitle:NSLocalizedString(@"Play", @"") forState:UIControlStateNormal];
}

- (IBAction)stopTapped:(id)sender {
    [recorder stop];
    [OpenALH stopSoundNamed:item.dateTime];
    [self.playButton setTitle:NSLocalizedString(@"Play", @"") forState:UIControlStateNormal];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setActive:NO error:nil];
}

#pragma mark AVAudioPlayerDelegate
/*
 * audioPlayerDidFinishPlaying:successfully: is called when a sound has finished
 * playing. This method is NOT called if the player is stopped due to an
 * interruption.
 */
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                      successfully:(BOOL)flag
{
    [self resetPlayer];
}

#pragma mark AVAudioPlayerDelegate
// if an error occurs while decoding it will be reported to the delegate.
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player
                                error:(NSError *)error
{
    [self popupWithMessage:[error localizedDescription]];
    [self resetPlayer];
}

#pragma mark AVAudioPlayerDelegate
/*
 * audioPlayerBeginInterruption: is called when the audio session has been
 * interrupted while the player was playing. The player will have been paused.
 */
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
}

#pragma mark AVAudioPlayerDelegate
/*
 * audioPlayerEndInterruption:withOptions: is called when the audio session
 * interruption has ended and this player had been interrupted while playing.
 * Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume.
 */
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
                      withOptions:(NSUInteger)flags
{
}

#if	0
#pragma mark AVAudioPlayerDelegate
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
                        withFlags:(NSUInteger)flags
{
}

#pragma mark AVAudioPlayerDelegate
/*
 * audioPlayerEndInterruption: is called when the preferred method,
 * audioPlayerEndInterruption:withFlags:, is not implemented.
 */
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
}
#endif

/*****************************************************************************/

-(void)popupWithMessage:(NSString *)message
{
    UIAlertView *	alertView;
    alertView = [[UIAlertView alloc]
                 initWithTitle:NSLocalizedString(@"Error", @"")
                 message:message
                 delegate:nil
                 cancelButtonTitle:NSLocalizedString(@"Close", @"")
                 otherButtonTitles:nil];
    [alertView show];
    alertView = nil;
}

-(void) markFaces:(UIImageView *)facePicture
{
    //create a context a context for the image to merge the original with the masks
    CGSize newSize = CGSizeMake(facePicture.bounds.size.width, facePicture.bounds.size.height);
    UIGraphicsBeginImageContext( newSize );
    [facePicture.image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // CI image with the previously loaded face detection picture
    CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];
    
    // create a face detector with high accuracy
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    // create an array containing all the detected faces from the detector
    NSArray* features = [detector featuresInImage:image];
    
    // iterate through every detected face.
    for(CIFaceFeature* faceFeature in features)
    {
        
        CGRect faceRect = [faceFeature bounds];
        
        // get the width & height of the face
        CGFloat faceWidth = faceRect.size.width;
        CGFloat faceHeight = faceRect.size.height;
        
        if (self.hatImgView != nil) {
            
            //CGRect hatRect = [self.hatImgView bounds];
            
            if (item.selectedMask == [NSNumber numberWithInteger:0]) {
                [self.hatImgView.image drawInRect:CGRectMake(faceRect.origin.x-faceWidth/2, faceRect.origin.y-faceHeight,faceWidth*2,faceHeight)];
            }
            else if (item.selectedMask == [NSNumber numberWithInteger:1])
            {
                [self.hatImgView.image drawInRect:CGRectMake(faceRect.origin.x-faceWidth/3, faceRect.origin.y-faceHeight,faceWidth*1.4,faceHeight)];
            }
            else if (item.selectedMask == [NSNumber numberWithInteger:2])
            {
                [self.hatImgView.image drawInRect:CGRectMake(faceRect.origin.x-faceWidth, faceRect.origin.y-faceHeight*1.5,faceWidth*3,faceHeight*2)];
            }
            else if (item.selectedMask == [NSNumber numberWithInteger:3])
            {
                [self.hatImgView.image drawInRect:CGRectMake(faceRect.origin.x, faceRect.origin.y-faceHeight*0.93,faceWidth*1.1,faceHeight*1.4)];
            }
        }
        
        if(faceFeature.hasLeftEyePosition)
        {
            if (leftEyeImgView != nil) {
                [self.leftEyeImgView.image drawInRect:CGRectMake(faceFeature.leftEyePosition.x-faceWidth/3.2, faceFeature.leftEyePosition.y-faceHeight*0.9,faceWidth,faceHeight/3.2)];
            }
            
        }
        
        if(faceFeature.hasRightEyePosition)
        {
            if (rightEyeImgView != nil) {
                [self.rightEyeImgView.image drawInRect:CGRectMake(faceFeature.rightEyePosition.x-faceWidth/4, faceFeature.rightEyePosition.y-faceHeight*0.9,faceWidth*0.4,faceWidth*0.4)];
            }
        }
        
        if(faceFeature.hasMouthPosition)
        {
            //CGRect mouthRect = [self.mouthImgView bounds];
            
            if (self.mouthImgView != nil) {
                if (item.selectedMask == [NSNumber numberWithInteger:0]) {
                    [self.mouthImgView.image drawInRect:CGRectMake(faceFeature.mouthPosition.x-faceWidth/4.6,faceFeature.mouthPosition.y,faceWidth/2,faceHeight*0.167)];
                }
                else if (item.selectedMask == [NSNumber numberWithInteger:1])
                {
                    [self.mouthImgView.image drawInRect:CGRectMake(faceFeature.mouthPosition.x-faceWidth/4.6,faceFeature.mouthPosition.y,faceWidth/2,faceHeight*0.167)];
                }
                else if (item.selectedMask == [NSNumber numberWithInteger:2])
                {
                    [self.mouthImgView.image drawInRect:CGRectMake(faceFeature.mouthPosition.x-faceWidth/4.3,faceFeature.mouthPosition.y,faceWidth/2,faceHeight*0.3)];
                }
            }
            
            if (self.beardImgView != nil) {
                if (item.selectedMask == [NSNumber numberWithInteger:0]) {
                    [self.beardImgView.image drawInRect:CGRectMake(faceFeature.mouthPosition.x*0.9,faceFeature.mouthPosition.y*1.2,faceWidth*0.3,faceHeight*0.3)];
                }
                else if (item.selectedMask == [NSNumber numberWithInteger:1])
                {
                    [self.beardImgView.image drawInRect:CGRectMake(faceFeature.mouthPosition.x-faceWidth/2.2,faceFeature.mouthPosition.y,faceWidth,faceHeight)];
                }
            }
            
        }
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData* imgData = UIImageJPEGRepresentation(newImage, 1.0);
    
    NSArray *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [docsPath objectAtIndex: 0];
    NSString *loc = [NSString stringWithFormat:@"%@/%@.jpg", docsDir, item.name];
    [imgData writeToFile:loc atomically:NO];
    
    itemPic.image = newImage;
}

- (void)chooseMaskTapped:(id)sender{
    myPickerView.alpha = 1;
    lbl2.alpha = 1;
    itemPic.alpha = 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    item.selectedMask = [NSNumber numberWithInteger:row];
    
    if (row == 0) {
        self.hatImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pirate_hat"]];
        self.mouthImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pirate_mustache"]];
        self.beardImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pirate_beard"]];
        self.leftEyeImgView = nil;
        self.rightEyeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pirateEyePatch"]];
        pitch = 0.7;
        isFirstPlay = true;
    }
    else if (row == 1)
    {
        self.hatImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"christmas_hat"]];
        self.mouthImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mustache"]];
        self.beardImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beard"]];
        self.leftEyeImgView = nil;
        self.rightEyeImgView = nil;
        pitch = 0.9;
        isFirstPlay = true;
    }
    else if (row == 2)
    {
        self.hatImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diva_hair"]];
        self.mouthImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diva_lips"]];
        self.beardImgView = nil;
        self.leftEyeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diva_sunglasses"]];
        self.rightEyeImgView = nil;
        pitch = 1.4;
        isFirstPlay = true;
    }
    else if (row == 3)
    {
        self.hatImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"batman_mask"]];
        self.mouthImgView = nil;
        self.beardImgView = nil;
        self.leftEyeImgView = nil;
        self.rightEyeImgView = nil;
        pitch = 0.6;
        isFirstPlay = true;
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 4;
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title;
    if (row == 0) {
        title = @"Pirate";
    }
    else if (row == 1)
    {
        title = @"Santa Clause";
    }
    else if (row == 2)
    {
        title = @"Pink Afro";
    }
    else if (row == 3)
    {
        title = @"Batman";
    }
    
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    mutParaStyle.alignment = NSTextAlignmentCenter;
    [as addAttribute:NSParagraphStyleAttributeName value:mutParaStyle range:NSMakeRange(0,[title length])];
    return as;
}

- (void)sendImageTapped:(id)sender{
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[@"9145361360"];
    NSString *message = [NSString stringWithFormat:@"Check me out, I just got masked out of my mind!"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    [messageController addAttachmentURL:item.outputFileURL withAlternateFilename:item.dateTime];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
