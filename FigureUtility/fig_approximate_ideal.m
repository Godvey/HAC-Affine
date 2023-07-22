function fig_approximate_ideal(out, ideal, tout, tg, delays)
tab = uitab(tg,'title', "Actual Model and Ideal Model");
axes('Parent',tab);
hold on;
lgd = [];
nums = length(out);
for i = 1:nums
    outi = out(i);
    ex = outi.deltax;
    plot(tout, ex(:,1), 'LineWidth', 4);
    lgd = [lgd, sprintf("τ = %.2f s", delays(i))];
end
plot(tout, ideal, '--', 'LineWidth', 5, 'Color', 'k');
lgd = [lgd "Reference"];
xlabel("Time (second)");
ylabel("Tracking errors of p_4 in x channel");
legend(lgd, 'FontName','Times New Roman', 'FontSize', 20);
set(gca, 'FontName','Times New Roman', 'FontSize',22);
grid on;
end