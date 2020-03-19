function [CompartmentsPositionsListAfterAddition,StimuliPositionsListAfterAddition] = CompartmentOrStimulusDefinition(HandlesForGUIControls,CompartmentShape,CompartmentsPositionsList,StimuliPositionsList,CompartmentOrStimulusNum,CurrentFileAnalyzed)
%COMPARTMENT_STIMULUS_DEFINITION Summary of this function goes here
%   Detailed explanation goes here

%%%%% CompartmentShape==1 means the shape is a poligon, CompartmentShape==0 means the shape is elliptical 

%%%%  'CompartmentOrStimulusNum' definitions %%%%
%%%%  This value specify for the function 'CompartmentOrStimulusDefinition' 
%%%%  which compartment or stimulus is added to the list of compartments or stimuli 
%%%%  1 to 5 = compartments 1 to 5
%%%%  11 to 13 = stimuli 1 to 3

if CompartmentShape==1
   CompartmentArea = impoly(HandlesForGUIControls.axes1);
else
   CompartmentArea = imellipse(HandlesForGUIControls.axes1);
end
wait(CompartmentArea); 
CompartmentPixels = createMask(CompartmentArea);
[CompartmentRow,CompartmentCol] = find(CompartmentPixels==1);
if CompartmentOrStimulusNum<=5
   CompartmentsPositionsList{CurrentFileAnalyzed,CompartmentOrStimulusNum}=[CompartmentRow,CompartmentCol];
else
   StimuliPositionsList{CurrentFileAnalyzed,CompartmentOrStimulusNum-10}=[CompartmentRow,CompartmentCol];
end
CompartmentsPositionsListAfterAddition=CompartmentsPositionsList;
StimuliPositionsListAfterAddition=StimuliPositionsList;
end

