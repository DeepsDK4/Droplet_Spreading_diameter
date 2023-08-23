% Author: Deependra Kumar |IIT Madras
% Date: 24 June
% Objective: Detction of droplet and finds out its diameter and spreadidng
% over the time.
% Droplet properties: water with food coloring.
% Surface: Impacted surface is PMMA surface
clear all; close all;
%% Importing Video 
vid = VideoReader("PMMA.mp4")
num_frames = vid.NumFrames;
% implay("PMMA.mp4") % to play the video @ 30fps

%% Calibration factor
dia_mm = 2.65; % droplet dia for calibration (mm)
dia_ref = 81.963; % avg dia of frames upto 27 frames in pixels-
width_mm = (width*dia_mm)/dia_ref; % width of frames in mm
height_mm = (height*dia_mm)/dia_ref; % height of frames in mm
scale = width_mm/width; %mm/pixel
frameRate = 2000; %pixel/sec (actual fps of video)

%% applying loops for all the frames
dia = []; k = 1;
for n = 27:30 % change the frame iteration as per requirement
    frame = read(vid,n);
    figure(),subplot(221), imshow(frame); title(sprintf('Original image of frame number %d',n));
    % converting to hsv(hue, saturation, and value (HSV) values of an HSV image
    hsv = rgb2hsv(frame);
    hImage = hsv(:,:,1);
    sImage = hsv(:,:,2); % we will be using this (saturation) one
    vImage = hsv(:,:,3);
    bw = im2bw(sImage); %Binary Image
    subplot(222), imshow(bw), title(sprintf('binary image of frame number %d',n));
    hold on;
    impixelinfo;
    
    % Calculationof diameter of droplet
    stats = [regionprops(bw)]; %Extracting white parts of the binary image for creating rectangle
    Area = extractfield(stats,'Area'); % extracting Area from stats for sorting 
    dim = []; sort_area = sort(Area,'descend');
  
    for i = 1:numel(stats)
        if Area(i)>sort_area(2) 
            rectangle('Position', stats(i).BoundingBox, ...
        'Linewidth', 1, 'EdgeColor', 'r'); % Creating a recatangular box for visuals
            dim = extractfield(stats(i),'BoundingBox')
            dia(k) = dim(3) % dimension in pixels, use calibration factpr to convert it into your desire unit
        end 
        
    end
    k = k+1;
end
%% Plot b/w dia/spreading dia over the time
% find the time from frame rate and frames of the video then plot it.