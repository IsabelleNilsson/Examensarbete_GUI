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
TabNames = {'Floor 4','Floor 3','Floor 2','Floor 1','Energy'};
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

for i = 1:handles.TabsNumber
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
        
        % reset value in GUI
        set(findobj('style','pushbutton'), 'Value', 0);
        set(findobj('style','checkbox'), 'Value', 0);
        set(findobj('style','radiobutton'), 'Value', 0);
        set(findobj('style','togglebutton'), 'Value', 0);
        set(findobj('style','togglebutton'), 'BackgroundColor',[0.94 0.94 0.94]);
        set(findobj('style','Slider'), 'Value', 0);
        set(findobj('style','edit'), 'String', {'0'});
        
        % reset value in Simulink (Constant blocks)
        block_name = find_system('House_model', 'BlockType', 'Constant');
        n=length(block_name);
        for i=1:1:n
            set_param(block_name{i,1},'Value','0') 
        end

 
 %--- phones charging F4 ---
 set(handles.Phones_charging_slider, 'value', 0);
 set(handles.Phones_charging_edit,'String', '0');
 numSteps_phone = 15;
 set(handles.Phones_charging_slider, 'Min', 0);
 set(handles.Phones_charging_slider, 'Max', numSteps_phone);
 set(handles.Phones_charging_slider, 'SliderStep', [1/(numSteps_phone) , 2/(numSteps_phone) ]);
 %sliderValuePhones = get(handles.Phones_charging_slider, 'Value') % example
 
 % laptops charging F4
 set(handles.Laptops_charging_slider, 'Value', 0);
 set(handles.Laptops_charging_edit,'String', '0');
 numSteps_laptops = 25;
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
        % reset GUI
        set(findobj('style','pushbutton'), 'Value', 0);
        set(findobj('style','checkbox'), 'Value', 0);
        set(findobj('style','togglebutton'), 'Value', 0);
        set(findobj('style','radiobutton'), 'Value', 0);
        set(findobj('style','togglebutton'), 'BackgroundColor',[0.94 0.94 0.94]);
        set(findobj('style','togglebutton'), 'Value', 0);
        set(findobj('style','edit'), 'String', {'0'});
        set(findobj('style','Slider'), 'Value', 0);
        
        % reset Simulink (Constant blocks)
        block_name = find_system('House_model', 'BlockType', 'Constant');
        n=length(block_name);
        for i=1:1:n
            set_param(block_name{i,1},'Value','0') %% Changing ‘Value’ of all the ‘Constant’ blocks to 0
        end
        
        
        set_param('House_model','SimulationCommand','stop');
        %plot(ScopeData.time, ScopeData.signals.values)
        %funkar inte nu eftersom värdena inte kommit in än tror jag* 
% ------------ Continue here ------------------------
        plot(F4_E.time, F4_E.signals.values)
        set(handles.Start_Stop_toggle,'BackgroundColor',[0.94 0.94 0.94]);
    end

%**********************************************
%*************** FLOOR 4 **********************
%**********************************************


%---------------- Bulbs ----------------------

% bulb max 7 Watt, energy/day 0.28 kW total 
% flourecent max 36 Watt

%not working?? nr 1


% --- Executes on button press in F4_Bulb_radio_1.
function F4_Bulb_radio_1_Callback(hObject, eventdata, handles)
% hObject    handle to F4_Bulb_radio_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of F4_Bulb_radio_1
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %set(handles.F4_Bulb_radio_1,'BackgroundColor','green');
    F4_bulb_1 = 7; % watt
elseif button_state == get(hObject,'Min')
    %set(handles.F4_Bulb_radio_1,'BackgroundColor',[0.94 0.94 0.94]);
     F4_bulb_1 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_1','Value', num2str(F4_bulb_1));

% --- Executes on button press in F4_Bulb_radio_2.
function F4_Bulb_radio_2_Callback(hObject, eventdata, handles)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %set(handles.F4_Bulb_radio_2,'BackgroundColor','green');
    F4_bulb_2 = 7; % watt
