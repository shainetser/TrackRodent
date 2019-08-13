function  [RatLocationCenterOfBody,TimesOfStimuliExploration,TimesInDifferentCompartments,firstFrameInTheAnalysis,LastAnalyzedFrame]=...
  WhiteRatWiredHeadDirectBased13_1_2019(filenameBehavioral,HandlesForGUIControls,StartingFrameForAnalysis,EndingFrameForAnalysis,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,SaveMovie,LowThresholdValue,HighThresholdValue,MovieNum);
   %%%%% The purpose of this function is to analyze the behavioral data.
   %%%%% It can evaluate general features about a single mouse
   %%%%% behavior, such as location and its derivatives.
   %%%%% It is also usefull for analyzing social recognition paradigms
   %%%%% and evaluate the time spent near a noval versus familiar conspecifics.
   
  
  
  %%%%% continue working on collecting the data for 'CompartmentsPositionsList'


global StopAnalysis
   
  RatLocationCenterOfBody=[];
  TimesOfStimuliExploration=cell(1,3);
  TimesInDifferentCompartments=cell(1,5);
  if SaveMovie==1 
     filenameOfMovie=[filenameBehavioral(1:end-4) '_AnalyzedMovie'];
     RatTrackingMovie = VideoWriter([filenameOfMovie '.avi']);
     open(RatTrackingMovie);
  end
  Film = VideoReader(filenameBehavioral);
 
  for k=StartingFrameForAnalysis:EndingFrameForAnalysis
  
     %%%%% open the image, convert it to black and white and clean it from noise      
     cdataRGB = read(Film,k);
     cdataWB_LowThreshold=im2bw(cdataRGB,LowThresholdValue);
     cdataBW_LowThreshold=ones(size(cdataWB_LowThreshold,1),size(cdataWB_LowThreshold,2));
     cdataBW_LowThreshold(find(cdataWB_LowThreshold==0))=0;
     Clean_cdataBW_LowThreshold = bwareaopen(cdataBW_LowThreshold, 400);
     se = strel('disk',10);
     Clean_cdataBW_LowThreshold=imerode(Clean_cdataBW_LowThreshold,se);
     se = strel('disk',15);
     Clean_cdataBW_LowThreshold=imdilate(Clean_cdataBW_LowThreshold,se);
     
     cdataRGB = read(Film,k);
     cdataWB_HighThreshold=im2bw(cdataRGB,HighThresholdValue);
     cdataBW_HighThreshold=ones(size(cdataWB_HighThreshold,1),size(cdataWB_HighThreshold,2));
     cdataBW_HighThreshold(find(cdataWB_HighThreshold==0))=0;
     Clean_cdataBW_HighThreshold = bwareaopen(cdataBW_HighThreshold, 400);
     
     %%%%% exclude pixels that were excluded from the image by the user
     for i=1:length(ExcludedAreasList)
           AreaToExclude=[];
           AreaToExclude=ExcludedAreasList{1,i}; 
           for j=1:size(AreaToExclude,1)
              Clean_cdataBW_LowThreshold(AreaToExclude(j,1),AreaToExclude(j,2))=0;
              Clean_cdataBW_HighThreshold(AreaToExclude(j,1),AreaToExclude(j,2))=0;
           end 
     end
     
     %%%%% change the areas of the stimuli in the clean black and white
     %%%%% image ('Clean_cdataWB') to black. For avoiding searching the
     %%%%% subject rat location in them.
     for i=1:length(StimuliPositionsList)
        StimulusPixels=[];
        StimulusPixels=StimuliPositionsList{1,i}; 
        for j=1:size(StimulusPixels,1)
           Clean_cdataBW_LowThreshold(StimulusPixels(j,1),StimulusPixels(j,2))=0; 
           Clean_cdataBW_HighThreshold(StimulusPixels(j,1),StimulusPixels(j,2))=0; 
        end 
     end
     
     %%%%%% Remove artifacts from the fiber optics or electrophysiology recording system cable
     se = strel('disk',11);
     Clean_cdataBW_LowThreshold=imclose(Clean_cdataBW_LowThreshold,se);
     se = strel('disk',18);
     Clean_cdataBW_LowThreshold=imerode(Clean_cdataBW_LowThreshold,se);
     se = strel('disk',24);
     Clean_cdataBW_LowThreshold=imdilate(Clean_cdataBW_LowThreshold,se);
     
        
     Clean_cdataBW_HighThreshold = fibermetric(double(Clean_cdataBW_HighThreshold),30);
     TempHighThreshold=HighThresholdValue*3;
     if TempHighThreshold>1
         TempHighThreshold=1;
     end
     Clean_cdataBW_HighThreshold=im2bw(Clean_cdataBW_HighThreshold,TempHighThreshold);
     
     %%%%% look for boundaries of the rat at low and high thresholds
     BoundariesBW_LowThreshold = bwboundaries(Clean_cdataBW_LowThreshold);
     BoundariesBW_HighThreshold = bwboundaries(Clean_cdataBW_HighThreshold);
     try
        BoundariesSizes_LowThreshold=[];
        for i=1:size(BoundariesBW_LowThreshold,1)
           BoundariesSizes_LowThreshold=[BoundariesSizes_LowThreshold,size(BoundariesBW_LowThreshold{i,1},1)];
        end
        RatBoundary_LowThreshold=BoundariesBW_LowThreshold{find(BoundariesSizes_LowThreshold==max(BoundariesSizes_LowThreshold)),1};
        
        BoundariesSizes_HighThreshold=[];
        for i=1:size(BoundariesBW_HighThreshold,1)
           BoundariesSizes_HighThreshold=[BoundariesSizes_HighThreshold,size(BoundariesBW_HighThreshold{i,1},1)];
        end
        BoundariesBW_HighThreshold=BoundariesBW_HighThreshold(BoundariesSizes_HighThreshold>200);
        BoundariesDistanceHighFromLowHighThreshold(1:length(BoundariesBW_HighThreshold))=0;
        for i=1:length(BoundariesBW_HighThreshold)
           for j=1:size(BoundariesBW_HighThreshold{i,1},1)
              Temp=find(abs(RatBoundary_LowThreshold(:,1)-BoundariesBW_HighThreshold{i,1}(j,1))<40);
              if ~isempty(find(abs(RatBoundary_LowThreshold(Temp,2)-BoundariesBW_HighThreshold{i,1}(j,2))<40))
                 BoundariesDistanceHighFromLowHighThreshold(i)=BoundariesDistanceHighFromLowHighThreshold(i)+1;
              end
           end
        end
