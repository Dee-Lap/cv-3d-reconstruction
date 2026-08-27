load('Subject4-Session3-Take4_mocapJoints.mat');
load('vue2CalibInfo.mat');
load('vue4CalibInfo.mat');

[statsTable, perFrameError, validFrameNums, L2all] = computeL2error(mocapJoints, vue2, vue4);

statsTable   % should be 13x5, all values very close to 0

plot(validFrameNums, perFrameError);
xlabel('Frame number'); ylabel('Total L2 error (12 joints)');
title('Reconstruction error across sequence');