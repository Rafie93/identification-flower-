%Create By Rafi'e
%Magiseter Ilmu Komputer Budi Luhur 2018

clc; clear; close all; warning off all;

image_folder_kansas = 'data latih\kansas';
filenames_kansas = dir(fullfile(image_folder_kansas, '*.jpg'));
total_images_kansas = numel(filenames_kansas);

image_folder_marguerite = 'data latih\marguerite';
filenames_marguerite = dir(fullfile(image_folder_marguerite, '*.jpg'));
total_images_marguerite = numel(filenames_marguerite);

image_folder_roses = 'data latih\roses';
filenames_roses = dir(fullfile(image_folder_roses, '*.jpg'));
total_images_roses = numel(filenames_roses);

image_folder_tulips = 'data latih\tulips';
filenames_tulips = dir(fullfile(image_folder_tulips, '*.jpg'));
total_images_tulips = numel(filenames_tulips);

total_gambar = total_images_kansas+total_images_marguerite+total_images_roses+total_images_tulips;

data_latih = zeros(total_gambar+1,11);
data_latih(1,1)=1; %Kolum Hue
data_latih(1,2)=2; %Kolum Saturation
data_latih(1,3)=3; %Kolum Value
data_latih(1,4)=4; %Kolum Contrast
data_latih(1,5)=5; %Kolum Corretaion
data_latih(1,6)=6; %Kolum Energy
data_latih(1,7)=7; %Kolum Homogeneity
data_latih(1,8)=8; %Kolum Class
data_latih(1,9)=9; %Kolum Energy
data_latih(1,10)=10; %Kolum Homogeneity
data_latih(1,11)=11; %Kolum Class

noIK = 1;
for n = 2:1+total_images_kansas
    full_name_kansas= fullfile(image_folder_kansas, filenames_kansas(noIK).name);
    img_filter = image_filtering_noise_removal(full_name_kansas);
    img_segmentasi_roi = segmentasi_warna_roi(img_filter);
    Img = img_segmentasi_roi;
    
    Img = im2double(Img);
    % Ekstraksi Ciri Warna RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
    CiriR = mean2(R);
    CiriG = mean2(G);
    CiriB = mean2(B);
    
    % Image Filtering
    
    % Image Segmentasi
    %Ektraksi Ciri HSV
    hsv = rgb2hsv(Img);
    hue = hsv(:, :, 1); % Hue image.    
    saturation = hsv(:, :,2); %saturation image
   % saturation =1-3.*(min(min(R,G),B))./(R+G+B);
    value = 1/3 *(R+G+B);

    CiriH = mean2(hue) * 255 ;
    CiriS = mean2(saturation) * 255;
    CiriV = mean2(value) * 255;
    %END
    % Ekstraksi Ciri Tekstur GLCM
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

    % Pembentukan data latih
    data_latih(n,1) = CiriR;
    data_latih(n,2) = CiriG;
    data_latih(n,3) = CiriB;
    data_latih(n,4) = CiriH;
    data_latih(n,5) = CiriS;
    data_latih(n,6) = CiriV;
    data_latih(n,7) = CiriContrast;
    data_latih(n,8) = CiriCorrelation;
    data_latih(n,9) = CiriEnergy;
    data_latih(n,10) = CiriHomogeneity;
    data_latih(n,11) = 1;
    noIK = noIK +1;
end
    
noIM = 1;
for i = 1+total_images_kansas+1:1+total_images_kansas+total_images_marguerite
    full_name_marguerite= fullfile(image_folder_marguerite, filenames_marguerite(noIM).name);
    img_filter = image_filtering_noise_removal(full_name_marguerite);
    img_segmentasi_roi = segmentasi_warna_roi(img_filter);
    
    Img = img_segmentasi_roi;
    Img = im2double(Img);
    % Ekstraksi Ciri Warna RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
    CiriR = mean2(R);
    CiriG = mean2(G);
    CiriB = mean2(B);
    %Ektrasksi Ciri HSV
    hsv = rgb2hsv(Img);
    hue = hsv(:, :, 1); % Hue image.    
   % saturation =1-3.*(min(min(R,G),B))./(R+G+B);
    saturation = hsv(:, :, 2); % Saturation image.  
    value = 1/3 *(R+G+B);

    CiriH = mean2(hue) * 255 ;
    CiriS = mean2(saturation) * 255;
    CiriV = mean2(value) * 255;
    %END
    % Ekstraksi Ciri Tekstur GLCM
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

    % Pembentukan data latih
    data_latih(i,1) = CiriR;
    data_latih(i,2) = CiriG;
    data_latih(i,3) = CiriB;
    data_latih(i,4) = CiriH;
    data_latih(i,5) = CiriS;
    data_latih(i,6) = CiriV;
    data_latih(i,7) = CiriContrast;
    data_latih(i,8) = CiriCorrelation;
    data_latih(i,9) = CiriEnergy;
    data_latih(i,10) = CiriHomogeneity;
    data_latih(i,11) = 2;
    noIM = noIM +1;
