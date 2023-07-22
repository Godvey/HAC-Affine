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
err = load(['./taskScen/normError.mat']);
tout = err.error_all.time;
err = err.error_all.signals.values;

% plot
set(0,'defaultfigurecolor','w');
plt_norm_err_gif(tout, err, gif_time, fig_dir, gif_save)

function plt_norm_err_gif(tout, err, gif_t, fig_dir, save)
step_gif = gif_t/(tout(2)-tout(1));
step_gif = floor(step_gif);
count = length(tout);
gif_array = [1:step_gif:(count-1) count];
filename = [fig_dir, '/norm_error'];
% fig setting
h = figure;
set(gcf, 'unit', 'centimeters', 'position', [4 4 28 14]);
lgd = {};
nums = size(err, 2);
if save
    vidobj = VideoWriter(filename, "MPEG-4");
    vidobj.Quality = 100;
    vidobj.FrameRate = 30;
    open(vidobj);
end
% plot
for i = gif_array
    for j = 1:nums
        plot(tout(1:i), err(1:i,j), 'LineWidth', 3);
        hold on;
    end
    grid on;
    xlim([0 150]);
    if tout(i) < 30
        ylim([0 15]);
    else
        err_max = max(err(floor(i - 30/(tout(2)-tout(1)) + 1):i))*1.1;
        if err_max < 0.3
            ylim([0, 0.3])
        else
            ylim([0, err_max])
        end
    end
    xlabel('Time (second)');
    ylabel('Formation Norm Error');
    if nums > 1
        legend(lgd, 'FontName','Times New Roman', 'FontSize', 16, 'NumColumns', 1);
    end
    set(gca, 'FontName','Times New Roman', 'FontSize',16, 'xtick', 0:10:tout(end));
    title(sprintf("t = %.2f s", tout(i)));
    drawnow;
    hold off;
    if save 
        % Capture the plot as an image 
        frame = getframe(h); 
        im = frame2im(frame);
        im = imresize(im, [800, 1600]);
        %[imind,cm] = rgb2ind(im,256);
        % Write to the GIF File 
        %if i == 1 
        %  imwrite(imind,cm,[filename '.gif'],'gif','Loopcount',inf,'DelayTime', 0.1); 
        %else 
        %  imwrite(imind,cm,[filename '.gif'],'gif','WriteMode','append','DelayTime', 0.1); 
        %end
        % Write to mp4
        writeVideo(vidobj, im);
    end
end
close all;
end