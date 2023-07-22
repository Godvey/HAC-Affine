%% ------ plot setting ------ %%
% formation plot setting - time range 
stepsize = 0.01;
case1 = 0;
t0 = 50;
simtime = t0;

% save dir
if case1 == 1
    folder = 'taskAccomplished';
else
    folder = 'taskFailed';
end
fig_dir = ['./', folder, '/'];
if ~exist(fig_dir, "dir")
    mkdir(fig_dir);
end


% read data
O_ff = load("./stressMatrix/stressMat_ff.mat");
O_ff = O_ff.stressMat_ff;
O_fl = load("./stressMatrix/stressMat_fl.mat");
O_fl = O_fl.stressMat_fl;
p = load(['./', folder, '/', folder, '-P.mat']);
tout = p.p_all_time.time;
p = p.p_all_time.signals.values;
p_ = zeros(size(p));
mat = -inv(O_ff) * O_fl;
for i = 1:size(p,1)
    pl = [p(i,1), p(i,2); p(i,3), p(i,4); p(i,5), p(i,6)];
    pf = mat * pl;
    pf = pf';
    pf = pf(:)';
    p_(i,1:6) = p(i,1:6);
    p_(i,7:18) = pf;
end
clear pf pl;
x = p(:,1:2:end);
y = p(:,2:2:end);


% plot
set(0,'defaultfigurecolor','w');


% fig setting
img = figure;
lgd = {};
set(gcf, 'unit', 'centimeters', 'position', [15 13 28 14]);
count = 1;
for i = [4, 6, 8]
    if true
        plot(tout, p(:,2*i-1), 'LineWidth', 3);
        lgd{count} = sprintf("Agent %d: Real Position", i);
        count = count + 1;
        hold on;
        plot(tout, p_(:,2*i-1), '--', 'LineWidth', 3);
        lgd{count} = sprintf("Agent %d: Desired Position", i);
        count = count + 1;
    else
        plt = plot(tout, p(:,2*i-1), 'LineWidth', 3);
        lgd{count} = sprintf("Agent %d: Real Position", i);
        count = count + 1;
        hold on;
        plot(tout, p_(:,2*i-1), '--', 'LineWidth', 3, 'Color', plt.Color);
        lgd{count} = sprintf("Agent %d: Desired Position", i);
        count = count + 1;
    end
end
grid on;
xlim([0 50]);
ylim([-10 55]);
xlabel('Time (second)');
ylabel('X Postion (meter)');
legend(lgd, 'FontName','Times New Roman', 'FontSize', 15.5, 'Location','north', 'NumColumns', 3);
set(gca, 'FontName','Times New Roman', 'FontSize', 17, 'xtick', 0:5:simtime, ...
    'GridLineStyle',':','GridColor','k','GridAlpha',1);
% save fig
exportgraphics(img, [fig_dir 'x.pdf'], "ContentType", "vector");


img = figure;
lgd = {};
set(gcf, 'unit', 'centimeters', 'position', [15 13 28 14]);
count = 1;
for i = [4, 6, 8]
    if true
        plot(tout, p(:,2*i), 'LineWidth', 3);
        lgd{count} = sprintf("Agent %d: Real Position", i);
        count = count + 1;
        hold on;
        plot(tout, p_(:,2*i), '--', 'LineWidth', 3);
        lgd{count} = sprintf("Agent %d: Desired Position", i);
        count = count + 1;
    else
        plt = plot(tout, p(:,2*i), 'LineWidth', 3);
        lgd{count} = sprintf("Agent %d: Real Position", i);
        count = count + 1;
        hold on;
        plot(tout, p_(:,2*i), '--', 'LineWidth', 3, 'Color', plt.Color);
        lgd{count} = sprintf("Agent %d: Desired Position", i);
        count = count + 1;
    end
end
grid on;
xlim([0 50]);
ylim([-1 6.5]);
xlabel('Time (second)');
ylabel('Y Postion (meter)');
legend(lgd, 'FontName','Times New Roman', 'FontSize', 15.5, 'Location','north', 'NumColumns', 3);
set(gca, 'FontName','Times New Roman', 'FontSize', 17, 'xtick', 0:5:simtime, ...
    'GridLineStyle',':','GridColor','k','GridAlpha',1);
% save fig
exportgraphics(img, [fig_dir 'y.pdf'], "ContentType", "vector");

