function genDummyData(m, n)
%GENDUMMYDATA generates a dummy data
%  INPUT:
%    m = number of rows (genes)
%    n = number of columns (libraries)
%  OUTPUT:
%    dummyData.txt is created in data folder.
%  RETURN VALUE:
%    This function does not return anythig.

arguments
    m = 50;
    n = 10;
end
fid = fopen(fullfile('data',filesep,'dummyData.txt'), 'wt');
fprintf(fid,'Genes');
for i = 1 : n
    fprintf(fid,'\tlib%d',i);
end
fprintf(fid,'\n');
for j = 1 : m
    fprintf(fid,'gene%d',j);
    for i = 1 : n
        fprintf(fid,'\t%.4f',rand);
    end
    fprintf(fid,'\n');
end
fprintf(fid,'\n');
fclose(fid);