
fs = 30000;
mic_distance = 0.2; 
speed_of_sound = 343;
threshold = 0.2;


audioFiles = {'sample1.wav','sample2.wav','sample3.wav'};


for fileIdx = 1:length(audioFiles)

    [audioData, fs] = audioread(audioFiles{fileIdx});


    mic1_signal = audioData(:, 1); 
    mic2_signal = audioData(:, 2); 

    
    gunshot_detected = find(abs(mic1_signal) > threshold, 1);

    if isempty(gunshot_detected)
        disp(['No gunshot detected in ', audioFiles{fileIdx}, '.']);
        continue;
    else
        
        toa_mic1 = gunshot_detected / fs;
        toa_mic2 = find(abs(mic2_signal) > threshold, 1) / fs;

        
        tdoa = toa_mic2 - toa_mic1;

        
        angle_of_arrival = asin(tdoa * speed_of_sound / mic_distance) * (180 / pi);

        
        if angle_of_arrival < 0
            angle_of_arrival = angle_of_arrival + 360;
        end

        
        if angle_of_arrival >= 315 || angle_of_arrival < 30
            direction = 'Front';
        elseif angle_of_arrival >= 30 && angle_of_arrival < 65
            direction = 'Forward Front';
        elseif angle_of_arrival >= 65 && angle_of_arrival < 136
            direction = 'Left';
        elseif angle_of_arrival >= 135 && angle_of_arrival < 225
            direction = 'Back';
        elseif angle_of_arrival >= 225 && angle_of_arrival < 315
            direction = 'Right';
        end

       
        sound(audioData, fs);
       
        pause(2);

       
        disp(['Gunshot detected in ', audioFiles{fileIdx}, ' at ', num2str(angle_of_arrival), ' degrees']);
        disp(['Direction: ', direction]);

       
        figure;
        polarplot(deg2rad(angle_of_arrival), 1, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
        title(['Alert Gunshot Arriving From: ', direction]);
        rlim([0 1]);
    end
end
