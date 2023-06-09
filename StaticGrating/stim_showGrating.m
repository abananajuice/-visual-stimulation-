function stim_showGrating(trials,cycleDuration,interstimulusInterval)
% stim_showGrating
% 光栅刺激实验


%% 参数设置
numCycles = 3; % 刺激呈现的周期数
orientations = [0:30:150]; % 运动的方向
f = 0.04; % 空间频率
O_index = randperm(length(orientations));


%% 生成标签结果并保存
len_oris = length(orientations);
label = zeros(numCycles*len_oris*trials,2);

label(:,2) = f;
i_ori = 1;

for t = 1:trials
    for i = 1:len_oris  %% 朝向的数目
        
        % 显示刺激
        for j = 1:numCycles
            label(i_ori,1) = orientations(O_index(i));
            i_ori=i_ori+1;
        end
    end
end

save("label"+datestr(now,30)+".mat",'label');

%% 屏幕配置

screens           = Screen('Screens');
% 设置现实屏幕
screenNumber      = 2;
Screen('Preference', 'SkipSyncTests', 1);
[window,~] = Screen(screenNumber,'OpenWindow',0,[],[],2); % 打开屏幕




black              = BlackIndex(window);
white              = WhiteIndex(window);
grey               = (white+black)/2;
Screen(window,'FillRect', grey);
Screen(window, 'Flip');

% 生成刺激
disp("生成刺激中...");
% if(exist(".\grating.mat","file"))
%     disp("发现存在刺激文件");
%     load(".\grating.mat");
% else
    grating = GenerateGrating(window,f,orientations);
    
% end
disp("刺激生成完成！")
%   object             = io64;
%   status             = io64(object);
%   io64(object,16424,0);
priorityLevel      = MaxPriority(window);
Priority(priorityLevel);
% HideCursor;
%     config_io;

%% 刺激呈现


for t = 1:trials
    for i = 1:len_oris  %% 朝向的数目
        
        % 显示刺激
        for j = 1:numCycles
            
            %             for ss = 1:60*cycleDuration
            % grating 按0-180顺序存储着不同朝向光栅
            Screen('DrawTexture', window, grating(O_index(i)));
            Screen('Flip', window);
            WaitSecs(cycleDuration);
            %         io64(object,16424,1); % 设定打标
            %         WaitSecs(0.0001);
            %         io64(object,16424,0);
            %             end
            % 60 指屏幕刷新率
            %             for ss = 1:60*interstimulusInterval
            % 显示灰屏
            Screen('FillRect', window, grey);
            Screen('Flip', window);
            WaitSecs(interstimulusInterval);
            %         io64(object,16424,1); % 设定打标
            %         WaitSecs(0.0001);
            %         io64(object,16424,0);
            %         end
        end        
    end
end

% 清除刺激纹理
Screen('Close', grating);
% 关闭屏幕
Screen('CloseAll');