end

noIR = 1;
for j = 1+total_images_kansas+total_images_marguerite+1:1+total_images_kansas+total_images_marguerite+total_images_roses
    full_name_roses= fullfile(image_folder_roses, filenames_roses(noIR).name);
    img_filter = image_filtering_noise_removal(full_name_roses);
    img_segmentasi_roi = segmentasi_warna_roi(img_filter);
    
    Img = img_segmentasi_roi;
    Img = im2double(Img);
    % Ekstraksi Ciri Warna RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
    CiriR = mean2(R);
    CiriG = mean2(G);
    CiriB = mean2(B);
    %Ektrasksi Ciri HSV
    hsv = rgb2hsv(Img);
    hue = hsv(:, :, 1); % Hue image.  
    saturation = hsv(:, :,2);
   % saturation =1-3.*(min(min(R,G),B))./(R+G+B);
    value = 1/3 *(R+G+B);

    CiriH = mean2(hue) * 255 ;
    CiriS = mean2(saturation) * 255;
    CiriV = mean2(value) * 255;
    %END
    % Ekstraksi Ciri Tekstur GLCM
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

    % Pembentukan data latih
    data_latih(j,1) = CiriR;
    data_latih(j,2) = CiriG;
    data_latih(j,3) = CiriB;
    data_latih(j,4) = CiriH;
    data_latih(j,5) = CiriS;
    data_latih(j,6) = CiriV;
    data_latih(j,7) = CiriContrast;
    data_latih(j,8) = CiriCorrelation;
    data_latih(j,9) = CiriEnergy;
    data_latih(j,10) = CiriHomogeneity;
    data_latih(j,11) = 3;
    noIR = noIR +1;
end

noIT = 1;
for k = 1+total_images_kansas+total_images_marguerite+total_images_roses+1:1+total_images_kansas+total_images_marguerite+total_images_roses+total_images_tulips
    full_name_tulips= fullfile(image_folder_tulips, filenames_tulips(noIT).name);
    img_filter = image_filtering_noise_removal(full_name_tulips);
    img_segmentasi_roi = segmentasi_warna_roi(img_filter);
    
    Img = img_segmentasi_roi;
    Img = im2double(Img);
    % Ekstraksi Ciri Warna RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
    CiriR = mean2(R);
    CiriG = mean2(G);
    CiriB = mean2(B);
    %Ektrasksi Ciri HSV
    hsv = rgb2hsv(Img);
    hue = hsv(:, :, 1); % Hue image.  
    saturation = hsv(:, :,2);
   % saturation =1-3.*(min(min(R,G),B))./(R+G+B);
    value = 1/3 *(R+G+B);

    CiriH = mean2(hue) * 255 ;
    CiriS = mean2(saturation) * 255;
    CiriV = mean2(value) * 255;
    %END
    % Ekstraksi Ciri Tekstur GLCM
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

    % Pembentukan data latih
    data_latih(k,1) = CiriR;
    data_latih(k,2) = CiriG;
    data_latih(k,3) = CiriB;
    data_latih(k,4) = CiriH;
    data_latih(k,5) = CiriS;
    data_latih(k,6) = CiriV;
    data_latih(k,7) = CiriContrast;
    data_latih(k,8) = CiriCorrelation;
    data_latih(k,9) = CiriEnergy;
    data_latih(k,10) = CiriHomogeneity;
    data_latih(k,11) = 4;
    noIT = noIT +1;
end
s = xlswrite('data_training_new.xls',data_latih)
