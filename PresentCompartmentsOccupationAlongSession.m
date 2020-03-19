function PresentCompartmentsOccupationAlongSession(HandlesForGUIControls,TimesInDifferentCompartments,StartingFrameForAnalysisNum,LastFrameAnalyzed)
%PRESENTCOMPARTMENTSOCCUPATIONALONGSESSION Summary of this function goes here
%   Detailed explanation goes here

CompartmentOccupation=[];
axes(HandlesForGUIControls.axes1);
cla reset;
set(HandlesForGUIControls.axes1,'box','on','Visible','on')
hold on;

for i=1:length(TimesInDifferentCompartments)
   TimesInCompartment=[];
   TimesInCompartment=TimesInDifferentCompartments{1,i}; 
   for j=1:size(TimesInCompartment,2)
      CompartmentOccupation=[CompartmentOccupation;TimesInCompartment(j),i];
   end 
   if ~isempty(CompartmentOccupation)
      scatter(CompartmentOccupation(:,1),CompartmentOccupation(:,2));
   end
end

ylim([0 6]);
xlabel('Frame number');
ylabel('Compartment')
hold off;

end

