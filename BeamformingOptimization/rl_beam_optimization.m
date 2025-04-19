function rl_beam_optimization()

    % Observation space: x, y, velocity
    obsInfo = rlNumericSpec([3 1], 'LowerLimit', [0; 0; 0], 'UpperLimit', [1; 1; 1]);
    obsInfo.Name = 'agentStates';

    % Action space: beam index
    actInfo = rlFiniteSetSpec(1:4); % 4 possible beams
    actInfo.Name = 'beamDirection';

    % Create environment
    env = rlFunctionEnv(obsInfo, actInfo, @stepFunction, @resetFunction);

    % Define neural network for Q-value function
    dnn = [
        featureInputLayer(3, 'Normalization', 'none', 'Name', 'input')
        fullyConnectedLayer(24, 'Name', 'fc1')
        reluLayer('Name', 'relu1')
        fullyConnectedLayer(24, 'Name', 'fc2')
        reluLayer('Name', 'relu2')
        fullyConnectedLayer(numel(actInfo.Elements), 'Name', 'output')];

    options = rlRepresentationOptions('LearnRate',1e-3,'GradientThreshold',1);
    rep = rlQValueRepresentation(dnn, obsInfo, actInfo, ...
        'Observation', {'input'}, repOptions=options);

    % DQN agent options
    agentOpts = rlDQNAgentOptions(...
        'SampleTime', 1, ...
        'ExperienceBufferLength', 1000, ...
        'DiscountFactor', 0.99, ...
        'MiniBatchSize', 64);

    agent = rlDQNAgent(rep, agentOpts);

    % Training options
    trainOpts = rlTrainingOptions(...
        'MaxEpisodes', 20, ...
        'MaxStepsPerEpisode', 50, ...
        'Verbose', false, ...
        'Plots', 'training-progress');

    % Train agent
    train(agent, env, trainOpts);
end

%% --- Reset Function ---
function [initialObs, loggedSignals] = resetFunction()
    x = rand();
    y = rand();
    v = rand();
    initialObs = [x; y; v];
    loggedSignals = [];  % Not used here
end

%% --- Step Function ---
function [nextObs, reward, isDone, loggedSignals] = stepFunction(action, loggedSignals)
    % Randomly simulate next state
    x = rand(); y = rand(); v = rand();
    nextObs = [x; y; v];

    % Reward logic: just a placeholder
    if action == 2 || action == 3
        reward = 1;
    else
        reward = -1;
    end

    isDone = false;           % Continue episode
    loggedSignals = [];       % No logging in this basic version
end
