function [outFilename, outFullFile] = videoFileSelector()
        mainDirectory = pwd;
        
        % detect subfolder
        subfolders = dir(fullfile(mainDirectory, '*'));
        subfolderNames = {subfolders([subfolders.isdir]).name};
        subfolderNames = subfolderNames(~ismember(subfolderNames, {'.', '..'}));


        
        videoSubfolders = {};
        videoFiles = [];
        for i = 1:numel(subfolderNames)
            subfolder = fullfile(mainDirectory, subfolderNames{i});
            
            aviFiles = dir(fullfile(subfolder, '*.avi'));
            mp4Files = dir(fullfile(subfolder, '*.mp4'));
            mkvFiles = dir(fullfile(subfolder, '*.mkv'));
            movFiles = dir(fullfile(subfolder, '*.mov'));
            videoFiles = [aviFiles; mp4Files; mkvFiles, movFiles];
            if ~isempty(videoFiles)
                videoSubfolders{end+1} = subfolderNames{i};
            end
        end

        if numel(videoSubfolders) == 0
            error('No subfolder containing videos found.');
        elseif numel(videoSubfolders) > 1
            disp('subfolders with video files: ')
            disp(videoSubfolders)
            error('More than one subfolder contains videos. Please organize your data.');
        end
        if numel(videoSubfolders) == 1
            subfolder = fullfile(mainDirectory, videoSubfolders{1});
            disp(['folder containing video files: ' videoSubfolders{1}])
            aviFiles = dir(fullfile(subfolder, '*.avi'));
            mp4Files = dir(fullfile(subfolder, '*.mp4'));
            mkvFiles = dir(fullfile(subfolder, '*.mkv'));
            movFiles = dir(fullfile(subfolder, '*.mov'));
            videoFiles = [aviFiles; mp4Files; mkvFiles, movFiles];
            
        end
        disp('List of video files in the subfolder:');
        for i = 1:numel(videoFiles)
            disp(['(' num2str(i) ') ' videoFiles(i).name]);
        end
        
        choice = input('Enter the number corresponding to the video file you wish to use: ');
        
        if isempty(choice) || ~isnumeric(str2double(choice))
            error('Invalid input. Please enter a numeric value.');
        end
        
        if choice < 1 || choice > numel(videoFiles)
            error('Invalid choice');
        end
    
        outFilename = videoFiles(choice).name;
        disp(['chosen file: ' outFilename])
        outFullFile = fullfile(subfolder, outFilename);

    end
