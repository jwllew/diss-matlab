imds = imageDatastore('eye_frames', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
imageSize = [227 227 3];


[eyeImdsTrain,eyeImdsTest] = splitEachLabel(imds,0.7,'randomized');


numTrainImages = numel(eyeImdsTrain.Labels);
idx = randperm(numTrainImages,16);
figure
for i = 1:16
    subplot(4,4,i)
    I = readimage(eyeImdsTrain,idx(i));
    imshow(I)
end

net = alexnet;
layersTransfer = net.Layers(1:end-3);
inputSize = net.Layers(1).InputSize;


numClasses = numel(categories(eyeImdsTrain.Labels));

layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];


% Specified data augmentation settings
pixelRange = [-30 30];
imgAug = imageDataAugmenter( ...
    'RandRotation',@() -20+40*rand, ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',[1,2], ...
    'RandYReflection', true, ...
    'RandYScale',[1,2]);

augEyesTrain = augmentedImageDatastore(inputSize(1:2), eyeImdsTrain, 'DataAugmentation', imgAug);
augEyesTest = augmentedImageDatastore(inputSize(1:2),eyeImdsTest);

% Specified training options with augmentation
options = trainingOptions('sgdm', ...
   'MiniBatchSize', 10, ...
   'MaxEpochs', 2, ...
   'InitialLearnRate', 3e-4, ...
   'Shuffle', 'every-epoch', ...
   'ValidationData',augEyesTest, ...
   'ValidationFrequency',3, ...
   'Verbose', true, ...
   'Plots', 'training-progress');    
eyenet = trainNetwork(augEyesTrain, layers, options);
 
[pred,scores] = classify(eyenet,augEyesTest);

idx = randperm(numel(eyeImdsTest.Files),4);
figure
for i = 1:4
    subplot(2,2,i)
    I = readimage(eyeImdsTest,idx(i));
    imshow(I)
    label = pred(idx(i));
    title(string(label));
end

vals = eyeImdsTest.Labels;
accuracy = mean(pred == vals)
