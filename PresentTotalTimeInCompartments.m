function PresentTotalTimeInCompartments(HandlesForGUIControls,TimesInDifferentCompartments,StartingFrameForAnalysisNum,LastFrameAnalyzed)
%PRESENTTOTALTIMEINCOMPARTMENTS Summary of this function goes here
%   Detailed explanation goes here
CompartmentOccupation=[];
axes(HandlesForGUIControls.axes1);
cla reset;
set(HandlesForGUIControls.axes1,'box','on','Visible','on')
hold on;

for i=1:length(TimesInDifferentCompartments)
   CompartmentOccupation=[CompartmentOccupation,length(TimesInDifferentCompartments{1,i})];
end
CompartmentOccupation=[CompartmentOccupation,LastFrameAnalyzed-StartingFrameForAnalysisNum-sum(CompartmentOccupation)];
if length(CompartmentOccupation)==5
   bar(1:5,CompartmentOccupation)
   xlim([0 6]);
   ylim([0 max(CompartmentOccupation)+max(CompartmentOccupation)/4]);
   set(gca,'XTick',0:1:5)
   set(gca,'XTickLabel',{'','1','2','3','4','5'})
   set(HandlesForGUIControls.StatusText,'string',['Total times are: '...
   ' Compart 1: ' num2str(CompartmentOccupation(1))... 
   ' Compart 2: ' num2str(CompartmentOccupation(2))...
   ' Compart 3: ' num2str(CompartmentOccupation(3))...
   ' Compart 4: ' num2str(CompartmentOccupation(4))...
   ' Compart 5: ' num2str(CompartmentOccupation(5))]);
elseif length(CompartmentOccupation)==6
   bar(1:6,CompartmentOccupation) 
   xlim([0 7]);
   ylim([0 max(CompartmentOccupation)+max(CompartmentOccupation)/4]);
   set(gca,'XTick',0:1:6)
   set(gca,'XTickLabel',{'','1','2','3','4','5','No compartment'})
   set(HandlesForGUIControls.StatusText,'string',['Total times are: '...
   ' Compart 1: ' num2str(CompartmentOccupation(1))... 
   ' Compart 2: ' num2str(CompartmentOccupation(2))...
   ' Compart 3: ' num2str(CompartmentOccupation(3))...
   ' Compart 4: ' num2str(CompartmentOccupation(4))...
   ' Compart 5: ' num2str(CompartmentOccupation(5))...
   ' No Compart: ' num2str(CompartmentOccupation(6))]);
end
 xlabel('Compartment number');
 ylabel('Total number of frames in the chamber')
 hold off;

end

