% CAL_CONF Caltech-101 configuration
%
%  Author:: Andrea Vedaldi

% AUTORIGHTS
% Copyright (C) 2008-09 Andrea Vedaldi
%
% This file is part of the VGG MKL Class and VGG MKL Det code packages,
% available in the terms of the GNU General Public License version 2.

conf.noClobber        = 1 ;
conf.parallelize      = 0 ;
conf.masterRandomSeed = 1 ;
conf.masterNumTrain   = 0.8;
conf.masterExpNum     = 1 ;
conf.smallData        = false ;

if exist('magicSmallData', 'var')
  conf.smallData = magicSmallData ;
end
if exist('magicMasterRandomSeed', 'var')
  conf.masterRandomSeed = magicMasterRandomSeed ;
end
if exist('magicMasterExpNum', 'var')
  conf.masterExpNum = magicMasterExpNum ;
end
if exist('magicMasterNumTrain', 'var')
  conf.masterNumTrain = magicMasterNumTrain ;
end

% How many and which GT ROIs to use as training data.
conf.numPos    = 30;
conf.numJitPos = 15 ;

% Directories ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

dataDir = fullfile(pwd,'data', ...
                   sprintf('proj-train%0.1f-%d',conf.masterNumTrain ,conf.masterRandomSeed)) ;
if conf.smallData
  dataDir = [dataDir '-small'] ;
end
calDir  = fullfile(pwd,'data','Test') ;
%calDir  = fullfile(pwd,'data','image') ;
tmpDir  = tempdir ;

conf.calDir      = calDir ;
conf.ppDir       = fullfile(dataDir, 'pp')  ;
conf.jobDir      = fullfile(dataDir, 'jobs') ;
conf.aggrDir     = fullfile(dataDir, 'aggr') ;
conf.trainDir    = fullfile(dataDir, 'train') ;
conf.imageDbPath = fullfile(dataDir, 'imdb.mat') ;
conf.gtRoiDbPath = fullfile(dataDir, 'roidb.mat') ;
conf.gtRoiTrainSetName = 'train' ;
conf.tmpDir      = tmpDir ;

ensuredir(dataDir) ;

clear dataDir vocDir tmpDir ;

% --------------------------------------------------------------------
%                                               Training configuration
% --------------------------------------------------------------------

% Train and test set labels
conf.trainSetName  = 'train' ;
conf.testSetName   = 'test' ;

% Which jitters to use when training
conf.jitterNames ={'zm1'};% ,'zm2'} ;
%conf.jitterNames = {'fliplr'};

% Enlarge ROIs by this much when computing histograms
conf.roiMagnif = 0 ;

conf.maxDenseDim = 300 ;

% Training appearance model ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Method used to learn the wieghts: none, manik, manikPartition
conf.learnWeightMethod = 'manik' ;
%conf.learnWeightMethod = 'equalMean' ;

% Weights of positive examples
conf.posWeight = 1.0 ;
%conf.posWeight = 10.0 ;

conf.kerType   = 'echi2' ;

% --------------------------------------------------------------------
%                                                Feature configuration
% --------------------------------------------------------------------

%conf.featNames = {'phog', 'phowGray','sift','ssim'} ;
conf.featNames = {'phowGray','sift'} ;

% SIFT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
conf.feat.sift.format            = 'dense' ;
conf.feat.sift.extractFn         = @densesift ;
conf.feat.sift.clusterFn         = @ikmeansCluster ;
conf.feat.sift.quantizeFn        = @ikmeansQuantize ;
conf.feat.sift.vocabSize         = 1000 ;
conf.feat.sift.numImagesPerClass = 30 ;
conf.feat.sift.numFeatsPerImage  = 100 ;
conf.feat.sift.compress          = false ;
conf.feat.sift.step              = 2 ;
conf.feat.sift.sizes             = [4 8 12 16] ;
conf.feat.sift.pyrLevels         = 0:2 ;
conf.feat.sift.fast              = true ;

% PHOG features ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

