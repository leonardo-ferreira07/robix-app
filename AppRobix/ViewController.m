//
//  ViewController.m
//  AppRobix
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 10/06/14.
//  Copyright (c) 2014 Leonardo Vinicius Kaminski Ferreira. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


@synthesize labelX, labelY, labelZ, progressX, progressY, progressZ, labelSlider;


            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // inicia o acelerômetro
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    // tempo para receber updates em segundos.
    accelerometer.updateInterval = 0.45;
    // delegate
    accelerometer.delegate = self;
    
    self.enviaFirst = NO;
    
    
    [self iniciaComunicacao]; // chama o método que inicia a comunicação.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload{
    
    [UIAccelerometer sharedAccelerometer].delegate = nil; //para o monitoramento.
    
    [super viewDidUnload];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    // recebe os valores do acelerômetro, e atualiza a interface com os valores atuais.
    
    int valorX = (int)round((acceleration.x * 90));
    int valorY = (int)round((acceleration.y * 90));
    int valorZ = (int)round((acceleration.z * 90));
    
    
    
    labelX.text = [NSString stringWithFormat:@"%i", valorX];
    labelY.text = [NSString stringWithFormat:@"%i", valorY];
    labelZ.text = [NSString stringWithFormat:@"%i", valorZ];
    
    self.progressX.progress = ABS(acceleration.x);
    self.progressY.progress = ABS(acceleration.y);
    self.progressZ.progress = ABS(acceleration.z);
    
    //NSLog(@"5,%i", valorX);
    
    //[self enviaMensagem:[NSString stringWithFormat:@"2,%i", valorX]]; // toda vez que o valor do acelerômetro for atualizado, enviará a mensagem atualizada para o servidor.
    
    //NSLog(@"enviou o valor de acelerometro.");
    
    // *****###### CRIAR A LÓGICA PARA SABER QUAL MOTOR MOVER A PARTIR DOS VALORES RECEBIDOS DE X, Y E Z DO ACELERÔMETRO.
    
}

- (IBAction)atualizacaoValorSlider:(id)sender { //método que recebe o valor do Slider e atualiza o valor do mesmo na label.
    
    UISlider *slider = sender;
    
    int valorSlider = (int)round(slider.value);
    
    labelSlider.text = [NSString stringWithFormat:@"%i", valorSlider];
    
    NSLog(@"5,%i", valorSlider);
    
    

    [self enviaMensagem:[NSString stringWithFormat:@"5,%i\n", valorSlider]]; // toda vez que o slider for atualizado, enviará a mensagem atualizada para o servidor.
    
   // NSLog(@"enviou o valor do Slider");
    
}

- (IBAction)btnTeste:(id)sender {
    
    [self enviaMensagem:@"2,90\n"];
    uint8_t string[] = "2,90\n";
    [outputStream write:string maxLength:strlen((char*)string)];
    
    NSLog(@"mensagem: 2,90 enviada.");
    
}


- (void)iniciaComunicacao { // método que cria todos os parâmetros e inicia(abre) a conexão com o servidor.
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.42.247", 9000, &readStream, &writeStream);
    inputStream = (__bridge_transfer NSInputStream *)readStream;
    outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    
    inputStream.delegate = self;
    outputStream.delegate = self;
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
}


- (void)enviaMensagem:(NSString *) mensagem { // método que vai fazer as conversões de String e enviará a mensagem convertida.
    
    
    NSData *data = [[NSData alloc] initWithData:[[NSString stringWithFormat:@"%@", mensagem] dataUsingEncoding:NSUTF8StringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
}




- (void)stream:(NSStream *)minhaStream handleEvent:(NSStreamEvent)streamEvent { // método que recebe mensagem por inputStream e faz todo o tratamento da mensagem que será exibida.
    
    
    switch (streamEvent) {
            
        
        case NSStreamEventHasSpaceAvailable:
            if(minhaStream == outputStream){
                NSString *vai = @"2,90\n";
                [self writeOut:vai];
                
            }
            
            break;
            
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream de comunicação aberta.");
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (minhaStream == inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *mensagemRecebida = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUnicodeStringEncoding];
                        
                        if (mensagemRecebida != nil) {
                            NSLog(@"Mensagem recebida do servidor: %@", mensagemRecebida);
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Não foi possível conectar com o host.");
            break;
            
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Cliente normal, aguardando algo...");
    }
}






- (void)writeOut:(NSString *)s {
    
    uint8_t *buf = (uint8_t *)[s UTF8String];
    
    NSInteger nwritten=[outputStream write:buf maxLength:strlen((char *)buf)];
    if (-1 == nwritten) {
        NSLog(@"Error writing to stream %@: %@", outputStream, [outputStream streamError]);
    } else {
        NSLog(@"Wrote %ld bytes to stream %@.", (long)nwritten, outputStream);
        int a = 0;
        NSLog(@"%i", a);
        a++;
    }
    NSLog(@"Writing out the following:");
    NSLog(@"%@", s);
}



@end

