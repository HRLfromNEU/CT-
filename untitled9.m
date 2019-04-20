%%%�����鿴lidc���ݼ�
clc;clear;
% namespace = '/Users/liuhaoran/Documents/lidc1';
namespace = '/Users/liuhaoran/Documents/MATLAB/enhanceCT/dongmaizengqiang/1';
% namespace = '/Users/liuhaoran/Documents/WL3/D25';
% namespace = '/Users/liuhaoran/Documents/WL3/D25�ж���ν��ɸѡ';
d = dir(namespace);

isub = [d(:).isdir]; 
nameFolds = {d(isub).name}';
nd = length(nameFolds);
cont = 1;
%%
for nfile = 4:nd
    
%     nfile =5
    subfoldername = strcat(namespace, '/', d(nfile,1).name);
    files = dir([subfoldername,'/*.raw']);
  
%     if(strcmp({files(1).name},{'_IRIS51_fisoCoord.raw'}))
%         fidraw_Coord = fopen(strcat(subfoldername, '/', files(1).name));
%     else
%         fidraw_Coord = fopen(strcat(subfoldername, '/', files(2).name));
%     end
%     if(strcmp({files(2).name},{'_IRIS51_fisoNew.raw'}))
%         fidraw_New = fopen(strcat(subfoldername, '/', files(2).name));
%     else
%         fidraw_New = fopen(strcat(subfoldername, '/', files(1).name));
%     end
%     
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
%%
    ThreeDImages_Coord = reshape(rawdata_Coord,[nxyzraw_New(1),nxyzraw_New(2),nxyzraw_New(3)]);
%     ThreeDImages_New = zeros(nxyzraw_New(1),nxyzraw_New(2),nxyzraw_New(3));
    ThreeDImages_New = reshape(rawdata_New,[nxyzraw_New(1),nxyzraw_New(2),nxyzraw_New(3)]);
    ThreeDImages_ROI = zeros(nxyzraw_New(1),nxyzraw_New(2),nxyzraw_New(3));
    f = zeros(nxyzraw_New(1),nxyzraw_New(2),3,nxyzraw_New(3));
    raw_max = max(rawdata_New);
    firstpoint = rawdata_New(1);
    name = strcat(subfoldername, '*');
    %ThreeDImages_New ��һ�����ν��roi������ȡ
    for k=1:nxyzraw_New(3)
        for j=1:nxyzraw_New(2)
            for i=1:nxyzraw_New(1)
%                 ThreeDImages_New(i,j,k) = rawdata_New((k-1)*irawxylong_New+(j-1)*nxyzraw_New(1)+i);
                if(ThreeDImages_New(i,j,k) < 0)
                    ThreeDImages_New(i,j,k) = 0;
                end
%                 ThreeDImages_New(i,j,k) = uint8((ThreeDImages_New(i,j,k)/raw_max) * 255);%ѹ���Ҷȵȼ���256��
                ThreeDImages_New(i,j,k) = (ThreeDImages_New(i,j,k)/raw_max);%ѹ���Ҷȵȼ���256��
                f(i,j,:,k)=ThreeDImages_New(i,j,k);
                if logical(ThreeDImages_Coord(i,j,k))==1
%                     ThreeDImages_ROI(i,j,k)=ThreeDImages_New(i,j,k);
                    f(i,j,1,k)=1;
                    f(i,j,2,k)=0;
                    f(i,j,3,k)=0;
                    
                end
            end
        end
    end
%     name = strcat('/Users/liuhaoran/Documents/lidc1', '/', d(nfile,1).name,'/',num2str(k));
    num = sqrt(nxyzraw_New(3));
    num1 = fix(num);
    for k = 1:nxyzraw_New(3)

       
        % figure ������󻯣�������Ҳ���Ŵ��ڱ�����Ӧ���
        scrsz = get(0,'ScreenSize');  % ��Ϊ�˻����Ļ��С��Screensize��һ��4Ԫ������[left,bottom, width, height]
        set(gcf,'Position',scrsz);    % �û�õ�screensize��������figure��position���ԣ�ʵ����󻯵�Ŀ��
        subplot(num1+1,num1+1,k)
        imshow(f(:,:,:,k))
%         imshow(ThreeDImages_New(:,:,k))
    end
% %     nfile = 5;
    a=input('enter a numeber:');
     %% �����ļ�����
%     if a == 1
%         copyfile( name ,'/Users/liuhaoran/Documents/�ν�ڷ���/D25�ɷ�')
%     else
%         copyfile( name ,'/Users/liuhaoran/Documents/�ν�ڷ���/D25���ɷ�')
%     end
    %% 
    close all     
    
end