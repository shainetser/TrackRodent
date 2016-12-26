function varargout = TrackRodent(varargin)
%TRACKMICE M-file for TrackMice.fig

%%% TrackRodent is a software for tracking dark mice on a white background
%%% or white rats on dark background
%%% the software needs the files found in the TrackRodent_Software folder and
%%% the files found in the "Ellipse_fitting" folder created by Viktor Witkovsky (2014; add by setting the
%%% path to it). 
%%% The algorisms for the software are updated regularly and
%%% created for different functions (tracking a single rodent, tracking the
%%% rodent nose and more...)

% Last Modified by GUIDE v2.5 04-Nov-2015 10:18:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrackRodent_OpeningFcn, ...
                   'gui_OutputFcn',  @TrackRodent_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TrackMice is made visible.
function TrackRodent_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for TrackMice
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TrackMice wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TrackRodent_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%  parameters for session analysis  %%%%%%%%%%%%%%%%%%%%%%%%
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed


HandlesForGUIControls=handles;
%%% set(hObject,'Position',[385.5 0.5 381 89.5] ) %%% for working with two screens 
ExcludedAreasListAllFiles={};
CompartmentsPositionsListAllFiles={};
StimuliPositionsListAllFiles={};
StartingFrameForAnalysisNumAllFiles=[];
EndingFrameForAnalysisNumAllFiles=[];
LowThresholdValueAllFiles=[];
HighThresholdValueAllFiles=[];
%%%%  'CompartmentOrStimulusNum' definitions %%%%
%%%%  This value specify for the function 'CompartmentOrStimulusDefinition' 
%%%%  which compartment or stimulus is added to the list of compartments or stimuli 
%%%%  1 to 5 = compartments 1 to 5
%%%%  11 to 13 = stimuli 1 to 3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   Session analysis panel   %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in LoadSessionFilePushButton.
function LoadSessionFilePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSessionFilePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

try
   ExcludedAreasListAllFiles={};
   CompartmentsPositionsListAllFiles={};
   StimuliPositionsListAllFiles={};
   StartingFrameForAnalysisNumAllFiles=[];
   EndingFrameForAnalysisNumAllFiles=[];
   LowThresholdValueAllFiles=[];
   HighThresholdValueAllFiles=[];
   [filenameBehavioral,CurrentFrameData,LastOpenDirectory] = LoadSessionFile (HandlesForGUIControls,LastOpenDirectory);
   CurrentFileAnalyzed=1;
   StartingFrameForAnalysisNumAllFiles(1:length(filenameBehavioral)-1)=1;
   StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
   LowThresholdValueAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.LowThresholdSetting,'String'));
   HighThresholdValueAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.HighThresholdSetting,'String'));
   if iscell(filenameBehavioral) 
      FileName=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
   else
      FileName=filenameBehavioral; 
   end
   CurrentFrameData=UpdateCurrentFrameData(FileName,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
   Film = VideoReader(FileName);
   MaxFrameNum=floor(Film.Duration*Film.FrameRate);
   set(HandlesForGUIControls.EndingFrameForAnalysisEdit,'string',num2str(MaxFrameNum));
   set(HandlesForGUIControls.StatusText,'string',filenameBehavioral(CurrentFileAnalyzed+1));
   EndingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=MaxFrameNum;
   clear Film
   
    if ischar(FileName)
     implay(FileName); 
  else
     implay([filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}]);
    end
  
catch
    errordlg('No movie was chosen or the movie is damaged')   
end

% --- Executes on button press in InspectMoviePushbutton.
function InspectMoviePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to InspectMoviePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

[LastOpenDirectory]=InspectMovie(LastOpenDirectory)

   
function FileNumberEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to FileNumberEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FileNumberEditBox as text
%        str2double(get(hObject,'String')) returns contents of FileNumberEditBox as a double

global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

CurrentFileAnalyzed=str2num(get(hObject,'String'));
try
   set(HandlesForGUIControls.StartingFrameForAnalysisEdit,'string',num2str(StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)));
   set(HandlesForGUIControls.EndingFrameForAnalysisEdit,'string',num2str(EndingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)));
   set(HandlesForGUIControls.LowThresholdSetting,'string',num2str(LowThresholdValueAllFiles(CurrentFileAnalyzed)));
   set(HandlesForGUIControls.HighThresholdSetting,'string',num2str(HighThresholdValueAllFiles(CurrentFileAnalyzed)));
   set(HandlesForGUIControls.StatusText,'string',filenameBehavioral(CurrentFileAnalyzed+1));
