function  [TimesOfMiceInteraction, Location1, Location2, firstFrameInTheAnalysis,LastFrameAnalyzed]=MiceMovieAnalyzerTwoMiceInteraction2_3_15(filenameBehavioral,HandlesForGUIControls,StartingFrameForAnalysis,EndingFrameForAnalysis,ExcludedAreasList,SaveMovie,LowThresholdValue,MovieNum);
   %%%%% The purpose of this function is to analyze the behavioral data.
   %%%%% It can evaluate general features about a two mice
   %%%%% behavior, such as location and its derivatives.
   %%%%% It is also usefull for analyzing social interaction
   %%%%% by evaluate the time in which the two mice are touching one another.
   
  
  
  %%%%% continue working on collecting the data for 'CompartmentsPositionsList'


global StopAnalysis
   
  Location1=[]; %%%%% Location of a mouse with no specific identity (if it is mouse 1 or 2)
  Location2=[]; %%%%% Location of a mouse with no specific identity (if it is mouse 1 or 2)
  TimesOfMiceInteraction=[];
  
  if SaveMovie==1 
     filenameOfMovie=[filenameBehavioral(1:end-4) '_AnalyzedMovie'];
     MouseTrackingMovie = VideoWriter([filenameOfMovie '.avi']);
     open(MouseTrackingMovie);
  end
  Film = VideoReader(filenameBehavioral);
 
  for k=StartingFrameForAnalysis:EndingFrameForAnalysis
  
     %%%%% open the image, convert it to black and white and clean it from noise      
     cdataRGB = read(Film,k);
     cdataBW=im2bw(cdataRGB,LowThresholdValue);
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

     %%%%%% Remove artifacts from the fiber optics
     se = strel('disk',9);
     Clean_cdataWB=imclose(Clean_cdataWB,se);
     se = strel('disk',1);
     Clean_cdataWB=imerode(Clean_cdataWB,se);
     Clean_cdataWB=imdilate(Clean_cdataWB,se);
     
     %%%%% look for boundaries of the mice
     BoundariesWB = bwboundaries(Clean_cdataWB);
     Mouse1Boundary=[];
     Mouse2Boundary=[];
     try
        BoundariesSizes=[];
        for i=1:size(BoundariesWB,1)
           BoundariesSizes=[BoundariesSizes,size(BoundariesWB{i,1},1)];
        end
        Mouse1Boundary=BoundariesWB{find(BoundariesSizes==max(BoundariesSizes)),1};
        Temp=[];
        Temp=find(BoundariesSizes==max(BoundariesSizes));
        BoundariesSizes(Temp(1))=0;
     catch
        %%%%%   do nothing at the moment   %%%%%
     end
     try
        if max(BoundariesSizes)>200
           Mouse2Boundary=BoundariesWB{find(BoundariesSizes==max(BoundariesSizes)),1};
        end
     catch
        %%%%%    do nothing at the moment    %%%%%% 
     end
     
     
     if k==StartingFrameForAnalysis 
        firstFrameInTheAnalysis=cdataRGB; %%%%% This parameter is saved for returning the first image of the analysis for presentation requirments 
     end
 
    
    %%%%% Look for interactions between mice by evaluating when they are
    %%%%% becoming one big black object instead of two.
    if ~isempty(Mouse1Boundary)
       if ~isempty(Mouse2Boundary)
          MiceSizeDifference=abs(size(Mouse1Boundary,1)-size(Mouse2Boundary,1));
          if MiceSizeDifference<500
             %%%%% do nothing at the moment %%%%  
          else
             TimesOfMiceInteraction=[TimesOfMiceInteraction,k]; 
          end
       else
          TimesOfMiceInteraction=[TimesOfMiceInteraction,k];
       end
    end
    
    imshow(cdataRGB,'Parent',HandlesForGUIControls.axes1);
    set(HandlesForGUIControls.axes1,'Box','off','Visible','off') 
    axes(HandlesForGUIControls.axes1);
    hold on;  
    if find(TimesOfMiceInteraction==k)
       plot(mean(Mouse1Boundary(:,2)),mean(Mouse1Boundary(:,1)),'yX'); 
       Location1=[Location1; mean(Mouse1Boundary(:,2)),mean(Mouse1Boundary(:,1))];
       Location2=[Location2; mean(Mouse1Boundary(:,2)),mean(Mouse1Boundary(:,1))];
    else
       try
          plot(mean(Mouse1Boundary(:,2)),mean(Mouse1Boundary(:,1)),'wX',mean(Mouse2Boundary(:,2)),mean(Mouse2Boundary(:,1)),'wX'); 
          plot(Mouse1Boundary(:,2),Mouse1Boundary(:,1)); 
          Location1=[Location1; mean(Mouse1Boundary(:,2)),mean(Mouse1Boundary(:,1))];
          Location2=[Location2; mean(Mouse2Boundary(:,2)),mean(Mouse2Boundary(:,1))];
       catch
              
       end
    end
    try
       plot(Mouse1Boundary(:,2),Mouse1Boundary(:,1)); 
    end
    try
       plot(Mouse2Boundary(:,2),Mouse2Boundary(:,1)); 
    end
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
  