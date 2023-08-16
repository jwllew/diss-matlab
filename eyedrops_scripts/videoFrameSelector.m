% function to select frames, export with a chosen label
    function [startFrame, endFrame, videoObj] = videoFrameSelector(inFile) 
        videoObj = VideoReader(inFile);
        numFrames = videoObj.NumberOfFrames;
        FramesStr = num2str(numFrames);
        fileLen = videoObj.Duration;
        minutes = floor(fileLen / 60);
        seconds = rem(fileLen, 60);
        if minutes ~= 0
            durationStr = sprintf('%d min and %.1f sec', minutes, seconds);
        else 
            durationStr = sprintf('%.1f sec', seconds);
        end
    
        % print video details
        fprintf('duration: %s. total frames: %s.\n', durationStr, FramesStr)

        
        function frame = getInput(prompt, minValue, maxValue)
            while true
                userInput = input(prompt, 's');
        
                if isempty(userInput) || isnan(str2double(userInput))
                    disp('Invalid input. Please enter a numeric value.');
                else
                    frame = str2double(userInput);
        
                    if frame >= minValue && frame <= maxValue
                        break;
                    else
                        disp(['Please enter a number between ' num2str(minValue) ' and ' num2str(maxValue)]);
                    end
                end
            end
        end
        fprintf("this script will process the selected video and save a chosen sequence of frames into\n" + ...
            "a labelled subdirectory within the directory 'eye_frames'.\n")

        startFrame = getInput('Enter the first frame number of your sequence: ', 1, numFrames);
        endFrame = getInput('Enter the last frame number: ', startFrame, numFrames);

           
        if endFrame > numFrames
            error('End frame exceeds the total number of frames in the video.');
        end
    
        if endFrame < startFrame
            error('End frame must be greater than or equal to the start frame.');
        end
    end