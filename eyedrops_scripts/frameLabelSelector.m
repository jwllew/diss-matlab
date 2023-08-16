function label = frameLabelSelector()
    while true
        label = input(['\n' ...
            'In order to train the model on these frames, they must be labelled.\n' ...
            'the frames will be stored in a directory whose name becomes their label.\n' ...
            'labels can only consist of letters, numbers, hyphens and underscores.\n'...
            'suggested labels:  preEyedrop or postEyedrop.\n\n'...
            'Enter the label for the frames: '], 's');
        
        if isempty(label)
            error('The frames need a label in order to be used in AlexNet training.');
        end
        
        % Regular expression pattern to match valid labels
        validPattern = '^[a-zA-Z0-9_-]*$';
        
        if isempty(regexp(label, validPattern, 'once'))
            disp('Invalid label. The label can only consist of numbers, letters, underscores, and hyphens.');
        else
            break; % Valid label, exit the loop
        end
    end
end