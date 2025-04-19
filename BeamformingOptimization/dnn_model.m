function net = dnn_model(features, labels)
    % Convert labels to categorical
    labels = categorical(labels);

    % Define DNN structure
    layers = [
        featureInputLayer(size(features, 2))
        fullyConnectedLayer(32)
        reluLayer
        fullyConnectedLayer(16)
        reluLayer
        fullyConnectedLayer(numel(unique(labels)))
        softmaxLayer
        classificationLayer];

    % Training options
    options = trainingOptions('adam', ...
        'MaxEpochs', 15, ...
        'Verbose', false, ...
        'Plots', 'training-progress');

    % Train the network
    net = trainNetwork(features, labels, layers, options);

    % Save the model
    save('beamforming_dnn.mat', 'net');
end
