function [ filenameBehavioral, CurrentFrameData,LastOpenDirectory] = LoadSessionFile(HandlesForGUIControls, LastOpenDirectory)
%LOADSESSIONFILE Summary of this function goes here
%   Detailed explanation goes here

  if isempty(LastOpenDirectory)
     [File,Path]=uigetfile('*.avi','Please select an avi file or multiple avi files','MultiSelect', 'on');
  else
     [File,Path]=uigetfile('*.avi','Please select an avi file or multiple avi files','MultiSelect', 'on',LastOpenDirectory); 
  end
  filenameBehavioral=[Path,File]; 
  LastOpenDirectory=Path;
  if ischar(File)
     Film = VideoReader([Path,File]);
     CurrentFrameData = read(Film,1); 
  else
     Film = VideoReader([Path,File{1,1}]);
     CurrentFrameData = read(Film,1);
  end
%   set(gcf,'Position',[10 50 1905 1040] )
  imshow(CurrentFrameData,'Parent',HandlesForGUIControls.axes1);
  set(HandlesForGUIControls.axes1,'Box','off','Visible','off')
  clear Film;
  
  if ~ischar(File)
     warndlg('Please notic you choosed multiple avi files')
     uiwait;
  end
end

