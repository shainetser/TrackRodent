function TotalStimuliExplorationTime( HandlesForGUIControls,TimesOfStimuliExploration,StartingFrameForAnalysisNum,LastFrameAnalyzed )
%TOTALSTIMULIEXPLORATIONTIME Summary of this function goes here
%   Detailed explanation goes here

StimulusExploration=[];
axes(HandlesForGUIControls.axes1);
cla reset;
set(HandlesForGUIControls.axes1,'box','on','Visible','on')
hold on;

for i=1:length(TimesOfStimuliExploration)
   StimulusExploration=[StimulusExploration,length(TimesOfStimuliExploration{1,i})];
end
StimulusExploration=[StimulusExploration,LastFrameAnalyzed-StartingFrameForAnalysisNum-sum(StimulusExploration)];
if length(StimulusExploration)==3
   bar(1:3,StimulusExploration)
   xlim([0 4]);
   ylim([0 max(StimulusExploration)+max(StimulusExploration)/4]);
   set(gca,'XTick',0:1:3)
   set(gca,'XTickLabel',{'','1','2','3'})
   set(HandlesForGUIControls.StatusText,'string',['Total times are: '...
   ' stimulus 1: ' num2str(StimulusExploration(1))... 
   ' stimulus 2: ' num2str(StimulusExploration(2))...
   ' stimulus 3: ' num2str(StimulusExploration(3))]);
elseif length(StimulusExploration)==4
    bar(1:4,StimulusExploration)
   xlim([0 5]);
   ylim([0 max(StimulusExploration)+max(StimulusExploration)/4]);
   set(gca,'XTick',0:1:4)
   set(gca,'XTickLabel',{'','1','2','3','No stimulus'})
   set(HandlesForGUIControls.StatusText,'string',['Total times are: '...
   ' stimulus 1: ' num2str(StimulusExploration(1))... 
   ' stimulus 2: ' num2str(StimulusExploration(2))...
   ' stimulus 3: ' num2str(StimulusExploration(3))...
   ' No stimulus: ' num2str(StimulusExploration(4))]);
end
xlabel('Stimulus number');
ylabel('Total number of frames exploring the stimulus')
hold off;

end

