function varargout = VISTK(varargin)
% VISTK M-file for VISTK.fig
%      VISTK, by itself, creates a new VISTK or raises the existing
%      singleton*.
%
%      H = VISTK returns the handle to a new VISTK or the handle to
%      the existing singleton*.
%
%      VISTK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISTK.M with the given input arguments.
%
%      VISTK('Property','Value',...) creates a new VISTK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VISTK_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VISTK_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VISTK

% Last Modified by GUIDE v2.5 14-Feb-2011 11:04:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VISTK_OpeningFcn, ...
                   'gui_OutputFcn',  @VISTK_OutputFcn, ...
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
end

% --- Executes just before VISTK is made visible.
function VISTK_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VISTK (see VARARGIN)

    % Choose default command line output for VISTK
    handles.output = hObject;

    % set the input data to the argument
    % should check if it is an actual stack
    handles.vRawStack = varargin{1};

    % set the limits on the slice slider
    set(handles.sliderSliceNumber, 'Max', size(handles.vRawStack, 3));
    set(handles.sliderSliceNumber, 'Min', 1);
    set(handles.sliderSliceNumber, 'SliderStep', [1/size(handles.vRawStack, 3), ...
        10/size(handles.vRawStack, 3)]);
    set(handles.lblSliceNumber, 'String', sprintf('Slice %i of %i', 1, size(handles.vRawStack, 3)));
    % set the limits on the threshold slider
    set(handles.sliderThresholdLevel, 'Min', min(handles.vRawStack(:)));
    set(handles.sliderThresholdLevel, 'Max', max(handles.vRawStack(:)));
    set(handles.sliderThresholdLevel, 'Value', min(handles.vRawStack(:)));
    range = max(handles.vRawStack(:)) - min(handles.vRawStack(:));
    set(handles.sliderThresholdLevel, 'SliderStep', [0.01 0.1]);
    % Update handles structure
    guidata(hObject, handles);

% UIWAIT makes VISTK wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end

% --- Outputs from this function are returned to the command line.
function varargout = VISTK_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;
end

% --- Executes on slider movement.
function sliderSliceNumber_Callback(hObject, eventdata, handles)
% hObject    handle to sliderSliceNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    slice = round(get(hObject, 'Value'));
    set(hObject, 'Value', slice);
    dindex = GetCurrentDimensionIndex(handles); 
    set(handles.lblSliceNumber, 'String', sprintf('Slice %i of %i', slice, size(handles.vRawStack, dindex)));

    Render(handles, false);
end

% --- Executes during object creation, after setting all properties.
function sliderSliceNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderSliceNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

end

function txtControlFigure_Callback(hObject, eventdata, handles)
% hObject    handle to txtControlFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtControlFigure as text
%        str2double(get(hObject,'String')) returns contents of txtControlFigure as a double
    id = int(get(hObject, 'String'));
    handles.hFig = figure(id);
    Render(handles, true);
end

% --- Executes during object creation, after setting all properties.
function txtControlFigure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtControlFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in btnNewFigure.
function btnNewFigure_Callback(hObject, eventdata, handles)
% hObject    handle to btnNewFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.hFig = figure;
    set(handles.txtControlFigure, 'String', sprintf('%i', handles.hFig));
    Render(handles, true);
    guidata(hObject, handles);
end

% --- Executes on selection change in popupColormap.
function popupColormap_Callback(hObject, eventdata, handles)
% hObject    handle to popupColormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    Render(handles, true);

% Hints: contents = cellstr(get(hObject,'String')) returns popupColormap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupColormap
end

% --- Executes during object creation, after setting all properties.
function popupColormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupColormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in btnRedraw.
function btnRedraw_Callback(hObject, eventdata, handles)
% hObject    handle to btnRedraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Render(handles, true);
end
% --- Executes on button press in btnSnap.
function btnSnap_Callback(hObject, eventdata, handles)
% hObject    handle to btnSnap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    current_fig = handles.hFig;
    handles.hFig = figure;
    Render(handles, true);
    handles.hFig = current_fig;
    guidata(hObject, handles);
end


function txtMaxProjectFrames_Callback(hObject, eventdata, handles)
% hObject    handle to txtMaxProjectFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    Render(handles, false);

% Hints: get(hObject,'String') returns contents of txtMaxProjectFrames as text
%        str2double(get(hObject,'String')) returns contents of txtMaxProjectFrames as a double
end

% --- Executes during object creation, after setting all properties.
function txtMaxProjectFrames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtMaxProjectFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in checkboxThreshold.
function checkboxThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Render(handles, false);
% Hint: get(hObject,'Value') returns toggle state of checkboxThreshold
end

% --- Executes on button press in btnApplyThreshold.
function btnApplyThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to btnApplyThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    ws_variable = inputdlg('Export result to workspace variable:', 'Apply Threshold');
    thresh = get(handles.sliderThresholdLevel, 'Value');
    val = handles.vRawStack > thresh;
    assignin('base', char(ws_variable), val);
