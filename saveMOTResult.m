close all;
% clear all;

addpath('E:\UofA\Thesis\Code\TrackingFramework\Matlab');
opt = globals();

is_save = 1;
db_type = 2;
results_dir = 'results';
save_input_images = 0;
start_idx = 1;
end_idx = 11;
seq_idx_list = [10:15, 25:30, 51:60];
% seq_idx_list = start_idx:end_idx;

colRGBDefs;
colors={
    'blue',...%1
    'red',...%2
    'green',...%3
    'cyan',...%4
    'magenta',...%5
    'yellow',...%6
    'forest_green',...%7
    'slate_gray',...%8
    'peach_puff_3',...%9
    'maroon',...%10
    'purple',...%11
    'orange',...%12
    'gold'...%13
    };

n_cols = length(colors);
colors_rgb = cell(n_cols, 1);
for i = 1:n_cols
    colors_rgb{i} = col_rgb{strcmp(col_names,colors{i})};
end



for seq_idx = seq_idx_list
    hf = figure(1);
    if db_type == 0
        seq_name = opt.mot2d_test_seqs{seq_idx};
        seq_num = opt.mot2d_test_nums(seq_idx);    
        seq_set = 'test';
        filename = sprintf('%s/%s_dres_image.mat', results_dir, seq_name);
    elseif db_type == 1
        seq_name = opt.kitti_train_seqs{seq_idx};
        seq_num = opt.kitti_train_nums(seq_idx);
        seq_set = 'training';
        filename = sprintf('%s/kitti_%s_%s_dres_image.mat', opt.results_kitti, seq_set, seq_name);
    else
        seq_name = opt.gram_seqs{seq_idx};
        seq_num = opt.gram_nums(seq_idx);
        filename = sprintf('%s/%s_dres_image.mat', opt.results, seq_name);
    end

    % build the dres structure for images
    if exist(filename, 'file') ~= 0
        fprintf('loading images from file %s...', filename);
        object = load(filename);
        dres_image = object.dres_image;
        fprintf('done\n');
    else
        fprintf('reading images...\n');
        if db_type == 0
            dres_image = read_dres_image(opt, seq_set, seq_name, seq_num);
        elseif db_type == 1
            dres_image = read_dres_image_kitti(opt, seq_set, seq_name, seq_num);
        else
            dres_image = read_dres_image_gram(opt, seq_name, seq_num);
        end
        fprintf('done\n');
        if save_input_images
            fprintf('saving images to file %s...', filename);
            save(filename, 'dres_image', '-v7.3');
            fprintf('done\n');
        end
    end

    fprintf('reading tracking results from %s\n', filename);
    if db_type == 0
        filename = sprintf('%s/%s.txt', opt.results, seq_name);
        file_video = sprintf('%s/%s.avi', opt.results, seq_name);
        dres_track = read_mot2dres(filename);
    elseif db_type == 1
        filename = sprintf('%s/%s.txt', opt.results_kitti, seq_name);
        file_video = sprintf('%s/%s.avi', opt.results_kitti, seq_name);
        dres_track = read_kitti2dres(filename);    
    else
        filename = sprintf('%s/%s.txt', opt.results_gram, seq_name);
        file_video = sprintf('%s/%s.avi', opt.results_gram, seq_name);
        dres_track = read_gram2dres(filename);
    end

    if is_save    
        aviobj = VideoWriter(file_video);
        aviobj.FrameRate = 9;
        open(aviobj);
        fprintf('saving video to %s\n', file_video);
    end

    for fr = 1:seq_num
        show_dres_gt(fr, dres_image.I{fr}, dres_track, colors_rgb);
        if is_save
            writeVideo(aviobj, getframe(hf));
        else
            pause(0.001);
        end
    end

    if is_save
        close(aviobj);
    end
end