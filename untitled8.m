%��ȡraw�ļ�����roi����ֱ��ͼ���⻯��ѹ���Ҷȵȼ��������µ�raw�ļ�
%
clc,clear

d = dir('/Users/liuhaoran/Documents/MATLAB/pingsaoshujuzhifangtu/pingsao_new/0');
% d = dir('/Users/liuhaoran/Documents/Nodules-LIDC/����');
% d = dir('/Users/liuhaoran/Documents/Nodules-LIDC/����');
% d = dir('/Users/liuhaoran/Documents/WL3/D25');
% d = dir('/Users/liuhaoran/Documents/WL3/D25�ж���ν��ɸѡ');
isub = [d(:).isdir]; 
nameFolds = {d(isub).name}';
nd = length(nameFolds);

% for nfile = 4:nd
    
    nfile = 8
    subfoldername = strcat('/Users/liuhaoran/Documents/MATLAB/pingsaoshujuzhifangtu/pingsao_new/0', '/', d(nfile,1).name);
    files = dir([subfoldername,'/*.raw']);
  

    %��ȡcoord���ݺ�new����
    if(strfind(files(1).name,'Coord'))
        fidraw_Coord = fopen(strcat(subfoldername, '/', files(1).name));
    else
        fidraw_Coord = fopen(strcat(subfoldername, '/', files(2).name));
    end
    if(strfind(files(2).name,'New'))
        fidraw_New = fopen(strcat(subfoldername, '/', files(2).name));
    else
        fidraw_New = fopen(strcat(subfoldername, '/', files(1).name));
    end
    
    
    nxyzraw_Coord = fread(fidraw_Coord, 3, 'int');
    fxyzraw_Coord = fread(fidraw_Coord, 3, 'float');
    irawlong_Coord = nxyzraw_Coord(1)*nxyzraw_Coord(2)*nxyzraw_Coord(3);
    irawxylong_Coord = nxyzraw_Coord(1)*nxyzraw_Coord(2);
    rawdata_Coord = fread(fidraw_Coord, irawlong_Coord, 'short');
    
    nxyzraw_New = fread(fidraw_New, 3, 'int');
    fxyzraw_New = fread(fidraw_New, 3, 'float');
    irawlong_New = nxyzraw_New(1)*nxyzraw_New(2)*nxyzraw_New(3);
    irawxylong_New = nxyzraw_New(1)*nxyzraw_New(2);
    rawdata_New = fread(fidraw_New, irawlong_New, 'short');


    ThreeDImages_Coord = reshape(rawdata_Coord,[nxyzraw_New(1),nxyzraw_New(2),nxyzraw_New(3)]);
    ThreeDImages_New = reshape(rawdata_New,[nxyzraw_New(1),nxyzraw_New(2),nxyzraw_New(3)]);
    ThreeDImages_ROI = zeros(nxyzraw_New(1),nxyzraw_New(2),nxyzraw_New(3));

%     raw_max = max(rawdata_New);
%     firstpoint = rawdata_New(1);
    

%     raw_con = 1;
    %�����µı�Ǿ���
    ThreeDImages_Coord_new = logical(ThreeDImages_Coord(:,:,:));
    

    %�Էν�ڱ����������һ�����ص�
%     for k=1:nxyzraw_New(3)
%         ThreeDImages_Coord_new(:,:,k) = 
%     end
    
    
    %ThreeDImages_New ��һ�����ν��roi������ȡ
    for k=1:nxyzraw_New(3)
        for j=1:nxyzraw_New(2)
            for i=1:nxyzraw_New(1)
%                 ThreeDImages_New(i,j,k) = rawdata_New((k-1)*irawxylong_New+(j-1)*nxyzraw_New(1)+i);
%                 if(ThreeDImages_New(i,j,k) < 0)
%                     ThreeDImages_New(i,j,k) = 0;
%                 end
%                 ThreeDImages_New(i,j,k) = uint8((ThreeDImages_New(i,j,k)/raw_max) * 255);%ѹ���Ҷȵȼ���256��
                if logical(ThreeDImages_Coord(i,j,k))==1
                    ThreeDImages_ROI(i,j,k)=ThreeDImages_New(i,j,k);
%                     number(raw_con) = ThreeDImages_New(i,j,k);
%                     raw_con =  raw_con+1;
                end
            end
        end
    end
    
%ֱ��ͼ���⻯
new_raw_roi = zeros(nxyzraw_New(1),nxyzraw_New(2),nxyzraw_New(3));

for k=1:nxyzraw_New(3)
    I = ThreeDImages_New(:,:,k);
    f_max = max(max(f(f(:,:,K)~=0)));
    f_min = min(min(f(f(:,:,K)~=0)));
    
    
end





% f = ThreeDImages_New(:,:,1);
% f_max = max(max(f(f(:,:)~=0)));
% f_min = min(min(f(f(:,:)~=0)));

%%
%%ֱ��ͼ���⻯

I = f;
[height,width] = size(I);
figure
subplot(221)
imshow(I,[])%��ʾԭʼͼ��
subplot(222)
imhist(I)%��ʾԭʼͼ��ֱ��ͼ
 
%�������ػҶ�ͳ��;
a = f_max-f_min+1;%�Ҷȵȼ���Χ
NumPixel = zeros(1,f_max-f_min+1);%ͳ�Ƹ��Ҷ���Ŀ����256���Ҷȼ�
for i = 1:height
    for j = 1: width
        if logical(ThreeDImages_Coord(i,j,1))==1
            NumPixel(I(i,j) -f_min + 1) = NumPixel(I(i,j) -f_min + 1) + 1;%��Ӧ�Ҷ�ֵ���ص���������һ
        end
    end
end
%����Ҷȷֲ��ܶ�
ProbPixel = zeros(1,a);
for i = 1:a
    ProbPixel(i) = NumPixel(i) / (sum(sum(f~=0)) * 1.0);
end
%�����ۼ�ֱ��ͼ�ֲ�
CumuPixel = zeros(1,a);
for i = 1:a
    if i == 1
        CumuPixel(i) = ProbPixel(i);
    else
        CumuPixel(i) = CumuPixel(i - 1) + ProbPixel(i);
    end
end
%�ۼƷֲ�ȡ��
CumuPixel = uint8(256 .* CumuPixel + 0.5);
%�ԻҶ�ֵ����ӳ�䣨���⻯��
for i = 1:height
    for j = 1: width
        if logical(ThreeDImages_Coord(i,j,1))==1
            I(i,j) = CumuPixel(I(i,j)-f_min+1);
        end
    end
end
I=uint8(I(:,:));
subplot(223)
imshow(I,[])%��ʾԭʼͼ��
subplot(224)
imhist(I)%��ʾԭʼͼ��ֱ��ͼ


I1 = I(:,:)+20;



ff = imread('1.png');
ff1 = rgb2gray(ff);
ff2 = double(ff);
ff3 = uint8(ff2);