elseif button_state == get(hObject,'Min')
    %set(handles.F4_Bulb_radio_2,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_2 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_2','Value', num2str(F4_bulb_2));

% --- Executes on button press in F4_Bulb_radio_3.
function F4_Bulb_radio_3_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %set(handles.F4_Bulb_radio_3,'BackgroundColor','green');
    F4_bulb_3 = 7; % watt
elseif button_state == get(hObject,'Min')
    %set(handles.F4_Bulb_radio_3,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_3 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_3','Value', num2str(F4_bulb_3));


function F4_Bulb_radio_4_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %set(handles.F4_Bulb_radio_4,'BackgroundColor','green');
    F4_bulb_4 = 7; % watt
elseif button_state == get(hObject,'Min')
    %set(handles.F4_Bulb_radio_4,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_4 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_4','Value', num2str(F4_bulb_4));


function F4_Bulb_radio_5_Callback(hObject, eventdata, handles)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %set(handles.F4_Bulb_radio_5,'BackgroundColor','green');
    F4_bulb_5 = 7; % watt
elseif button_state == get(hObject,'Min')
    %set(handles.F4_Bulb_radio_5,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_5 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_5','Value', num2str(F4_bulb_5));


function F4_Bulb_radio_6_Callback(hObject, eventdata, handles)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %set(handles.F4_Bulb_radio_6,'BackgroundColor','green');
    F4_bulb_6 = 7; % watt
elseif button_state == get(hObject,'Min')
    %set(handles.F4_Bulb_radio_6,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_6 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_6','Value', num2str(F4_bulb_6));


function F4_Bulb_radio_7_Callback(hObject, eventdata, handles)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %set(handles.F4_Bulb_radio_7,'BackgroundColor','green');
    F4_bulb_7 = 7; % watt
elseif button_state == get(hObject,'Min')
    %set(handles.F4_Bulb_radio_7,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_7 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_7','Value', num2str(F4_bulb_7));


function F4_Bulb_radio_8_Callback(hObject, eventdata, handles)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %set(handles.F4_Bulb_radio_8,'BackgroundColor','green');
    F4_bulb_8 = 7; % watt
elseif button_state == get(hObject,'Min')
    %set(handles.F4_Bulb_radio_8,'BackgroundColor',[0.94 0.94 0.94]);
    F4_bulb_8 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_bulb_8','Value', num2str(F4_bulb_8));



%-------------------- Accesspoint ----------------------

% --- Executes on button press in F4_Accesspoint_radio.
function F4_Accesspoint_radio_Callback(hObject, eventdata, handles)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %set(handles.F4_Accesspoint_radio,'BackgroundColor','green');
    F4_accesspoint = 6.5; % watt
    
    %standby energy
elseif button_state == get(hObject,'Min')
    %set(handles.F4_Accesspoint_radio,'BackgroundColor',[0.94 0.94 0.94]);
    F4_accesspoint = 0; % watt
end
set_param('House_model/Floor_4/Accesspoint/F4_accesspoint','Value', num2str(F4_accesspoint));



%---------------- FLOURECENTS ----------------------

% --- Executes on button press in F4_fluorescent_toggle_1.
function F4_Fluorescent_toggle_1_Callback(hObject, eventdata, handles)
% hObject    handle to F4_fluorescent_toggle_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Fluorescent_toggle_1,'BackgroundColor','green');
    F4_flourescent_1 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Fluorescent_toggle_1,'BackgroundColor',[0.94 0.94 0.94]);
    F4_flourescent_1 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_flourescent_1','Value', num2str(F4_flourescent_1));

% --- Executes on button press in F4_fluorescent_toggle_1.
function F4_Fluorescent_toggle_2_Callback(hObject, eventdata, handles)

button_state = get(hObject,'Value');

if button_state == get(hObject,'Max')
    set(handles.F4_Fluorescent_toggle_2,'BackgroundColor','green');
    F4_flourescent_2 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Fluorescent_toggle_2,'BackgroundColor',[0.94 0.94 0.94]);
    F4_flourescent_2 = 0; % watt
end

set_param('House_model/Floor_4/Lightening/F4_flourescent_2','Value', num2str(F4_flourescent_2));


% --- Executes on button press in F4_fluorescent_toggle_3.
function F4_Fluorescent_toggle_3_Callback(hObject, eventdata, handles)
% hObject    handle to F4_fluorescent_toggle_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%wn=2;
%sys = tf(wn^2,[1,2*wn,wn^2]);
%sys = wn^2;
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F4_Fluorescent_toggle_3,'BackgroundColor','green');
    F4_flourescent_3 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Fluorescent_toggle_3,'BackgroundColor',[0.94 0.94 0.94]);
    F4_flourescent_3 = 0; % watt
end
set_param('House_model/Floor_4/Lightening/F4_flourescent_3','Value', num2str(F4_flourescent_3));
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


% --- Executes on button press in f3_fluorescent_toggle_5.
function F4_Fluorescent_toggle_4_Callback(hObject, eventdata, handles)

button_state = get(hObject,'Value');

if button_state == get(hObject,'Max')
    set(handles.F4_Fluorescent_toggle_4,'BackgroundColor','green');
    F4_flourescent_4 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Fluorescent_toggle_4,'BackgroundColor',[0.94 0.94 0.94]);
    F4_flourescent_4 = 0; % watt
