clear, clc

max_frame_time = 0;

%open webcam object and define resolution to use
cam = webcam(1);
res = [160 120];  %[ width  height ] =
cam.Resolution = sprintf('%dx%d',res(1),res(2));

%define change detection area
transmit_period = 0.2;  %clock period of data transmission
reticle_size = 10;  %size of square in center of webcam view
h_bound = res(1)/2-reticle_size/2:res(1)/2+reticle_size/2;
v_bound = res(2)/2-reticle_size/2:res(2)/2+reticle_size/2;

%record screen with webcam and perform detection
detection = 0;
take_sample = 0;
ascii_ind = 1;
frame_time = zeros(1,10);
ascii_buff = zeros(1,8);
old_frame = zeros(res(2),res(1));
old_sample = zeros(res(2),res(1));

while 1   
    tic
    
    %take image and convert to black and white
    new_frame = snapshot(cam);
    new_frame = rgb2gray(new_frame);
    new_frame = imbinarize(new_frame);
    
    %show image with reticle
    show_frame = new_frame;
    show_frame(v_bound,res(1)/2-reticle_size/2) = 0; %left
    show_frame(v_bound,res(1)/2+reticle_size/2) = 0; %right
    show_frame(res(2)/2-reticle_size/2,h_bound) = 0; %bottom
    show_frame(res(2)/2+reticle_size/2,h_bound) = 0; %top
    if take_sample == 1 %show when sample occurs on visual
        show_frame(res(2)/2+reticle_size/2+10,h_bound) = 0; %top
    end
    imshow(show_frame);
    
    if ~detection  %search for start bit transmission
        change_val = detect_change(new_frame(v_bound,h_bound),old_frame,4);
        if change_val == 1 %contents of reticle go from white to black
            detection = 1;  %run ascii parse sequence
            take_sample = 1;
%             sample_time = 0;
            previous_bit = 1;
        end 
    end

    if detection && take_sample  %parse ascii bits until end sequence recorded
        sample_time = 0;
        take_sample = 0;
        
        %parse ascii stream
        change_val = detect_change(new_frame(v_bound,h_bound),old_sample,4);
        if change_val == 0
            ascii_buff(ascii_ind) = previous_bit;
        end
        if change_val == 1
            ascii_buff(ascii_ind) = 1;
            previous_bit = 1;
        end
        if change_val == -1
            ascii_buff(ascii_ind) = 0;
            previous_bit = 0;
        end
        
        old_sample = new_frame(v_bound,h_bound);
%         sample_mat{ascii_ind} = old_sample;
        
        ascii_ind = ascii_ind+1;
        
        %end parsing sequence and print out character when buffer is full
        if ascii_ind == 9
            detection = 0;
            ascii_ind = 1;
            ascii_char = char(bin2dec(int2str(ascii_buff(2:8))));
            fprintf('%s\n',ascii_char)
        end
    end
    
    old_frame = new_frame(v_bound,h_bound);   
    
    frame_time = toc;
    if detection
        sample_time = sample_time+frame_time;
        if (sample_time >= transmit_period)
            take_sample = 1;
        end
    end
end
