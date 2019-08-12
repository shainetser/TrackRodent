function  [TimesOfMiceInteraction, TimesOfMiceInteractionDistantInteraction, TimesOfMiceInteractionTightInteraction,...
          Location1, Location2, firstFrameInTheAnalysis,LastFrameAnalyzed]=...
          WhiteRats_TwoRatsFreeInteraction07_5_18...
          (filenameBehavioral,HandlesForGUIControls,StartingFrameForAnalysis,EndingFrameForAnalysis,ExcludedAreasList,SaveMovie,LowThresholdValue,MovieNum)
   %%%%% The purpose of this function is to analyze the behavioral data.
   %%%%% It can evaluate general features about a single rat
   %%%%% behavior, such as location and its derivatives.
   %%%%% It is also usefull for analyzing social recognition paradigms
   %%%%% and evaluate the time spent near a noval versus familiar conspecifics.
   

global StopAnalysis
   
  Location1=[]; %%%%% Location of a mouse with no specific identity (if it is rat 1 or 2)
  Location2=[]; %%%%% Location of a mouse with no specific identity (if it is rat 1 or 2)
  TimesOfMiceInteraction=[]; %%%% The name is left "TimesOfMiceInteraction" and not "TimeOfRatsInteraction" for remaining consistent with the rest of the functions in TrackRodent and other functions
  TimesOfMiceInteractionDistantInteraction=[];  %%%% The name is left "TimesOfMiceInteractionDistantInteraction" and not "TimesOfRatsInteractionDistantInteraction" for remaining consistent with the rest of the functions in TrackRodent and other functions
  TimesOfMiceInteractionTightInteraction=[];   %%%% The name is left "TimesOfMiceInteractionTightInteraction" and not "TimesOfRatsInteractionTightInteraction" for remaining consistent with the rest of the functions in TrackRodent and other functions
  
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
     
     %%%%% look for boundaries of the rat
     BoundariesBW = bwboundaries(Clean_cdataBW);
     Rat1Boundary=[];
     Rat2Boundary=[];
     try
        BoundariesSizes=[];
        for i=1:size(BoundariesBW,1)
           BoundariesSizes=[BoundariesSizes,size(BoundariesBW{i,1},1)];
        end
        Rat1Boundary=BoundariesBW{find(BoundariesSizes==max(BoundariesSizes)),1};
        Temp=[];
        Temp=find(BoundariesSizes==max(BoundariesSizes));
        BoundariesSizes(Temp(1))=0;
     catch
        %%%%%   do nothing at the moment   %%%%%
     end
     try
        if max(BoundariesSizes)>200
           Rat2Boundary=BoundariesBW{find(BoundariesSizes==max(BoundariesSizes)),1};
        end
     catch
        %%%%%    do nothing at the moment    %%%%%% 
     end   
    
     if k==StartingFrameForAnalysis 
        firstFrameInTheAnalysis=cdataRGB; %%%%% This parameter is saved for returning the first image of the analysis for presentation requirments 
     end
 
    %%%%% Look for interactions between rats by evaluating when they are
    %%%%% becoming one big white object instead of two.
    if ~isempty(Rat1Boundary)
       if ~isempty(Rat2Boundary)
          RatsSizeDifference=abs(size(Rat1Boundary,1)-size(Rat2Boundary,1));
          if RatsSizeDifference<500
             %%%%% do nothing at the moment %%%%  
          else
             TimesOfMiceInteraction=[TimesOfMiceInteraction,k]; %%%% The name is left "TimesOfMiceInteraction" and not "TimeOfRatsInteraction" for remaining consistent with the rest of the functions in TrackRodent and other functions
          end
       else
          if size(Rat1Boundary,1)<=1000 
             TimesOfMiceInteractionTightInteraction=[TimesOfMiceInteractionTightInteraction,k];  
          else
             TimesOfMiceInteractionDistantInteraction=[TimesOfMiceInteractionDistantInteraction,k];
          end
          TimesOfMiceInteraction=[TimesOfMiceInteraction,k]; %%%% The name is left "TimesOfMiceInteraction" and not "TimeOfRatsInteraction" for remaining consistent with the rest of the functions in TrackRodent and other functions
       end
    end
    
    imshow(cdataRGB,'Parent',HandlesForGUIControls.axes1);
    set(HandlesForGUIControls.axes1,'Box','off','Visible','off') 
    hold on;  
    if find(TimesOfMiceInteraction==k)
       if find(TimesOfMiceInteractionTightInteraction==k) 
          plot(mean(Rat1Boundary(:,2)),mean(Rat1Boundary(:,1)),'rX'); 
          Location1=[Location1; mean(Rat1Boundary(:,2)),mean(Rat1Boundary(:,1))];
          Location2=[Location2; mean(Rat1Boundary(:,2)),mean(Rat1Boundary(:,1))];
       elseif find(TimesOfMiceInteractionDistantInteraction) 
          plot(mean(Rat1Boundary(:,2)),mean(Rat1Boundary(:,1)),'bX'); 
          Location1=[Location1; mean(Rat1Boundary(:,2)),mean(Rat1Boundary(:,1))];
          Location2=[Location2; mean(Rat1Boundary(:,2)),mean(Rat1Boundary(:,1))]; 
       end
    else
       try
          plot(mean(Rat1Boundary(:,2)),mean(Rat1Boundary(:,1)),'wX',mean(Rat2Boundary(:,2)),mean(Rat2Boundary(:,1)),'wX'); 
          plot(Rat1Boundary(:,2),Rat1Boundary(:,1)); 
          Location1=[Location1; mean(Rat1Boundary(:,2)),mean(Rat1Boundary(:,1))];
          Location2=[Location2; mean(Rat2Boundary(:,2)),mean(Rat2Boundary(:,1))];
       catch
              
       end
    end
    try
       plot(Rat1Boundary(:,2),Rat1Boundary(:,1)); 
    end
    try
       plot(Rat2Boundary(:,2),Rat2Boundary(:,1)); 
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
       LastFrameAnalyzed=k;
       break;
    end
  end
  
  clear Film
  if SaveMovie==1 
     close(RatTrackingMovie);
  end
  LastFrameAnalyzed=k;
end
  
