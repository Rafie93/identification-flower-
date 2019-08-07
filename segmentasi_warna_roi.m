%Create By Rafi'e
%Magiseter Ilmu Komputer Budi Luhur 2018
function[ImageSegmentasi]=segmentasi_warna_roi(RGB)
RGB = imresize(RGB,[256,256]);
BG = zeros(256,256,3);
BG = uint8(BG);
% Melakukan transformasi ruang warna citra yang semula RGB menjadi HSV
HSV = rgb2hsv(RGB);
H = HSV(:,:,1);
range = [100 250]/360; 
mask = (H>range(1)) & (H<range(2));
mask = imcomplement(mask);
mask = imfill(mask,'holes');
mask = bwareaopen(mask,100);
str = strel('disk',5);
mask = imerode(mask,str);

%Gabungkan BG Hitam dengan Hasil Deteksi Wilayah
R = RGB(:,:,1);
G = RGB(:,:,2);
B = RGB(:,:,3);

R2 = BG(:,:,1);
G2 = BG(:,:,2);
B2 = BG(:,:,3);
 
R2(mask) = R(mask);
G2(mask) = G(mask);
B2(mask) = B(mask);
ImageSegmentasi = cat(3,R2,G2,B2);