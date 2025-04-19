function [features, labels] = simulate_mimo()
    % Parameters
    numUsers = 10;
    numBeams = 8;
    numSamples = 1000;

    % Simulated user positions and SNRs
    features = rand(numSamples, 3); % (x, y, velocity)
    labels = randi([1 numBeams], numSamples, 1); % Optimal beam index (1 to 8)

    % Visualize a basic SNR vs beam index (example)
    snrs = rand(1, numBeams) * 30; % random SNRs
    figure;
    bar(snrs);
    title('Example Beam SNRs');
    xlabel('Beam Index'); ylabel('SNR (dB)');
    saveas(gcf, 'results/beamforming_comparison.png');
end