end

set_param('House_model/Floor_4/Lightening/F4_flourescent_4','Value', num2str(F4_flourescent_4));

% --- Executes on button press in f3_fluorescent_toggle_5.
function F4_Fluorescent_toggle_5_Callback(hObject, eventdata, handles)

button_state = get(hObject,'Value');

if button_state == get(hObject,'Max')
    set(handles.F4_Fluorescent_toggle_5,'BackgroundColor','green');
    F4_flourescent_5 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Fluorescent_toggle_5,'BackgroundColor',[0.94 0.94 0.94]);
    F4_flourescent_5 = 0; % watt
end

set_param('House_model/Floor_4/Lightening/F4_flourescent_5','Value', num2str(F4_flourescent_5));

% --- Executes on button press in F4_fluorescent_toggle_6.
function F4_Fluorescent_toggle_6_Callback(hObject, eventdata, handles)

button_state = get(hObject,'Value');

if button_state == get(hObject,'Max')
    set(handles.F4_Fluorescent_toggle_6,'BackgroundColor','green');
    F4_flourescent_6 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F4_Fluorescent_toggle_6,'BackgroundColor',[0.94 0.94 0.94]);
    F4_flourescent_6 = 0; % watt
end

set_param('House_model/Floor_4/Lightening/F4_flourescent_6','Value', num2str(F4_flourescent_6));

% --- Executes on button press in F4_MaxEffect_toggle_7.
function F4_MaxEffect_toggle_7_Callback(hObject, eventdata, handles)

% F4_Fluorescent_toggle_1_Callback(hObject, eventdata, handles);
% F4_Fluorescent_toggle_2_Callback(hObject, eventdata, handles);
% F4_Fluorescent_toggle_3_Callback(hObject, eventdata, handles);
% F4_Fluorescent_toggle_4_Callback(hObject, eventdata, handles);
% F4_Fluorescent_toggle_5_Callback(hObject, eventdata, handles);
% F4_Fluorescent_toggle_6_Callback(hObject, eventdata, handles);
% F4_Bulb_radio_1_Callback(hObject, eventdata, handles);



%----------------- OUTLET ---------------------------

function Phones_charging_slider_Callback(hObject, eventdata, handles)
% hObject    handle to Phones_charging_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
 F4_Phones_charging = round(get(hObject,'Value'));
 maxcharging_phone = 2.4*5;         %% WHY? / Josefine
 F4_Phones_effect = F4_Phones_charging*maxcharging_phone; %watt ändra
 set_param('House_model/Floor_4/Outlet/F4_Phones','Value', num2str(F4_Phones_effect));
 
 sliderValue = num2str(F4_Phones_charging)
 set(handles.Phones_charging_edit,'String', sliderValue);

%  set(handles.Phones_charging_slider, 'value', 0);
%  set(handles.Phones_charging_edit,'String', '0');
%  numSteps_phone = 15;
%  set(handles.Phones_charging_slider, 'Min', 0);
%  set(handles.Phones_charging_slider, 'Max', numSteps_phone);
%  set(handles.Phones_charging_slider, 'SliderStep', [1/(numSteps_phone) , 2/(numSteps_phone) ]);
%  %sliderValuePhones = get(handles.Phones_charging_slider, 'Value') % example
%  
 
function Phones_charging_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function Laptops_charging_slider_Callback(hObject, eventdata, handles)

% SEN: ---- x hur lång tid det har gått eller antal timmar....
% energy= nr * watt * time/60 kwh

 Laptops_Charging = round(get(hObject,'Value'))
 F4_Laptop_effect = Laptops_Charging*45;
 set_param('House_model/Floor_4/Outlet/F4_Laptops','Value', num2str(F4_Laptop_effect));
 sliderValue = num2str(Laptops_Charging);
 set(handles.Laptops_charging_edit,'String', sliderValue);