%         for i=1:size(BoundariesBW_HighThreshold,1)
%            BoundariesDistanceHighFromLowHighThreshold=[BoundariesDistanceHighFromLowHighThreshold;...
%               abs(round(mean(BoundariesBW_HighThreshold{i,1}(:,2)))-round(mean(BoundariesBW_LowThreshold{find(BoundariesSizes_LowThreshold==max(BoundariesSizes_LowThreshold)),1}(:,2))))+...
%               abs(round(mean(BoundariesBW_HighThreshold{i,1}(:,1)))-round(mean(BoundariesBW_LowThreshold{find(BoundariesSizes_LowThreshold==max(BoundariesSizes_LowThreshold)),1}(:,1))))];
%         end
        RatBoundary_HighThreshold=BoundariesBW_HighThreshold{find(BoundariesDistanceHighFromLowHighThreshold==max(BoundariesDistanceHighFromLowHighThreshold)),1};
     catch
        RatBoundary_LowThreshold=[];
        RatBoundary_HighThreshold=[];
     end
     
     %%%%% Find the boarders of the stimuli areas
     if k==StartingFrameForAnalysis
        for i=1:length(StimuliPositionsList)
           StimulusPixels=[];
           StimulusPixels=StimuliPositionsList{1,i}; 
           StimulusAreaOnFrame=zeros(size(cdataWB_LowThreshold,1),size(cdataWB_LowThreshold,2));
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
     
    %%%%% collect the 'RatLocationCenterOfBody' and look for its location
    %%%%% within the different compartments 'CompartmentsPositionsList'
    if ~isempty(RatBoundary_LowThreshold)
       RatLocationCenterOfBody=[RatLocationCenterOfBody; round(mean(RatBoundary_LowThreshold(:,2))),round(mean(RatBoundary_LowThreshold(:,1)))];
       for i=1:length(CompartmentsPositionsList)
          Compartment=[];
          Compartment=CompartmentsPositionsList{1,i}; 
          if ~isempty(Compartment)
             if find(Compartment(find(Compartment(:,1)==round(mean(RatBoundary_LowThreshold(:,1)))),2)==round(mean(RatBoundary_LowThreshold(:,2))))
                TimesInDifferentCompartments{1,i}=[[TimesInDifferentCompartments{1,i}],k]; 
             end
          end
       end
    end
    
    %%%% Find here the Rat pixels bourders of the head according to
    %%%% the ellipse and the assumed tail location. Do this only when the
    %%%% mouse center of body is stable, which assumes the rat is not
    %%%% moving to much such as during inversigation of something stationary.
    
    RatsBoundaryHead=[];
    try
       if ~isempty(RatBoundary_LowThreshold)
       %%%% fit an ellipse to the mouse low-threshold boundaries
          RatEllipseFitParameters = ellipseFit4HC(transpose(RatBoundary_LowThreshold(:,2)),transpose(RatBoundary_LowThreshold(:,1)));
     
       %%%% finding the ellipse farest vertices.
          DistanceTemp=0;
          DistanceMax=0;
          for i=1:length(RatEllipseFitParameters.mu_X_fit)
             for j=1:length(RatEllipseFitParameters.mu_X_fit)
                Point1X=RatEllipseFitParameters.mu_X_fit(i);
                Point1Y=RatEllipseFitParameters.nu_Y_fit(i);
                Point2X=RatEllipseFitParameters.mu_X_fit(j);
                Point2Y=RatEllipseFitParameters.nu_Y_fit(j);
                DistanceTemp=sqrt((Point1X-Point2X)^2+(Point1Y-Point2Y)^2);
                if DistanceTemp>DistanceMax
                   DistanceMax=DistanceTemp; 
                   EllipseTip1=[Point1X,Point1Y];
                   EllipseTip2=[Point2X,Point2Y];
                end
             end
          end
       %%%% finding which vertex of the ellipse is the head. 
       %%%% 'RatTailDirection' is calculated according to the average
       %%%% pixels location using high threshold. This assumes the tail
       %%%% is detected, which shift the location of the averaged pixels to be
       %%%% closer to the tail.
       RatTailDirection=[];
       for j=1:size(RatBoundary_HighThreshold,1)
           Temp=find(abs(RatBoundary_LowThreshold(:,1)-RatBoundary_HighThreshold(j,1))<40);
           if ~isempty(find(abs(RatBoundary_LowThreshold(Temp,2)-RatBoundary_HighThreshold(j,2))<40))
              RatTailDirection=[RatTailDirection;RatBoundary_HighThreshold(j,1) RatBoundary_HighThreshold(j,2)];
           end
       end 
             
