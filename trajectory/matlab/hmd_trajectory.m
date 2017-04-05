clear all; close all;

array = csvread('coaster2_yao_ss.csv');
id=array(:, 1);
x=array(:, 2);
y=array(:, 3);
z=array(:, 4);
yaw=array(:, 5);
pitch=array(:, 6);
roll=array(:, 7);
cal_yaw=array(:, 8);
cal_pitch=array(:, 9);
cal_roll=array(:, 10);

figure;
%axis([-180, 180, -180, 180, -180, 180]);
%ax=axes;
%set(ax,'xlim',[-180 180],'ylim',[-180 180],'zlim',[-180 180]);
%comet3(x, y, z);
%comet(yaw, 'r');
%comet(pitch, 'g');
%comet(roll, 'b');
hold on;
plot(yaw, 'r--.');
plot(pitch, 'g--.');
%plot(roll, 'b--.');
hold off;

figure;
hold on;
plot(cal_yaw, 'r--.');
plot(cal_pitch, 'g--.');
%plot(cal_roll, 'b--.');
hold off;

figure;
ax=axes;
set(ax,'xlim',[-180 180],'ylim',[-180 180]);
hold(ax);
comet(ax, cal_yaw, cal_pitch);