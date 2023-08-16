augmentations = {
    struct('name', 'rotation', 'prefix', 'rotate_', 'range', [-115, 150]), ...
    struct('name', 'brightness', 'prefix', 'brightness_', 'range', [0.2, 3]), ...
    struct('name', 'contrast', 'prefix', 'contrast_', 'range', [0.2, 3]), ...
    struct('name', 'flip', 'prefix', 'flip_', 'range', [0, 1]), ...
    struct('name', 'noise', 'prefix', 'noise_', 'range', [0.01, 0.1]), ...
    struct('name', 'crop', 'prefix', 'crop_', 'range', [0.7, 1])
};


parentFolder = 'eye_frames';
% subfolders = {'open_eye', 'closed_eye'};

subfolders = {};
items = dir(parentFolder);

for i = 1:numel(items)
    item = items(i);
    
    % check if the item is a dir and is not '.' or '..'
    if item.isdir && ~strcmp(item.name, '.') && ~strcmp(item.name, '..')
        subfolders{end+1} = item.name;
    end
end

for k = 1:length(subfolders)
    currentSubfolder = subfolders{k};
    subfolderPath = fullfile(parentFolder, currentSubfolder);
    
    imds = imageDatastore(subfolderPath, 'IncludeSubfolders', false);
    
    outputFolder = fullfile(parentFolder, currentSubfolder);
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end
    

    for i = 1:length(imds.Files)
        img = readimage(imds, i);
        
        [~, name, ext] = fileparts(imds.Files{i});
        
        for j = 1:length(augmentations)
            augmentedImg = applyAugmentation(img, augmentations{j});
            
            augmentedFilename = fullfile(outputFolder, ...
                ['aug_', augmentations{j}.prefix name ext]);
            
            imwrite(augmentedImg, augmentedFilename);
        end
    end
end


function augmentedImg = applyAugmentation(img, augmentation)
    switch augmentation.name
        case 'rotation'
            angle = randi(augmentation.range);
            augmentedImg = imrotate(img, angle, 'bilinear', 'crop');
        case 'brightness'
            scale = augmentation.range(1) + ...
                (diff(augmentation.range) * rand());
            augmentedImg = img * scale;
        case 'contrast'
            scale = augmentation.range(1) + ...
                (diff(augmentation.range) * rand());
            augmentedImg = img * scale;
        case 'flip'
            if rand() > 0
                augmentedImg = flip(img, 2);
            else
                augmentedImg = img;
            end
        case 'noise'
            noiseLevel = augmentation.range(1) + ...
                (diff(augmentation.range) * rand());
            augmentedImg = imnoise(img, 'gaussian', 0, noiseLevel);
        case 'crop'
            scale = augmentation.range(1) + ...
                (diff(augmentation.range) * rand());
            croppedWidth = round(size(img, 2) * scale);
            croppedHeight = round(size(img, 1) * scale);
            x = randi(size(img, 2) - croppedWidth + 1);
            y = randi(size(img, 1) - croppedHeight + 1);
            croppedImg = imcrop(img, [x, y, croppedWidth - 1, croppedHeight - 1]);
            augmentedImg = imresize(croppedImg, [227, 227]);
        otherwise
            augmentedImg = img;
    end
end