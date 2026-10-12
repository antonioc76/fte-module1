t = time;
idx_0 = find(t > 1.8 & t < 2.0);
idx_f = find(t > 3.8 & t < 4.0);
idx_step = find(t > 2.0);

RPM_bldc_0 = mean(bldc(idx_0));
RPM_can_0 = mean(can(idx_0));
RPM_tf_0 = mean(transfer_fn(idx_0));
RPM_cmd_0 = mean(RPM_cmd(idx_0));

RPM_bldc_f = mean(bldc(idx_f));
RPM_can_f = mean(can(idx_f));
RPM_tf_f = mean(transfer_fn(idx_f));
RPM_cmd_f = mean(RPM_cmd(idx_f));

delta_bldc = RPM_bldc_f - RPM_bldc_0;
delta_can = RPM_can_f - RPM_can_0;
delta_tf = RPM_tf_f - RPM_tf_0;
delta_RPM_cmd = RPM_cmd_f - RPM_cmd_0;

RPM_bldc_norm = (bldc - RPM_bldc_0) / delta_bldc;
RPM_can_norm = (can - RPM_can_0) / delta_can;
RPM_tf_norm = (transfer_fn - RPM_tf_0) / delta_tf;
RPM_cmd_norm = (RPM_cmd - RPM_cmd_0) / delta_RPM_cmd;

% time to rise
K_rise = 1 - 1/exp(1); 
bldc_ttr_idx = find(RPM_bldc_norm >= K_rise, 1, 'first');
can_ttr_idx = find(RPM_can_norm >= K_rise, 1, 'first');
tf_ttr_idx = find(RPM_tf_norm >= K_rise, 1, 'first');

bldc_ttr = time(bldc_ttr_idx) - 2.0
can_ttr = time(can_ttr_idx) - 2.0
tf_ttr = time(tf_ttr_idx) - 2.0

bldc_ss_err = RPM_bldc_f - max(RPM_cmd)
can_ss_err = RPM_can_f - max(RPM_cmd)
tf_ss_err = RPM_tf_f - max(RPM_cmd)

f = figure;
ax = axes(f);

set(ax, 'LineWidth', 1.5)

grid(ax, "on");
hold(ax, "on");
legend(ax);

plot(ax, t, RPM_bldc_norm, 'DisplayName', 'electro-mechanical model', 'color', 'red', 'LineWidth', 1.5);
plot(ax, t, RPM_can_norm, 'DisplayName', 'CAN ESC model', 'color', 'green', 'LineWidth', 1.5);
plot(ax, t, RPM_tf_norm, 'DisplayName', 'transfer fn model', 'color', 'blue', 'LineWidth', 1.5);
plot(ax, t, RPM_cmd_norm, 'DisplayName', 'RPM command', 'color', [1 0 1], 'LineWidth', 1.5);

scatter(t(bldc_ttr_idx), RPM_bldc_norm(bldc_ttr_idx), 'DisplayName', 'bldc(\tau)', 'color', 'red', 'LineWidth', 1.5);
scatter(t(can_ttr_idx), RPM_can_norm(can_ttr_idx), 'DisplayName', 'can(\tau)', 'color', 'green', 'LineWidth', 1.5);
scatter(t(tf_ttr_idx), RPM_tf_norm(tf_ttr_idx), 'DisplayName', 'tf(\tau)', 'color', 'blue', 'LineWidth', 1.5);

xlabel(ax, "Time (sec)");
ylabel(ax, "Normalized RPM [0-1]");