catch
   if CurrentFileAnalyzed<=length(filenameBehavioral)-1
      StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
      LowThresholdValueAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.LowThresholdSetting,'String'));
      HighThresholdValueAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.HighThresholdSetting,'String'));
      if iscell(filenameBehavioral) 
         FileName=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
      else
         FileName=filenameBehavioral; 
      end
      CurrentFrameData=UpdateCurrentFrameData(FileName,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
      Film = VideoReader(FileName);
      MaxFrameNum=floor(Film.Duration*Film.FrameRate);
      set(HandlesForGUIControls.EndingFrameForAnalysisEdit,'string',num2str(MaxFrameNum));
      set(HandlesForGUIControls.StatusText,'string',filenameBehavioral(CurrentFileAnalyzed+1));
      EndingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=MaxFrameNum;
      clear Film
   end
end



% --- Executes during object creation, after setting all properties.
function FileNumberEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileNumberEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PreviousFilePushButton.
function PreviousFilePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to PreviousFilePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

if iscell(filenameBehavioral) 
   NumOfFiles=(length(filenameBehavioral)-1);
else
   NumOfFiles=1; 
   set(HandlesForGUIControls.FileNumberEditBox,'string',num2str(1));
   set(HandlesForGUIControls.StatusText,'string',filenameBehavioral(2));
end

if CurrentFileAnalyzed>1 && CurrentFileAnalyzed<=length(filenameBehavioral)
   set(HandlesForGUIControls.FileNumberEditBox,'string',num2str(CurrentFileAnalyzed-1));
   set(HandlesForGUIControls.StatusText,'string',filenameBehavioral(CurrentFileAnalyzed));
   CurrentFileAnalyzed=CurrentFileAnalyzed-1;
   
   try
      set(HandlesForGUIControls.StartingFrameForAnalysisEdit,'string',num2str(StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)));
      set(HandlesForGUIControls.EndingFrameForAnalysisEdit,'string',num2str(EndingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)));
      set(HandlesForGUIControls.LowThresholdSetting,'string',num2str(LowThresholdValueAllFiles(CurrentFileAnalyzed)));
      set(HandlesForGUIControls.HighThresholdSetting,'string',num2str(HighThresholdValueAllFiles(CurrentFileAnalyzed)));
      if iscell(filenameBehavioral) 
         FileName=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
      else
         FileName=filenameBehavioral; 
      end
      CurrentFrameData=UpdateCurrentFrameData(FileName,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
   catch
      StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
      LowThresholdValueAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.LowThresholdSetting,'String'));
      HighThresholdValueAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.HighThresholdSetting,'String'));
      if iscell(filenameBehavioral) 
         FileName=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
      else
         FileName=filenameBehavioral; 
      end
      CurrentFrameData=UpdateCurrentFrameData(FileName,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
      Film = VideoReader(FileName);
      MaxFrameNum=floor(Film.Duration*Film.FrameRate);
      set(HandlesForGUIControls.EndingFrameForAnalysisEdit,'string',num2str(MaxFrameNum));
      EndingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=MaxFrameNum;
      clear Film
   end
end




% --- Executes on button press in NextFilePushButton.
function NextFilePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to NextFilePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed 

if iscell(filenameBehavioral) 
   NumOfFiles=(length(filenameBehavioral)-1);
else
   NumOfFiles=1; 
   set(HandlesForGUIControls.FileNumberEditBox,'string',num2str(1));
   set(HandlesForGUIControls.StatusText,'string',filenameBehavioral(2));
end
      
if CurrentFileAnalyzed<NumOfFiles
   set(HandlesForGUIControls.FileNumberEditBox,'string',num2str(CurrentFileAnalyzed+1));
   set(HandlesForGUIControls.StatusText,'string',filenameBehavioral(CurrentFileAnalyzed+2));
   CurrentFileAnalyzed=CurrentFileAnalyzed+1;
   
   try
      set(HandlesForGUIControls.StartingFrameForAnalysisEdit,'string',num2str(StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)));
      set(HandlesForGUIControls.EndingFrameForAnalysisEdit,'string',num2str(EndingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)));
      set(HandlesForGUIControls.LowThresholdSetting,'string',num2str(LowThresholdValueAllFiles(CurrentFileAnalyzed)));
      set(HandlesForGUIControls.HighThresholdSetting,'string',num2str(HighThresholdValueAllFiles(CurrentFileAnalyzed)));
      if iscell(filenameBehavioral) 
         FileName=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
      else
         FileName=filenameBehavioral; 
      end
      CurrentFrameData=UpdateCurrentFrameData(FileName,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
   catch
      StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
      LowThresholdValueAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.LowThresholdSetting,'String'));
      HighThresholdValueAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.HighThresholdSetting,'String'));
      if iscell(filenameBehavioral) 
         FileName=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
      else
         FileName=filenameBehavioral; 
      end
      CurrentFrameData=UpdateCurrentFrameData(FileName,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
      Film = VideoReader(FileName);
      MaxFrameNum=floor(Film.Duration*Film.FrameRate);
      set(HandlesForGUIControls.EndingFrameForAnalysisEdit,'string',num2str(MaxFrameNum));
      EndingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=MaxFrameNum;
      clear Film
   end
end




% --- Executes on button press in ExcludeAreaPushButton.
function ExcludeAreaPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExcludeAreaPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
[ExcludedAreasListAfterExclusion]=ExcludeArea(HandlesForGUIControls,ExcludedAreasListAllFiles,CurrentFileAnalyzed);
ExcludedAreasListAllFiles=ExcludedAreasListAfterExclusion;
if iscell(filenameBehavioral) 
   Film=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
else
   Film=filenameBehavioral; 
end
CurrentFrameData=UpdateCurrentFrameData(Film,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
clear Film;

% --- Executes on button press in RemoveExcludedAreaPushbutton.
function RemoveExcludedAreaPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveExcludedAreaPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
[ExcludedAreasListAfterRemoval]=RemoveExcludedArea(HandlesForGUIControls,ExcludedAreasListAllFiles,CurrentFileAnalyzed);
ExcludedAreasListAllFiles=ExcludedAreasListAfterRemoval;
if iscell(filenameBehavioral) 
   Film=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
else
   Film=filenameBehavioral; 
end
CurrentFrameData=UpdateCurrentFrameData(Film,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
clear Film;

% --- Executes on button press in Compartment1PushButton.
function Compartment1PushButton_Callback(hObject, eventdata, handles)
% hObject    handle to Compartment1PushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
CompartmentOrStimulusNum=1;
CompartmentShape=get(HandlesForGUIControls.PolygonCompartment1RadioButton,'value');
[CompartmentsPositionsListAfterAddition,StimuliPositionsListAfterAddition] = CompartmentOrStimulusDefinition(HandlesForGUIControls,CompartmentShape,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CompartmentOrStimulusNum,CurrentFileAnalyzed);
CompartmentsPositionsListAllFiles=CompartmentsPositionsListAfterAddition;
StimuliPositionsListAllFiles=StimuliPositionsListAfterAddition;
if iscell(filenameBehavioral) 
   Film=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
else
   Film=filenameBehavioral; 
end
CurrentFrameData=UpdateCurrentFrameData(Film,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
clear Film;


% --- Executes on button press in Compartment2PushButton.
function Compartment2PushButton_Callback(hObject, eventdata, handles)
% hObject    handle to Compartment2PushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
CompartmentOrStimulusNum=2;
CompartmentShape=get(HandlesForGUIControls.PolygonCompartment1RadioButton,'value');
[CompartmentsPositionsListAfterAddition,StimuliPositionsListAfterAddition] = CompartmentOrStimulusDefinition(HandlesForGUIControls,CompartmentShape,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CompartmentOrStimulusNum,CurrentFileAnalyzed);
CompartmentsPositionsListAllFiles=CompartmentsPositionsListAfterAddition;
StimuliPositionsListAllFiles=StimuliPositionsListAfterAddition;
if iscell(filenameBehavioral) 
   Film=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
else
   Film=filenameBehavioral; 
end
CurrentFrameData=UpdateCurrentFrameData(Film,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
clear Film;

% --- Executes on button press in Compartment3PushButton.
function Compartment3PushButton_Callback(hObject, eventdata, handles)
% hObject    handle to Compartment3PushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
CompartmentOrStimulusNum=3;
CompartmentShape=get(HandlesForGUIControls.PolygonCompartment1RadioButton,'value');
[CompartmentsPositionsListAfterAddition,StimuliPositionsListAfterAddition] = CompartmentOrStimulusDefinition(HandlesForGUIControls,CompartmentShape,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CompartmentOrStimulusNum,CurrentFileAnalyzed);
CompartmentsPositionsListAllFiles=CompartmentsPositionsListAfterAddition;
StimuliPositionsListAllFiles=StimuliPositionsListAfterAddition;
if iscell(filenameBehavioral) 
   Film=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
else
   Film=filenameBehavioral; 
end
CurrentFrameData=UpdateCurrentFrameData(Film,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
clear Film;

% --- Executes on button press in Compartment4pushbutton.
function Compartment4pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Compartment4pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
CompartmentOrStimulusNum=4;
CompartmentShape=get(HandlesForGUIControls.PolygonCompartment1RadioButton,'value');
[CompartmentsPositionsListAfterAddition,StimuliPositionsListAfterAddition] = CompartmentOrStimulusDefinition(HandlesForGUIControls,CompartmentShape,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CompartmentOrStimulusNum,CurrentFileAnalyzed);
CompartmentsPositionsListAllFiles=CompartmentsPositionsListAfterAddition;
StimuliPositionsListAllFiles=StimuliPositionsListAfterAddition;
if iscell(filenameBehavioral) 
   Film=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
else
   Film=filenameBehavioral; 
end
CurrentFrameData=UpdateCurrentFrameData(Film,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
clear Film;

% --- Executes on button press in Compartment5pushbutton.
function Compartment5pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Compartment5pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
CompartmentOrStimulusNum=5;
CompartmentShape=get(HandlesForGUIControls.PolygonCompartment1RadioButton,'value');
[CompartmentsPositionsListAfterAddition,StimuliPositionsListAfterAddition] = CompartmentOrStimulusDefinition(HandlesForGUIControls,CompartmentShape,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CompartmentOrStimulusNum,CurrentFileAnalyzed);
CompartmentsPositionsListAllFiles=CompartmentsPositionsListAfterAddition;
StimuliPositionsListAllFiles=StimuliPositionsListAfterAddition;
if iscell(filenameBehavioral) 
   Film=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
else
   Film=filenameBehavioral; 
end
CurrentFrameData=UpdateCurrentFrameData(Film,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
clear Film;

% --- Executes on button press in Stimulus1LocationPushButton.
function Stimulus1LocationPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to Stimulus1LocationPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
CompartmentOrStimulusNum=11;
CompartmentShape=get(HandlesForGUIControls.PolygonCompartment1RadioButton,'value');
[CompartmentsPositionsListAfterAddition,StimuliPositionsListAfterAddition] = CompartmentOrStimulusDefinition(HandlesForGUIControls,CompartmentShape,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CompartmentOrStimulusNum,CurrentFileAnalyzed);
CompartmentsPositionsListAllFiles=CompartmentsPositionsListAfterAddition;
StimuliPositionsListAllFiles=StimuliPositionsListAfterAddition;
if iscell(filenameBehavioral) 
   Film=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
else
   Film=filenameBehavioral; 
end
CurrentFrameData=UpdateCurrentFrameData(Film,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
clear Film;

% --- Executes on button press in Stimulus2LocationPushButton.
function Stimulus2LocationPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to Stimulus2LocationPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
CompartmentOrStimulusNum=12;
CompartmentShape=get(HandlesForGUIControls.PolygonCompartment1RadioButton,'value');
[CompartmentsPositionsListAfterAddition,StimuliPositionsListAfterAddition] = CompartmentOrStimulusDefinition(HandlesForGUIControls,CompartmentShape,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CompartmentOrStimulusNum,CurrentFileAnalyzed);
CompartmentsPositionsListAllFiles=CompartmentsPositionsListAfterAddition;
StimuliPositionsListAllFiles=StimuliPositionsListAfterAddition;
if iscell(filenameBehavioral) 
   Film=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
else
   Film=filenameBehavioral; 
end
CurrentFrameData=UpdateCurrentFrameData(Film,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
clear Film;

% --- Executes on button press in Stimulus3LocationPushbutton.
function Stimulus3LocationPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Stimulus3LocationPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
CompartmentOrStimulusNum=13;
CompartmentShape=get(HandlesForGUIControls.PolygonCompartment1RadioButton,'value');
[CompartmentsPositionsListAfterAddition,StimuliPositionsListAfterAddition] = CompartmentOrStimulusDefinition(HandlesForGUIControls,CompartmentShape,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CompartmentOrStimulusNum,CurrentFileAnalyzed);
CompartmentsPositionsListAllFiles=CompartmentsPositionsListAfterAddition;
StimuliPositionsListAllFiles=StimuliPositionsListAfterAddition;
if iscell(filenameBehavioral) 
   Film=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
else
   Film=filenameBehavioral; 
end
CurrentFrameData=UpdateCurrentFrameData(Film,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
clear Film;

% --- Executes on selection change in SessionAnalysisAlgorithmPopupmenu.
function SessionAnalysisAlgorithmPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to SessionAnalysisAlgorithmPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SessionAnalysisAlgorithmPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SessionAnalysisAlgorithmPopupmenu


% --- Executes during object creation, after setting all properties.
function SessionAnalysisAlgorithmPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SessionAnalysisAlgorithmPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StartingFrameForAnalysisEdit_Callback(hObject, eventdata, handles)
% hObject    handle to StartingFrameForAnalysisEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartingFrameForAnalysisEdit as text
%        str2double(get(hObject,'String')) returns contents of StartingFrameForAnalysisEdit as a double
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed


if iscell(filenameBehavioral) 
   Film = VideoReader([filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}]);
else
   Film = VideoReader(filenameBehavioral); 
end
nFrames = floor(Film.Duration*Film.FrameRate); 
clear Film;
if str2num(get(hObject,'String'))<=nFrames
   StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(hObject,'String')); 
   if iscell(filenameBehavioral) 
      Film=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
   else
      Film=filenameBehavioral; 
   end
   CurrentFrameData=UpdateCurrentFrameData(Film,StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed),HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
   clear Film;
else
    errordlg(['The maximal number of frames in the movie is ' num2str(nFrames)],'Loading frame problem');
end



% --- Executes during object creation, after setting all properties.
function StartingFrameForAnalysisEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartingFrameForAnalysisEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function EndingFrameForAnalysisEdit_Callback(hObject, eventdata, handles)
% hObject    handle to EndingFrameForAnalysisEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndingFrameForAnalysisEdit as text
%        str2double(get(hObject,'String')) returns contents of EndingFrameForAnalysisEdit as a double

global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed


if iscell(filenameBehavioral) 
   Film = VideoReader([filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}]);
else
   Film = VideoReader(filenameBehavioral); 
end
nFrames = floor(Film.Duration*Film.FrameRate); 
clear Film;
if str2num(get(hObject,'String'))<=nFrames
   EndingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed)=str2num(get(hObject,'String'));
else
    errordlg(['The maximal number of frames in the movie is ' num2str(nFrames)],'Loading frame problem');
end


% --- Executes during object creation, after setting all properties.
function EndingFrameForAnalysisEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndingFrameForAnalysisEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MouseLocationCenterOfBodyCheckbox.
function MouseLocationCenterOfBodyCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to MouseLocationCenterOfBodyCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in TimesOfStimuliExplorationCheckBox.
function TimesOfStimuliExplorationCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to TimesOfStimuliExplorationCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TimesOfStimuliExplorationCheckBox

% --- Executes on button press in TimesInDifferentCompartmentsCheckbox.
function TimesInDifferentCompartmentsCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to TimesInDifferentCompartmentsCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TimesInDifferentCompartmentsCheckbox


% --- Executes on button press in SaveAnalyzedMovieCheckbox.
function SaveAnalyzedMovieCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to SaveAnalyzedMovieCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SaveAnalyzedMovieCheckbox

% --- Executes on button press in SaveResultsWhenAnalysisFinished.
function SaveResultsWhenAnalysisFinished_Callback(hObject, eventdata, handles)
% hObject    handle to SaveResultsWhenAnalysisFinished (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SaveResultsWhenAnalysisFinished

% --- Executes on button press in SaveComparmentsSettingsPushButton.
function SaveComparmentsSettingsPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveComparmentsSettingsPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

if isempty(LastOpenDirectory)
      [File,Path] = uiputfile('*.mat','Please save compartments settings','_settings');
else
      [File,Path] = uiputfile('*.mat','Please save compartments settings',[LastOpenDirectory '_settings']);
end

filenameOfSettings=[Path,File];
try
   save(filenameOfSettings, 'ExcludedAreasListAllFiles','CompartmentsPositionsListAllFiles','StimuliPositionsListAllFiles')
   set(HandlesForGUIControls.StatusText,'string','Settings were saved');
catch
   warndlg('Settings were not saved') 
end


% --- Executes on button press in LoadCompatrmentsSettingsPushButton.
function LoadCompatrmentsSettingsPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadCompatrmentsSettingsPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StartingFrameForAnalysisNum=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
if isempty(LastOpenDirectory)
   [File, Path] = uigetfile('*.mat','Please load compartments settings','MultiSelect', 'off');
else
   [File, Path] = uigetfile('*.mat','Please load compartments settings','MultiSelect', 'off',LastOpenDirectory); 
end
filenameOfSettings=[Path,File];

try
   load(filenameOfSettings);
   if iscell(filenameBehavioral) 
      Film=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
   else
      Film=filenameBehavioral; 
   end
   CurrentFrameData=UpdateCurrentFrameData(Film,StartingFrameForAnalysisNum,HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
   clear Film;   
   set(HandlesForGUIControls.StatusText,'string','Settings were loaded');
catch
   warndlg('Settings were not loaded') 
end


function LowThresholdSetting_Callback(hObject, eventdata, handles)
% hObject    handle to LowThresholdSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LowThresholdSetting as text
%        str2double(get(hObject,'String')) returns contents of LowThresholdSetting as a double

global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

LowThresholdValueAllFiles(CurrentFileAnalyzed)=str2double(get(hObject,'String'));
if iscell(filenameBehavioral) 
   FilmName=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
else
   FilmName=filenameBehavioral; 
end
StartingFrameForAnalysisNum=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
CurrentFrameData=UpdateCurrentFrameData(FilmName,StartingFrameForAnalysisNum,HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
AnimalType=get(HandlesForGUIControls.RatRadioButton,'value');

if AnimalType==0 %%%%% for mouse
   Film = VideoReader(FilmName);
   %%%%% open the image, convert it to black and white and clean it from noise      
   cdataRGB = read(Film,StartingFrameForAnalysisNum);
   cdataBW=im2bw(cdataRGB,LowThresholdValueAllFiles(CurrentFileAnalyzed));
   cdataWB=zeros(size(cdataBW,1),size(cdataBW,2));
   cdataWB(find(cdataBW==0))=1;
   Clean_cdataWB = bwareaopen(cdataWB, 400);
     
   %%%%% exclude pixels that were excluded from the image by the user
   if ~isempty(ExcludedAreasListAllFiles)
      for i=1:length(ExcludedAreasListAllFiles(CurrentFileAnalyzed,:))
         AreaToExclude=[];
         AreaToExclude=ExcludedAreasListAllFiles{CurrentFileAnalyzed,i}; 
         for j=1:size(AreaToExclude,1)
            Clean_cdataWB(AreaToExclude(j,1),AreaToExclude(j,2))=0;
         end 
      end
   end

   %%%%% look for boundaries of the mice
   BoundariesWB = bwboundaries(Clean_cdataWB);
   axes(HandlesForGUIControls.axes1);
   hold on;

   for i=1:size(BoundariesWB,1) 
      BoundaryToPlot=BoundariesWB{i,1}; 
      plot(BoundaryToPlot(:,2),BoundaryToPlot(:,1),'-g','LineWidth',2) 
   end
else   %%%%% for rat
   Film = VideoReader(FilmName);
   %%%%% open the image, convert it to black and white and clean it from noise      
   cdataRGB = read(Film,StartingFrameForAnalysisNum);
   cdataWB=im2bw(cdataRGB,LowThresholdValueAllFiles(CurrentFileAnalyzed));
   cdataBW=ones(size(cdataWB,1),size(cdataWB,2));
   cdataBW(find(cdataWB==0))=0;
   Clean_cdataBW = bwareaopen(cdataBW, 400);
     
   %%%%% exclude pixels that were excluded from the image by the user
   if ~isempty(ExcludedAreasListAllFiles)
      for i=1:length(ExcludedAreasListAllFiles(CurrentFileAnalyzed,:))
         AreaToExclude=[];
         AreaToExclude=ExcludedAreasListAllFiles{CurrentFileAnalyzed,i}; 
         for j=1:size(AreaToExclude,1)
            Clean_cdataBW(AreaToExclude(j,1),AreaToExclude(j,2))=0;
         end 
      end
   end

   %%%%% look for boundaries of the rat
   se = strel('disk',10);
   Clean_cdataBW=imerode(Clean_cdataBW,se);
   se = strel('disk',10);
   Clean_cdataBW=imdilate(Clean_cdataBW,se);
   BoundariesWB = bwboundaries(Clean_cdataBW);
   axes(HandlesForGUIControls.axes1);
   hold on;

   for i=1:size(BoundariesWB,1) 
      BoundaryToPlot=BoundariesWB{i,1}; 
      plot(BoundaryToPlot(:,2),BoundaryToPlot(:,1),'-g','LineWidth',2) 
   end 
end
% --- Executes during object creation, after setting all properties.
function LowThresholdSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LowThresholdSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HighThresholdSetting_Callback(hObject, eventdata, handles)
% hObject    handle to HighThresholdSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HighThresholdSetting as text
%        str2double(get(hObject,'String')) returns contents of HighThresholdSetting as a double

global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

HighThresholdValueAllFiles(CurrentFileAnalyzed)=str2double(get(hObject,'String'));
if iscell(filenameBehavioral) 
   FilmName=[filenameBehavioral{1,1},filenameBehavioral{1,CurrentFileAnalyzed+1}];
else
   FilmName=filenameBehavioral; 
end
StartingFrameForAnalysisNum=str2num(get(HandlesForGUIControls.StartingFrameForAnalysisEdit,'String'));
CurrentFrameData=UpdateCurrentFrameData(FilmName,StartingFrameForAnalysisNum,HandlesForGUIControls,ExcludedAreasListAllFiles,CompartmentsPositionsListAllFiles,StimuliPositionsListAllFiles,CurrentFileAnalyzed);
AnimalType=get(HandlesForGUIControls.RatRadioButton,'value');

if AnimalType==0 %%%%% for mouse
   Film = VideoReader(FilmName);
   %%%%% open the image, convert it to black and white and clean it from noise      
   cdataRGB = read(Film,StartingFrameForAnalysisNum);
   cdataBW=im2bw(cdataRGB,HighThresholdValueAllFiles(CurrentFileAnalyzed));
   cdataWB=zeros(size(cdataBW,1),size(cdataBW,2));
   cdataWB(find(cdataBW==0))=1;
   Clean_cdataWB = bwareaopen(cdataWB, 400);
     
   %%%%% exclude pixels that were excluded from the image by the user
   if ~isempty(ExcludedAreasListAllFiles)
      for i=1:length(ExcludedAreasListAllFiles(CurrentFileAnalyzed,:))
         AreaToExclude=[];
         AreaToExclude=ExcludedAreasListAllFiles{CurrentFileAnalyzed,i}; 
         for j=1:size(AreaToExclude,1)
            Clean_cdataWB(AreaToExclude(j,1),AreaToExclude(j,2))=0;
         end 
      end
   end
   
   %%%%% look for boundaries of the mice
   BoundariesWB = bwboundaries(Clean_cdataWB);
   axes(HandlesForGUIControls.axes1);
   hold on;

   for i=1:size(BoundariesWB,1) 
      BoundaryToPlot=BoundariesWB{i,1}; 
      plot(BoundaryToPlot(:,2),BoundaryToPlot(:,1),'-b','LineWidth',2) 
   end
else   %%%%% for rat
   Film = VideoReader(FilmName);
   %%%%% open the image, convert it to black and white and clean it from noise      
   cdataRGB = read(Film,StartingFrameForAnalysisNum);
   cdataWB=im2bw(cdataRGB,HighThresholdValueAllFiles(CurrentFileAnalyzed));
   cdataBW=ones(size(cdataWB,1),size(cdataWB,2));
   cdataBW(find(cdataWB==0))=0;
   Clean_cdataBW = bwareaopen(cdataBW, 400);
     
   %%%%% exclude pixels that were excluded from the image by the user
   if ~isempty(ExcludedAreasListAllFiles)
      for i=1:length(ExcludedAreasListAllFiles(CurrentFileAnalyzed,:))
         AreaToExclude=[];
         AreaToExclude=ExcludedAreasListAllFiles{(CurrentFileAnalyzed),i}; 
         for j=1:size(AreaToExclude,1)
            Clean_cdataBW(AreaToExclude(j,1),AreaToExclude(j,2))=0;
         end 
      end
   end
   
   %%%%% look for boundaries of the rat
   se = strel('disk',10);
   Clean_cdataBW=imerode(Clean_cdataBW,se);
   se = strel('disk',10);
   Clean_cdataBW=imdilate(Clean_cdataBW,se);
   BoundariesWB = bwboundaries(Clean_cdataBW);
   axes(HandlesForGUIControls.axes1);
   hold on;

   for i=1:size(BoundariesWB,1) 
      BoundaryToPlot=BoundariesWB{i,1}; 
      plot(BoundaryToPlot(:,2),BoundaryToPlot(:,1),'-g','LineWidth',2) 
   end 
end 
% --- Executes during object creation, after setting all properties.
function HighThresholdSetting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HighThresholdSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in StartAnalysisPushButton.
function StartAnalysisPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartAnalysisPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StopAnalysis=0;
SaveMovie=get(HandlesForGUIControls.SaveAnalyzedMovieCheckbox,'Value');
SaveResultsWhenAnalysisFinished=get(HandlesForGUIControls.SaveResultsWhenAnalysisFinished,'Value');
contents = get(HandlesForGUIControls.SessionAnalysisAlgorithmPopupmenu,'string');
SelectedAlgorithm=contents{get(HandlesForGUIControls.SessionAnalysisAlgorithmPopupmenu,'Value')};

for MovieNum=1:(size(filenameBehavioral,2)-1)

   firstFrameInTheAnalysis=[]; 
   MouseLocationCenterOfBody=[];
   MouseLocationCenterOfBody1=[];
   MouseLocationCenterOfBody2=[];
   TimesOfStimuliExploration=cell(1,3);
   TimesInDifferentCompartments=cell(1,5);
   TimesOfTwoMiceInteraction=[];
   StartingFrameForAnalysisNum=StartingFrameForAnalysisNumAllFiles(MovieNum);
   EndingFrameForAnalysisNum=EndingFrameForAnalysisNumAllFiles(MovieNum);
   LowThresholdValue=LowThresholdValueAllFiles(MovieNum);
   HighThresholdValue=HighThresholdValueAllFiles(MovieNum);
   ExcludedAreasList={};
   CompartmentsPositionsList={};
   StimuliPositionsList={};
   try
      ExcludedAreasList=ExcludedAreasListAllFiles(MovieNum,:);
   catch
      %%% Do nothing    
   end
   try
      CompartmentsPositionsList=CompartmentsPositionsListAllFiles(MovieNum,:);
   catch
      %%% Do nothing    
   end
   try
      StimuliPositionsList=StimuliPositionsListAllFiles(MovieNum,:);
   catch
      %%% Do nothing    
   end
   
   if iscell(filenameBehavioral) 
      filenameBehavioralForAnalysis=[filenameBehavioral{1,1},filenameBehavioral{1,MovieNum+1}];
   else
      filenameBehavioralForAnalysis=filenameBehavioral; 
   end

   switch SelectedAlgorithm
       case 'Mice_Algorithm_from_23_7_14'
          [MouseLocationCenterOfBody,TimesOfStimuliExploration,TimesInDifferentCompartments,firstFrameInTheAnalysis,LastFrameAnalyzed]=MiceMovieAnalyzerSRM23_7_14(filenameBehavioralForAnalysis,HandlesForGUIControls,StartingFrameForAnalysisNum,EndingFrameForAnalysisNum,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,SaveMovie,LowThresholdValue,MovieNum);
          set(HandlesForGUIControls.StatusText,'string','Finished analyzing');
          if SaveResultsWhenAnalysisFinished==1
             filenameOfSettings=[filenameBehavioralForAnalysis(1:end-4) '_video_data_results' num2str(MovieNum) '.mat'];
             save(filenameOfSettings,'filenameBehavioralForAnalysis','StartingFrameForAnalysisNum','EndingFrameForAnalysisNum','LastFrameAnalyzed','ExcludedAreasList','CompartmentsPositionsList','StimuliPositionsList',...
             'MouseLocationCenterOfBody','MouseLocationCenterOfBody1','MouseLocationCenterOfBody2','TimesOfStimuliExploration','TimesInDifferentCompartments','firstFrameInTheAnalysis','TimesOfTwoMiceInteraction',...
             'LowThresholdValue', 'HighThresholdValue')
             set(HandlesForGUIControls.StatusText,'string','Analysis parameters and data were saved'); 
          end
       case 'Mice_Algorithm_from_23_7_14_Fast'
          [MouseLocationCenterOfBody,TimesOfStimuliExploration,TimesInDifferentCompartments,firstFrameInTheAnalysis,LastFrameAnalyzed]=MiceMovieAnalyzerSRM23_7_14_Fast(filenameBehavioralForAnalysis,HandlesForGUIControls,StartingFrameForAnalysisNum,EndingFrameForAnalysisNum,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,SaveMovie,LowThresholdValue,MovieNum);
          set(HandlesForGUIControls.StatusText,'string','Finished analyzing');
          if SaveResultsWhenAnalysisFinished==1
             filenameOfSettings=[filenameBehavioralForAnalysis(1:end-4) '_video_data_results' num2str(MovieNum) '.mat'];
             save(filenameOfSettings,'filenameBehavioralForAnalysis','StartingFrameForAnalysisNum','EndingFrameForAnalysisNum','LastFrameAnalyzed','ExcludedAreasList','CompartmentsPositionsList','StimuliPositionsList',...
             'MouseLocationCenterOfBody','MouseLocationCenterOfBody1','MouseLocationCenterOfBody2','TimesOfStimuliExploration','TimesInDifferentCompartments','firstFrameInTheAnalysis','TimesOfTwoMiceInteraction',...
             'LowThresholdValue', 'HighThresholdValue')
             set(HandlesForGUIControls.StatusText,'string','Analysis parameters and data were saved'); 
          end
       case 'Mice_Algorithm_from_10_3_2016'
          [MouseLocationCenterOfBody,TimesOfStimuliExploration,TimesInDifferentCompartments,firstFrameInTheAnalysis,LastFrameAnalyzed]=MiceMovieAnalyzerSRM10_3_2016(filenameBehavioralForAnalysis,HandlesForGUIControls,StartingFrameForAnalysisNum,EndingFrameForAnalysisNum,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,SaveMovie,LowThresholdValue,HighThresholdValue,MovieNum);
          set(HandlesForGUIControls.StatusText,'string','Finished analyzing');
          if SaveResultsWhenAnalysisFinished==1
             filenameOfSettings=[filenameBehavioralForAnalysis(1:end-4) '_video_data_results' num2str(MovieNum) '.mat'];
             save(filenameOfSettings,'filenameBehavioralForAnalysis','StartingFrameForAnalysisNum','EndingFrameForAnalysisNum','LastFrameAnalyzed','ExcludedAreasList','CompartmentsPositionsList','StimuliPositionsList',...
             'MouseLocationCenterOfBody','MouseLocationCenterOfBody1','MouseLocationCenterOfBody2','TimesOfStimuliExploration','TimesInDifferentCompartments','firstFrameInTheAnalysis','TimesOfTwoMiceInteraction',...
             'LowThresholdValue', 'HighThresholdValue')
             set(HandlesForGUIControls.StatusText,'string','Analysis parameters and data were saved'); 
          end
       case 'Mice_Algorithm_from_10_3_2016_Fast'
          [MouseLocationCenterOfBody,TimesOfStimuliExploration,TimesInDifferentCompartments,firstFrameInTheAnalysis,LastFrameAnalyzed]=MiceMovieAnalyzerSRM10_3_2016_Fast(filenameBehavioralForAnalysis,HandlesForGUIControls,StartingFrameForAnalysisNum,EndingFrameForAnalysisNum,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,SaveMovie,LowThresholdValue,HighThresholdValue,MovieNum);
          set(HandlesForGUIControls.StatusText,'string','Finished analyzing');
          if SaveResultsWhenAnalysisFinished==1
             filenameOfSettings=[filenameBehavioralForAnalysis(1:end-4) '_video_data_results' num2str(MovieNum) '.mat'];
             save(filenameOfSettings,'filenameBehavioralForAnalysis','StartingFrameForAnalysisNum','EndingFrameForAnalysisNum','LastFrameAnalyzed','ExcludedAreasList','CompartmentsPositionsList','StimuliPositionsList',...
             'MouseLocationCenterOfBody','MouseLocationCenterOfBody1','MouseLocationCenterOfBody2','TimesOfStimuliExploration','TimesInDifferentCompartments','firstFrameInTheAnalysis','TimesOfTwoMiceInteraction',...
             'LowThresholdValue', 'HighThresholdValue')
             set(HandlesForGUIControls.StatusText,'string','Analysis parameters and data were saved'); 
          end
       case 'Two_Mice_Interaction_Algorithm_2_3_2015'
          [TimesOfTwoMiceInteraction, MouseLocationCenterOfBody1, MouseLocationCenterOfBody2, firstFrameInTheAnalysis,LastFrameAnalyzed]=MiceMovieAnalyzerTwoMiceInteraction3_1_16(filenameBehavioralForAnalysis,HandlesForGUIControls,StartingFrameForAnalysisNum,EndingFrameForAnalysisNum,ExcludedAreasList,SaveMovie,LowThresholdValue,MovieNum);
          set(HandlesForGUIControls.StatusText,'string','Finished analyzing');
          if SaveResultsWhenAnalysisFinished==1
             filenameOfSettings=[filenameBehavioralForAnalysis(1:end-4) '_video_data_results' num2str(MovieNum) '.mat'];
             save(filenameOfSettings,'filenameBehavioralForAnalysis','StartingFrameForAnalysisNum','EndingFrameForAnalysisNum','LastFrameAnalyzed','ExcludedAreasList','CompartmentsPositionsList','StimuliPositionsList',...
             'MouseLocationCenterOfBody','MouseLocationCenterOfBody1','MouseLocationCenterOfBody2','TimesOfStimuliExploration','TimesInDifferentCompartments','firstFrameInTheAnalysis','TimesOfTwoMiceInteraction',...
             'LowThresholdValue', 'HighThresholdValue')
             set(HandlesForGUIControls.StatusText,'string','Analysis parameters and data were saved'); 
          end
       case 'Rat_Algorithm_from_15_7_2015'
          [MouseLocationCenterOfBody,TimesOfStimuliExploration,TimesInDifferentCompartments,firstFrameInTheAnalysis,LastFrameAnalyzed]=RatMovieAnalyzerSRM15_7_15(filenameBehavioralForAnalysis,HandlesForGUIControls,StartingFrameForAnalysisNum,EndingFrameForAnalysisNum,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,SaveMovie,LowThresholdValue,MovieNum);
          set(HandlesForGUIControls.StatusText,'string','Finished analyzing');
          if SaveResultsWhenAnalysisFinished==1
             filenameOfSettings=[filenameBehavioralForAnalysis(1:end-4) '_video_data_results' num2str(MovieNum) '.mat'];
             save(filenameOfSettings,'filenameBehavioralForAnalysis','StartingFrameForAnalysisNum','EndingFrameForAnalysisNum','LastFrameAnalyzed','ExcludedAreasList','CompartmentsPositionsList','StimuliPositionsList',...
             'MouseLocationCenterOfBody','MouseLocationCenterOfBody1','MouseLocationCenterOfBody2','TimesOfStimuliExploration','TimesInDifferentCompartments','firstFrameInTheAnalysis','TimesOfTwoMiceInteraction',...
             'LowThresholdValue', 'HighThresholdValue')
             set(HandlesForGUIControls.StatusText,'string','Analysis parameters and data were saved'); 
          end
       case 'Rat_Algorithm_from_15_7_2015_Fast'
          [MouseLocationCenterOfBody,TimesOfStimuliExploration,TimesInDifferentCompartments,firstFrameInTheAnalysis,LastFrameAnalyzed]=RatMovieAnalyzerSRM15_7_15_Fast(filenameBehavioralForAnalysis,HandlesForGUIControls,StartingFrameForAnalysisNum,EndingFrameForAnalysisNum,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,SaveMovie,LowThresholdValue,MovieNum);
          set(HandlesForGUIControls.StatusText,'string','Finished analyzing');
          if SaveResultsWhenAnalysisFinished==1
             filenameOfSettings=[filenameBehavioralForAnalysis(1:end-4) '_video_data_results' num2str(MovieNum) '.mat'];
             save(filenameOfSettings,'filenameBehavioralForAnalysis','StartingFrameForAnalysisNum','EndingFrameForAnalysisNum','LastFrameAnalyzed','ExcludedAreasList','CompartmentsPositionsList','StimuliPositionsList',...
             'MouseLocationCenterOfBody','MouseLocationCenterOfBody1','MouseLocationCenterOfBody2','TimesOfStimuliExploration','TimesInDifferentCompartments','firstFrameInTheAnalysis','TimesOfTwoMiceInteraction',...
             'LowThresholdValue', 'HighThresholdValue')
             set(HandlesForGUIControls.StatusText,'string','Analysis parameters and data were saved'); 
          end   
       case 'Mice_Algorithm_from_4_11_15'
          [MouseLocationCenterOfBody,TimesOfStimuliExploration,TimesInDifferentCompartments,firstFrameInTheAnalysis,LastFrameAnalyzed]=MiceMovieAnalyzerSRM4_11_15(filenameBehavioralForAnalysis,HandlesForGUIControls,StartingFrameForAnalysisNum,EndingFrameForAnalysisNum,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,SaveMovie,LowThresholdValue,MovieNum);
          set(HandlesForGUIControls.StatusText,'string','Finished analyzing');
          if SaveResultsWhenAnalysisFinished==1
             filenameOfSettings=[filenameBehavioralForAnalysis(1:end-4) '_video_data_results' num2str(MovieNum) '.mat'];
             save(filenameOfSettings,'filenameBehavioralForAnalysis','StartingFrameForAnalysisNum','EndingFrameForAnalysisNum','LastFrameAnalyzed','ExcludedAreasList','CompartmentsPositionsList','StimuliPositionsList',...
             'MouseLocationCenterOfBody','MouseLocationCenterOfBody1','MouseLocationCenterOfBody2','TimesOfStimuliExploration','TimesInDifferentCompartments','firstFrameInTheAnalysis','TimesOfTwoMiceInteraction',...
             'LowThresholdValue', 'HighThresholdValue')
             set(HandlesForGUIControls.StatusText,'string','Analysis parameters and data were saved'); 
          end
       case 'Mice_Algorithm_from_4_11_15_Fast'
          [MouseLocationCenterOfBody,TimesOfStimuliExploration,TimesInDifferentCompartments,firstFrameInTheAnalysis,LastFrameAnalyzed]=MiceMovieAnalyzerSRM4_11_15_Fast(filenameBehavioralForAnalysis,HandlesForGUIControls,StartingFrameForAnalysisNum,EndingFrameForAnalysisNum,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,SaveMovie,LowThresholdValue,MovieNum);
          set(HandlesForGUIControls.StatusText,'string','Finished analyzing');
          if SaveResultsWhenAnalysisFinished==1
             filenameOfSettings=[filenameBehavioralForAnalysis(1:end-4) '_video_data_results' num2str(MovieNum) '.mat'];
             save(filenameOfSettings,'filenameBehavioralForAnalysis','StartingFrameForAnalysisNum','EndingFrameForAnalysisNum','LastFrameAnalyzed','ExcludedAreasList','CompartmentsPositionsList','StimuliPositionsList',...
             'MouseLocationCenterOfBody','MouseLocationCenterOfBody1','MouseLocationCenterOfBody2','TimesOfStimuliExploration','TimesInDifferentCompartments','firstFrameInTheAnalysis','TimesOfTwoMiceInteraction',...
             'LowThresholdValue', 'HighThresholdValue')
             set(HandlesForGUIControls.StatusText,'string','Analysis parameters and data were saved'); 
          end
       otherwise
          errordlg('Please choose an algorithm for analysis');    
          return;
   end
   if ~iscell(filenameBehavioral)
      break;
   end
   if StopAnalysis
      break;
   end
end


% --- Executes on button press in StopAnalysisPushButton.
function StopAnalysisPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to StopAnalysisPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StopAnalysis=1;


% --- Executes on button press in SaveAnalysisPushButton.
function SaveAnalysisPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveAnalysisPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

StartingFrameForAnalysisNum=StartingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed);
EndingFrameForAnalysisNum=EndingFrameForAnalysisNumAllFiles(CurrentFileAnalyzed);
LowThresholdValue=LowThresholdValueAllFiles(CurrentFileAnalyzed);
HighThresholdValue=HighThresholdValueAllFiles(CurrentFileAnalyzed);
ExcludedAreasList={};
CompartmentsPositionsList={};
StimuliPositionsList={};

try
   ExcludedAreasList=ExcludedAreasListAllFiles(CurrentFileAnalyzed,:);
catch
   %%% Do nothing    
end
try
   CompartmentsPositionsList=CompartmentsPositionsListAllFiles(CurrentFileAnalyzed,:);
catch
   %%% Do nothing    
end
try
   StimuliPositionsList=StimuliPositionsListAllFiles(CurrentFileAnalyzed,:);
catch
   %%% Do nothing    
end
   
if isempty(LastOpenDirectory)
   [File,Path] = uiputfile('*.mat','Please save analysis results (of last movie in the analysis)','_video_data_results');
else
   [File,Path] = uiputfile('*.mat','Please save analysis results (of last movie in the analysis)',[LastOpenDirectory '_video_data_results']);
end
filenameOfSettings=[Path,File];

if iscell(filenameBehavioral) 
   filenameBehavioralForAnalysis=[filenameBehavioral{1,1},filenameBehavioral{1,MovieNum+1}];
else
   filenameBehavioralForAnalysis=filenameBehavioral; 
end
filenameOfSettings=[filenameBehavioralForAnalysis(1:end-4) '_video_data_result' '.mat'];
try
   if iscell(filenameBehavioral) 
      save(filenameOfSettings,'filenameBehavioralForAnalysis','StartingFrameForAnalysisNum','EndingFrameForAnalysisNum','LastFrameAnalyzed','ExcludedAreasList','CompartmentsPositionsList','StimuliPositionsList',...
      'MouseLocationCenterOfBody','MouseLocationCenterOfBody1','MouseLocationCenterOfBody2','TimesOfStimuliExploration','TimesInDifferentCompartments','firstFrameInTheAnalysis','TimesOfTwoMiceInteraction',...
      'LowThresholdValue', 'HighThresholdValue')
      set(HandlesForGUIControls.StatusText,'string','Analysis parameters and data were saved');
   else
      save(filenameOfSettings,'filenameBehavioral','StartingFrameForAnalysisNum','EndingFrameForAnalysisNum','ExcludedAreasList','CompartmentsPositionsList','StimuliPositionsList',...
      'MouseLocationCenterOfBody','MouseLocationCenterOfBody1','MouseLocationCenterOfBody2','TimesOfStimuliExploration','TimesInDifferentCompartments','firstFrameInTheAnalysis','TimesOfTwoMiceInteraction','LastFrameAnalyzed',...
      'LowThresholdValue','HighThresholdValue')
      set(HandlesForGUIControls.StatusText,'string','Analysis parameters and data were saved');
   end  
catch
   warndlg('Results were not saved')     
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   Results presentation panel   %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in LoadResultsFilePushButton.
function LoadResultsFilePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadResultsFilePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

if isempty(LastOpenDirectory)
   [File, Path] = uigetfile('*.mat','Please choose a results file','MultiSelect', 'off');
else
   [File, Path] = uigetfile('*.mat','Please choose a results file','MultiSelect', 'off',LastOpenDirectory); 
end
filenameOfSettings=[Path,File];
LastOpenDirectory=Path;

try
   load(filenameOfSettings);
   StartingFrameForAnalysisNumAllFiles=StartingFrameForAnalysisNum;
   ExcludedAreasListAllFiles=ExcludedAreasList;
   CompartmentsPositionsListAllFiles=CompartmentsPositionsList;
   StimuliPositionsListAllFiles=StimuliPositionsList;
   PresentMouseLocationTrace(firstFrameInTheAnalysis,HandlesForGUIControls,MouseLocationCenterOfBody,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,MouseLocationCenterOfBody1,MouseLocationCenterOfBody2);  
catch
   warndlg('Results were not loaded')    
end
% --- Executes when selected object is changed in DataToPresentUniPanel.
function DataToPresentUniPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in DataToPresentUniPanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

ExcludedAreasList={};
CompartmentsPositionsList={};
StimuliPositionsList={};

StartingFrameForAnalysisNum=StartingFrameForAnalysisNumAllFiles(1);
try
   ExcludedAreasList=ExcludedAreasListAllFiles(1,:);
catch
   %%% Do nothing    
end
try
   CompartmentsPositionsList=CompartmentsPositionsListAllFiles(1,:);
catch
   %%% Do nothing    
end
try
   StimuliPositionsList=StimuliPositionsListAllFiles(1,:);
catch
   %%% Do nothing    
end

switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'MouseLocationTraceRadioButton'
          PresentMouseLocationTrace(firstFrameInTheAnalysis,HandlesForGUIControls,MouseLocationCenterOfBody,ExcludedAreasList,CompartmentsPositionsList,StimuliPositionsList,MouseLocationCenterOfBody1,MouseLocationCenterOfBody2);  
    case 'CompartmentsOccupationAlongSessionRadioButton'
          PresentCompartmentsOccupationAlongSession(HandlesForGUIControls,TimesInDifferentCompartments,StartingFrameForAnalysisNum,LastFrameAnalyzed);
    case 'StimuliExplorationAlongSessionRadioButton'
          PresentStimuliExplorationAlongSession(HandlesForGUIControls,TimesOfStimuliExploration,StartingFrameForAnalysisNum,LastFrameAnalyzed);
    case 'TotalTimeInCompartmentsRadioButton'
          PresentTotalTimeInCompartments(HandlesForGUIControls,TimesInDifferentCompartments,StartingFrameForAnalysisNum,LastFrameAnalyzed) 
    case 'TotalStimuliExplorationTimeRadioButton'
          TotalStimuliExplorationTime(HandlesForGUIControls,TimesOfStimuliExploration,StartingFrameForAnalysisNum,LastFrameAnalyzed); 
    case 'TwoMiceInteractionAlongSessionRadioButton' 
          PresentTwoMiceInteractionAlongSession(HandlesForGUIControls,StartingFrameForAnalysisNum,LastFrameAnalyzed,TimesOfTwoMiceInteraction); 
    case 'TwoMiceInteractionTotalTimeRadioButton'
          PresentTotalTimeOfTwoMiceInteraction(HandlesForGUIControls,StartingFrameForAnalysisNum,LastFrameAnalyzed,TimesOfTwoMiceInteraction); 
    otherwise
        % Code for when there is no match.
end


% --- Executes on button press in SaveResultsFigurePushButton.
function SaveResultsFigurePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveResultsFigurePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global HandlesForGUIControls
global filenameBehavioral;
global LastOpenDirectory;
global CurrentFrameData;
global StartingFrameForAnalysisNumAllFiles;
global EndingFrameForAnalysisNumAllFiles;
global LastFrameAnalyzed;
global ExcludedAreasListAllFiles;
global CompartmentsPositionsListAllFiles;
global StimuliPositionsListAllFiles;
global StopAnalysis
global MouseLocationCenterOfBody
global TimesOfStimuliExploration
global TimesInDifferentCompartments
global TimesOfTwoMiceInteraction
global firstFrameInTheAnalysis
global MouseLocationCenterOfBody1
global MouseLocationCenterOfBody2
global LowThresholdValueAllFiles
global HighThresholdValueAllFiles
global CurrentFileAnalyzed

EPS_Format_Flag=get(HandlesForGUIControls.EPS_File_Format_RadioButton,'value');
PDF_Format_Flag=get(HandlesForGUIControls.PDF_File_Format_RadioButton,'value');

try
   if EPS_Format_Flag==1
      [File,Path] = uiputfile('*.eps','Please enter a name for saving the graph in an EPS format',LastOpenDirectory);
      filename=[Path,File]; 
      export_fig(HandlesForGUIControls.axes1, [filename '.eps']);
   elseif PDF_Format_Flag==1 
      [File,Path] = uiputfile('*.pdf','Please enter a name for saving the graph in a PDF format',LastOpenDirectory);
      filename=[Path,File]; 
      export_fig(HandlesForGUIControls.axes1, [filename '.pdf']); 
   end
catch
   warndlg('The figure was not save')     
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   Status text and graphics   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function StatusText_Callback(hObject, eventdata, handles)
% hObject    handle to StatusText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StatusText as text
%        str2double(get(hObject,'String')) returns contents of StatusText as a double


% --- Executes during object creation, after setting all properties.
function StatusText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StatusText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Dialog boxes for multiple files analysis %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function StartingFrameForAnalysisEdit2_Callback(hObject, eventdata, handles)
% hObject    handle to StartingFrameForAnalysisEdit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartingFrameForAnalysisEdit2 as text
%        str2double(get(hObject,'String')) returns contents of StartingFrameForAnalysisEdit2 as a double


% --- Executes during object creation, after setting all properties.
function StartingFrameForAnalysisEdit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartingFrameForAnalysisEdit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EndingFrameForAnalysisEdit2_Callback(hObject, eventdata, handles)
% hObject    handle to EndingFrameForAnalysisEdit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndingFrameForAnalysisEdit2 as text
%        str2double(get(hObject,'String')) returns contents of EndingFrameForAnalysisEdit2 as a double


% --- Executes during object creation, after setting all properties.
function EndingFrameForAnalysisEdit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndingFrameForAnalysisEdit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StartingFrameForAnalysisEdit3_Callback(hObject, eventdata, handles)
% hObject    handle to StartingFrameForAnalysisEdit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartingFrameForAnalysisEdit3 as text
%        str2double(get(hObject,'String')) returns contents of StartingFrameForAnalysisEdit3 as a double


% --- Executes during object creation, after setting all properties.
function StartingFrameForAnalysisEdit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartingFrameForAnalysisEdit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EndingFrameForAnalysisEdit3_Callback(hObject, eventdata, handles)
% hObject    handle to EndingFrameForAnalysisEdit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndingFrameForAnalysisEdit3 as text
%        str2double(get(hObject,'String')) returns contents of EndingFrameForAnalysisEdit3 as a double


% --- Executes during object creation, after setting all properties.
function EndingFrameForAnalysisEdit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndingFrameForAnalysisEdit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StartingFrameForAnalysisEdit4_Callback(hObject, eventdata, handles)
% hObject    handle to StartingFrameForAnalysisEdit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartingFrameForAnalysisEdit4 as text
%        str2double(get(hObject,'String')) returns contents of StartingFrameForAnalysisEdit4 as a double


% --- Executes during object creation, after setting all properties.
function StartingFrameForAnalysisEdit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartingFrameForAnalysisEdit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EndingFrameForAnalysisEdit4_Callback(hObject, eventdata, handles)
% hObject    handle to EndingFrameForAnalysisEdit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndingFrameForAnalysisEdit4 as text
%        str2double(get(hObject,'String')) returns contents of EndingFrameForAnalysisEdit4 as a double


% --- Executes during object creation, after setting all properties.
function EndingFrameForAnalysisEdit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndingFrameForAnalysisEdit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StartingFrameForAnalysisEdit5_Callback(hObject, eventdata, handles)
% hObject    handle to StartingFrameForAnalysisEdit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartingFrameForAnalysisEdit5 as text
%        str2double(get(hObject,'String')) returns contents of StartingFrameForAnalysisEdit5 as a double


% --- Executes during object creation, after setting all properties.
function StartingFrameForAnalysisEdit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartingFrameForAnalysisEdit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EndingFrameForAnalysisEdit5_Callback(hObject, eventdata, handles)
% hObject    handle to EndingFrameForAnalysisEdit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndingFrameForAnalysisEdit5 as text
%        str2double(get(hObject,'String')) returns contents of EndingFrameForAnalysisEdit5 as a double


% --- Executes during object creation, after setting all properties.
function EndingFrameForAnalysisEdit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndingFrameForAnalysisEdit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
