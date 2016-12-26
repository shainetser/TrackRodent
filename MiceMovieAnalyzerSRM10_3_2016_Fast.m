function  [MouseLocationCenterOfBody,TimesOfStimuliExploration,TimesInDifferentCompartments,firstFrameInTheAnalysis,LastFrameAnalyzed]=MiceMovieAnalyzerSRM23_7_14(filenameBehavioral,HandlesForGUIControls,StartingFrameForAnalysis,EndingFrameForAnalysis,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,SaveMovie,LowThresholdValue,HighThresholdValue, MovieNum);
   %%%%% The purpose of this function is to analyze the behavioral data.
   %%%%% It can evaluate general features about a single mouse
   %%%%% behavior, such as location and its derivatives.
   %%%%% It is also usefull for analyzing social recognition paradigms
   %%%%% and evaluate the time spent near a noval versus familiar conspecifics.
   %%%%% The addition in this algorism is for tracking the mouse nose and
   %%%%% directionality.
   

global StopAnalysis
   
  MouseLocationCenterOfBody=[];
  TimesOfStimuliExploration=cell(1,3);
  TimesInDifferentCompartments=cell(1,5);
  if SaveMovie==1 
     filenameOfMovie=[filenameBehavioral(1:end-4) '_AnalyzedMovie'];
     MouseTrackingMovie = VideoWriter([filenameOfMovie '.avi']);
     open(MouseTrackingMovie);
  end
  Film = VideoReader(filenameBehavioral);
 
  for k=StartingFrameForAnalysis:EndingFrameForAnalysis
  
     %%%%% open the image, convert it to black and white and clean it from noise 
     %%%%% High and low thresholds in this algorithm are used for detection
     %%%%% of the tail outside of the ellipse fitted to the mouse
     %%%%% boundaries. low threshold is for finding the ellipse and high
     %%%%% threshold is for finding the tail outside of the ellipse.
     cdataRGB = read(Film,k);
     cdataBW_LowThreshold=im2bw(cdataRGB,LowThresholdValue);
     cdataWB_LowThreshold=zeros(size(cdataBW_LowThreshold,1),size(cdataBW_LowThreshold,2));
     cdataWB_LowThreshold(find(cdataBW_LowThreshold==0))=1;
     Clean_cdataWB_LowThreshold = bwareaopen(cdataWB_LowThreshold, 400);
     
     cdataBW_HighThreshold=im2bw(cdataRGB,HighThresholdValue);
     cdataWB_HighThreshold=zeros(size(cdataBW_HighThreshold,1),size(cdataBW_HighThreshold,2));
     cdataWB_HighThreshold(find(cdataBW_HighThreshold==0))=1;
     Clean_cdataWB_HighThreshold = bwareaopen(cdataWB_HighThreshold, 400);
     
     %%%%% exclude pixels that were excluded from the image by the user
     for i=1:length(ExcludedAreasList)
           AreaToExclude=[];
           AreaToExclude=ExcludedAreasList{1,i}; 
           for j=1:size(AreaToExclude,1)
              Clean_cdataWB_LowThreshold(AreaToExclude(j,1),AreaToExclude(j,2))=0;
              Clean_cdataWB_HighThreshold(AreaToExclude(j,1),AreaToExclude(j,2))=0;
           end 
     end
     
     %%%%% change the areas of the stimuli in the clean black and white
     %%%%% image ('Clean_cdataWB') to black. For avoiding searching the
     %%%%% subject mouse location in them.
     for i=1:length(StimuliPositionsList)
        StimulusPixels=[];
        StimulusPixels=StimuliPositionsList{1,i}; 
        for j=1:size(StimulusPixels,1)
           Clean_cdataWB_LowThreshold(StimulusPixels(j,1),StimulusPixels(j,2))=0; 
           Clean_cdataWB_HighThreshold(StimulusPixels(j,1),StimulusPixels(j,2))=0; 
        end 
     end
     
     %%%%% look for boundaries of the mouse with high and low thresholds
     BoundariesWB_LowThreshold = bwboundaries(Clean_cdataWB_LowThreshold);
     BoundariesWB_HighThreshold = bwboundaries(Clean_cdataWB_HighThreshold);
     try
        BoundariesSizes_LowThreshold=[];
        for i=1:size(BoundariesWB_LowThreshold,1)
           BoundariesSizes_LowThreshold=[BoundariesSizes_LowThreshold,size(BoundariesWB_LowThreshold{i,1},1)];
        end
        MouseBoundary_LowThreshold=BoundariesWB_LowThreshold{find(BoundariesSizes_LowThreshold==max(BoundariesSizes_LowThreshold)),1};
        
        BoundariesSizes_HighThreshold=[];
        for i=1:size(BoundariesWB_HighThreshold,1)
           BoundariesSizes_HighThreshold=[BoundariesSizes_HighThreshold,size(BoundariesWB_HighThreshold{i,1},1)];
        end
        MouseBoundary_HighThreshold=BoundariesWB_HighThreshold{find(BoundariesSizes_HighThreshold==max(BoundariesSizes_HighThreshold)),1};

     catch
         MouseBoundary_LowThreshold=[];
         MouseBoundary_HighThreshold=[];
         
     end
     
     %%%%% Find the boarders of the stimuli areas
     if k==StartingFrameForAnalysis
        for i=1:length(StimuliPositionsList)
           StimulusPixels=[];
           StimulusPixels=StimuliPositionsList{1,i}; 
           StimulusAreaOnFrame=zeros(size(cdataBW_LowThreshold,1),size(cdataBW_LowThreshold,2));
           for j=1:size(StimulusPixels,1)
              StimulusAreaOnFrame(StimulusPixels(j,1),StimulusPixels(j,2))=255;  
           end 
           se = strel('disk',1);
           ExtentedStimulusAreaOnFrame=imdilate(StimulusAreaOnFrame,se);
           StimulusBoundariesPixels=bwboundaries(ExtentedStimulusAreaOnFrame);
           if ~isempty(StimuliPositionsList{1,i})
              ALLStimuliBoundariesPixels{1,i}=StimulusBoundariesPixels{1,1};
           end
        end 
        firstFrameInTheAnalysis=cdataRGB; %%%%% This parameter is saved for returning the first image of the analysis for presentation requirments 
     end
     
     
     %%%%% collect the 'MouseLocationCenterOfBody' according to the lowThreshold BW conversion and look for its location
    %%%%% within the different compartments 'CompartmentsPositionsList'
    if ~isempty(MouseBoundary_LowThreshold)
       MouseLocationCenterOfBody=[MouseLocationCenterOfBody; round(mean(MouseBoundary_LowThreshold(:,2))),round(mean(MouseBoundary_LowThreshold(:,1)))];
       for i=1:length(CompartmentsPositionsList)
          Compartment=[];
          Compartment=CompartmentsPositionsList{1,i}; 
          if ~isempty(Compartment)
             if find(Compartment(find(Compartment(:,1)==round(mean(MouseBoundary_LowThreshold(:,1)))),2)==round(mean(MouseBoundary_LowThreshold(:,2))))
                TimesInDifferentCompartments{1,i}=[[TimesInDifferentCompartments{1,i}],k]; 
             end
          end
       end
    end
    
    
    %%%% Find here the mouse pixels bourders of the head according to
    %%%% the ellipse and the assumed tail location. Do this only when the
    %%%% mouse center of body is stable, which assumes the mouse is not
    %%%% moving to much such as during inversigation of something stationary.
    
    MouseBoundaryHead=[];
    try
       if ~isempty(MouseBoundary_LowThreshold)
       %%%% fit an ellipse to the mouse low-threshold boundaries
          MouseEllipseFitParameters = ellipseFit4HC(transpose(MouseBoundary_LowThreshold(:,2)),transpose(MouseBoundary_LowThreshold(:,1)));
     
       %%%% finding the ellipse farest vertices.
          DistanceTemp=0;
          DistanceMax=0;
          for i=1:length(MouseEllipseFitParameters.mu_X_fit)
             for j=1:length(MouseEllipseFitParameters.mu_X_fit)
                Point1X=MouseEllipseFitParameters.mu_X_fit(i);
                Point1Y=MouseEllipseFitParameters.nu_Y_fit(i);
                Point2X=MouseEllipseFitParameters.mu_X_fit(j);
                Point2Y=MouseEllipseFitParameters.nu_Y_fit(j);
                DistanceTemp=sqrt((Point1X-Point2X)^2+(Point1Y-Point2Y)^2);
                if DistanceTemp>DistanceMax
                   DistanceMax=DistanceTemp; 
                   EllipseTip1=[Point1X,Point1Y];
                   EllipseTip2=[Point2X,Point2Y];
                end
             end
          end
       %%%% finding which vertex of the ellipse is the head. 
       %%%% 'MouseTailDirection' is calculated according to the average
       %%%% pixels location using high threshold. This assumes the tail
       %%%% is detected, which shift the location of the averaged pixels to be
       %%%% closer to the tail.
          MouseTailDirection=[mean(MouseBoundary_HighThreshold(:,2)),mean(MouseBoundary_HighThreshold(:,1))];
          if abs(EllipseTip1(1,1)-MouseTailDirection(1,1))+ abs(EllipseTip1(1,2)-MouseTailDirection(1,2))<= abs(EllipseTip2(1,1)-MouseTailDirection(1,1))+ abs(EllipseTip2(1,2)-MouseTailDirection(1,2)) 
             EllipseTipMouseHead=EllipseTip2;
          else
             EllipseTipMouseHead=EllipseTip1; 
          end
         
          Temp=find([abs(MouseBoundary_LowThreshold(:,2)-EllipseTipMouseHead(1,1))]<25);
          Temp2=find([abs(MouseBoundary_LowThreshold(Temp,1)-EllipseTipMouseHead(1,2))]<25);
          MouseBoundaryHead=[MouseBoundary_LowThreshold(Temp(Temp2),2),MouseBoundary_LowThreshold(Temp(Temp2),1)];
       end
    catch
        %%%% do nothing at the moment. 
        %%%% Catch is for failiers of the "ellipseFit4HC" algorithm.
    end
    
    
    %%%%% Find the number of pixels of the stimuli areas boundaries ('ALLStimuliBoundariesPixels') 
    %%%%% that were touched by the subject mouse head('MouseBoundaryHead')    
    NumOfMousePixelsAroundStimulus1=0;
    NumOfMousePixelsAroundStimulus2=0;
    NumOfMousePixelsAroundStimulus3=0;
    if ~isempty(MouseBoundaryHead)  %%%% if 'MouseBoundaryHead' is empty the algorithm did not found the mouse or the mouse is moving fast and probably not investigating
       if (exist('ALLStimuliBoundariesPixels'))
          for i=1:length(ALLStimuliBoundariesPixels) 
             StimulusBoundariesPixels=ALLStimuliBoundariesPixels{1,i};   
             for j=1:size(StimulusBoundariesPixels,1)
                Temp=find(MouseBoundaryHead(:,2)==StimulusBoundariesPixels(j,1));
                if ~isempty(find(MouseBoundaryHead(Temp,1)==StimulusBoundariesPixels(j,2)));
                   if i==1
                      NumOfMousePixelsAroundStimulus1=NumOfMousePixelsAroundStimulus1+1; 
                   elseif i==2
                      NumOfMousePixelsAroundStimulus2=NumOfMousePixelsAroundStimulus2+1;  
                   elseif i==3
                      NumOfMousePixelsAroundStimulus3=NumOfMousePixelsAroundStimulus3+1; 
                   else
                      %%%%% do nothing at the moment%%%%% 
                   end 
                end
             end 
          end
       end
    end
    

    %%%%%%% ploting the ellipse around the mouse for presentation only
