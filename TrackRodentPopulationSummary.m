function varargout = TrackRodentPopulationSummary(varargin)
% TRACKRODENTPOPULATIONSUMMARY MATLAB code for TrackRodentPopulationSummary.fig
%      TRACKRODENTPOPULATIONSUMMARY, by itself, creates a new TRACKRODENTPOPULATIONSUMMARY or raises the existing
%      singleton*.
%
%      H = TRACKRODENTPOPULATIONSUMMARY returns the handle to a new TRACKRODENTPOPULATIONSUMMARY or the handle to
%      the existing singleton*.
%
%      TRACKRODENTPOPULATIONSUMMARY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACKRODENTPOPULATIONSUMMARY.M with the given input arguments.
%
%      TRACKRODENTPOPULATIONSUMMARY('Property','Value',...) creates a new TRACKRODENTPOPULATIONSUMMARY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrackRodentPopulationSummary_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrackRodentPopulationSummary_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrackRodentPopulationSummary

% Last Modified by GUIDE v2.5 16-May-2019 12:15:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrackRodentPopulationSummary_OpeningFcn, ...
                   'gui_OutputFcn',  @TrackRodentPopulationSummary_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before TrackRodentPopulationSummary is made visible.
function TrackRodentPopulationSummary_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrackRodentPopulationSummary (see VARARGIN)

% Choose default command line output for TrackRodentPopulationSummary
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TrackRodentPopulationSummary wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TrackRodentPopulationSummary_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%  Global parameters  %%%%%%%%%%%%%%%%%%%%%%%%
global VideoBehavioralfileList
global VideoBehavioralpath
global LastPathChoosen
global Stimulus1Name
global Stimulus2Name

VideoBehavioralfileList=[];
VideoBehavioralpath=[];
LastPathChoosen=[];
Stimulus1Name=[];
Stimulus2Name=[];

% --- Executes on button press in ChooseVideoFilesPushbutton.
function ChooseVideoFilesPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseVideoFilesPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%  Global parameters  %%%%%%%%%%%%%%%%%%%%%%%%
global VideoBehavioralfileList
global VideoBehavioralpath
global LastPathChoosen
global Stimulus1Name
global Stimulus2Name

if isempty(LastPathChoosen) | LastPathChoosen==0
   [VideoBehavioralfileList, VideoBehavioralpath] = uigetfile('*.mat','Select analyzed video data files (from "TrackRodent" software):','MultiSelect', 'on');
   LastPathChoosen=VideoBehavioralpath;
   if ischar(VideoBehavioralfileList)
      Temp=VideoBehavioralfileList; 
      VideoBehavioralfileList={};
      VideoBehavioralfileList{1}=Temp;
   end  
else
   [VideoBehavioralfileList, VideoBehavioralpath] = uigetfile('*.mat','Select analyzed video data files (from "TrackRodent" software):','MultiSelect', 'on',LastPathChoosen);
   if ischar(VideoBehavioralfileList)
      Temp=VideoBehavioralfileList; 
      VideoBehavioralfileList={};
      VideoBehavioralfileList{1}=Temp;
   end  
   if VideoBehavioralpath~=0 
      LastPathChoosen=VideoBehavioralpath; 
   else
      VideoBehavioralfileList=[];
      VideoBehavioralpath=[]; 
   end        
end
handles.NumOfVideoFilesChosenEditBox.String=num2str(length(VideoBehavioralfileList));
handles.MainStatusTextEditBox.String='Analyzed video data files were chosen';


function NumOfVideoFilesChosenEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to NumOfVideoFilesChosenEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumOfVideoFilesChosenEditBox as text
%        str2double(get(hObject,'String')) returns contents of NumOfVideoFilesChosenEditBox as a double


% --- Executes during object creation, after setting all properties.
function NumOfVideoFilesChosenEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumOfVideoFilesChosenEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TotalNumberOfFramesToAnalyzeEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to TotalNumberOfFramesToAnalyzeEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TotalNumberOfFramesToAnalyzeEditBox as text
%        str2double(get(hObject,'String')) returns contents of TotalNumberOfFramesToAnalyzeEditBox as a double


% --- Executes during object creation, after setting all properties.
function TotalNumberOfFramesToAnalyzeEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TotalNumberOfFramesToAnalyzeEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TestNameEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to TestNameEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TestNameEditBox as text
%        str2double(get(hObject,'String')) returns contents of TestNameEditBox as a double


% --- Executes during object creation, after setting all properties.
function TestNameEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TestNameEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Stimulus1NameEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to Stimulus1NameEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Stimulus1NameEditBox as text
%        str2double(get(hObject,'String')) returns contents of Stimulus1NameEditBox as a double


% --- Executes during object creation, after setting all properties.
function Stimulus1NameEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stimulus1NameEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Stimulus2NameEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to Stimulus2NameEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Stimulus2NameEditBox as text
%        str2double(get(hObject,'String')) returns contents of Stimulus2NameEditBox as a double


% --- Executes during object creation, after setting all properties.
function Stimulus2NameEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stimulus2NameEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PopulationTotalTimeOfStimuliInvestigationCheckbox.
function PopulationTotalTimeOfStimuliInvestigationCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationTotalTimeOfStimuliInvestigationCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationTotalTimeOfStimuliInvestigationCheckbox


