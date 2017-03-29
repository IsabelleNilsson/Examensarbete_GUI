function varargout = SimpleOptimizedTabs2(varargin)
%{
    
    HOW TO CREATE A NEW TAB

    1. Create or copy PANEL and TEXT objects in GUI

    2. Rename tag of PANEL to "tabNPanel" and TEXT for "tabNtext", where N
    - is a sequential number. 
    Example: tab3Panel, tab3text, tab4Panel, tab4text etc.
    
    3. Add to Tab Code - Settings in m-file of GUI a name of the tab to
    TabNames variable

    Version: 1.0
    First created: January 18, 2016
    Last modified: January 18, 2016

    Author: WFAToolbox (http://wfatoolbox.com)

%}

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SimpleOptimizedTabs2_OpeningFcn, ...
                   'gui_OutputFcn',  @SimpleOptimizedTabs2_OutputFcn, ...
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


% --- Executes just before SimpleOptimizedTabs2 is made visible.
function SimpleOptimizedTabs2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SimpleOptimizedTabs2 (see VARARGIN)

% Choose default command line output for SimpleOptimizedTabs2
handles.output = hObject;

%% Tabs Code
% Settings
TabFontSize = 8;
TabNames = {'Floor 4','Floor 3','Energy'};
FigWidth = 0.5;

% Figure resize
set(handles.SimpleOptimizedTab,'Units','normalized')
pos = get(handles. SimpleOptimizedTab, 'Position');
set(handles. SimpleOptimizedTab, 'Position', [pos(1) pos(2) FigWidth pos(4)])

% Tabs Execution
handles = TabsFun(handles,TabFontSize,TabNames);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SimpleOptimizedTabs2 wait for user response (see UIRESUME)
% uiwait(handles.SimpleOptimizedTab);

% --- TabsFun creates axes and text objects for tabs
function handles = TabsFun(handles,TabFontSize,TabNames)

% Set the colors indicating a selected/unselected tab
handles.selectedTabColor=get(handles.tab1Panel,'BackgroundColor');
handles.unselectedTabColor=handles.selectedTabColor-0.1;

% Create Tabs
TabsNumber = length(TabNames);
handles.TabsNumber = TabsNumber;
TabColor = handles.selectedTabColor;
for i = 1:TabsNumber
    n = num2str(i);
    
    % Get text objects position
    set(handles.(['tab',n,'text']),'Units','normalized')
    pos=get(handles.(['tab',n,'text']),'Position');

    % Create axes with callback function
    handles.(['a',n]) = axes('Units','normalized',...
                    'Box','on',...
                    'XTick',[],...
                    'YTick',[],...
                    'Color',TabColor,...
                    'Position',[pos(1) pos(2) pos(3) pos(4)+0.01],...
                    'Tag',n,...
                    'ButtonDownFcn',[mfilename,'(''ClickOnTab'',gcbo,[],guidata(gcbo))']);
                    
    % Create text with callback function
    handles.(['t',n]) = text('String',TabNames{i},...
                    'Units','normalized',...
                    'Position',[pos(3),pos(2)/2+pos(4)],...
                    'HorizontalAlignment','left',...
                    'VerticalAlignment','middle',...
                    'Margin',0.001,...
                    'FontSize',TabFontSize,...
                    'Backgroundcolor',TabColor,...
                    'Tag',n,...
                    'ButtonDownFcn',[mfilename,'(''ClickOnTab'',gcbo,[],guidata(gcbo))']);

    TabColor = handles.unselectedTabColor;
end
            
% Manage panels (place them in the correct position and manage visibilities)
set(handles.tab1Panel,'Units','normalized')
pan1pos=get(handles.tab1Panel,'Position');
set(handles.tab1text,'Visible','off')

%set(handles.tab2Panel,'Units','normalized')
%pan2pos=get(handles.tab2Panel,'Position');
%set(handles.tab2text,'Visible','off')

%set(handles.axes3,'Visible','on')


for i = 2:TabsNumber
    n = num2str(i);
    set(handles.(['tab',n,'Panel']),'Units','normalized')
    set(handles.(['tab',n,'Panel']),'Position',pan1pos)
    set(handles.(['tab',n,'Panel']),'Visible','off')
    set(handles.(['tab',n,'text']),'Visible','off')
end

% --- Callback function for clicking on tab
function ClickOnTab(hObject,~,handles)
m = str2double(get(hObject,'Tag'));

for i = 1:handles.TabsNumber;
    n = num2str(i);
    if i == m
        set(handles.(['a',n]),'Color',handles.selectedTabColor)
        set(handles.(['t',n]),'BackgroundColor',handles.selectedTabColor)
        set(handles.(['tab',n,'Panel']),'Visible','on') 
        
        % ------- Picture in the background (not working yet)---------------------
       % panhandle = uipanel(handles.tab1Panel);
       % panax = axes('Units','normal','DataAspectRatioMode','auto', 'Parent', panhandle);
       % imhandle = imshow('fourth_floor.PNG', 'Parent', panax);
        
    else
        set(handles.(['a',n]),'Color',handles.unselectedTabColor)
        set(handles.(['t',n]),'BackgroundColor',handles.unselectedTabColor)
        set(handles.(['tab',n,'Panel']),'Visible','off')
    end
end

% --- Outputs from this function are returned to the command line.
function varargout = SimpleOptimizedTabs2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%--------------- FROM HERE ADDITIONAL BOTTONS ARE ADDED--------------------


%--------------------------------------------------
%------------- start/stop simulink ----------------
%--------------------------------------------------

%---------- Open simulink model if not opened ------
   if bdIsLoaded('House_model')
       fprintf('open and ready')   
   elseif ~bdIsLoaded('House_model')
       open_system('House_model')
   end
   
%---------------- initiation  -----------------
%------------ Set default values --------------

 % phones charging F4
 set(handles.Phones_charging_slider, 'Value', 0);
 numSteps_phone = 25;
 set(handles.Phones_charging_slider, 'Min', 0);
 set(handles.Phones_charging_slider, 'Max', numSteps_phone);
 set(handles.Phones_charging_slider, 'SliderStep', [1/(numSteps_phone) , 2/(numSteps_phone) ]);
 
 % laptops charging F4
 set(handles.Laptops_charging_slider, 'Value', 0);
 numSteps_laptops = 15;
 set(handles.Laptops_charging_slider, 'Min', 0);
 set(handles.Laptops_charging_slider, 'Max', numSteps_laptops);
 set(handles.Laptops_charging_slider, 'SliderStep', [1/(numSteps_laptops) , 2/(numSteps_laptops) ]);
 
 
% ---------------- Run simulinkmodel -------------------
function Start_Stop_toggle_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
    if button_state == get(hObject,'Max')
        %-------- Start simulation ------------
        set_param('House_model','SimulationCommand','start');
        set(handles.Start_Stop_toggle,'BackgroundColor','green');
    elseif button_state == get(hObject,'Min')
        set_param('House_model','SimulationCommand','stop');
        set(handles.Start_Stop_toggle,'BackgroundColor',[0.94 0.94 0.94]);
    end

%**********************************************
%*************** FLOOR 4 **********************
%**********************************************


%---------------- Bulbs ----------------------

% bulb max 7 Watt, energy/day 0.28 kW total 
% flourecent max 36 Watt

% --- Executes on button press in F4_Bulb_radio_1.
function F4_Bulb_radio_1_Callback(hObject, eventdata, handles)
% hObject    handle to F4_Bulb_radio_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of F4_Bulb_radio_1
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Bulb_radio_1,'BackgroundColor','green');
    F4_bulb_1 = 7; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Bulb_radio_1,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_1 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_1','Value', num2str(F4_bulb_1));

