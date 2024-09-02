clear all; clc;

N = 100;  
sigma = 2;  
noise_std = 2;  

video_reader = VideoReader('sevenup.m4v');

% Create output video file
output_file = 'tracking.avi';
video_writer = VideoWriter(output_file);
open(video_writer);

% Initialize particles
x0 = 174;  
y0 = 81;  
particles = repmat([x0; y0], 1, N) + noise_std*randn(2, N);
weights = ones(1, N)/N;


while hasFrame(video_reader)
    
    frame = readFrame(video_reader);
    edges = edge(im2gray(frame), 'Canny');
   
    distances = bwdist(edges);
    likelihoods = exp(-distances.^2/(2*sigma^2));

    if sum(likelihoods(:))==0
        break;
    end

    particles = round(min(max(1, particles), [size(frame, 2); size(frame, 1)]));
    weights = likelihoods(sub2ind(size(frame), particles(2,:), particles(1,:)));
    weights = weights./sum(weights);

    resampled_particles = zeros(2, N);
    for i = 1:N
        idx = randsample(N, 1, true, weights);
        resampled_particles(:,i) = particles(:,idx);
    end
    particles = resampled_particles + noise_std*randn(2, N);
    
    estimated_location = mean(resampled_particles, 2);
    
    % Draw bounding box around estimated location
    bbox_x = max(1, round(estimated_location(1)-20));
    bbox_y = max(1, round(estimated_location(2)-20));
    bbox_w = min(size(frame,2)-bbox_x, 40);
    bbox_h = min(size(frame,1)-bbox_y, 40);
    bbox = [bbox_x, bbox_y, bbox_w, bbox_h];
    frame_with_bbox = insertShape(frame, 'Rectangle', bbox, 'LineWidth', 2);
    
    % Write out frame with bounding box to output video
    writeVideo(video_writer, frame_with_bbox);
end

% Close video writer
close(video_writer);





