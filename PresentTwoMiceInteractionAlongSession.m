function PresentTwoMiceInteractionAlongSession(HandlesForGUIControls,StartingFrameForAnalysisNum,LastFrameAnalyzed,TimesOfTwoMiceInteraction); 
%PRESENTTOTALTIMEINCOMPARTMENTS Summary of this function goes here
%   Detailed explanation goes here
axes(HandlesForGUIControls.axes1);
cla reset;
set(HandlesForGUIControls.axes1,'box','on','Visible','on')
hold on;

Interaction=[];
for j=1:size(TimesOfTwoMiceInteraction,2)
   Interaction=[Interaction;TimesOfTwoMiceInteraction(j),1];
end 
if ~isempty(Interaction)
   scatter(Interaction(:,1),Interaction(:,2));
end
   
ylim([0 2]);
xlabel('Frame number');
set(gca,'YTick',0:1:2)
ylabel('Interaction')
hold off;

end

