% produces NOAA-style colorbar
%
% (c) Andrew Howe 2005
% 2005 June 6
%
% input a value for the resolution you desire
% 64 is MatLab's standard
% 128 is default
% 256 looks mighty smooth

function [gradient] = noaa_colorgradient(resolution);



if (nargin < 1)
    resolution = 128;
end
if ( (nargin ~= 1) && ~(nargin == 0))
    error('ERROR:function takes 1 argument')
end
if (resolution < 8)
    error('ERROR:invalid resolution')
end

%resolution=256;
gradient=zeros(resolution,3);

%build start and end points
p2=floor(.30*resolution);
p3=floor(.45*resolution);
p4=floor(.55*resolution);
p5=floor(.75*resolution);
p6=floor(.8*resolution);
p7=floor(.9*resolution);

%red
addand1=(1/(p2-1));
gradient(1,:)=[1 0 0];
for i=2:p2
    gradient(i,:)=gradient(i-1,:);
    gradient(i,2)=gradient(i,2)+addand1;
end

% yellow
addand1=(1/abs(p2-p3));
for i=(p2+1):p3
    gradient(i,:)=gradient(i-1,:);
    gradient(i,1)=gradient(i,1)-addand1;
end

% green
addand1=(1/abs(p3-p4));
for i=(p3+1):p4
    gradient(i,:)=gradient(i-1,:);
    gradient(i,3)=gradient(i,3)+addand1;
end

% indigo
addand1=(.28/abs(p4-p5));
addand2=(.54/abs(p4-p5));
addand3=(.30/abs(p4-p5));
for i=(p4+1):p5
    gradient(i,:)=gradient(i-1,:);
    gradient(i,1)=gradient(i,1)+addand1;
    gradient(i,2)=gradient(i,2)-addand2;
    gradient(i,3)=gradient(i,3)-addand3;
end

% purple/violet
gradient(p5+1,:)=[.88 .56 .87];
addand1=(.42/(abs(p5-p6)));
addand2=(.56/(abs(p5-p6)));
addand3=(.33/(abs(p5-p6)));
for i=(p5+2):p6
    gradient(i,:)=gradient(i-1,:);
    gradient(i,1)=gradient(i,1)-addand1;
    gradient(i,2)=gradient(i,2)-addand2;
    gradient(i,3)=gradient(i,3)-addand3;
end

% blue
addand1=(.46/(abs(p6-p7)));
addand3=(.26/(abs(p6-p7)));
for i=(p6+1):p7
    gradient(i,:)=gradient(i-1,:);
    gradient(i,1)=gradient(i,1)-addand1;
    gradient(i,3)=gradient(i,3)-addand3;
end

% I messed up the order, so flip the gradient and then
% build the grayscale gradient
gradient=flipud(gradient);

%build grayscale tail
addand1=1/((resolution+1)/4);
gradient((1),:)=1;
%for i = ((resolution-(resolution-p7))+2):resolution
for i = 2:(resolution-p7)
    gradient(i,:)=gradient(i-1,:);
    gradient(i,:)=gradient(i,:)-addand1;
end



%Error messages
if ( (min(gradient)) < 0 ) 
        error('ERROR: there is a negative value in the gradient')
end
if ( (max(gradient)) > 1 )
    error('ERROR: there is a value larger than 1 in the gradient')
end
