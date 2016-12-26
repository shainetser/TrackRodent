function [ExcludedAreasListAfterExclusion] = ExcludeArea(HandlesForGUIControls,ExcludedAreasList,CurrentFileAnalyzed )
%EXCLUDEAREA Summary of this function goes here
%   Detailed explanation goes here

AreaToExclude = impoly(HandlesForGUIControls.axes1);
wait(AreaToExclude); 
PixelsForRemoval = createMask(AreaToExclude);
[RowForRemoval,ColForRemoval] = find(PixelsForRemoval==1);
try
   Temp=size(ExcludedAreasList(CurrentFileAnalyzed,:),2)+1;
catch
   Temp=1; 
end
ExcludedAreasList{CurrentFileAnalyzed,Temp}=[RowForRemoval,ColForRemoval];
ExcludedAreasListAfterExclusion=ExcludedAreasList;

end
