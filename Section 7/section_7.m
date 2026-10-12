step_name = sprintf("%d_%d", pwm_start, delta_pwm);
t = time;
idx_0 = find(t > 1.8 & t < 2.0);
idx_f = find(t > 4.8 & t < 5.0);
idx_step = find(t > 2.0 & t < 5.0);

rpm = [bldc, can, transfer_fn, RPM_cmd];
soc = [bldc_soc, can_soc, tf_soc];
bcur = [bldc_bcur, can_bcur, tf_bcur];
cvol = [bldc_cvol, can_cvol, tf_cvol];

N_0 = mean(rpm(idx_0, :), 1);

N_f = mean(rpm(idx_f, :), 1);

delta = N_f - N_0;

norm = (rpm - N_0) ./ delta;

t10_idx(1) = find(norm(idx_step, 1) > 0.1, 1, 'first') + idx_step(1);
t10_idx(2) = find(norm(idx_step, 2) > 0.1, 1, 'first') + idx_step(1);
t10_idx(3) = find(norm(idx_step, 3) > 0.1, 1, 'first') + idx_step(1);

t90_idx(1) = find(norm(idx_step, 1) > 0.9, 1, 'first') + idx_step(1);
t90_idx(2) = find(norm(idx_step, 2) > 0.9, 1, 'first') + idx_step(1);
t90_idx(3) = find(norm(idx_step, 3) > 0.9, 1, 'first') + idx_step(1);

tsettle_idx(1) = find(abs(norm(idx_step, 1) - 0.98) < 1e-2, 1, 'last') + idx_step(1)
tsettle_idx(2) = find(abs(norm(idx_step, 2) - 0.98) < 1e-2, 1, 'last') + idx_step(1)
tsettle_idx(3) = find(abs(norm(idx_step, 3) - 0.98) < 1e-2, 1, 'last') + idx_step(1)

tr = t(t90_idx) - t(t10_idx)

tsettle = t(tsettle_idx)

set(groot, 'defaultLineLineWidth', 1.5);
f = figure;

subplot(2, 2, 1);

plot(t, rpm(:, 1), 'color', 'red', 'DisplayName', 'electromechanical');
hold on
grid on
plot(t, rpm(:, 2), 'color', 'green', 'DisplayName', 'can ESC');
plot(t, rpm(:, 3), 'color', 'blue', 'DisplayName', 'transfer fn');
plot(t, rpm(:, 4), 'color', [1 0 1], 'DisplayName', 'RPM cmd (LUT)');

legend('Location','southeast');
xlabel('time (sec)');
ylabel('rotational velocity (RPM)');

% 
% scatter(t(t10_idx(1)), norm(t10_idx(1), 1), 'color', 'red');
% scatter(t(t10_idx(2)), norm(t10_idx(2), 2), 'color', 'green');
% scatter(t(t10_idx(3)), norm(t10_idx(3), 3), 'color', 'blue');
% 
% scatter(t(t90_idx(1)), norm(t90_idx(1), 1));
% scatter(t(t90_idx(2)), norm(t90_idx(2), 2));
% scatter(t(t90_idx(3)), norm(t90_idx(3), 3));

scatter(t(tsettle_idx(1)), rpm(tsettle_idx(1), 1), 'red', 'DisplayName', 'bldc(\tau_{0.98})');
scatter(t(tsettle_idx(2)), rpm(tsettle_idx(2), 2), 'green', 'DisplayName', 'can(\tau_{0.98})');
scatter(t(tsettle_idx(3)), rpm(tsettle_idx(3), 3), 'blue', 'DisplayName', 'tf(\tau_{0.98})');

subplot(2, 2, 2)

plot(t, soc(:, 1), 'DisplayName', 'electromechanical');
hold on
grid on
plot(t, soc(:, 2), 'DisplayName', 'CAN ESC');
plot(t, soc(:, 3), 'DisplayName', 'transfer fn');

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
legend('Location', 'southeast');
xlabel('time (sec)'); 
ylabel('voltage per cell (V)');

fig_name = sprintf("Section 7/%s_7_plots.fig", step_name);
png_name = sprintf("Section 7/%s_7_plots.png", step_name);

f.WindowState = "fullscreen";
save(fig_name, "f");
saveas(f, png_name);

