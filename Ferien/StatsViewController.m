//
//  StatsViewController.m
//  Ferien
//
//  Created by Tobi on 02.02.13.
//  Copyright (c) 2013 Tobi. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController ()

@end

@implementation StatsViewController

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 16;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    Ferien *ferien = [[Ferien alloc] init];
    
    NSNumber *num = nil;
    if ([plot isKindOfClass:[CPTBarPlot class]]) {
        NSArray *reversedArrayCount = [[ferien.getToplist reverseObjectEnumerator] allObjects];
        num = (NSNumber *)[NSNumber numberWithFloat:[[reversedArrayCount objectAtIndex:index] floatValue]];
        }
    return num;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    if ( [plot.identifier isEqual: @"bl"] ) {
        Ferien *ferien = [[Ferien alloc] init];
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
        textStyle.fontName = @"Helvetica-Bold";
        textStyle.fontSize = 8.0f;
        textStyle.color = [CPTColor blackColor];
        
        NSArray *reversedArrayBl = [[ferien.bundeslandListWithManagedObjects reverseObjectEnumerator] allObjects];
        NSArray *reversedArrayCount = [[ferien.getToplist reverseObjectEnumerator] allObjects];
        
        CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@ (%@)", [reversedArrayBl objectAtIndex:index], [reversedArrayCount objectAtIndex:index]]];
        label.textStyle = textStyle;
        
        return label;
    }
    
    CPTTextLayer *defaultLabel = [[CPTTextLayer alloc] initWithText:@"Label"];
    return defaultLabel;
    
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index {
    if ([barPlot.identifier isEqual:@"bl"] ) {
        Ferien *ferien = [[Ferien alloc] init];

        NSMutableArray *colors = [[NSMutableArray alloc] initWithObjects:[UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], [UIColor lightGrayColor], nil];
        
        [colors replaceObjectAtIndex:15-ferien.currentBundesland withObject:[UIColor orangeColor]];
        
        for (int i = 0; i < 16; i++) {
            CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[colors objectAtIndex:index]
                                                            endingColor:[CPTColor whiteColor]
                                                      beginningPosition:0.0 endingPosition:1.5 ];
            [gradient setGradientType:CPTGradientTypeAxial];
            [gradient setAngle:320.0];
        
            CPTFill *fill = [CPTFill fillWithGradient:gradient];
        
            return fill;
        }
    }
    return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    
}

- (void)initView {
    self.labelFerienName.text = self.ferienName;
    self.labelFeriendauer.text = self.feriendauer;
}

- (void)mergeChanges:(NSNotification *)notification {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [delegate managedObjectContext];
    
    // Merge changes into the main context on the main thread
    [mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                  withObject:notification
                               waitUntilDone:YES];
}

