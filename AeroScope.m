clc; clear; close all;
%% Step 1: Load Images
VF25 = imread('VF25.jpg');      % Haas VF25 (Side view, no tires)
FW47 = imread('FW47.jpg');      % Williams FW47 (Side view, no tires)

targetSize = [752 3392];        % Standardized resolution
VF25 = imresize(VF25, targetSize);
FW47 = imresize(FW47, targetSize);

%% Step 2: Preprocessing
grayVF = imgaussfilt(rgb2gray(VF25), 2);
grayFW = imgaussfilt(rgb2gray(FW47), 2);

%% Step 3: Compute Difference
diff_img = imabsdiff(grayVF, grayFW);
bw_diff = imbinarize(mat2gray(diff_img), 0.25);
bw_clean = bwareaopen(bw_diff, 300);

%% Step 4: Aerodynamic Zones (Front Wing, Sidepod, Rear Wing, Floor)
height_px = size(bw_clean, 1);
zones = struct('FrontWing',0,'Sidepod',0,'RearWing',0,'Floor',0);
stats = regionprops(bw_clean, 'BoundingBox', 'Centroid', 'Area');

for k = 1:length(stats)
    y = stats(k).Centroid(2);
    area = stats(k).Area;

    if y < 0.25 * height_px
        part = 'FrontWing';
    elseif y < 0.5 * height_px
        part = 'Sidepod';
    elseif y < 0.75 * height_px
        part = 'RearWing';
    else
        part = 'Floor';
    end

    zones.(part) = zones.(part) + area;
end

%% Step 5: Heatmap of Differences
figure('Name','AeroScope – Aerodynamic Differences (Heatmap)');
imshow(labeloverlay(FW47, bw_clean, 'Colormap','autumn','Transparency',0.5));
title('VF25 (Haas) vs FW47 (Williams) – Aerodynamic Heatmap');

%% Step 6: Report Aerodynamic Differences
fields = fieldnames(zones);
values = struct2array(zones);
total_area = sum(values);

fprintf('\n=== AeroScope Aerodynamic Comparison ===\n');
fprintf('VF25 (Haas) vs FW47 (Williams)\n');
fprintf('---------------------------------------\n');
total_diff = nnz(bw_clean);
total_px = numel(bw_clean);
total_pct = (total_diff / total_px) * 100;
fprintf('Total Aerodynamic Difference: %.2f %% of car area\n\n', total_pct);

for i = 1:numel(fields)
    pct = (zones.(fields{i}) / total_area) * 100;
    fprintf('%-10s Difference: %.2f %%\n', fields{i}, pct);
end

[~, idx] = max(values);
fprintf('\nMost Distinct Aero Zone: %s (%.2f %%)\n', fields{idx}, (values(idx)/total_area)*100);

%% Step 7: Bar Chart Visualization 📊
zoneNames = fields;
zonePerc = (values / total_area) * 100;

figure('Name','AeroScope – Aerodynamic Difference Chart');
bar(zonePerc, 'FaceColor',[0.1 0.6 0.9]);
xticklabels(zoneNames);
ylabel('Difference Percentage (%)');
title('VF25 vs FW47 – Aerodynamic Zone Comparison');
grid on;
for i = 1:length(zonePerc)
    text(i, zonePerc(i)+1, sprintf('%.1f%%', zonePerc(i)), ...
        'HorizontalAlignment','center','FontWeight','bold');
end

%% Step 8: Aerodynamic Complexity & Speed Efficiency Index
meanVF = mean(grayVF(:)); texVF = std2(grayVF);
meanFW = mean(grayFW(:)); texFW = std2(grayFW);

smoothVF = 1 / (1 + texVF);
smoothFW = 1 / (1 + texFW);
diffFactor = (1 - total_pct / 100);

SEI_VF = (smoothVF * 0.6) + (diffFactor * 0.4);
SEI_FW = (smoothFW * 0.6) + (diffFactor * 0.4);

fprintf('\n=== Aerodynamic Complexity ===\n');
fprintf('VF25 (Haas): mean=%.2f, texture=%.2f\n', meanVF, texVF);
fprintf('FW47 (Williams): mean=%.2f, texture=%.2f\n', meanFW, texFW);

fprintf('\n=== Speed Efficiency Index (SEI) ===\n');
fprintf('VF25 (Haas): %.3f\n', SEI_VF);
fprintf('FW47 (Williams): %.3f\n', SEI_FW);

%% Step 9: Speed Prediction 🏁
if SEI_VF > SEI_FW
    fprintf('\n🏎️ Predicted Faster Car: Haas VF25\n');
    fprintf('Reason: Smoother aerodynamic profile and efficient floor design.\n');
else
    fprintf('\n🏎️ Predicted Faster Car: Williams FW47\n');
    fprintf('Reason: Cleaner surface geometry and optimized sidepod airflow.\n');
end

fprintf('\n---------------------------------------\n');
fprintf('Analysis Complete – AeroScope v3.5\n');