% --- Executes on button press in F4_Bulb_radio_2.
function F4_Bulb_radio_2_Callback(hObject, eventdata, handles)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Bulb_radio_2,'BackgroundColor','green');
    F4_bulb_2 = 7; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Bulb_radio_2,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_2 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_2','Value', num2str(F4_bulb_2));

% --- Executes on button press in F4_Bulb_radio_3.
function F4_Bulb_radio_3_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Bulb_radio_3,'BackgroundColor','green');
    F4_bulb_3 = 7; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Bulb_radio_3,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_3 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_3','Value', num2str(F4_bulb_3));

function F4_Bulb_radio_4_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Bulb_radio_4,'BackgroundColor','green');
    F4_bulb_4 = 7; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Bulb_radio_4,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_4 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_4','Value', num2str(F4_bulb_4));

function F4_Bulb_radio_5_Callback(hObject, eventdata, handles)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Bulb_radio_5,'BackgroundColor','green');
    F4_bulb_5 = 7; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Bulb_radio_5,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_5 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_5','Value', num2str(F4_bulb_5));

function F4_Bulb_radio_6_Callback(hObject, eventdata, handles)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Bulb_radio_6,'BackgroundColor','green');
    F4_bulb_6 = 7; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Bulb_radio_6,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_6 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_6','Value', num2str(F4_bulb_6));

function F4_Bulb_radio_7_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Bulb_radio_7,'BackgroundColor','green');
    F4_bulb_7 = 7; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Bulb_radio_7,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_7 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_7','Value', num2str(F4_bulb_7));

function F4_Bulb_radio_8_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Bulb_radio_8,'BackgroundColor','green');
    F4_bulb_8 = 7; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Bulb_radio_8,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_8 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_8','Value', num2str(F4_bulb_8));


%-------------------- Accesspoint ----------------------

