load hospital

%% Question 1
weight_mu = mean(hospital.Weight);
weight_std = std(hospital.Weight);
weight_median = median(hospital.Weight);

weight_mu
weight_std
weight_median

fprintf('The median is less than the mean and so the data is skewed to the left.')

%% Question 2

weight_hist = histogram(hospital.Weight);
weight_hist

fprintf('The data fits a double bell curve with peaks in the 120-140 and 180-200 bins. So there is indeed a skew to the left (and also to the right). The fact that the left skew is larger results in the median weight being higher than the mean weight of the patients.')

%% Question 3

figure(1)
subplot(3,1,1)
weight_hist_bins10 = histogram(hospital.Weight, 10);
weight_hist_bins10
subplot(3,1,2)
weight_hist_bins20 = histogram(hospital.Weight, 20);
weight_hist_bins20
subplot(3,1,3)
[Numberofpatients, NA] = size(hospital.Weight);
weight_hist_binsNoPatients = histogram(hospital.Weight, Numberofpatients);
weight_hist_binsNoPatients

%% Question 4

[bin_num4, bin_loc4] = hist(hospital.Weight, 18);
P4 = bin_num4 / sum(bin_num4);
figure(2)
plot(bin_loc4, P4)
hold on

%% Question 5

nWeightAndGenderM = hospital.Weight(hospital.Sex == 'Male');
nWeightAndGenderF = hospital.Weight(hospital.Sex == 'Female');
nWeightAndSmoker = hospital.Weight(hospital.Smoker == 1);
nWeightAndNotSmoker = hospital.Weight(hospital.Smoker == 0);

[bin_num5SexM, bin_loc5SexM] = hist(nWeightAndGenderM, 18);
[bin_num5SexF, bin_loc5SexF] = hist(nWeightAndGenderF, 18);
[bin_num5S, bin_loc5S] = hist(nWeightAndSmoker, 18);
[bin_num5NS, bin_loc5NS] = hist(nWeightAndNotSmoker, 18);

P5NS = bin_num5NS / sum(bin_num5NS);
P5S = bin_num5S / sum(bin_num5S);
P5M = bin_num5SexM / sum(bin_num5SexM);
P5F = bin_num5SexF / sum(bin_num5SexF);



%% Question 6

figure(2)
plot(bin_loc5SexM, P5M)
plot(bin_loc5SexF, P5F)
title('Male vs Female')
legend('All', 'Male', 'Female')
hold off

figure(3)
plot(bin_loc4, P4)
hold on
plot(bin_loc5S, P5S)
plot(bin_loc5NS, P5NS)
title('Smoker vs Non-Smoker')
legend('All', 'Smoker', 'Non-Smoker')
hold off