%           if abs(EllipseTip2(1,2)-EllipseTip1(1,2))>=abs(EllipseTip2(1,1)-EllipseTip1(1,1))
%              RatTailDirection=mean(RatBoundary_HighThreshold(:,1));
%              if abs(EllipseTip2(1,2)-RatTailDirection)<=abs(EllipseTip1(1,2)-RatTailDirection)
%                 EllipseTipRatHead=EllipseTip1;  
%              else
%                 EllipseTipRatHead=EllipseTip2; 
%              end
%           end
          if abs(EllipseTip1(1,1)-mean(RatTailDirection(:,2)))+ abs(EllipseTip1(1,2)-mean(RatTailDirection(:,1)))<= abs(EllipseTip2(1,1)-mean(RatTailDirection(:,2)))+ abs(EllipseTip2(1,2)-mean(RatTailDirection(1,1))) 
             EllipseTipRatHead=EllipseTip2;
          else
             EllipseTipRatHead=EllipseTip1; 
          end
         
          Temp=find([abs(RatBoundary_LowThreshold(:,2)-EllipseTipRatHead(1,1))]<40);
          Temp2=find([abs(RatBoundary_LowThreshold(Temp,1)-EllipseTipRatHead(1,2))]<40);
          RatsBoundaryHead=[RatBoundary_LowThreshold(Temp(Temp2),2),RatBoundary_LowThreshold(Temp(Temp2),1)];
       end
    catch
        %%%% do nothing at the moment. 
        %%%% Catch is for failiers of the "ellipseFit4HC" algorithm.
    end
    
    %%%%% Find the number of pixels of the stimuli areas boundaries ('ALLStimuliBoundariesPixels') 
    %%%%% that were touched by the subject rat boundary('RatBoundary')    
    NumOfRatPixelsAroundStimulus1=0;
    NumOfRatPixelsAroundStimulus2=0;
    NumOfRatPixelsAroundStimulus3=0;
    if ~isempty(RatsBoundaryHead)  %%%% if 'RatsBoundaryHead' is empty the algorithm did not found the mouse or the mouse is moving fast and probably not investigating
       if (exist('ALLStimuliBoundariesPixels'))
          for i=1:length(ALLStimuliBoundariesPixels) 
             StimulusBoundariesPixels=ALLStimuliBoundariesPixels{1,i};   
             for j=1:size(StimulusBoundariesPixels,1)
                Temp=find(RatsBoundaryHead(:,2)==StimulusBoundariesPixels(j,1));
                if ~isempty(find(RatsBoundaryHead(Temp,1)==StimulusBoundariesPixels(j,2)));
                   if i==1
                      NumOfRatPixelsAroundStimulus1=NumOfRatPixelsAroundStimulus1+1; 
                   elseif i==2
                      NumOfRatPixelsAroundStimulus2=NumOfRatPixelsAroundStimulus2+1;  
                   elseif i==3
                      NumOfRatPixelsAroundStimulus3=NumOfRatPixelsAroundStimulus3+1; 
                   else
                      %%%%% do nothing at the moment%%%%% 
                   end 
                end
             end 
          end
       end
    end
    
    
    imshow(cdataRGB,'Parent',HandlesForGUIControls.axes1);
    set(HandlesForGUIControls.axes1,'Box','off','Visible','off') 
    hold on;  
    if ~isempty(RatsBoundaryHead)
       if NumOfRatPixelsAroundStimulus1>0 && NumOfRatPixelsAroundStimulus1<100
          plot(mean(RatBoundary_LowThreshold(:,2)),mean(RatBoundary_LowThreshold(:,1)),'wX',mean(RatsBoundaryHead(:,1)),mean(RatsBoundaryHead(:,2)),'yd');
          plot(RatsBoundaryHead(:,1),RatsBoundaryHead(:,2),'g')
          plot(RatBoundary_HighThreshold(:,2),RatBoundary_HighThreshold(:,1),'r');
          plot(mean(RatTailDirection(:,2)),mean(RatTailDirection(:,1)),'rX');
          TimesOfStimuliExploration{1,1}=[[TimesOfStimuliExploration{1,1}],k];
       elseif NumOfRatPixelsAroundStimulus2>0 && NumOfRatPixelsAroundStimulus2<100
          plot(mean(RatBoundary_LowThreshold(:,2)),mean(RatBoundary_LowThreshold(:,1)),'wX',mean(RatsBoundaryHead(:,1)),mean(RatsBoundaryHead(:,2)),'yd');
          plot(RatsBoundaryHead(:,1),RatsBoundaryHead(:,2),'g')
          plot(RatBoundary_HighThreshold(:,2),RatBoundary_HighThreshold(:,1),'r');
          plot(mean(RatTailDirection(:,2)),mean(RatTailDirection(:,1)),'rX');
          TimesOfStimuliExploration{1,2}=[[TimesOfStimuliExploration{1,2}],k];
       elseif NumOfRatPixelsAroundStimulus3>0 && NumOfRatPixelsAroundStimulus3<100
          plot(mean(RatBoundary_LowThreshold(:,2)),mean(RatBoundary_LowThreshold(:,1)),'wX',mean(RatsBoundaryHead(:,1)),mean(RatsBoundaryHead(:,2)),'yd');
          plot(RatsBoundaryHead(:,1),RatsBoundaryHead(:,2),'g')
          plot(RatBoundary_HighThreshold(:,2),RatBoundary_HighThreshold(:,1),'r');
          plot(mean(RatTailDirection(:,2)),mean(RatTailDirection(:,1)),'rX');
          TimesOfStimuliExploration{1,3}=[[TimesOfStimuliExploration{1,3}],k];
       else
          plot(mean(RatBoundary_LowThreshold(:,2)),mean(RatBoundary_LowThreshold(:,1)),'wX',mean(RatsBoundaryHead(:,1)),mean(RatsBoundaryHead(:,2)),'wd');
          plot(RatsBoundaryHead(:,1),RatsBoundaryHead(:,2),'g')
          plot(RatBoundary_HighThreshold(:,2),RatBoundary_HighThreshold(:,1),'r');
          plot(mean(RatTailDirection(:,2)),mean(RatTailDirection(:,1)),'rX');
       end 
    elseif isempty(RatBoundary_LowThreshold)  %%%%% activated when the algorithm did not find the rat
        RatLocationCenterOfBody=[RatLocationCenterOfBody; NaN,NaN];
    else
        plot(mean(RatBoundary_LowThreshold(:,2)),mean(RatBoundary_LowThreshold(:,1)),'wX');
        plot(RatBoundary_LowThreshold(:,2),RatBoundary_LowThreshold(:,1),'g');
        plot(RatBoundary_HighThreshold(:,2),RatBoundary_HighThreshold(:,1),'r');
    end   
    hold off;
    
    if SaveMovie==1 
       F=getframe(HandlesForGUIControls.axes1);
       writeVideo(RatTrackingMovie,F);
    end
    
    TempNameStartPoint=strfind(filenameBehavioral, '\');
    if isempty(TempNameStartPoint)
       TempNameStartPoint=strfind(filenameBehavioral, '/'); 
    end
    set(HandlesForGUIControls.StatusText,'string',[filenameBehavioral(TempNameStartPoint(end)+1:end) '   Analyzed frame ' num2str(k) '    Final frame ' num2str(EndingFrameForAnalysis)]);
    pause(0.1);
    if StopAnalysis
       LastAnalyzedFrame=k;
       break;
    end
  end
  
  clear Film
  if SaveMovie==1 
     close(RatTrackingMovie);
  end
  LastAnalyzedFrame=k;
end