% --- Executes on button press in F4_Accesspoint_radio.
function F4_Accesspoint_radio_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Accesspoint_radio,'BackgroundColor','green');
    F4_Accesspoint = 6.5; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Accesspoint_radio,'BackgroundColor',[0.94 0.94 0.94]);
    F4_Accesspoint = 0; % watt
end
set_param('House_model/Floor_4/Accesspoint/F4_Accesspoint','Value', num2str(F4_Accesspoint));

%---------------- FLOURECENTS ----------------------
function F4_Fluorscent_toggle_1_Callback(hObject, eventdata, handles)
% hObject    handle to F4_Fluorscent_toggle_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Fluorscent_toggle_1,'BackgroundColor','green');
    F4_flourecent_1 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Fluorscent_toggle_1,'BackgroundColor',[0.94 0.94 0.94]);
    F4_flourecent_1 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_flourecent_1','Value', num2str(F4_flourecent_1));

function F4_Fluorscent_toggle_2_Callback(hObject, eventdata, handles)
% hObject    handle to F4_Fluorscent_toggle_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Fluorscent_toggle_2,'BackgroundColor','green');
    F4_flourecent_2 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Fluorscent_toggle_2,'BackgroundColor',[0.94 0.94 0.94]);
    F4_flourecent_2 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_flourecent_2','Value', num2str(F4_flourecent_2));

function F4_Fluorscent_toggle_3_Callback(hObject, eventdata, handles)
% hObject    handle to F4_Fluorscent_toggle_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%wn=2;
%sys = tf(wn^2,[1,2*wn,wn^2]);
%sys = wn^2;
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Fluorscent_toggle_3,'BackgroundColor','green');
    F4_flourecent_3 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Fluorscent_toggle_3,'BackgroundColor',[0.94 0.94 0.94]);
    F4_flourecent_3 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_flourecent_3','Value', num2str(F4_flourecent_3));
%plot(ScopeData.time,ScopeData.signals.values)
% f = figure;
% ax = axes('Parent',f,'position',[0.13 0.39  0.77 0.54]);
% h = plot(ax,sys);
% setoptions(h,'XLim',[0,10],'YLim',[0,2]);
%b.Callback = @(es,ed) updateSystem(h,wn^2*2*(es.Value)*wn);
% zeta = .5;                           % Damping Ratio
% wn = 2;                              % Natural Frequency
% sys = tf(wn^2,[1,2*zeta*wn,wn^2]);
% f = figure;
% ax = axes('Parent',f,'position',[0.13 0.39  0.77 0.54]);
% h = stepplot(ax,sys);
%
% setoptions(h,'XLim',[0,10],'YLim',[0,2]);
%b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
%              'value',zeta, 'min',0, 'max',1);
%b.Callback = @(es,ed) updateSystem(h,tf(wn^2,[1,2*(es.Value)*wn,wn^2]));


function F4_Fluorscent_toggle_4_Callback(hObject, eventdata, handles)
% hObject    handle to F4_Fluorscent_toggle_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of togglebutton1
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Fluorscent_toggle_4,'BackgroundColor','green');
    F4_flourecent_4 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Fluorscent_toggle_4,'BackgroundColor',[0.94 0.94 0.94]);
    F4_flourecent_4 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_flourecent_4','Value', num2str(F4_flourecent_4));

function F4_Fluorscent_toggle_5_Callback(hObject, eventdata, handles)
% hObject    handle to F4_Fluorscent_toggle_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Fluorscent_toggle_5,'BackgroundColor','green');
    F4_flourecent_5 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Fluorscent_toggle_5,'BackgroundColor',[0.94 0.94 0.94]);
    F4_flourecent_5 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_flourecent_5','Value', num2str(F4_flourecent_5));

function F4_Fluorscent_toggle_6_Callback(hObject, eventdata, handles)
% hObject    handle to F4_Fluorscent_toggle_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Fluorscent_toggle_6,'BackgroundColor','green');
    F4_flourecent_6 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Fluorscent_toggle_6,'BackgroundColor',[0.94 0.94 0.94]);
    F4_flourecent_6 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_flourecent_6','Value', num2str(F4_flourecent_6));

function F4_MaxEffect_toggle_7_Callback(hObject, eventdata, handles)
% hObject    handle to F4_MaxEffect_toggle_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

F4_Fluorscent_toggle_1_Callback(hObject, eventdata, handles);
F4_Fluorscent_toggle_2_Callback(hObject, eventdata, handles);
F4_Fluorscent_toggle_3_Callback(hObject, eventdata, handles);
F4_Fluorscent_toggle_4_Callback(hObject, eventdata, handles);
F4_Fluorscent_toggle_5_Callback(hObject, eventdata, handles);
F4_Fluorscent_toggle_6_Callback(hObject, eventdata, handles);
F4_Bulb_radio_1_Callback(hObject, eventdata, handles);