function Laptops_charging_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function Phones_charging_edit_Callback(hObject, eventdata, handles)


function Phones_charging_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Laptops_charging_edit_Callback(hObject, eventdata, handles)


function Laptops_charging_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%**********************************************
%*************** FLOOR 3 **********************
%**********************************************


%---------------- Flourescents ----------------------

function F3_Fluorescent_toggle_1_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorescent_toggle_1,'BackgroundColor','green');
    F3_flourescent_1 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorescent_toggle_1,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourescent_1 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourescent_1','Value', num2str(F3_flourescent_1));

function F3_Fluorescent_toggle_2_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorescent_toggle_2,'BackgroundColor','green');
    F3_flourescent_2 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorescent_toggle_2,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourescent_2 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourescent_2','Value', num2str(F3_flourescent_2));

function F3_Fluorescent_toggle_3_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorescent_toggle_3,'BackgroundColor','green');
    F3_flourescent_3 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorescent_toggle_3,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourescent_3 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourescent_3','Value', num2str(F3_flourescent_3));

function F3_Fluorescent_toggle_4_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorescent_toggle_4,'BackgroundColor','green');
    F3_flourescent_4 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorescent_toggle_4,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourescent_4 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourescent_4','Value', num2str(F3_flourescent_4));

function F3_Fluorescent_toggle_5_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');

if button_state == get(hObject,'Max')
    set(handles.F3_Fluorescent_toggle_5,'BackgroundColor','green');
    F3_flourescent_5 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorescent_toggle_5,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourescent_5 = 0; % watt
end

set_param('House_model/Floor_3/Lightening/F3_flourescent_5','Value', num2str(F3_flourescent_5));


function F3_Fluorescent_toggle_6_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorescent_toggle_6,'BackgroundColor','green');
    F3_flourescent_6 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorescent_toggle_6,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourescent_6 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourescent_6','Value', num2str(F3_flourescent_6));

function F3_Fluorescent_toggle_7_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorescent_toggle_7,'BackgroundColor','green');
    F3_flourescent_7 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorescent_toggle_7,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourescent_7 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourescent_7','Value', num2str(F3_flourescent_7));


function F3_Fluorescent_toggle_8_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_Fluorescent_toggle_8,'BackgroundColor','green');
    F3_flourescent_8 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_Fluorescent_toggle_8,'BackgroundColor',[0.94 0.94 0.94]);
    F3_flourescent_8 = 0; % watt
end
set_param('House_model/Floor_3/Lightening/F3_flourescent_8','Value', num2str(F3_flourescent_8));


%------------  Accesspoint  ----------------------

function F3_Accesspoint_radio_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %set(handles.F3_Accesspoint_radio,'BackgroundColor','green');
    F3_Accesspoint = 6.5; % watt
elseif button_state == get(hObject,'Min')
    %set(handles.F3_Accesspoint_radio,'BackgroundColor',[0.94 0.94 0.94]);
    F3_Accesspoint = 0; % watt
end
set_param('House_model/Floor_3/Accesspoint/F3_accesspoint_1','Value', num2str(F3_Accesspoint));


% --------------------- AC ------------------

function F3_AC_toggle_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F3_AC_toggle,'BackgroundColor','green');
    F3_AC = 3000; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F3_AC_toggle,'BackgroundColor',[0.94 0.94 0.94]);
    F3_AC = 0; % watt
end
set_param('House_model/Floor_3/AC/F3_AC_1','Value', num2str(F3_AC));




% ------------------ Music -------------------
% --- Executes on button press in F3_Music_checkbox.
function F3_Music_checkbox_Callback(hObject, eventdata, handles)
 
ON = get(handles.F3_Music_checkbox, 'Value');
if ON
    set_param('House_model/Floor_3/Music/F3_subwoofer','Value', '115');
    set_param('House_model/Floor_3/Music/F3_reciver','Value', '200');
    set_param('House_model/Floor_3/Music/F3_speakers','Value', '30');
else 
    set_param('House_model/Floor_3/Music/F3_subwoofer','Value', '0');
    set_param('House_model/Floor_3/Music/F3_reciver','Value', '0');
    set_param('House_model/Floor_3/Music/F3_speakers','Value', '0');
end



%----------- Continue here -------------------------------


%------------- Volyme ------------------
%           More volyme is more effect
%------------- Do it? ------------------

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%**********************************************
%*************** FLOOR 2 **********************
%**********************************************


