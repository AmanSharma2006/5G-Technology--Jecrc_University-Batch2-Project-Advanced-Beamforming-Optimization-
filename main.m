clc; clear; close all;

disp('Starting Beamforming Optimization Simulation...');

% Simulate MIMO system
[features, labels] = simulate_mimo();

% Train DNN for beam prediction
net = dnn_model(features, labels);  % <-- Capture the trained network

% Save features and labels as CSV
writematrix(features, 'features.csv');
writematrix(double(labels), 'labels.csv');  % Convert from categorical if needed

% Predict using the trained model
predicted_labels = classify(net, features);  % Categorical
predicted_beams = double(predicted_labels);  % Convert to numeric

% Save predicted beams
writematrix(predicted_beams, 'predicted_beams.csv');

% Conventional SNR
snr_conv = conventional_beamforming(features);

% Estimate AI SNR (replace with your real method if needed)
snr_ai = sum(features .* predicted_beams, 2);  % Placeholder

% Save SNR results
writematrix(snr_conv, 'snr_conventional.csv');
writematrix(snr_ai, 'snr_ai.csv');

% Plotting SNR Comparison
figure;
plot(snr_conv, '-o', 'DisplayName', 'Conventional Beamforming');
hold on;
plot(snr_ai, '-x', 'DisplayName', 'AI-Driven Beamforming');
xlabel('User Index');
ylabel('SNR');
title('SNR Comparison: Conventional vs AI-Driven Beamforming');
legend;
grid on;
saveas(gcf, 'snr_comparison.png');  % Save plot

disp('Simulation Completed.');