% --- Executes on button press in PopulationInvestigationOfStimuliAlongTimeCheckbox.
function PopulationInvestigationOfStimuliAlongTimeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationInvestigationOfStimuliAlongTimeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationInvestigationOfStimuliAlongTimeCheckbox


% --- Executes on button press in PopulationShortVsLongBoutsInvestigationTimeCheckbox.
function PopulationShortVsLongBoutsInvestigationTimeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationShortVsLongBoutsInvestigationTimeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationShortVsLongBoutsInvestigationTimeCheckbox


% --- Executes on button press in PopulationOneSecHistBoutsDurationCheckbox.
function PopulationOneSecHistBoutsDurationCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationOneSecHistBoutsDurationCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationOneSecHistBoutsDurationCheckbox


% --- Executes on button press in PopulationShortVsLongBoutsRDI_Checkbox.
function PopulationShortVsLongBoutsRDI_Checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationShortVsLongBoutsRDI_Checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationShortVsLongBoutsRDI_Checkbox


% --- Executes on button press in PopulationBoutsLessThen6SecAlongTimeCheckbox.
function PopulationBoutsLessThen6SecAlongTimeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationBoutsLessThen6SecAlongTimeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationBoutsLessThen6SecAlongTimeCheckbox


% --- Executes on button press in PopulationBouts6to19secAlongTimeCheckbox.
function PopulationBouts6to19secAlongTimeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationBouts6to19secAlongTimeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationBouts6to19secAlongTimeCheckbox


% --- Executes on button press in PopulationBoutsMoreThen19SecAlongTimeCheckbox.
function PopulationBoutsMoreThen19SecAlongTimeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationBoutsMoreThen19SecAlongTimeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationBoutsMoreThen19SecAlongTimeCheckbox


% --- Executes on button press in PopulationChamberMeanBoutLength_Checkbox.
function PopulationChamberMeanBoutLength_Checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationChamberMeanBoutLength_Checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationChamberMeanBoutLength_Checkbox


% --- Executes on button press in PopulationShortVsLongIntervalsTotalTimeCheckbox.
function PopulationShortVsLongIntervalsTotalTimeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationShortVsLongIntervalsTotalTimeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationShortVsLongIntervalsTotalTimeCheckbox


% --- Executes on button press in PopulationOneSecHistIntervalsEachStimulusCheckbox.
function PopulationOneSecHistIntervalsEachStimulusCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationOneSecHistIntervalsEachStimulusCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationOneSecHistIntervalsEachStimulusCheckbox


% --- Executes on button press in PopulationOneSecHistIntervalsTwoStimuliCheckbox.
function PopulationOneSecHistIntervalsTwoStimuliCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationOneSecHistIntervalsTwoStimuliCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationOneSecHistIntervalsTwoStimuliCheckbox


% --- Executes on button press in PopulationShortVsLongIntervalsRDICheckbox.
function PopulationShortVsLongIntervalsRDICheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationShortVsLongIntervalsRDICheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationShortVsLongIntervalsRDICheckbox


% --- Executes on button press in PopulationIntervalsLessThen5SecAlongTimeCheckbox.
function PopulationIntervalsLessThen5SecAlongTimeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationIntervalsLessThen5SecAlongTimeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationIntervalsLessThen5SecAlongTimeCheckbox


% --- Executes on button press in PopulationIntervals5to20SecAlongTimeCheckbox.
function PopulationIntervals5to20SecAlongTimeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationIntervals5to20SecAlongTimeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationIntervals5to20SecAlongTimeCheckbox


% --- Executes on button press in PopulationIntervalsMoreThen20SecAlongTimeCheckbox.
function PopulationIntervalsMoreThen20SecAlongTimeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationIntervalsMoreThen20SecAlongTimeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationIntervalsMoreThen20SecAlongTimeCheckbox


% --- Executes on button press in TransitionsBetweenStimuliRasterCheckbox.
function TransitionsBetweenStimuliRasterCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to TransitionsBetweenStimuliRasterCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TransitionsBetweenStimuliRasterCheckbox


% --- Executes on button press in TransitionsAlongTime1MinbinCheckbox.
function TransitionsAlongTime1MinbinCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to TransitionsAlongTime1MinbinCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TransitionsAlongTime1MinbinCheckbox


% --- Executes on button press in PopulationHeatMapInteractionDurationCheckbox.
function PopulationHeatMapInteractionDurationCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationHeatMapInteractionDurationCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PopulationHeatMapInteractionDurationCheckbox


% --- Executes on button press in ExportToExcelPopVideoChamberAloneCheckbox.
function ExportToExcelPopVideoChamberAloneCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to ExportToExcelPopVideoChamberAloneCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ExportToExcelPopVideoChamberAloneCheckbox


% --- Executes on button press in StartPushbutton.
function StartPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to StartPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%  Global parameters  %%%%%%%%%%%%%%%%%%%%%%%%
global VideoBehavioralfileList
global VideoBehavioralpath
global LastPathChoosen
global Stimulus1Name
global Stimulus2Name

PopulationChambersVideoAnalysis_16052019(VideoBehavioralpath,VideoBehavioralfileList,handles)

function MainStatusTextEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to MainStatusTextEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MainStatusTextEditBox as text
%        str2double(get(hObject,'String')) returns contents of MainStatusTextEditBox as a double


% --- Executes during object creation, after setting all properties.
function MainStatusTextEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MainStatusTextEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
