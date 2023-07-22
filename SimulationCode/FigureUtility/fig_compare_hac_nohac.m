function fig_compare_hac_nohac(out, tout, delays, tg)
tab = uitab(tg,'title', "HAC Compare noHAC");
axes('Parent',tab);
nums = length(delays(1)) + 1;
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
    % X channel
    subplot(1, 2, 1);
    hold on;
    plot(tout, vecnorm(ex, 2, 2), 'LineWidth', 3);
    grid on;
    xlabel("Time (second)");
    ylabel("Norm Error in X-channel");
    set(gca, 'FontName','Times New Roman', 'FontSize',17);

    % Y channel
    subplot(1, 2, 2);
    hold on;
    if delay_i ~= nums
        if nums == 2
            lgd{delay_i} = sprintf("Using HAC", delays(delay_i));
        else
            lgd{delay_i} = sprintf("τ = %.2f", delays(delay_i));
        end
    else
        lgd{delay_i} = "Without Using HAC";
    end
    plot(tout, vecnorm(ey, 2, 2), 'LineWidth', 3);
    grid on;
    if delay_i == nums
        hLegend = legend(lgd, 'FontName','Times New Roman', 'FontSize', 16, 'NumColumns', size(ex, 2));
        set(hLegend, 'position', [0.1300    0.025    0.7750    0.01]);
    end
    xlabel("Time (second)");
    ylabel("Norm Error in Y-channel");
    set(gca, 'FontName','Times New Roman', 'FontSize',17);
end
end