%---------------- ROOM 1; Socialroom ----------------------

function F2_Fluorescent_toggle_1_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F2_Fluorescent_toggle_1,'BackgroundColor','green');
    F2_flourescent_1 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F2_Fluorescent_toggle_1,'BackgroundColor',[0.94 0.94 0.94]);
    F2_flourescent_1 = 0; % watt
end
set_param('House_model/Floor_2/Room_1/F2_flourescent_1','Value', num2str(F2_flourescent_1));

function F2_Fluorescent_toggle_2_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F2_Fluorescent_toggle_2,'BackgroundColor','green');
    F2_flourescent_2 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F2_Fluorescent_toggle_2,'BackgroundColor',[0.94 0.94 0.94]);
    F2_flourescent_2 = 0; % watt
end
set_param('House_model/Floor_2/Room_1/F2_flourescent_2','Value', num2str(F2_flourescent_2));

function F2_TV_radio_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F2_TV = 71; % watt
elseif button_state == get(hObject,'Min')
    F2_TV = 0; % watt
end
set_param('House_model/Floor_2/Room_1/F2_TV','Value', num2str(F2_TV));

function F2_R1_projector_radio_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %set(handles.F4_Accesspoint_radio,'BackgroundColor','green');
    F2_R1_projector = 240; % watt
    
    %standby energy
elseif button_state == get(hObject,'Min')
    %set(handles.F4_Accesspoint_radio,'BackgroundColor',[0.94 0.94 0.94]);
    F2_R1_projector = 0; % watt
end
set_param('House_model/Floor_2/Room_1/F2_projector','Value', num2str(F2_R1_projector));


% --------------- ROOM 2; Studio ---------------------
function F2_Fluorescent_toggle_3_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F2_Fluorescent_toggle_3,'BackgroundColor','green');
    F2_Fluorescent_3 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F2_Fluorescent_toggle_3,'BackgroundColor',[0.94 0.94 0.94]);
    F2_Fluorescent_3 = 0; % watt
end
set_param('House_model/Floor_2/Room_2/F2_fluorescent_1','Value', num2str(F2_Fluorescent_3));

function F2_R2_computer_radio_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %set(handles.F2_R2_computer_radio,'BackgroundColor','green');
    F2_R2_computer = 71; % watt
elseif button_state == get(hObject,'Min')
    %set(handles.F2_R2_computer_radio,'BackgroundColor',[0.94 0.94 0.94]);
    F2_R2_computer = 0; % watt
end
set_param('House_model/Floor_2/Room_2/F2_computer','Value', num2str(F2_R2_computer));

function F2_mixertable_radio_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %set(handles.F2_mixertable_radio,'BackgroundColor','green');
    F2_mixertable = 71; % watt
elseif button_state == get(hObject,'Min')
    %set(handles.F2_mixertable_radio,'BackgroundColor',[0.94 0.94 0.94]);
    F2_mixertable = 0; % watt
end
set_param('House_model/Floor_2/Room_2/F2_mixertable','Value', num2str(F2_mixertable));

function F2_R2_Bulb_radio_1_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F2_R2_Bulb_1 = 7; % watt
elseif button_state == get(hObject,'Min')
    F2_R2_Bulb_1 = 0; % watt
end
set_param('House_model/Floor_2/Room_2/F2_bulb_1','Value', num2str(F2_R2_Bulb_1));

function F2_R2_Bulb_radio_2_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F2_R2_Bulb_2 = 7; % watt
elseif button_state == get(hObject,'Min')
    F2_R2_Bulb_2 = 0; % watt
end
set_param('House_model/Floor_2/Room_2/F2_bulb_2','Value', num2str(F2_R2_Bulb_2));


% --------------- ROOM 3; Record ---------------------
function F2_Fluorescent_toggle_4_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F2_Fluorescent_toggle_4,'BackgroundColor','green');
    F2_Fluorescent_4 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F2_Fluorescent_toggle_4,'BackgroundColor',[0.94 0.94 0.94]);
    F2_Fluorescent_4 = 0; % watt
end
set_param('House_model/Floor_2/Room_3/F2_fluorescent_1','Value', num2str(F2_Fluorescent_4));

function F2_R3_keyboard_radio_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F2_R3_keyboard = 6; % watt
elseif button_state == get(hObject,'Min')
    F2_R3_keyboard = 0; % watt
