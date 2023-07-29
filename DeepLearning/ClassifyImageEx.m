%% Example 1. Using a Pretrained Network

%% Load AlexNet

net = alexnet;

net.Layers(1)

%% Load the first image

img = imread('file1.jpg');

imshow(img)

%% Resize the image

imgSize = size(img)

img = imresize(img, [227 227]);

imshow(img)

%% Classify the image

pred = classify(net, img)