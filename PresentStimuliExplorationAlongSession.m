function PresentStimuliExplorationAlongSession(HandlesForGUIControls,TimesOfStimuliExploration,StartingFrameForAnalysisNum,LastFrameAnalyzed)
%PRESENTSTIMULIEXPLORATIONALONGSESSION Summary of this function goes here
%   Detailed explanation goes here
StimuliExploration=[];
axes(HandlesForGUIControls.axes1);
cla reset;
set(HandlesForGUIControls.axes1,'box','on','Visible','on')
hold on;

for i=1:length(TimesOfStimuliExploration)
   TimesOfStimulusExploration=[];
   TimesOfStimulusExploration=TimesOfStimuliExploration{1,i}; 
   for j=1:size(TimesOfStimulusExploration,2)
      StimuliExploration=[StimuliExploration;TimesOfStimulusExploration(j),i];
   end 
   if ~isempty(StimuliExploration)
      scatter(StimuliExploration(:,1),StimuliExploration(:,2));
   end
   
end

ylim([0 4]);
xlabel('Frame number');
ylabel('Stimulus')
hold off;

end