end
set_param('House_model/Floor_2/Room_3/F2_keyboard','Value', num2str(F2_R3_keyboard));

function F2_R3_guitar_radio_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F2_R3_guitar = 20; % watt
elseif button_state == get(hObject,'Min')
    F2_R3_guitar = 0; % watt
end
set_param('House_model/Floor_2/Room_3/F2_el_guitar','Value', num2str(F2_R3_guitar));

function F2_R3_Mick_radio_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F2_R3_Mick = 1; % watt      --------------- REMOVE?! /J
elseif button_state == get(hObject,'Min')
    F2_R3_Mick = 0; % watt
end
set_param('House_model/Floor_2/Room_3/F2_mick','Value', num2str(F2_R3_Mick));

% ------------- ROOM 4; Office/Media/Projection ------
% accesspoint
function F2_R4_Accesspoint_radio_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F2_R4_Accesspoint = 6.5; % watt  
elseif button_state == get(hObject,'Min')
    F2_R4_Accesspoint = 0; % watt
end
set_param('House_model/Floor_2/Room_4/F2_accesspoint','Value', num2str(F2_R4_Accesspoint));
% comp*4
function F2_R4_computer_radio_1_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F2_R4_computer_1 = 45; % watt  
elseif button_state == get(hObject,'Min')
    F2_R4_computer_1 = 0; % watt
end
set_param('House_model/Floor_2/Room_4/F2_computer_1','Value', num2str(F2_R4_computer_1));

function F2_R4_computer_radio_2_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F2_R4_computer_2 = 45; % watt  
elseif button_state == get(hObject,'Min')
    F2_R4_computer_2 = 0; % watt
end
set_param('House_model/Floor_2/Room_4/F2_computer_2','Value', num2str(F2_R4_computer_2));

function F2_R4_computer_radio_3_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F2_R4_computer_3 = 45; % watt  
elseif button_state == get(hObject,'Min')
    F2_R4_computer_3 = 0; % watt
end
set_param('House_model/Floor_2/Room_4/F2_computer_3','Value', num2str(F2_R4_computer_3));

function F2_R4_computer_radio_4_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F2_R4_computer_4 = 45; % watt  
elseif button_state == get(hObject,'Min')
    F2_R4_computer_4 = 0; % watt
end
set_param('House_model/Floor_2/Room_4/F2_computer_4','Value', num2str(F2_R4_computer_4));
% flourecent*2
function F2_Fluorescent_toggle_5_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F2_Fluorescent_toggle_5,'BackgroundColor','green');
    F2_flourescent_5 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F2_Fluorescent_toggle_5,'BackgroundColor',[0.94 0.94 0.94]);
    F2_flourescent_5 = 0; % watt
end
set_param('House_model/Floor_2/Room_4/F2_flourescent_1','Value', num2str(F2_flourescent_5));

function F2_Fluorescent_toggle_6_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F2_Fluorescent_toggle_6,'BackgroundColor','green');
    F2_flourescent_6 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F2_Fluorescent_toggle_6,'BackgroundColor',[0.94 0.94 0.94]);
    F2_flourescent_6 = 0; % watt
end
set_param('House_model/Floor_2/Room_4/F2_flourescent_2','Value', num2str(F2_flourescent_6));

% Printer*2?
function F2_R4_printer_radio_1_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F2_R4_printer_1 = 36; % watt
elseif button_state == get(hObject,'Min')
    F2_R4_printer_1 = 0; % watt
end
set_param('House_model/Floor_2/Room_4/F2_printer_1','Value', num2str(F2_R4_printer_1));

function F2_R4_printer_radio_2_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F2_R4_printer_2 = 36; % watt
elseif button_state == get(hObject,'Min')
    F2_R4_printer_2 = 0; % watt
end
set_param('House_model/Floor_2/Room_4/F2_printer_1','Value', num2str(F2_R4_printer_2));

%---------- Photo charging slider ---------------
function F2_photo_slider_Callback(hObject, eventdata, handles)
 %where = get(hObject,'Min')
 F2_photo = (100*get(hObject,'Value'))
 F2_photo_effect = F2_photo*8; %watt ändra ---------- CORRECT THIS ONE
 set_param('House_model/Floor_2/Room_4/F2_photo','Value', num2str(F2_photo_effect));
 sliderValue = num2str(F2_photo_effect)
 set(handles.F2_photo_edit,'String', sliderValue);
 
