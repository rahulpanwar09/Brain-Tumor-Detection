function varargout = BrainTumor(varargin)
% BRAINTUMOR MATLAB code for BrainTumor.fig
%      BRAINTUMOR, by itself, creates a new BRAINTUMOR or raises the existing
%      singleton*.
%
%      H = BRAINTUMOR returns the handle to a new BRAINTUMOR or the handle to
%      the existing singleton*.
%
%      BRAINTUMOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BRAINTUMOR.M with the given input arguments.
%
%      BRAINTUMOR('Property','Value',...) creates a new BRAINTUMOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BrainTumor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BrainTumor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BrainTumor

% Last Modified by GUIDE v2.5 16-Jun-2021 15:59:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BrainTumor_OpeningFcn, ...
                   'gui_OutputFcn',  @BrainTumor_OutputFcn, ...
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


% --- Executes just before BrainTumor is made visible.
function BrainTumor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BrainTumor (see VARARGIN)

% Choose default command line output for BrainTumor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BrainTumor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BrainTumor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image1
[path,user_cancel]=imgetfile();
if user_cancel
    msgbox(sprintf('Invalid Selection'));
    return
end
 image1=imread(path);
 image1=im2double(image1);
 axes(handles.axes1);
 imshow(image1);
 title('\fontsize{18}\color[rgb]{0.635 0.078 0.184}Patient''s Brain');
 

% --- Executes on button press in inspect.
function inspect_Callback(hObject, eventdata, handles)
% hObject    handle to inspect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image1

axes(handles.axes2); 
blackandwhite=im2bw(image1,0.7);

label=bwlabel(blackandwhite);
property=regionprops(label,'Solidity','Area');

density=[property.Solidity];
area=[property.Area];

high_dense_area=density>0.5;
max_area=max(area(high_dense_area));

tumor=find(area==max_area);
tumor=ismember(label,tumor);

dilation=strel('square',5);
tumor=imdilate(tumor,dilation);

B=bwboundaries(tumor,'noholes');

imshow(image1,[]);
hold on
for i=1:length(B)
    plot(B{i}(:,2),B{i}(:,1), 'y' ,'linewidth',1.45);    
end

title('\fontsize{18}\color[rgb]{0.635 0.078 0.184}Detected Tumor');
hold off;
