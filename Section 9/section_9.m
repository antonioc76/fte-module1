case_name = sprintf("%d_%.2f_", pwm_start, inflow_vel);
t = time;

rpm = [bldc, can, transfer_fn, RPM_cmd];
soc = [bldc_soc, can_soc, tf_soc];
bcur = [bldc_bcur, can_bcur, tf_bcur];
cvol = [bldc_cvol, can_cvol, tf_cvol];

f = figure;
subplot(2,2,1);

plot(t, rpm(:, 1), 'color', 'red', 'DisplayName', 'electromechanical');
hold on
grid on
plot(t, rpm(:, 2), 'color', 'green', 'DisplayName', 'can ESC');
plot(t, rpm(:, 3), 'color', 'blue', 'DisplayName', 'transfer fn');
plot(t, rpm(:, 4), 'color', [1 0 1], 'DisplayName', 'RPM cmd (LUT)');

legend('Location','southeast');
xlabel('time (sec)');
ylabel('rotational velocity (RPM)');

subplot(2, 2, 2)

plot(t, soc(:, 1), 'DisplayName', 'electromechanical', 'Color', 'red');
hold on
grid on
plot(t, soc(:, 2), 'DisplayName', 'CAN ESC', 'Color', 'green');
plot(t, soc(:, 3), 'DisplayName', 'transfer fn', 'Color', 'blue');

xlabel('time (sec)');
ylabel('SoC (%)');

legend();

subplot(2,2, 3);

plot(t, bcur(:, 1), 'Color', 'red');
hold on
grid on
plot(t, bcur(:, 2), 'Color', 'green');
plot(t, bcur(:, 3), 'Color', 'blue');

legend('electromechanical', 'CAN ESC', 'transfer fn');

xlabel('time (sec)'); 
ylabel('current (A)');


subplot(2,2,4);

plot(t, cvol(:, 1), 'Color', 'red');
hold on
grid on
plot(t, cvol(:, 2), 'Color', 'green');
plot(t, cvol(:, 3), 'Color', 'blue');

legend('electromechanical', 'CAN ESC', 'transfer fn');
% legend('Location', 'southeast');
xlabel('time (sec)'); 
ylabel('voltage per cell (V)');

fig_name = sprintf("Section 9/%s_9_plots.fig", case_name);
png_name = sprintf("Section 9/%s_9_plots.png", case_name);

f.WindowState = "fullscreen";
savefig(f, fig_name);
saveas(f, png_name);

%% load torque and inflow
Q_load = [bldc_Q_load, can_Q_load, tf_Q_load];

idx_ss = find(t > 2.8 & t < 3.0);

rpm_ss(1) = mean(rpm(idx_ss, 1));
rpm_ss(2) = mean(rpm(idx_ss, 2));
rpm_ss(3) = mean(rpm(idx_ss, 3))

Q_load_ss(1) = mean(Q_load(idx_ss, 1));
Q_load_ss(2) = mean(Q_load(idx_ss, 2));
Q_load_ss(3) = mean(Q_load(idx_ss, 3))

f2 = figure;

subplot(2, 1, 1);

plot(t, rpm(:, 1), 'color', 'red', 'DisplayName', 'electromechanical');
hold on
grid on
plot(t, rpm(:, 2), 'color', 'green', 'DisplayName', 'can ESC');
plot(t, rpm(:, 3), 'color', 'blue', 'DisplayName', 'transfer fn');
plot(t, rpm(:, 4), 'color', [1 0 1], 'DisplayName', 'RPM cmd (LUT)');

legend('Location','southeast');
xlabel('time (sec)');
ylabel('rotational velocity (RPM)');

subplot(2,1,2);

plot(t, Q_load(:, 1), 'Color', 'red');
hold on
plot(t, Q_load(:, 2), 'Color', 'green');
plot(t, Q_load(:, 3), 'Color', 'blue');

legend('electromechanical', 'CAN ESC', 'transfer fn');

ylabel('Q_{load} (Nm)');
xlabel('time (sec)');

f2.WindowState = "fullscreen";

fig_name = sprintf("Section 9/%s_window.fig", case_name);
png_name = sprintf("Section 9/%s_window.png", case_name);

savefig(f2, fig_name);
saveas(f2, png_name);

close all

%% battery depletion
% delta_rpm = rpm(400, :) - rpm(end, :)
% delta_soc = soc(400, :) - soc(end, :)
% delta_cur = bcur(400, :) - bcur(end, :)
% delta_cvol = cvol(400, :) - cvol(end, :)
