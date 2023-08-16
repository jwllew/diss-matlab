try
    [filename, fullFilename] = videoFileSelector;
    [startFrame, endFrame, videoObj] = videoFrameSelector(fullFilename);
    framesLabel = frameLabelSelector();
    frameSplitter(startFrame, endFrame, videoObj, framesLabel, filename);
catch exception
    disp(['An error occurred: ' exception.message]);
end