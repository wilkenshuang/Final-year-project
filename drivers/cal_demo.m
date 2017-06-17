% CAL_DEMO  Run a Caltech-101 experiment
%
%   Author:: Andrea Vedaldi

% AUTORIGHTS
% Copyright (C) 2008-09 Andrea Vedaldi
%
% This file is part of the VGG MKL Class and VGG MKL Det code packages,
% available in the terms of the GNU General Public License version 2.

cal_conf ;

waitJobs = [] ;

imdb = getImageDb(conf.imageDbPath) ;
roidb = getRoiDb(conf.gtRoiDbPath) ;
trainImageSel = findImages(imdb, 'set', imdb.sets.TRAIN) ;
testImageSel  = findImages(imdb, 'set', imdb.sets.TEST) ;

conf.do_packScores = 1 ;
conf.do_evalScores = 1 ;

% --------------------------------------------------------------------
%                                                             Run jobs
% --------------------------------------------------------------------

aggrRoiDbDir       = fullfile(conf.aggrDir, 'rois') ;
aggrTestRoiDbDir   = fullfile(conf.aggrDir, 'rois-test') ;
aggrRoiDbPath      = fullfile(aggrRoiDbDir, 'roidb') ;
aggrTestRoiDbPath  = fullfile(aggrTestRoiDbDir, 'roidb') ;

commDir = fullfile(conf.trainDir, 'COMMON', conf.expPrefix) ;

tsdb = load(aggrTestRoiDbPath) ;
classIds = unique(tsdb.rois.class) ;
numClasses = length(classIds) ;
numImages  = length(tsdb.rois.id) ;
classNames = fieldnames(roidb.classes)' ;

% --------------------------------------------------------------------
%                                                          Pack scores
% --------------------------------------------------------------------

if conf.do_packScores

  scores = zeros(numClasses, numImages) ;

  for ci = 1:length(classNames)
    className = classNames{ci} ;

    stageDir = fullfile(conf.trainDir, upper(className), conf.expPrefix) ;
    testRoiDbDir = fullfile(stageDir, 'rois-test') ;
    testRoiScorePath = fullfile(testRoiDbDir, 'test-scores') ;

    data = load(testRoiScorePath) ;

    i = find(classIds == tsdb.classes.(upper(className))) ;
    scores(i, :) = data.scores ;
  end
  ssave(fullfile(commDir, 'scoreMatrix'), 'scores', 'classIds') ;
end
ID=randperm(length(testImageSel));
for i=1:25
name=char(imdb.images.name(testImageSel(ID(i))));
sprintf('Actual class: %s\n',name)
[drop, predClass] = max(scores(:, ID(i))); 
sprintf('Predicted class: %s\n',char(classNames(predClass)))
subplot(5,5,i)
imagesc(imread(['H:\vgg-mkl-class-1.1\data\test\',name '.bmp']));
text(5,5,sprintf(char(classNames(predClass))),...
       'background','w',...
       'verticalalignment','top', ...
       'fontsize', 6) ;
   colormap gray
set(gca,'xtick',[],'ytick',[]) ; axis image ;
end