function F2_photo_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function F2_photo_edit_Callback(hObject, eventdata, handles)

function F2_photo_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%---------- Phones charging slider ---------------
function F2_phone_slider_Callback(hObject, eventdata, handles)
 maxcharging_phone = 5;
 F2_phone = 100*(get(hObject,'Value'))
 F2_phone_effect = F2_phone*maxcharging_phone; %watt ändra ------- CORRET THIS ONE
 set_param('House_model/Floor_2/Room_4/F2_phones','Value', num2str(F2_phone_effect));
 sliderValue = num2str(F2_phone_effect)
 set(handles.F2_phone_edit,'String', sliderValue);
 
function F2_phone_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function F2_phone_edit_Callback(hObject, eventdata, handles)

function F2_phone_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ---------- Video charging slider -----------------------
function F2_video_slider_Callback(hObject, eventdata, handles)
 F2_video = (100*get(hObject,'Value'));
 F2_video_effect = F2_video*12; %watt ändra ------------ CORRECT THIS! 
 set_param('House_model/Floor_2/Room_4/F2_video','Value', num2str(F2_video_effect));
 sliderValue = num2str(F2_video_effect)
 set(handles.F2_video_edit,'String', sliderValue);
 
function F2_video_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function F2_video_edit_Callback(hObject, eventdata, handles)

function F2_video_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ------------ Laptop charging slider --------------

function F2_laptop_slider_Callback(hObject, eventdata, handles)
 F2_laptop = (100*get(hObject,'Value'));
 F2_laptop_effect = F2_laptop*45; %watt ändra  ----------- CORRECT THIS!! 
 set_param('House_model/Floor_2/Room_4/F2_laptops','Value', num2str(F2_laptop_effect));
 sliderValue = num2str(F2_laptop_effect)
 set(handles.F2_laptop_edit,'String', sliderValue);

function F2_laptop_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function F2_laptop_edit_Callback(hObject, eventdata, handles)

function F2_laptop_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ------------- Stairwell -------------------------
function F2_Fluorescent_toggle_7_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F2_Fluorescent_toggle_7,'BackgroundColor','green');
    F2_flourescent_7 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F2_Fluorescent_toggle_7,'BackgroundColor',[0.94 0.94 0.94]);
    F2_flourescent_7 = 0; % watt
end
set_param('House_model/Floor_2/Stairwell/F2_flourescent_1','Value', num2str(F2_flourescent_7));


function F2_Fluorescent_toggle_8_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F2_Fluorescent_toggle_8,'BackgroundColor','green');
    F2_flourescent_8 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F2_Fluorescent_toggle_8,'BackgroundColor',[0.94 0.94 0.94]);
    F2_flourescent_8 = 0; % watt
end
set_param('House_model/Floor_2/Stairwell/F2_flourescent_2','Value', num2str(F2_flourescent_8));

%-----------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Floor 1, Tab 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 10 flourescents
function F1_Fluorescent_toggle_1_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F1_Fluorescent_toggle_1,'BackgroundColor','green');
    F1_flourescent_1 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F1_Fluorescent_toggle_1,'BackgroundColor',[0.94 0.94 0.94]);
    F1_flourescent_1 = 0; % watt
end
set_param('House_model/Floor_1/Lightening/F1_flourescent_1','Value', num2str(F1_flourescent_1));

function F1_Fluorescent_toggle_2_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F1_Fluorescent_toggle_2,'BackgroundColor','green');
    F1_flourescent_2 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F1_Fluorescent_toggle_2,'BackgroundColor',[0.94 0.94 0.94]);
    F1_flourescent_2 = 0; % watt
end
set_param('House_model/Floor_1/Lightening/F1_flourescent_2','Value', num2str(F1_flourescent_2));

function F1_Fluorescent_toggle_3_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F1_Fluorescent_toggle_3,'BackgroundColor','green');
    F1_flourescent_3 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F1_Fluorescent_toggle_3,'BackgroundColor',[0.94 0.94 0.94]);
    F1_flourescent_3 = 0; % watt
end
set_param('House_model/Floor_1/Lightening/F1_flourescent_3','Value', num2str(F1_flourescent_3));

function F1_Fluorescent_toggle_4_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F1_Fluorescent_toggle_4,'BackgroundColor','green');
    F1_flourescent_4 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F1_Fluorescent_toggle_4,'BackgroundColor',[0.94 0.94 0.94]);
    F1_flourescent_4 = 0; % watt
