function [CurrentFrameData] = UpdateCurrentFrameData(filenameBehavioral,StartingFrameForAnalysis,HandlesForGUIControls,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,CurrentFileAnalyzed)
%UPDATECURRENTFRAMEDATA Summary of this function goes here
%   Detailed explanation goes here

%%%%%  Load the frame from the original movie
Film = VideoReader(filenameBehavioral);
CurrentFrameData = read(Film,StartingFrameForAnalysis);

%%%%% Mark areas in different colors
try
   for i=1:length(ExcludedAreasList(CurrentFileAnalyzed,:))
      AreaToExclude=[];
      AreaToExclude=ExcludedAreasList{CurrentFileAnalyzed,i}; 
      for j=1:size(AreaToExclude,1)
         CurrentFrameData(AreaToExclude(j,1),AreaToExclude(j,2),1)=255; %%%% Mark excluded areas is red
      end 
   end
catch
   %%% Do nothing 
end
try
   for i=1:length(CompartmentsPositionsList(CurrentFileAnalyzed,:))
      Compartment=[];
      Compartment=CompartmentsPositionsList{CurrentFileAnalyzed,i}; 
      for j=1:size(Compartment,1)
         CurrentFrameData(Compartment(j,1),Compartment(j,2),1)=0;  %%%% Mark compartments areas in blue
      end 
   end
catch
    %%% Do nothing
end

try
   for i=1:length(StimuliPositionsList(CurrentFileAnalyzed,:))
      Stimulus=[];
      Stimulus=StimuliPositionsList{CurrentFileAnalyzed,i}; 
      for j=1:size(Stimulus,1)
         CurrentFrameData(Stimulus(j,1),Stimulus(j,2),3)=0;  %%%% Mark stimuli areas in yellow
      end 
   end
catch
    %%% Do nothing
end


%%%%% present the image and text on it%%%%
cla reset
imshow(CurrentFrameData,'Parent',HandlesForGUIControls.axes1);
set(HandlesForGUIControls.axes1,'Box','off','Visible','off')
axes(HandlesForGUIControls.axes1);

try
   for i=1:length(CompartmentsPositionsList(CurrentFileAnalyzed,:))
      Compartment=[];
      Compartment=CompartmentsPositionsList{CurrentFileAnalyzed,i}; 
      if ~isempty(Compartment)
         text(mean(Compartment(:,2)),mean(Compartment(:,1)),['Compartment ' num2str(i)],'FontSize',12)
      end
   end
catch
    %%% Do nothing
end

try
   for i=1:length(StimuliPositionsList(CurrentFileAnalyzed,:))
      Stimulus=[];
      Stimulus=StimuliPositionsList{CurrentFileAnalyzed,i}; 
      if ~isempty(Stimulus)
         text(mean(Stimulus(:,2)),mean(Stimulus(:,1)),['Stimulus ' num2str(i)],'FontSize',12)
      end
   end
catch
    %%% Do nothing
end


end

