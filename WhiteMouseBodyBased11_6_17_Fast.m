function  [MouseLocationCenterOfBody,TimesOfStimuliExploration,TimesInDifferentCompartments,firstFrameInTheAnalysis,LastFrameAnalyzed]=WhiteMouseBodyBased11_6_17_Fast(filenameBehavioral,HandlesForGUIControls,StartingFrameForAnalysis,EndingFrameForAnalysis,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,SaveMovie,LowThresholdValue,MovieNum);
   %%%%% The purpose of this function is to analyze the behavioral data.
   %%%%% It can evaluate general features about a single mouse
   %%%%% behavior, such as location and its derivatives.
   %%%%% It is also usefull for analyzing social recognition paradigms
   %%%%% and evaluate the time spent near a noval versus familiar conspecifics.
   
  
  
  %%%%% continue working on collecting the data for 'CompartmentsPositionsList'

MouseBoundary=[];
global StopAnalysis
   
  MouseLocationCenterOfBody=[];
  TimesOfStimuliExploration=cell(1,3);
  TimesInDifferentCompartments=cell(1,5);
  Film = VideoReader(filenameBehavioral);
 
  for k=StartingFrameForAnalysis:EndingFrameForAnalysis
  
     %%%%% open the image, convert it to black and white and clean it from noise      
     cdataRGB = read(Film,k);
     cdataBW=im2bw(cdataRGB,LowThresholdValue);
     cdataBW=(cdataBW-1)*-1;   %%%%%%%% for converting the white mouse and black background to black and white
     cdataWB=zeros(size(cdataBW,1),size(cdataBW,2));
     cdataWB(find(cdataBW==0))=1;
     Clean_cdataWB = bwareaopen(cdataWB, 400);
     
     %%%%% exclude pixels that were excluded from the image by the user
     for i=1:length(ExcludedAreasList)
           AreaToExclude=[];
           AreaToExclude=ExcludedAreasList{1,i}; 
           for j=1:size(AreaToExclude,1)
              Clean_cdataWB(AreaToExclude(j,1),AreaToExclude(j,2))=0;
           end 
     end
     
     %%%%% change the areas of the stimuli in the clean black and white
     %%%%% image ('Clean_cdataWB') to black. For avoiding searching the
     %%%%% subject mouse location in them.
     for i=1:length(StimuliPositionsList)
        StimulusPixels=[];
        StimulusPixels=StimuliPositionsList{1,i}; 
        for j=1:size(StimulusPixels,1)
           Clean_cdataWB(StimulusPixels(j,1),StimulusPixels(j,2))=0;  
        end 
     end
     
     %%%%% look for boundaries of the mouse
     BoundariesWB = bwboundaries(Clean_cdataWB);
     try
        BoundariesSizes=[];
        for i=1:size(BoundariesWB,1)
           BoundariesSizes=[BoundariesSizes,size(BoundariesWB{i,1},1)];
        end
        MouseBoundary=BoundariesWB{find(BoundariesSizes==max(BoundariesSizes)),1};
     catch
        %%%%%   do nothing at the moment   %%%%%
     end
     
     %%%%% Find the boarders of the stimuli areas
     if k==StartingFrameForAnalysis
        for i=1:length(StimuliPositionsList)
           StimulusPixels=[];
           StimulusPixels=StimuliPositionsList{1,i}; 
           StimulusAreaOnFrame=zeros(size(cdataBW,1),size(cdataBW,2));
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
    %%%%% that were touched by the subject mouse boundary('MouseBoundary')    
    NumOfMousePixelsAroundStimulus1=0;
    NumOfMousePixelsAroundStimulus2=0;
    NumOfMousePixelsAroundStimulus3=0;
    if ~isempty(MouseBoundary)  %%%% if 'MouseBoundary' is empty the algorithm did not found the mouse there is no need to find if it touched the stimuli
       if (exist('ALLStimuliBoundariesPixels'))
          for i=1:length(ALLStimuliBoundariesPixels) 
             StimulusBoundariesPixels=ALLStimuliBoundariesPixels{1,i};   
             for j=1:size(StimulusBoundariesPixels,1)
                Temp=find(MouseBoundary(:,1)==StimulusBoundariesPixels(j,1));
                if ~isempty(find(MouseBoundary(Temp,2)==StimulusBoundariesPixels(j,2)));
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
    
    %%%%% collect the 'MouseLocationCenterOfBody' and look for its location
    %%%%% within the different compartments 'CompartmentsPositionsList'
    if ~isempty(MouseBoundary)
       MouseLocationCenterOfBody=[MouseLocationCenterOfBody; round(mean(MouseBoundary(:,2))),round(mean(MouseBoundary(:,1)))];
       for i=1:length(CompartmentsPositionsList)
          Compartment=[];
          Compartment=CompartmentsPositionsList{1,i}; 
          if ~isempty(Compartment)
             if find(Compartment(find(Compartment(:,1)==round(mean(MouseBoundary(:,1)))),2)==round(mean(MouseBoundary(:,2))))
                TimesInDifferentCompartments{1,i}=[[TimesInDifferentCompartments{1,i}],k]; 
             end
          end
       end
    end
     
    if NumOfMousePixelsAroundStimulus1>10
       TimesOfStimuliExploration{1,1}=[[TimesOfStimuliExploration{1,1}],k];
    elseif NumOfMousePixelsAroundStimulus2>10
       TimesOfStimuliExploration{1,2}=[[TimesOfStimuliExploration{1,2}],k];
    elseif NumOfMousePixelsAroundStimulus3>10
       TimesOfStimuliExploration{1,3}=[[TimesOfStimuliExploration{1,3}],k];
    elseif ~isempty(MouseBoundary)
    else   %%%%% activated when the algorithm did not find the mouse
        MouseLocationCenterOfBody=[MouseLocationCenterOfBody; NaN,NaN]; 
    end 
    
    TempNameStartPoint=strfind(filenameBehavioral, '\');
    set(HandlesForGUIControls.StatusText,'string',[filenameBehavioral(TempNameStartPoint(end)+1:end) '   Analyzed frame ' num2str(k) '    Final frame ' num2str(EndingFrameForAnalysis)]);    
    pause(0.01);
    if StopAnalysis
       LastFrameAnalyzed=k;
       break;
    end
  end
  
  clear Film
  LastFrameAnalyzed=k;
  
end
  
