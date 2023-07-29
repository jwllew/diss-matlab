%% Example 2. Transfer Learning

%% Load AlexNet

net = alexnet;

%% Create an image datastore

imds = imageDatastore('flowers', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

%% Split the data

[train, test] = splitEachLabel(imds, 0.8, 'randomized');

%% Modify layers of AlexNet

layers = net.Layers;

fc = fullyConnectedLayer(5);
layers(23) = fc;

layers(end) = classificationLayer;

%% Set training options

options = trainingOptions('sgdm', ...
    'MiniBatchSize', 10, ...
    'MaxEpochs', 2, ...
    'InitialLearnRate', 3e-4, ...
    'Shuffle', 'every-epoch', ...
    'Verbose', false, ...
    'Plots', 'training-progress');

%% Train the network

flwrnet = trainNetwork(train, layers, options);

%% Evaluate performance

preds = classify(flwrnet, test);

actual = test.Labels;

numCorrect = nnz(preds == actual);

fracCorrect = numCorrect/length(actual);

confusionchart(actual, preds);