%% Example 3. Building a neural network from scratch

%% Create an image datastore

% Retrieve the path to the demo dataset

digitDatasetPath = fullfile(matlabroot, 'toolbox','nnet','nndemos','nndatasets','DigitDataset');


% Create image datastore

imds = imageDatastore(digitDatasetPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

%% Split the data

[train, test] = splitEachLabel(imds, 0.8, 'randomized');

%% Define the network architecture (the layers)

layers = [...
    imageInputLayer([28 28 1])
    convolution2dLayer(5,20)
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];


%% Set your training options

options = trainingOptions('sgdm', ...
    'MaxEpochs', 20, ...
    'InitialLearnRate', 1e-4, ...
    'Verbose', false, ...
    'Plots', 'training-progress');

%% Train the network

net = trainNetwork(train, layers, options);

%% Evaluate the network

preds = classify(net, test);

actual = test.Labels;

numCorrect = nnz(preds == actual);

fracCorrect = numCorrect/length(actual);

confusionchart(actual, preds)