conf.feat.phog.format            = 'sparse' ;
conf.feat.phog.extractFn         = @phog ;
conf.feat.phog.clusterFn         = @phogCluster ;
conf.feat.phog.quantizeFn        = @phogQuantize ;
conf.feat.phog.numImagesPerClass = 30 ;
conf.feat.phog.numFeatsPerImage  = 100 ;
conf.feat.phog.compress          = false ;
conf.feat.phog.step              = 2 ;
conf.feat.phog.sizes             = [5 7 9 12] ;
conf.feat.phog.pyrLevels         = 0:2 ;
conf.feat.phog.fast              = true ;
conf.feat.phog.vocabSize      = 1000 ;

% PHOW features ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

conf.feat.phowGray.format            = 'dense' ;
conf.feat.phowGray.extractFn         = @phow ;
conf.feat.phowGray.clusterFn         = @ikmeansCluster ;
conf.feat.phowGray.quantizeFn        = @ikmeansQuantize ;
conf.feat.phowGray.vocabSize         = 1000 ;
conf.feat.phowGray.numImagesPerClass = 30 ;
conf.feat.phowGray.numFeatsPerImage  = 100 ;
conf.feat.phowGray.compress          = false ;
conf.feat.phowGray.step              = 2 ;
conf.feat.phowGray.sizes             = [5 7 9 12] ;
conf.feat.phowGray.color             = false ;
conf.feat.phowGray.pyrLevels         = 0:2 ;
conf.feat.phowGray.fast              = true ;

conf.feat.phowColor                  = conf.feat.phowGray ;
conf.feat.phowColor.color            = true ;


% SSIM features ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

conf.feat.ssim.format            = 'dense' ;
conf.feat.ssim.extractFn         = @vggSsim ;
conf.feat.ssim.clusterFn         = @vggCluster ;
conf.feat.ssim.quantizeFn        = @vggQuantize ;
conf.feat.ssim.vocabSize         = 1000 ;
conf.feat.ssim.numImagesPerClass = 10 ;
conf.feat.ssim.numFeatsPerImage  = 300 ;
conf.feat.ssim.compress          = false ;
conf.feat.ssim.pyrLevels         = 0:2 ;

conf.feat.ssim.coRelWindowRadius = 40 ;
conf.feat.ssim.subsample_x       = 4 ;
conf.feat.ssim.subsample_y       = 4 ;
conf.feat.ssim.numRadiiIntervals = 3 ;
conf.feat.ssim.numThetaIntervals = 10 ;
conf.feat.ssim.saliencyThresh    = 1 ;
conf.feat.ssim.size              = 5 ;
conf.feat.ssim.varNoise          = 150 ;
conf.feat.ssim.nChannels         = 3 ;
conf.feat.ssim.useMask           = 0 ;
conf.feat.ssim.autoVarRadius     = 1 ;

% rename feat -> featOpts
conf.featOpts = conf.feat ;
conf = rmfield(conf, 'feat') ;

conf.learnWeightMethod   = 'manik' ;

switch conf.masterExpNum
  case 1
    conf.expPrefix  = 'baseline' ;

  case 2
    conf.expPrefix  = 'baseline-phog' ;
    %conf.featNames  = {'phog'} ;

  case 3
    conf.expPrefix  = 'baseline-phowGray' ;
    conf.featNames  = {'phowGray'} ;

  case 4
    conf.expPrefix  = 'baseline-phowColor' ;
    conf.featNames  = {'phowColor'} ;

  case 5
    conf.expPrefix  = 'baseline-ssim' ;
    %conf.featNames  = {'ssim'} ;

  case 6
    conf.expPrefix  = 'baseline-avg' ;
    conf.learnWeightMethod = 'equalMean' ;
end

if conf.smallData
  conf.numJitPos = 0 ;
end

% Setup the kernels
conf.kerDb = [] ;
for fi = 1:length(conf.featNames)
  featName = conf.featNames{fi} ;

  if conf.featOpts.(featName).vocabSize == 0
    conf.kerDb = [conf.kerDb ...
                  calcKernelDb({'el2'}, { featName }, conf.featOpts) ;] ;
  else
    conf.kerDb = [conf.kerDb ...
                  calcKernelDb({'echi2'}, { featName }, conf.featOpts) ;] ;
  end
end
