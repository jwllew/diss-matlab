function frameSplitter(startFrame, endFrame, videoObj, label, inFile)
        % Create a new folder to save the extracted frames (optional)
        outputFolder = 'eye_frames';
        if ~exist(outputFolder, 'dir')
            mkdir(outputFolder);
        end
        totalToProcess = 1 + (endFrame - startFrame);
        x = 1;
        fprintf('Processing frames %d to %d (%d frames)\n. Frames to be stored in a folder named %s.\n', startFrame, endFrame, totalToProcess, outputFolder);
    
        targetHeight = 227;
        targetWidth = 227;
        % Loop through the desired frames and save each frame as an image file
        for frameNum = startFrame:endFrame
            % Read the current frame
            currentFrame = read(videoObj, frameNum);
            resizedFrame = imresize(currentFrame, [targetHeight, targetWidth]);
            % Save the frame as an image file in the output folder with the label as a subfolder
            labelOutputFolder = fullfile(outputFolder, label);
            if ~exist(labelOutputFolder, 'dir')
                mkdir(labelOutputFolder);
            end
    
            % [~, name1, ~] = fileparts(filename);
            name1 = strrep(inFile, '.', '_');
            frameFilename = sprintf('%s/%s_frame_%04d.jpg', labelOutputFolder, name1, frameNum);
            imwrite(resizedFrame, frameFilename);
    
            % Alternatively, you can perform any required processing on the frames here
    
            % Display some progress information (optional)
            fprintf('(%d/%d) Processing frame number %d\n', x, totalToProcess, frameNum)
            x = x+1;
        end
end
    
    
    
        % Optionally, you can return the names of the saved image files if needed
        % extractedFrameNames = dir(fullfile(outputFolder, '*.jpg'));
        % extractedFrameNames = {extractedFrameNames.name};