end
set_param('House_model/Floor_1/Lightening/F1_flourescent_4','Value', num2str(F1_flourescent_4));

function F1_Fluorescent_toggle_5_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F1_Fluorescent_toggle_5,'BackgroundColor','green');
    F1_flourescent_5 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F1_Fluorescent_toggle_5,'BackgroundColor',[0.94 0.94 0.94]);
    F1_flourescent_5 = 0; % watt
end
set_param('House_model/Floor_1/Lightening/F1_flourescent_5','Value', num2str(F1_flourescent_5));

function F1_Fluorescent_toggle_6_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F1_Fluorescent_toggle_6,'BackgroundColor','green');
    F1_flourescent_6 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F1_Fluorescent_toggle_6,'BackgroundColor',[0.94 0.94 0.94]);
    F1_flourescent_6 = 0; % watt
end
set_param('House_model/Floor_1/Lightening/F1_flourescent_6','Value', num2str(F1_flourescent_6));

function F1_Fluorescent_toggle_7_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F1_Fluorescent_toggle_7,'BackgroundColor','green');
    F1_flourescent_7 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F1_Fluorescent_toggle_7,'BackgroundColor',[0.94 0.94 0.94]);
    F1_flourescent_7 = 0; % watt
end
set_param('House_model/Floor_1/Lightening/F1_flourescent_7','Value', num2str(F1_flourescent_7));

function F1_Fluorescent_toggle_8_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F1_Fluorescent_toggle_8,'BackgroundColor','green');
    F1_flourescent_8 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F1_Fluorescent_toggle_8,'BackgroundColor',[0.94 0.94 0.94]);
    F1_flourescent_8 = 0; % watt
end
set_param('House_model/Floor_1/Lightening/F1_flourescent_8','Value', num2str(F1_flourescent_8));

function F1_Fluorescent_toggle_9_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F1_Fluorescent_toggle_9,'BackgroundColor','green');
    F1_flourescent_9 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F1_Fluorescent_toggle_9,'BackgroundColor',[0.94 0.94 0.94]);
    F1_flourescent_9 = 0; % watt
end
set_param('House_model/Floor_1/Lightening/F1_flourescent_9','Value', num2str(F1_flourescent_9));

function F1_Fluorescent_toggle_10_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    set(handles.F1_Fluorescent_toggle_10,'BackgroundColor','green');
    F1_flourescent_10 = 36; % watt
elseif button_state == get(hObject,'Min')
    set(handles.F1_Fluorescent_toggle_10,'BackgroundColor',[0.94 0.94 0.94]);
    F1_flourescent_10 = 0; % watt
end
set_param('House_model/Floor_1/Lightening/F1_flourescent_10','Value', num2str(F1_flourescent_10));

% 1 router
function F1_router_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    F1_router = 45; % watt  
elseif button_state == get(hObject,'Min')
    F1_router = 0; % watt
end
set_param('House_model/Floor_1/Router/F1_router','Value', num2str(F1_router));

% outlets; phones and laptops
% --- Executes on slider movement.
function F1_phones_slider_Callback(hObject, eventdata, handles)
 maxcharging_phone = 5;
 F1_phone = 100*(get(hObject,'Value'));
 F1_phone_effect = F1_phone * maxcharging_phone;
 set_param('House_model/Floor_1/Outlet/F1_phones','Value', num2str(F1_phone_effect));
 sliderValue = num2str(F1_phone_effect);
 set(handles.F1_phones_edit,'String', sliderValue);
 
function F1_phones_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function F1_laptops_slider_Callback(hObject, eventdata, handles)
 F1_laptop = (100*get(hObject,'Value'));
 F1_laptop_effect = F1_laptop*45;
 set_param('House_model/Floor_1/Outlet/F1_laptops','Value', num2str(F1_laptop_effect));
 sliderValue = num2str(F1_laptop_effect);
 set(handles.F1_laptops_edit,'String', sliderValue);
 
 function F1_laptops_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function F1_phones_edit_Callback(hObject, eventdata, handles)
function F1_phones_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function F1_laptops_edit_Callback(hObject, eventdata, handles)
function F1_laptops_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-----------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Plot, Tab 5
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

%maskio - sikio
%macho - jicho
%mapoa - poa - näsa
%mdomo - 
%nuele - Hår
%chingo - hals
%bega - 
%mkono - 





