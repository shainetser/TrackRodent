function  [RatLocationCenterOfBody,TimesOfStimuliExploration,TimesInDifferentCompartments,firstFrameInTheAnalysis,LastAnalyzedFrame]=WhiteRatBodyBased15_7_15(filenameBehavioral,HandlesForGUIControls,StartingFrameForAnalysis,EndingFrameForAnalysis,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,SaveMovie,LowThresholdValue,MovieNum);
   %%%%% The purpose of this function is to analyze the behavioral data.
   %%%%% It can evaluate general features about a single rat
   %%%%% behavior, such as location and its derivatives.
   %%%%% It is also usefull for analyzing social recognition paradigms
   %%%%% and evaluate the time spent near a noval versus familiar conspecifics.
   
RatBoundary=[];
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
     cdataWB=im2bw(cdataRGB,LowThresholdValue);
     cdataBW=ones(size(cdataWB,1),size(cdataWB,2));
     cdataBW(find(cdataWB==0))=0;
     Clean_cdataBW = bwareaopen(cdataBW, 400);
     se = strel('disk',10);
     Clean_cdataBW=imerode(Clean_cdataBW,se);
     se = strel('disk',15);
     Clean_cdataBW=imdilate(Clean_cdataBW,se);
     
     %%%%% exclude pixels that were excluded from the image by the user
     for i=1:length(ExcludedAreasList)
           AreaToExclude=[];
           AreaToExclude=ExcludedAreasList{1,i}; 
           for j=1:size(AreaToExclude,1)
              Clean_cdataBW(AreaToExclude(j,1),AreaToExclude(j,2))=0;
           end 
     end
     
     %%%%% change the areas of the stimuli in the clean black and white
     %%%%% image ('Clean_cdataWB') to black. For avoiding searching the
     %%%%% subject rat location in them.
     for i=1:length(StimuliPositionsList)
        StimulusPixels=[];
        StimulusPixels=StimuliPositionsList{1,i}; 
        for j=1:size(StimulusPixels,1)
           Clean_cdataBW(StimulusPixels(j,1),StimulusPixels(j,2))=0;  
        end 
     end
     
     %%%%% look for boundaries of the rat
     BoundariesBW = bwboundaries(Clean_cdataBW);
     try
        BoundariesSizes=[];
        for i=1:size(BoundariesBW,1)
           BoundariesSizes=[BoundariesSizes,size(BoundariesBW{i,1},1)];
        end
        RatBoundary=BoundariesBW{find(BoundariesSizes==max(BoundariesSizes)),1};
     catch
        %%%%%   do nothing at the moment   %%%%%
     end
     
     %%%%% Find the boarders of the stimuli areas
     if k==StartingFrameForAnalysis
        for i=1:length(StimuliPositionsList)
           StimulusPixels=[];
           StimulusPixels=StimuliPositionsList{1,i}; 
           StimulusAreaOnFrame=zeros(size(cdataWB,1),size(cdataWB,2));
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
     
    %%%%% Find the number of pixels of the stimuli areas boundaries ('ALLStimuliBoundariesPixels') 
    %%%%% that were touched by the subject rat boundary('RatBoundary')    
    NumOfRatPixelsAroundStimulus1=0;
    NumOfRatPixelsAroundStimulus2=0;
    NumOfRatPixelsAroundStimulus3=0;
    if ~isempty(RatBoundary)  %%%% if 'RatBoundary' is empty the algorithm did not found the mouse there is no need to find if it touched the stimuli
       if (exist('ALLStimuliBoundariesPixels'))
          for i=1:length(ALLStimuliBoundariesPixels) 
             StimulusBoundariesPixels=ALLStimuliBoundariesPixels{1,i};   
             for j=1:size(StimulusBoundariesPixels,1)
                Temp=find(RatBoundary(:,1)==StimulusBoundariesPixels(j,1));
                if ~isempty(find(RatBoundary(Temp,2)==StimulusBoundariesPixels(j,2)));
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
    
    %%%%% collect the 'RatLocationCenterOfBody' and look for its location
    %%%%% within the different compartments 'CompartmentsPositionsList'
    if ~isempty(RatBoundary)
       RatLocationCenterOfBody=[RatLocationCenterOfBody; round(mean(RatBoundary(:,2))),round(mean(RatBoundary(:,1)))];
       for i=1:length(CompartmentsPositionsList)
          Compartment=[];
          Compartment=CompartmentsPositionsList{1,i}; 
          if ~isempty(Compartment)
             if find(Compartment(find(Compartment(:,1)==round(mean(RatBoundary(:,1)))),2)==round(mean(RatBoundary(:,2))))
                TimesInDifferentCompartments{1,i}=[[TimesInDifferentCompartments{1,i}],k]; 
             end
          end
       end
    end
    
    imshow(cdataRGB,'Parent',HandlesForGUIControls.axes1);
    set(HandlesForGUIControls.axes1,'Box','off','Visible','off') 
    hold on;  
    if NumOfRatPixelsAroundStimulus1>10 && NumOfRatPixelsAroundStimulus1<100
       plot(mean(RatBoundary(:,2)),mean(RatBoundary(:,1)),'gX');
       TimesOfStimuliExploration{1,1}=[[TimesOfStimuliExploration{1,1}],k];
    elseif NumOfRatPixelsAroundStimulus2>10 && NumOfRatPixelsAroundStimulus2<100
       plot(mean(RatBoundary(:,2)),mean(RatBoundary(:,1)),'bX');
       TimesOfStimuliExploration{1,2}=[[TimesOfStimuliExploration{1,2}],k];
    elseif NumOfRatPixelsAroundStimulus3>10 && NumOfRatPixelsAroundStimulus3<100
       plot(mean(RatBoundary(:,2)),mean(RatBoundary(:,1)),'yX');
       TimesOfStimuliExploration{1,3}=[[TimesOfStimuliExploration{1,3}],k];
    elseif ~isempty(RatBoundary)
       plot(mean(RatBoundary(:,2)),mean(RatBoundary(:,1)),'rX'); 
    else   %%%%% activated when the algorithm did not find the mouse
        RatLocationCenterOfBody=[RatLocationCenterOfBody; NaN,NaN]; 
    end 
    hold off;
    
    if SaveMovie==1 
       F=getframe(HandlesForGUIControls.axes1);
       writeVideo(RatTrackingMovie,F);
    end
    
    TempNameStartPoint=strfind(filenameBehavioral, '\');
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
  
