% findErrorExtremesTest.m
load('Subject4-Session3-Take4_mocapJoints.mat');
load('vue2CalibInfo.mat');
load('vue4CalibInfo.mat');

[statsTable, perFrameError, validFrameNums, L2all] = computeL2error(mocapJoints, vue2, vue4);

% plot total error across the sequence
figure;
plot(validFrameNums, perFrameError);
xlabel('Mocap frame number');
ylabel('Total L2 error (sum across 12 joints)');
title('Reconstruction error across full sequence');

% find the min and max error frames
[minErr, minIdx] = min(perFrameError);
[maxErr, maxIdx] = max(perFrameError);

minFrame = validFrameNums(minIdx);
maxFrame = validFrameNums(maxIdx);

fprintf('Minimum total error: %.6e at frame %d\n', minErr, minFrame);
fprintf('Maximum total error: %.6e at frame %d\n', maxErr, maxFrame);

% mark them on the plot
hold on;
plot(minFrame, minErr, 'go', 'MarkerSize', 10, 'LineWidth', 2);
plot(maxFrame, maxErr, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
legend('Total error', 'Min error frame', 'Max error frame');