end

% --- Executes on slider movement.
function sliderThresholdLevel_Callback(hObject, eventdata, handles)
% hObject    handle to sliderThresholdLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    enableThresh = get(handles.checkboxThreshold, 'Value');
    if(enableThresh)
        Render(handles, false);
    end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
end

% --- Executes during object creation, after setting all properties.
function sliderThresholdLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderThresholdLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

function Render(handles, firstTime)
    slice = round(get(handles.sliderSliceNumber, 'Value'));
    mpf = round(str2num(get(handles.txtMaxProjectFrames, 'String')));
    
    xy = get(handles.radioXY, 'Value');
    xz = get(handles.radioXZ, 'Value');
    yz = get(handles.radioYZ, 'Value');
    
    enableThresh = get(handles.checkboxThreshold, 'Value');
    thresh = get(handles.sliderThresholdLevel, 'Value');
    
    if(enableThresh)
        if(xy)
            projection = 'xy';
            minidx = max(1, slice - mpf);
            maxidx = min(size(handles.vRawStack, 3), slice + mpf);
            plane = 255*max( handles.vRawStack(:,:,minidx:maxidx) > thresh, [], 3 );
        elseif(xz)
            projection = 'xz';
            minidx = max(1, slice - mpf);
            maxidx = min(size(handles.vRawStack, 2), slice + mpf);
            plane = 255*transpose(squeeze(max(handles.vRawStack(:,minidx:maxidx, :) > thresh, [], 2)));
        elseif(yz)
            projection = 'yz';
            minidx = max(1, slice - mpf);
            maxidx = min(size(handles.vRawStack, 1), slice + mpf);
            plane = 255*transpose(squeeze(max(handles.vRawStack(minidx:maxidx, :, :) > thresh, [], 1)));
        else
            projection ='xy';
            plane = 0;
        end
    else
        if(xy)
            projection = 'xy';
            minidx = max(1, slice - mpf);
            maxidx = min(size(handles.vRawStack, 3), slice + mpf);
            plane = max( handles.vRawStack(:,:,minidx:maxidx), [], 3 );
        elseif(xz)
            projection = 'xz';
            minidx = max(1, slice - mpf);
            maxidx = min(size(handles.vRawStack, 2), slice + mpf);
            plane = transpose(squeeze(max(handles.vRawStack(:,minidx:maxidx, :), [], 2)));
        elseif(yz)
            projection = 'yz';
            minidx = max(1, slice - mpf);
            maxidx = min(size(handles.vRawStack, 1), slice + mpf);
            plane = transpose(squeeze(max(handles.vRawStack(minidx:maxidx, :, :), [], 1)));
        else
            projection ='xy';
            plane = 0;
        end
    end
    
    
    cmapidx = get(handles.popupColormap, 'Value');
    cmaps = get(handles.popupColormap, 'String');
    cmap = cmaps{cmapidx};
    
    if(enableThresh)
        range = [0 255];
    else
        range = [min(handles.vRawStack(:)) max(handles.vRawStack(:))];
    end
    
    if(firstTime)
        VISTKRenderFunction(handles.hFig, plane, 'Projection', projection, ...
            'ColorMap', cmap, 'ColorRange', range, 'Slice', slice, ...
            'FullUpdate', true)
    else
        VISTKRenderFunction(handles.hFig, plane, 'Projection', projection, ...
            'ColorMap', cmap, 'ColorRange', range, 'Slice', slice)
    end
    
end


% --- Executes when selected object is changed in panelProjection.
function panelProjection_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panelProjection 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
    % set the limits on the slice slider
    
    ResetSliceSlider(handles);
    sliderSliceNumber_Callback(handles.sliderSliceNumber, eventdata, handles);
end

function ResetSliceSlider(handles)
    dindex = GetCurrentDimensionIndex(handles);
    set(handles.sliderSliceNumber, 'Max', size(handles.vRawStack, dindex));
    set(handles.sliderSliceNumber, 'Min', 1);
    set(handles.sliderSliceNumber, 'SliderStep', [1/size(handles.vRawStack, dindex), ...
        10/size(handles.vRawStack, dindex)]);
    set(handles.sliderSliceNumber, 'Value', 1);
    set(handles.lblSliceNumber, 'String', sprintf('Slice %i of %i', 1, size(handles.vRawStack, dindex)));
end

function dindex = GetCurrentDimensionIndex(handles)
    xy = get(handles.radioXY, 'Value');
    xz = get(handles.radioXZ, 'Value');
    yz = get(handles.radioYZ, 'Value');
    
    if(xy)
        dindex = 3;
    elseif(xz)
        dindex = 2;
    elseif(yz)
        dindex = 1;
    end
end