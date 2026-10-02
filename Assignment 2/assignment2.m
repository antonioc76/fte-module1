tolerance = 1e-6;
idx = mod(time, 2) >= 1.8 - tolerance;

RPM_ss = RPM(idx);
pwm_ss = pwm_cmd(idx);
time_ss = time(idx);

plot(time_ss, RPM_ss);

f = 1/100;

tau_ss = .2;

n = tau_ss / f;

RPM_bins = reshape(RPM_ss, n, []);
pwm_bins = reshape(pwm_ss, n, []);

RPM_avgs = mean(RPM_bins);
pwm = mode(pwm_bins);

plot(pwm, RPM_avgs, 'LineWidth', 1.5);

grid on

hold on

scatter(pwm, RPM_avgs, 'filled');

legend('trend', 'data');

set(gca, 'FontSize', 18, 'FontWeight', 'bold');

xlabel('PWM ({\mu}sec)')
ylabel('Speed (RPM)')

results_table = table;
results_table.pwm = pwm;
results_table.RPM = RPM_avgs;