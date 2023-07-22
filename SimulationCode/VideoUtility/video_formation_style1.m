%% ------ plot setting ------ %%
% formation plot setting - time range 
stepsize = 0.01;
case1 = 1;
t0 = 50;
simtime = t0;

% gif setting
gif = 1; % 0: generate static fig, 1: generate dynamic fig (gif)
gif_time = 1/2; % gif time gap
gif_save = 1; % 0: gif save off, 1: gif save on


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
plt_formation_gif(x, y, tout, gif_time, gif_save, fig_dir);


function plt_formation_gif(x, y, tout, gif_t, save, fig_dir)
step_gif = gif_t/(tout(2)-tout(1));
step_gif = floor(step_gif);
count = length(tout);
gif_array = [1:step_gif:(count-1) count];
filename = [fig_dir, '/formation_result'];
% fig setting
ymin = min(min(y));
ymax = max(max(y));
yindent = (ymax - ymin)*0.01;
xmin = min(min(x));
xmax = max(max(x));
xindent = (xmax - xmin)*0.01;
symble = ['o'; 'o'; 'o'; 'o'; 'o'; 'o'; 'o'; 'o'; 'o'];
color = {'#F47D61'; '#F47D61'; '#F47D61'; '#6F80BE'; '#6F80BE'; "#6F80BE"; "#6F80BE"; '#6F80BE'; '#6F80BE'};
lgd = {};
h = figure;
set(gcf, 'unit', 'centimeters', 'position', [4 4 28 14]);
if save
    vidobj = VideoWriter(filename, "MPEG-4");
    vidobj.Quality = 100;
    vidobj.FrameRate = 30;
    open(vidobj);