%     plot(MouseEllipseFitParameters.mu_X_fit,MouseEllipseFitParameters.nu_Y_fit,'o','LineWidth',1,'MarkerSize',1);
    
    if ~isempty(MouseBoundaryHead)
       if NumOfMousePixelsAroundStimulus1>5
          TimesOfStimuliExploration{1,1}=[[TimesOfStimuliExploration{1,1}],k];
       elseif NumOfMousePixelsAroundStimulus2>5
          TimesOfStimuliExploration{1,2}=[[TimesOfStimuliExploration{1,2}],k];
       elseif NumOfMousePixelsAroundStimulus3>5
          TimesOfStimuliExploration{1,3}=[[TimesOfStimuliExploration{1,3}],k];
       else
       end
       
    elseif isempty(MouseBoundary_LowThreshold)  %%%%% activated when the algorithm did not find the mouse
        MouseLocationCenterOfBody=[MouseLocationCenterOfBody; NaN,NaN];
    else
    end
    
%     plot(MouseBoundary_HighThreshold(:,2),MouseBoundary_HighThreshold(:,1),'b')
%     plot(MouseBoundaryHead(:,1),MouseBoundaryHead(:,2),'r')
    hold off;
    
    if SaveMovie==1 
       F=getframe(HandlesForGUIControls.axes1);
       writeVideo(MouseTrackingMovie,F);
    end
    
    TempNameStartPoint=strfind(filenameBehavioral, '\');
    set(HandlesForGUIControls.StatusText,'string',[filenameBehavioral(TempNameStartPoint(end)+1:end) '   Analyzed frame ' num2str(k) '    Final frame ' num2str(EndingFrameForAnalysis)]);    
    
   if StopAnalysis
       LastFrameAnalyzed=k;
       break;
    end
  end
  
  clear Film
  if SaveMovie==1 
     close(MouseTrackingMovie);
  end
  LastFrameAnalyzed=k;
  
end
  
