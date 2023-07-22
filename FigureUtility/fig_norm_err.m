function fig_norm_err(out, tout, tg, delays)
nums = length(out)+1;
tab = uitab(tg,'title', "Norm Error");
axes('Parent',tab);
axis off;
box off;
for delay_i = 1:nums
    if delay_i == nums
        outi = out(1);
        ex = outi.deltax_nohac;
        ey = outi.deltay_nohac;
    else
        outi = out(delay_i);
        ex = outi.deltax;
        ey = outi.deltay;
    end
    subplot(nums, 2, 2*delay_i-1);
    hold on;
    for i = 1:size(ex, 2)
        lgd{i} = sprintf("Agent %d", i + 3);
        plot(tout, ex(:,i), 'LineWidth', 3);
    end
    grid on;
    if delay_i == nums
        hLegend = legend(lgd, 'FontName','Times New Roman', 'FontSize', 16, 'NumColumns', size(ex, 2));
        set(hLegend, 'position', [0.1300    0.025    0.7750    0.01]);
    end
    xlabel("Time (second)");
    ylabel("Tracking errors in X-channel");
    set(gca, 'FontName','Times New Roman', 'FontSize',8);
    if delay_i ~= nums
        title(sprintf("τ = %.2f", delays(delay_i)), 'FontName','Times New Roman', 'FontSize', 16);
    else
        title("Without HAC", 'FontName','Times New Roman', 'FontSize', 16);
    end
    % y channel
    subplot(nums, 2, 2*delay_i)
    hold on;
    for i = 1:size(ey, 2)
        lgd{i} = sprintf("Agent %d", i + 3);
        plot(tout, ey(:,i), 'LineWidth', 3);
    end
    grid on;
    %legend(lgd, 'FontName','Times New Roman', 'FontSize', 16, 'NumColumns', 3);
    xlabel("Time (second)");
    ylabel("Tracking errors in Y-channel");
    set(gca, 'FontName','Times New Roman', 'FontSize',8);
    if delay_i ~= nums
        title(sprintf("τ = %.2f", delays(delay_i)), 'FontName','Times New Roman', 'FontSize', 16);
    else
        title("Without HAC", 'FontName','Times New Roman', 'FontSize', 16);
    end
end
end