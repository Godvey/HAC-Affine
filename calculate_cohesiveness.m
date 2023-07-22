% this file is to calculate cohesiveness
clc;
if length(out) == 1
    out = [out];
end
nums = length(out) + 1;

fprintf("--------------------------------------------------------------\n")
fprintf("    Case \t Cohesiveness - X \t Cohesiveness - Y \t\n")
fprintf("--------------------------------------------------------------\n")
for i = 1:nums
    if i == nums
        outi = out(1);
        deltax = outi.deltax_nohac;
        deltay = outi.deltay_nohac;
    else
        outi = out(i);
        deltax = outi.deltax;
        deltay = outi.deltay;
    end
    
    sizez = size(deltax,1);
    nodenum = 9;
    followernum = size(deltax,2);
    count = sizez(1) - 1;
    tempx = deltax;
    tempy = deltay;
    avgerrx = sum(deltax, 2)/followernum;
    avgerry = sum(deltay, 2)/followernum;
    tempx = sum(sum(abs(tempx - avgerrx)));
    tempy = sum(sum(abs(tempy - avgerry)));
    tempex = sum(sum(abs(avgerrx)));
    tempey = sum(sum(abs(avgerry)));
    
    couhesiveX = tempx/count;
    couhesiveY = tempy/count;
    
    if i == nums
        fprintf(" Without HAC \t      %.3f   \t\t      %.3f \t\n", couhesiveX, couhesiveY);
    else
        fprintf("  τ = %.2f\t    %.3f   \t\t      %.3f \t\n", delays(i), couhesiveX, couhesiveY);
    end
end
fprintf("--------------------------------------------------------------\n")