- (void)initGraph {
    @autoreleasepool {
        
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        
        // Every thread needs its own managed object context
        NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
        [moc setUndoManager:nil];
        [moc setPersistentStoreCoordinator: [delegate persistentStoreCoordinator]];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(mergeChanges:)
                   name:NSManagedObjectContextDidSaveNotification
                 object:moc];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480) {
                CPTGraphHostingView *chartView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(10, 100, 290, 330)];
                [self.view addSubview:chartView];
                
                CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:chartView.bounds];
                graph.plotAreaFrame.masksToBorder = NO;
                chartView.hostedGraph = graph;

                graph.paddingLeft = 20.0f;
                graph.paddingTop = 0.0f;
                graph.paddingRight = 0.0f;
                graph.paddingBottom = 20.0f;
                
                CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
                textStyle.color = [CPTColor grayColor];
                textStyle.fontName = @"Helvetica-Bold";
                textStyle.fontSize = 8.0f;;
                
                CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
                axisTitleStyle.color = [CPTColor grayColor];
                axisTitleStyle.fontName = @"Helvetica-Bold";
                axisTitleStyle.fontSize = 12.0f;
                CPTMutableLineStyle *axisLineStyleX = [CPTMutableLineStyle lineStyle];
                axisLineStyleX.lineWidth = 2.0f;
                axisLineStyleX.lineColor = [CPTColor grayColor];
                CPTMutableLineStyle *axisLineStyleY = [CPTMutableLineStyle lineStyle];
                axisLineStyleY.lineWidth = 2.0f;
                axisLineStyleY.lineColor = [CPTColor grayColor];
                
                CPTXYAxisSet *axisSet = (CPTXYAxisSet *) chartView.hostedGraph.axisSet;
                
                axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
                axisSet.xAxis.title = @"Ferientage pro Jahr";
                axisSet.xAxis.titleTextStyle = axisTitleStyle;
                axisSet.xAxis.titleOffset = 10.0f;
                axisSet.xAxis.axisLineStyle = axisLineStyleX;
                axisSet.xAxis.labelTextStyle = textStyle;
                axisSet.xAxis.labelOffset = -7.0f;
                axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(10.0f);
                axisSet.xAxis.labelFormatter.maximumFractionDigits = 0;
                
                axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
                axisSet.yAxis.title = @"Bundesländer";
                axisSet.yAxis.titleTextStyle = axisTitleStyle;
                axisSet.yAxis.titleOffset = 5.0f;
                axisSet.yAxis.axisLineStyle = axisLineStyleY;
                
                CPTXYPlotSpace *plotspace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
                plotspace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(110)];
                plotspace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(17)];
                [graph addPlotSpace:plotspace];
                
                CPTBarPlot *plot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:YES];
                plot.plotRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.5) length:CPTDecimalFromFloat(16)];
                plot.labelTextStyle = textStyle;
                plot.labelFormatter.maximumFractionDigits = 0;
                plot.labelOffset = -3.0f;
                plot.identifier = @"bl";
                plot.dataSource = self;
                plot.delegate = self;
                [graph addPlot:plot];
                
                plot.anchorPoint = CGPointMake(0.0, 0.0);
                CABasicAnimation *scaling = [CABasicAnimation
                                             animationWithKeyPath:@"transform.scale.x"];
                scaling.fromValue = [NSNumber numberWithFloat:0.0];
                scaling.toValue = [NSNumber numberWithFloat:1.0];
                scaling.duration = 1.0f;
                scaling.removedOnCompletion = NO;
                scaling.fillMode = kCAFillModeForwards;
                [plot addAnimation:scaling forKey:@"scaling"];
            }
            if(result.height == 568) {
                CPTGraphHostingView *chartView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(10, 100, 290, 420)];
                [self.view addSubview:chartView];
                
                CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:chartView.bounds];
                graph.plotAreaFrame.masksToBorder = NO;
                chartView.hostedGraph = graph;
                
                graph.paddingLeft = 20.0f;
                graph.paddingTop = 0.0f;
                graph.paddingRight = 0.0f;
                graph.paddingBottom = 20.0f;
                
                CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
                textStyle.color = [CPTColor grayColor];
                textStyle.fontName = @"Helvetica-Bold";
                textStyle.fontSize = 8.0f;;
                
                CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
                axisTitleStyle.color = [CPTColor grayColor];
                axisTitleStyle.fontName = @"Helvetica-Bold";
                axisTitleStyle.fontSize = 12.0f;
                CPTMutableLineStyle *axisLineStyleX = [CPTMutableLineStyle lineStyle];
                axisLineStyleX.lineWidth = 2.0f;
                axisLineStyleX.lineColor = [CPTColor grayColor];
                CPTMutableLineStyle *axisLineStyleY = [CPTMutableLineStyle lineStyle];
                axisLineStyleY.lineWidth = 2.0f;
                axisLineStyleY.lineColor = [CPTColor grayColor];
                
                CPTXYAxisSet *axisSet = (CPTXYAxisSet *) chartView.hostedGraph.axisSet;
                
                axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
                axisSet.xAxis.title = @"Ferientage pro Jahr";
                axisSet.xAxis.titleTextStyle = axisTitleStyle;
                axisSet.xAxis.titleOffset = 10.0f;
                axisSet.xAxis.axisLineStyle = axisLineStyleX;
                axisSet.xAxis.labelTextStyle = textStyle;
                axisSet.xAxis.labelOffset = -7.0f;
                axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(10.0f);
                axisSet.xAxis.labelFormatter.maximumFractionDigits = 0;
                
                axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
                axisSet.yAxis.title = @"Bundesländer";
                axisSet.yAxis.titleTextStyle = axisTitleStyle;
                axisSet.yAxis.titleOffset = 5.0f;
                axisSet.yAxis.axisLineStyle = axisLineStyleY;
                
                CPTXYPlotSpace *plotspace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
                plotspace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(110)];
                plotspace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(17)];
                [graph addPlotSpace:plotspace];
                
                CPTBarPlot *plot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:YES];
                plot.plotRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.5) length:CPTDecimalFromFloat(16)];
                plot.labelTextStyle = textStyle;
                plot.labelFormatter.maximumFractionDigits = 0;
                plot.labelOffset = -3.0f;
                plot.identifier = @"bl";
                plot.dataSource = self;
                plot.delegate = self;
                [graph addPlot:plot];
                
                plot.anchorPoint = CGPointMake(0.0, 0.0);
                CABasicAnimation *scaling = [CABasicAnimation
                animationWithKeyPath:@"transform.scale.x"];
                scaling.fromValue = [NSNumber numberWithFloat:0.0];
                scaling.toValue = [NSNumber numberWithFloat:1.0];
                scaling.duration = 1.0f;
                scaling.removedOnCompletion = NO;
                scaling.fillMode = kCAFillModeForwards;
                [plot addAnimation:scaling forKey:@"scaling"];
            }
        }
        [self.spinner stopAnimating];
        self.returnButton.hidden = NO;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   	[self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [NSThread detachNewThreadSelector:@selector(initGraph) toTarget:self withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
}

@end
