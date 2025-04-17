function [x, y] = get_electrode_xy(elec_nr,metafile)

if strcmp(metafile.info.type,"MCS")
    tmp = ['ID_' num2str(elec_nr-1)];
        electrode_name = metafile.channels_names.(tmp);

        
        
        % This section was an independent function, but for now we can keep
        % it here
        code = 'ABCDEFGHJKLM';
        Lia = ismember(code,electrode_name(1));
        out = find(Lia);
        if out == 0
            warning('Column not found!')
        end
        % End of previously independent section

        x = out;
        y = str2double(extract(electrode_name, digitsPattern));
end