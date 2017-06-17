path =fullfile(pwd,'data','AllCroppedPics');
subfolders=dir(path);
for ii = 7%:length(subfolders),
    subname = subfolders(ii).name;
    if ~strcmp(subname, '.') & ~strcmp(subname, '..'),
        ClassPath=fullfile(path,subname,'\');
        Classfolders=dir(ClassPath);
        for jj=1:length(Classfolders)
            foldersname=Classfolders(jj).name;
            if ~strcmp(foldersname, '.') & ~strcmp(foldersname, '..'),
                Sequencepath=fullfile(ClassPath,foldersname,'\');
                Imagepath=dir([Sequencepath '*.bmp']);
                for i = 1:numel(Imagepath)
                    oldname = Imagepath(i).name;
                    I=imread(fullfile(Sequencepath,oldname));
                    newname = strcat(subname,'_',foldersname,'_',num2str(i),'.bmp');
                    imwrite(I,fullfile(Sequencepath,newname),'bmp');
                end
            end
        end;
    end;
end