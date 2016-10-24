//
//  ViewController.h
//  AppRobix
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 10/06/14.
//  Copyright (c) 2014 Leonardo Vinicius Kaminski Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAccelerometerDelegate, NSStreamDelegate> {
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
}
@property (nonatomic) BOOL enviaFirst;
@property (weak, nonatomic) IBOutlet UILabel *labelX;
@property (weak, nonatomic) IBOutlet UILabel *labelY;
@property (weak, nonatomic) IBOutlet UILabel *labelZ;
@property (weak, nonatomic) IBOutlet UILabel *labelSlider;

@property (weak, nonatomic) IBOutlet UIProgressView *progressX;
@property (weak, nonatomic) IBOutlet UIProgressView *progressY;
@property (weak, nonatomic) IBOutlet UIProgressView *progressZ;

- (IBAction)atualizacaoValorSlider:(id)sender;

- (IBAction)btnTeste:(id)sender;


@end

