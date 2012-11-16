%> @ingroup guigroup
%> @file
%> @brief Repeated Train-Test (@ref reptt) Properties Window
%>
%> This window asks for properties common to all @ref reptt classes
%>
%> @image html Screenshot-uip_gridsearch.png
%>
%> <b>Test post-processor</b> (optional) - see reptt::postpr_test
%>
%> <b>Estimation post-processor</b> - see reptt::postpr_est
%>
%> <b>Mold Train-Test Logs</b> - see reptt::log_mold
%>
%> @sa reptt

%> @cond
function varargout = uip_gridsearch(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_gridsearch_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_gridsearch_OutputFcn, ...
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

% --- Executes just before uip_gridsearch is made visible.
function uip_gridsearch_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
handles.names_log_mold = {};
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command line.
function varargout = uip_gridsearch_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject); % Handles is not a handle(!), so gotta retrieve it again to see changes in .output
    varargout{1} = handles.output;
    delete(gcf);
catch %#ok<*CTCH>
    output.flag_ok = 0;
    output.params = {};
    varargout{1} = output;
end;


%-----------------------------------------------------------------------------------------------------------

%############
function refresh(handles)

% logs
listbox_load_from_workspace('ttlog', handles.listbox_log_mold, 0);
v = get(handles.listbox_log_mold, 'Value');
if sum(v > length(handles.names_log_mold)) > 0 && ~isempty(handles.names_log_mold)
    set(handles.listbox_log_mold, 'Value', 1);
end;
set(handles.edit_log_mold, 'String', handles.names_log_mold);

% others
listbox_load_from_workspace('block', handles.popupmenu_postpr_est, 1, 'Leave blank');
listbox_load_from_workspace('block', handles.popupmenu_postpr_test, 1, 'Leave blank');
listbox_load_from_workspace({'block_cascade_base', 'clssr'}, handles.popupmenu_clssr, 0);
listbox_load_from_workspace('chooser', handles.popupmenu_chooser, 1, 'Use default');
listbox_load_from_workspace('sgs', handles.popupmenu_sgs, 1, 'Use none');

local_show_description(handles, []);

%############
function local_show_description(handles, listbox)
if isempty(listbox)
    set(handles.edit_description, 'String', {});
end;
show_description(listbox, handles.edit_description);


%-----------------------------------------------------------------------------------------------------------


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    ssgs = listbox_get_selected_1stname(handles.popupmenu_sgs);
    if isempty(ssgs)
        ssgs = '[]';
    end;
    schooser = listbox_get_selected_1stname(handles.popupmenu_chooser);
    if isempty(schooser)
        schooser = '[]';
    end;
    spostpr_test = listbox_get_selected_1stname(handles.popupmenu_postpr_test);
    if isempty(spostpr_test)
        spostpr_test = '[]';
    end;
    spostpr_est = listbox_get_selected_1stname(handles.popupmenu_postpr_est);
    if isempty(spostpr_est)
        spostpr_est = '[]';
    end;
    sclssr = listbox_get_selected_1stname(handles.popupmenu_clssr);
    if isempty(sclssr)
        irerror('Classifier not specified!');
    end;

    if isempty(handles.names_log_mold)
        % irerror('No mold Train-Test Logs specified!');
    end;
    
    s = get(handles.edit_paramspecs, 'String');
    if iscell(s)
        s = sprintf('%s\n', s{:});
    end;

    handles.output.params = {...
    'sgs', ssgs, ...
    'clssr', sclssr, ...
    'chooser', schooser, ...
    'postpr_test', spostpr_test, ...
    'postpr_est', spostpr_est, ...
    'log_mold', params2str2(handles.names_log_mold) ...
    'no_iterations', int2str(eval(fel(get(handles.edit_no_iterations, 'String')))), ...
    'paramspecs', cell2str(eval(s)), ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    rethrow(ME);
end;

%#####
function listbox_log_mold_Callback(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU>
local_show_description(handles, handles.listbox_log_mold);

%#####
function pushbutton_log_mold_add_Callback(hObject, eventdata, handles)
nn = listbox_get_selected_1stname(handles.listbox_log_mold);
if ~isempty(nn)
    handles.names_log_mold{end+1} = nn;
    guidata(hObject, handles);
    refresh(handles);
end;

%#####
function pushbutton_log_mold_restart_Callback(hObject, eventdata, handles)
set(handles.edit_log_mold, 'String', {});
handles.names_log_mold = [];
guidata(hObject, handles);
refresh(handles);

%#####
function popupmenu_clssr_Callback(hObject, eventdata, handles)
local_show_description(handles, handles.popupmenu_clssr);

%#####
function popupmenu_postpr_test_Callback(hObject, eventdata, handles)
local_show_description(handles, handles.popupmenu_postpr_test);

%#####
function popupmenu_postpr_est_Callback(hObject, eventdata, handles)
local_show_description(handles, handles.popupmenu_postpr_est);

%#####
function popupmenu_sgs_Callback(hObject, eventdata, handles)
local_show_description(handles, handles.popupmenu_sgs);

%#####
function popupmenu_chooser_Callback(hObject, eventdata, handles)
local_show_description(handles, handles.popupmenu_chooser);
%-------------------------------------------------------------------------------


%#####
function pushbutton_t_knn_Callback(hObject, eventdata, handles)
set(handles.edit_paramspecs, 'string', 'k-NN''s "k"');

%#####
function pushbutton_t_svm_Callback(hObject, eventdata, handles)
set(handles.edit_paramspecs, 'string', 'C, gamma stuff');

function popupmenu_sgs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function checkbox_flag_parallel_Callback(hObject, eventdata, handles)
function popupmenu_clssr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_chooser_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_no_iterations_Callback(hObject, eventdata, handles)
function edit_no_iterations_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_paramspecs_Callback(hObject, eventdata, handles)
function edit_paramspecs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_description_Callback(hObject, eventdata, handles) %#ok<*INUSD>
function edit_description_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_postpr_test_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_postpr_est_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_block_mold_Callback(hObject, eventdata, handles)
function edit_block_mold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox_log_mold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_log_mold_Callback(hObject, eventdata, handles)
function edit_log_mold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox_block_mold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