end
% plot
for i = gif_array
    x0 = x(i,:);
    y0 = y(i,:);
    plot(0,0);
    hold on;
    rect_x1 = [16, 16, 26, 26];
    rect_y1 = [2.8, 10, 10, 2.8];
    rect_x2 = [16, 16, 26, 26];
    rect_y2 = [-2.8, -10, -10, -2.8];
    sigma = 0.8;
    patch(rect_x1, rect_y1, [.7 .8 .8], 'EdgeColor', 'k', 'LineWidth', 1.5);
    obs = patch(rect_x2, rect_y2, [.7 .8 .8], 'EdgeColor', 'k', 'LineWidth', 1.5);
    plot(x0([1,9]), y0([1,9]), 'k', 'LineWidth', 2);
    plot(x0([1,8]), y0([1,8]), 'k', 'LineWidth', 2);
    plot(x0([1,2]), y0([1,2]), 'k', 'LineWidth', 2);
    plot(x0([1,3]), y0([1,3]), 'k', 'LineWidth', 2);
    plot(x0([2,4]), y0([2,4]), 'k', 'LineWidth', 2);
    plot(x0([2,5]), y0([2,5]), 'k', 'LineWidth', 2);
    plot(x0([2,7]), y0([2,7]), 'k', 'LineWidth', 2);
    plot(x0([3,4]), y0([3,4]), 'k', 'LineWidth', 2);
    plot(x0([3,5]), y0([3,5]), 'k', 'LineWidth', 2);
    plot(x0([3,6]), y0([3,6]), 'k', 'LineWidth', 2);
    plot(x0([4,5]), y0([4,5]), 'k', 'LineWidth', 2);
    plot(x0([4,6]), y0([4,6]), 'k', 'LineWidth', 2);
    plot(x0([5,7]), y0([5,7]), 'k', 'LineWidth', 2);
    plot(x0([6,7]), y0([6,7]), 'k', 'LineWidth', 2);
    plot(x0([6,8]), y0([6,8]), 'k', 'LineWidth', 2);
    plot(x0([7,9]), y0([7,9]), 'k', 'LineWidth', 2);
    plot(x0([8,9]), y0([8,9]), 'k', 'LineWidth', 2);
    f = [];
    for j = 1:size(x,2)
        fj = plot(x(i, j), y(i, j), symble(j), 'Color', color{j}, 'LineWidth', 1.2, ...
            'MarkerSize', 12, 'MarkerFaceColor', color{j}, 'MarkerEdgeColor', 'k');
        text(x(i, j)-0.25, y(i, j), sprintf("%d", j), 'Color', 'w', 'FontName', 'Times New Roman');
        if j == 1 || j == 4
            f = [f; fj];
        end
    end
    for j = 1:3
        plot(x(1:i, j), y(1:i, j), 'LineWidth', 2, 'Color', color{j});
    end
    f = [f; obs];
    p = [x0', y0'];
    [j1, num1] = judge_collision(p, rect_x1, rect_y1, sigma/2);
    [j2, num2] = judge_collision(p, rect_x2, rect_y2, sigma/2);
    [j3, num3] = judge_collision_agents(p, sigma);
    if j1 || j2
        if num1 ~= 0
            p0 = p(num1,:);
            t = 0 : .1 : 2 * pi;
            x2 = 1.2 * cos(t) + p0(1);
            y2 = 1.2 * sin(t) + p0(2);
            cmap = [1,0,0];
            text(p0(1)-2.8, p0(2)+2.5, "Collision", "Color", 'r', 'FontName', 'Times New Roman', 'FontSize', 16);
            patch(x2, y2, cmap, 'facealpha', 0.4, 'edgecolor', 'none');
        end
        if num2 ~= 0
            p0 = p(num2,:);
            t = 0 : .1 : 2 * pi;
            x2 = 1.2 * cos(t) + p0(1);
            y2 = 1.2 * sin(t) + p0(2);
            cmap = [1,0,0];
            text(p0(1)-2.8, p0(2)-2.5, "Collision", "Color", 'r', 'FontName', 'Times New Roman', 'FontSize', 16);
            patch(x2, y2, cmap, 'facealpha', 0.4, 'edgecolor', 'none');
        end
    end
    if j3
        for i0 = 1:size(num3,1)
            p_i = p(num3(i0,1),:);
            p_j = p(num3(i0,2),:);
            p0 = (p_i + p_j)/2;
            t = 0 : .1 : 2 * pi;
            x2 = 1.2 * cos(t) + p0(1);
            y2 = 1.2 * sin(t) + p0(2);
            cmap = [1,0,0];
            text(p0(1)-2.8, p0(2)-2.5, "Collision", "Color", 'r', 'FontName', 'Times New Roman', 'FontSize', 16);
            patch(x2, y2, cmap, 'facealpha', 0.4, 'edgecolor', 'none');
        end
    end
    axis([xmin-xindent xmax+xindent ymin-yindent ymax+yindent]);
    axis equal;
    grid on;
    xlabel('x (meter)');
    ylabel('y (meter)');
    lgd = {"Leader", "Follower", "Obstacle"};
    legend(f, lgd, 'FontName','Times New Roman', 'FontSize', 17, 'Position', [0.17, 0.86, 0.7 ,0.01], ...
    'Orientation','horizon', 'NumColumns', 5);
    set(gca, 'FontName','Times New Roman', 'FontSize',17);
    title(sprintf("t = %.2f s", tout(i)));
    hold off;
    drawnow;
    
    if save
        % Capture the plot as an image
        frame = getframe(h); 
        im = frame2im(frame);
        im = imresize(im, [800, 1600]);
        % Write to mp4
        % collision -> break
%         if j1 || j2
%             for i = 1:15
%                 writeVideo(vidobj, im);
%             end
%             break;
%         end
        writeVideo(vidobj, im);
    end
    
end
close all;
end

function [res, num] = judge_collision(p, rect_x, rect_y, sigma)
num = 0;
res = false;
x_min = min(rect_x);
x_max = max(rect_x);
k1 = rect_y(3) - rect_y(2);
k2 = rect_y(4) - rect_y(1);
f1 = @(x) rect_y(2) + k1*(x - x_min)/(x_max - x_min);
f2 = @(x) rect_y(1) + k2*(x - x_min)/(x_max - x_min);
for i = 1:size(p,1)
    x0 = p(i,1);
    y0 = p(i,2);
    y1 = f1(x0);
    y2 = f2(x0);
    y_min = min(y1, y2);
    y_max = max(y1, y2);
    if x0 > x_min && x0 < x_max
        if y0 > y_min - sigma && y0 < y_max + sigma
            res = true;
            num = i;
            return
        end
    end
end
end

function [res, num] = judge_collision_agents(p, sigma)
num = [0, 0];
res = false;
for i = 1:size(p,1)
    pi = p(i,:);
    for j = (i+1):(size(p,1))
        pj = p(j,:);
        dp = pi - pj;
        d = norm(dp, 2);
        if d < sigma
            num(end+1,:) = [i, j];
            res = true;
        end
    end
end
num(1,:) = [];
end