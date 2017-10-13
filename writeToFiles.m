function writeToFiles(root_dir, write_to_bin, entries)

if ~exist(root_dir, 'dir')
    mkdir(root_dir);
end
if write_to_bin
    file_ext='bin';
else
    file_ext='txt';
end


n_entries = numel(entries);
for i=1:n_entries
    entry = entries{i};
    array = entry{1};
    fname = sprintf('%s/%s.%s', root_dir, entry{2}, file_ext);
    if write_to_bin
        dtype = entry{3};
        [m, n] = size(array);
        if m>1 && n>1
            % transpose for compatibility with the row major storage in
            % C/Python/Numpy
            array = array';
        end
        fid = fopen(fname,'w');
        fwrite(fid, array, dtype);
        fclose(fid);
    else
        fmt = entry{4};
        dlmwrite(fname, array, 'delimiter', '\t','precision',fmt);
    end
    
end
end
