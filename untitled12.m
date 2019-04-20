
%%
clc,clear
name  = '/Users/liuhaoran/Documents/MATLAB/开题报告/平扫动静脉期实验数据/RawFiles-49/22776364/'
d = dir(name);
% d = dir('/Users/liuhaoran/Documents/Nodules-LIDC/恶性');
% d = dir('/Users/liuhaoran/Documents/Nodules-LIDC/良性');
% d = dir('/Users/liuhaoran/Documents/WL3/D25');
% d = dir('/Users/liuhaoran/Documents/WL3/D25中多个肺结节筛选');
isub = [d(:).isdir]; 
nameFolds = {d(isub).name}';
nd = length(nameFolds);
cont = 1;
% for nfile = 4:nd+1
    
    nfile = 5
    subfoldername = strcat(name, '/', d(nfile,1).name);
    files = dir([subfoldername,'/*.raw']);

%     
    %读取coord数据和new数据
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
    

    raw_con = 1;
    %ThreeDImages_New 归一化；肺结节roi区域提取
%     for k=1:nxyzraw_New(3)
        k = 2
        for j=1:nxyzraw_New(2)
            for i=1:nxyzraw_New(1)
%                 ThreeDImages_New(i,j,k) = rawdata_New((k-1)*irawxylong_New+(j-1)*nxyzraw_New(1)+i);
%                 if(ThreeDImages_New(i,j,k) < 0)
%                     ThreeDImages_New(i,j,k) = 0;
%                 end
%                 ThreeDImages_New(i,j,k) = uint8((ThreeDImages_New(i,j,k)/raw_max) * 255);%压缩灰度等级到256级
                if logical(ThreeDImages_Coord(i,j,k))==1
                    ThreeDImages_ROI(i,j)=ThreeDImages_New(i,j,k);
                    number(raw_con) = ThreeDImages_New(i,j,k);
                    raw_con =  raw_con+1;
                end
            end
        end
%     end
%     imshow(ThreeDImages_ROI,[])
    num_max = max(number)
    num_min = min(number)
    num_doubel = (number - num_min)/(num_max-num_min)
   
   imhist(num_doubel)
