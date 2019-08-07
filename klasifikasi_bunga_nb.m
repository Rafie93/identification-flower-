%Create By Rafi'e
%Magiseter Ilmu Komputer Budi Luhur 2018
function varargout = klasifikasi_bunga_nb(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @klasifikasi_bunga_nb_OpeningFcn, ...
    'gui_OutputFcn',  @klasifikasi_bunga_nb_OutputFcn, ...
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


% --- Executes just before klasifikasi_bunga_nb is made visible.
function klasifikasi_bunga_nb_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
movegui(hObject,'center');


% --- Outputs from this function are returned to the command line.
function varargout = klasifikasi_bunga_nb_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)
try
    [nama_file,nama_path] = uigetfile({'*.*'});
    
    if ~isequal(nama_file,0)
        path = fullfile(nama_path,nama_file);
        Img = imread(path);
        axes(handles.axes1)
        imshow(Img)
        handles.Img = Img;
        
        guidata(hObject,handles)
        
        axes(handles.axes2)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
        
        axes(handles.axes3)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
        
        axes(handles.axes4)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
        
        axes(handles.axes5)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
        
        axes(handles.axes6)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
        
        axes(handles.axes7)
        cla reset
        set(gca,'XTick',[])
        set(gca,'YTick',[])
        
        set(handles.uitable1,'Data',[])
        set(handles.edit1,'String','')
    else
        return
    end
catch
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
try
    
    rgbImage = (handles.Img);
    %start image filtering
    [rows columns numberOfColorBands] = size(rgbImage);
    % Generate a noisy image.  This has salt and pepper noise independently on
    % each color channel so the noise may be colored.
    noisyRGB = imnoise(rgbImage,'salt & pepper', 0.05);
    % Extract the individual red, green, and blue color channels.
    redChannel = noisyRGB(:, :, 1);
    greenChannel = noisyRGB(:, :, 2);
    blueChannel = noisyRGB(:, :, 3);

    % Median Filter the channels:
    redMF = medfilt2(redChannel, [3 3]);
    greenMF = medfilt2(greenChannel, [3 3]);
    blueMF = medfilt2(blueChannel, [3 3]);

    % Find the noise in the red.
    noiseImage = (redChannel == 0 | redChannel == 255);
    % Get rid of the noise in the red by replacing with median.
    noiseFreeRed = redChannel;
    noiseFreeRed(noiseImage) = redMF(noiseImage);

    % Find the noise in the green.
    noiseImage = (greenChannel == 0 | greenChannel == 255);
    % Get rid of the noise in the green by replacing with median.
    noiseFreeGreen = greenChannel;
    noiseFreeGreen(noiseImage) = greenMF(noiseImage);

    % Find the noise in the blue.
    noiseImage = (blueChannel == 0 | blueChannel == 255);
    % Get rid of the noise in the blue by replacing with median.
    noiseFreeBlue = blueChannel;
    noiseFreeBlue(noiseImage) = blueMF(noiseImage);

    % Reconstruct the noise free RGB image
    rgbFiltered = cat(3, noiseFreeRed, noiseFreeGreen, noiseFreeBlue);
    %END IMAGE FILTERING
    
    %START IMAGE SEGMENTASI
    img_segmentasi_roi = segmentasi_warna_roi(rgbFiltered);
    %END IMAGE SEGMENTASI 

    Img = im2double(img_segmentasi_roi); 
    % Ekstraksi Ciri Warna RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
    CiriR = mean2(R);
    CiriG = mean2(G);
    CiriB = mean2(B);
    
    Red = cat(3,R,G*0,B*0);
    Green = cat(3,R*0,G,B*0);
    Blue = cat(3,R*0,G*0,B);
    
    %Ekstraksi Ciri Warna HSV
    hsv = rgb2hsv(Img);
    
    hue = hsv(:, :, 1); % Hue image.
    saturation = hsv(:, :, 2); %Saturation
    value = 1/3 *(R+G+B);
   
    %END
    
    axes(handles.axes2)
    imshow(Red)
    title('Red')
    
    axes(handles.axes3)
    imshow(Green)
    title('Green')
    
    axes(handles.axes4)
    imshow(Blue)
    title('Blue')
    
    axes(handles.axes5)
    imshow(hue)
    title('Hue')

    axes(handles.axes6)
    imshow(saturation)
    title('Saturation')
    
    axes(handles.axes7)
    imshow(value)
    title('Value')

    %Ektraksi Ciri Warna HSV
    
    CiriH = mean2(hue) * 255 ;
    CiriS = mean2(saturation) * 255;
    CiriV = mean2(value) * 255;
    
    %Ektraksi Ciri Teksture GLCM
    GrayImg = (0.299*R)+(0.587*G)+(0.144*B)
    glcm = graycomatrix(GrayImg,'Offset',[2 0;0 2]);
    
    stats = graycoprops(glcm,{'contrast','correlation','energy','homogeneity'});
 
    Contrast = stats.Contrast;
    Correlation = stats.Correlation;
    Energy = stats.Energy;
    Homogeneity = stats.Homogeneity;

    CiriContrast =  mean(Contrast);
    CiriCorrelation = mean(Correlation);
    CiriEnergy = mean(Energy);
    CiriHomogeneity = mean(Homogeneity);
    
    data2 = cell(10,2);
    data2{1,1} = 'Red';
    data2{2,1} = 'Green';
    data2{3,1} = 'Blue';
    data2{4,1} = 'Hue';
    data2{5,1} = 'Saturation';
    data2{6,1} = 'Value';
    data2{7,1} = 'Contrast';
    data2{8,1} = 'Correlation';
    data2{9,1} = 'Energy';
    data2{10,1} = 'Homogeneity'; 
    data2{1,2} = CiriR;
    data2{2,2} = CiriG;
    data2{3,2} = CiriB;
    data2{4,2} = CiriH;
    data2{5,2} = CiriS;
    data2{6,2} = CiriV;
    data2{7,2} = CiriContrast;
    data2{8,2} = CiriCorrelation;
    data2{9,2} = CiriEnergy;
    data2{10,2}= CiriHomogeneity;
    
    set(handles.uitable1,'Data',data2,'ForegroundColor',[0 0 0])
    
    ciri_bunga = [CiriR CiriG CiriB CiriH CiriS CiriV CiriContrast CiriCorrelation  CiriEnergy CiriHomogeneity ];
    handles.ciri_bunga = ciri_bunga;
    guidata(hObject, handles)
    
    set(handles.edit1,'String','')
catch
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    ciri_bunga = handles.ciri_bunga;
    load NaiveBayesFlower
    label_class = predict(NaiveBayesFlower,ciri_bunga);
    
    if label_class == 1
        kelas = 'Kansas state flower';
    elseif label_class == 2
        kelas = 'Marguerite daisy';
    elseif label_class == 3
        kelas = 'Roses';
    elseif label_class == 4
        kelas = 'Tulips';
    else
        kelas = 'Unknown';
    end
    
    set(handles.edit1,'String',kelas);
catch
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes2)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes3)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes4)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes5)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes6)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes7)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])


set(handles.uitable1,'Data',[])
set(handles.edit1,'String','')


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
