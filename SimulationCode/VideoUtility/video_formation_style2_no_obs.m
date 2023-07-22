%% ------ plot setting ------ %%
% formation plot setting - time range 
stepsize = 0.01;
t0 = 50;
simtime = t0;

% gif setting
gif = 1; % 0: generate static fig, 1: generate dynamic fig (gif)
gif_time = 1/2; % gif time gap
gif_save = 1; % 0: gif save off, 1: gif save on


% save dir
fig_dir = ['./taskScen'];
if ~exist(fig_dir, "dir")
    mkdir(fig_dir);
end


% read data
p = load(['./taskScen/Position.mat']);
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
symble = ['o'; 'p'; '^'; 's'; 'd'; 'h'; 'v'; '>'; '<'];
color = {"#006BC2"; "#E85E00"; "#F2AD13"; "#853D8F"; "#759F2D"; "#47BCF3"; "#AF2426"; '#FF1C02'; '#FFEF00'};
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
for j = 1:size(x,2)
    lgd{j} = sprintf("Agent.%d", j);
end
for i = gif_array
    x0 = x(i,:);
    y0 = y(i,:);
    plot(0,0);
    hold on;
    plot(x0([1,2,4,6,8,9,7,5,3,1]), y0([1,2,4,6,8,9,7,5,3,1]), 'k', 'LineWidth', 1.5);
%     plot(x0([1,9]), y0([1,9]), 'k', 'LineWidth', 1.5);
%     plot(x0([1,8]), y0([1,8]), 'k', 'LineWidth', 1.5);
%     plot(x0([1,2]), y0([1,2]), 'k', 'LineWidth', 1.5);
%     plot(x0([1,3]), y0([1,3]), 'k', 'LineWidth', 1.5);
%     plot(x0([2,4]), y0([2,4]), 'k', 'LineWidth', 1.5);
%     plot(x0([2,5]), y0([2,5]), 'k', 'LineWidth', 1.5);
%     plot(x0([2,7]), y0([2,7]), 'k', 'LineWidth', 1.5);
%     plot(x0([3,4]), y0([3,4]), 'k', 'LineWidth', 1.5);
%     plot(x0([3,5]), y0([3,5]), 'k', 'LineWidth', 1.5);
%     plot(x0([3,6]), y0([3,6]), 'k', 'LineWidth', 1.5);
%     plot(x0([4,5]), y0([4,5]), 'k', 'LineWidth', 1.5);
%     plot(x0([4,6]), y0([4,6]), 'k', 'LineWidth', 1.5);
%     plot(x0([5,7]), y0([5,7]), 'k', 'LineWidth', 1.5);
%     plot(x0([6,7]), y0([6,7]), 'k', 'LineWidth', 1.5);
%     plot(x0([6,8]), y0([6,8]), 'k', 'LineWidth', 1.5);
%     plot(x0([7,9]), y0([7,9]), 'k', 'LineWidth', 1.5);
%     plot(x0([8,9]), y0([8,9]), 'k', 'LineWidth', 1.5);
    f = [];
    for j = 1:size(x,2)
        fj = plot(x(i, j), y(i, j), symble(j), 'Color', color{j}, ...
            'MarkerSize', 8, 'MarkerFaceColor', color{j}, 'MarkerEdgeColor', 'b');
        %text(x(i, j)-0.25, y(i, j), sprintf("%d", j), 'Color', 'w', 'FontName', 'Times New Roman');
        f = [f; fj];
        plot(x(1:i, j), y(1:i, j), 'LineWidth', 2, 'Color', color{j});
    end
    p = [x0', y0'];
    axis([xmin-xindent xmax+xindent ymin-yindent ymax+yindent]);
    axis equal;
    grid on;
    xlabel('x (meter)');
    ylabel('y (meter)');
    %legend(f, lgd, 'FontName','Times New Roman', 'FontSize', 17, 'Position', [0.17, 0.86, 0.7 ,0.01], ...
    %'Orientation','horizon', 'NumColumns', 5);
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
legend(f, lgd, 'FontName','Times New Roman', 'FontSize', 17, 'Position', [0.17, 0.86, 0.7 ,0.01], ...
    'Orientation','horizon', 'NumColumns', 5);
exportgraphics(gcf, [fig_dir, '/formatioin.pdf'], "ContentType", "vector");
close all;
end