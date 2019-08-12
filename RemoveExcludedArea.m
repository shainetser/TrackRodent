function [ExcludedAreasListAfterRemoval ] = RemoveExcludedArea(HandlesForGUIControls,ExcludedAreasList,CurrentFileAnalyzed )
%EXCLUDEAREA Summary of this function goes here
%   Detailed explanation goes here
ExcludedAreasListAfterRemoval=ExcludedAreasList;
ExcludedAreasListAfterRemoval(CurrentFileAnalyzed,1:end)=cell(1,size(ExcludedAreasList,2));
NotForExclusion=0;
axes(HandlesForGUIControls.axes1); 
[AreaToRemoveRow AreaToRemoveCol]= ginput(1);

%%%%% check for each excluded area if it needs to be removed %%%%
for i=1:size(ExcludedAreasList,2)
   ExcludedArea=[];
   ExcludedArea=ExcludedAreasList{CurrentFileAnalyzed,i};
   for j=1:size(ExcludedArea,1)
       if ExcludedArea(j,2)==round(AreaToRemoveRow) && ExcludedArea(j,1)==round(AreaToRemoveCol)
          NotForExclusion=1;
       end
   end
   if NotForExclusion
       disp('Area was removed')
       NotForExclusion=0;
   else
      ExcludedAreasListAfterRemoval(CurrentFileAnalyzed,i)=ExcludedAreasList(CurrentFileAnalyzed,i);
   end   
end

end