%----------------- OUTLET ---------------------------

% --- Executes on slider movement.
function Phones_charging_slider_Callback(hObject, eventdata, handles)
% hObject    handle to Phones_charging_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%  value = round(get(hObject,'Value'))
%     if value == 0 

 Phones_Charging = round(get(hObject,'Value'))
 
 
% --- Executes during object creation, after setting all properties.
function Phones_charging_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Phones_charging_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Laptops_charging_slider_Callback(hObject, eventdata, handles)
% hObject    handle to Laptops_charging_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Laptops_Charging = round(get(hObject,'Value'))
% -------------- x hur lång tid det har gått eller antal timmar....
% energy= nr * watt * time
energy_consumption = Laptops_Charging*45;

% --- Executes during object creation, after setting all properties.
function Laptops_charging_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Laptops_charging_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Phones_charging_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Phones_charging_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of Phones_charging_edit as text
%        str2double(get(hObject,'String')) returns contents of Phones_charging_edit as a double

% --- Executes during object creation, after setting all properties.
function Phones_charging_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Phones_charging_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Laptops_charging_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Laptops_charging_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of Laptops_charging_edit as text
%        str2double(get(hObject,'String')) returns contents of Laptops_charging_edit as a double


% --- Executes during object creation, after setting all properties.
function Laptops_charging_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Laptops_charging_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%**********************************************
%*************** FLOOR 3 **********************
%**********************************************

%---------------- Flourcent ----------------------

function F3_Fluorscent_toggle_1_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorscent_toggle_1,'BackgroundColor','green');
    F3_flourecent_1 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorscent_toggle_1,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourecent_1 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourecent_1','Value', num2str(F3_flourecent_1));

function F3_Fluorscent_toggle_2_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorscent_toggle_2,'BackgroundColor','green');
    F3_flourecent_2 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorscent_toggle_2,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourecent_2 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourecent_2','Value', num2str(F3_flourecent_2));

function F3_Fluorscent_toggle_3_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorscent_toggle_3,'BackgroundColor','green');
    F3_flourecent_3 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorscent_toggle_3,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourecent_3 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourecent_3','Value', num2str(F3_flourecent_3));

function F3_Fluorscent_toggle_4_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorscent_toggle_4,'BackgroundColor','green');
    F3_flourecent_4 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorscent_toggle_4,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourecent_4 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourecent_4','Value', num2str(F3_flourecent_4));

function F3_Fluorscent_toggle_5_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorscent_toggle_5,'BackgroundColor','green');
    F3_flourecent_5 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorscent_toggle_5,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourecent_5 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourecent_5','Value', num2str(F3_flourecent_5));

function F3_Fluorscent_toggle_6_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorscent_toggle_6,'BackgroundColor','green');
    F3_flourecent_6 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorscent_toggle_6,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourecent_6 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourecent_6','Value', num2str(F3_flourecent_6));

function F3_Fluorscent_toggle_7_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorscent_toggle_7,'BackgroundColor','green');
    F3_flourecent_7 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorscent_toggle_7,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourecent_7 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourecent_7','Value', num2str(F3_flourecent_7));

function F3_Fluorscent_toggle_8_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorscent_toggle_8,'BackgroundColor','green');
    F3_flourecent_8 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorscent_toggle_8,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourecent_8 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourecent_8','Value', num2str(F3_flourecent_8));

function F3_Fluorscent_toggle_9_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorscent_toggle_9,'BackgroundColor','green');
    F3_flourecent_9 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorscent_toggle_9,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourecent_9 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourecent_9','Value', num2str(F3_flourecent_9));

function F3_Fluorscent_toggle_10_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorscent_toggle_10,'BackgroundColor','green');
    F3_flourecent_10 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorscent_toggle_10,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourecent_10 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourecent_10','Value', num2str(F3_flourecent_10));

function F3_Accesspoint_radio_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Accesspoint_radio,'BackgroundColor','green');
    F3_Accesspoint = 6.5; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Accesspoint_radio,'BackgroundColor',[0.94 0.94 0.94]);
    F3_Accesspoint = 0; % watt
end
set_param('House_model/Floor_3/Accesspoint/F3_Accesspoint','Value', num2str(F3_Accesspoint));


%-----------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Plot, Tab 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes4
%rto = get_param(gcb,'RuntimeObject');
%blk = 'House_model/F4_bulb';
%event = 'PostOutputs';
%listener = 
%h = add_exec_event_listener(blk,event,listener)
%BlockTypes = get_param(BlockPaths,'BlockType')
%BlockTypes = get_param(House_model/F4_bulb,'Scope')
%rto = get_param(gcb,'simout');
