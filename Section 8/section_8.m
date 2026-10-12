% sweep_name = sprintf("%.2f_", freq);
sweep_name = sprintf("ramp_");

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

fig_name = sprintf("Section 8/%s_8_plots.fig", sweep_name);
png_name = sprintf("Section 8/%s_8_plots.png", sweep_name);

f.WindowState = "fullscreen";
save(fig_name, "f");
saveas(f, png_name);

