clear all; close all;

img = imread('panel_equir_00900.png');
pos = csvread('panel_output_900.csv');

x = pos(:,1);
y = pos(:,2);

imshow(img);
hold on;
%{
colorstring = 'wbgry';
for i = 1:5
  plot(x(i), y(i), '.', 'Color', colorstring(i), 'MarkerSize', 30);
end
%}
plot(x, y, 'r.', 'MarkerSize', 30);