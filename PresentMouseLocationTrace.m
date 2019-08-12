function PresentMouseLocationTrace(firstFrameInTheAnalysis,HandlesForGUIControls,MouseLocationCenterOfBody,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,MouseLocationCenterOfBody1,MouseLocationCenterOfBody2)
%PRESENTMOUSELOCATIONTRACE Summary of this function goes here
%   Detailed explanation goes here


%%%%% Mark areas in different colors   
for i=1:length(CompartmentsPositionsList)
   Compartment=[];
   Compartment=CompartmentsPositionsList{1,i}; 
   for j=1:size(Compartment,1)
      firstFrameInTheAnalysis(Compartment(j,1),Compartment(j,2),1)=0;  %%%% Mark compartments areas in blue
   end 
end

for i=1:length(StimuliPositionsList)
   Stimulus=[];
   Stimulus=StimuliPositionsList{1,i}; 
   for j=1:size(Stimulus,1)
      firstFrameInTheAnalysis(Stimulus(j,1),Stimulus(j,2),3)=0;  %%%% Mark stimuli areas in yellow
   end 
end


%%%%% present the image and text on it%%%%
axes(HandlesForGUIControls.axes1);
cla reset;
imshow(firstFrameInTheAnalysis,'Parent',HandlesForGUIControls.axes1);
set(HandlesForGUIControls.axes1,'Box','off','Visible','off')
axes(HandlesForGUIControls.axes1);
hold on;

for i=1:length(CompartmentsPositionsList)
   Compartment=[];
   Compartment=CompartmentsPositionsList{1,i}; 
   if ~isempty(Compartment)
      text(mean(Compartment(:,2)),mean(Compartment(:,1)),['Compartment ' num2str(i)],'FontSize',12)
   end
end

for i=1:length(StimuliPositionsList)
   Stimulus=[];
   Stimulus=StimuliPositionsList{1,i}; 
   if ~isempty(Stimulus)
      text(mean(Stimulus(:,2)),mean(Stimulus(:,1)),['Stimulus ' num2str(i)],'FontSize',12)
   end
end

%%%%% plot the trace of the mouse movements on the image for tracking a
%%%%% single mouse

if ~isempty(MouseLocationCenterOfBody)
   plot(MouseLocationCenterOfBody(:,1),MouseLocationCenterOfBody(:,2))
end

%%%%% plot the trace of the two mice interaction for algorithm:
%%%%% "MiceMovieAnalyzerTwoMiceInteraction2_3_15"

if ~isempty(MouseLocationCenterOfBody1)
    for i=1:length(MouseLocationCenterOfBody1) 
       if (MouseLocationCenterOfBody1(i,1)==MouseLocationCenterOfBody2(i,1) && MouseLocationCenterOfBody1(i,2)==MouseLocationCenterOfBody2(i,2))    
          plot(MouseLocationCenterOfBody1(i,1),MouseLocationCenterOfBody1(i,2),'*r')
       else
          plot(MouseLocationCenterOfBody1(i,1),MouseLocationCenterOfBody1(i,2),'.b',MouseLocationCenterOfBody2(i,1),MouseLocationCenterOfBody2(i,2),'.b')           
       end
    end
end

hold off;

end

