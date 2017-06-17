j=1;
subSequence=[];
for k = 1:length(sel)
    ii = sel(k) ;
    subSequence(j)=imageSequence(ii);
    j=j+1;
end
Seqlength=max(subSequence)-min(subSequence)+1;
TrainSeq=floor(0.9*Seqlength);
TestSeq=Seqlength-TrainSeq;
if imageSequence(ii)<=TrainSeq
    imdb.images.set(dbi) = imdb.sets.TRAIN ;
else
    imdb.images.set(dbi) = imdb.sets.TEST ;
end
for ji = 1:length(conf.jitterNames)
  jitterName = upper(conf.jitterNames{ji}) ;
  roidb.jitters.(jitterName) = uint8(ji) ;

  imageIndex = [imdb.images.id] ;
  for ri = 1: length(rois)
    roi = rois{ri} ;

    ii = binsearch(imageIndex, roi.id) ;
    imageSize = imdb.images.size(:,ii) ;

    if roi.set ~= roidb.sets.TRAIN, continue ; end

    roi.id  = roi.id + 1e6 * double(roidb.jitters.(jitterName)) ;
    roi.box = tfBox(imageSize(1), imageSize(2), jitterName, roi.box) ;
    roi.jitter = roidb.jitters.(jitterName) ;

    ji_rois{end+1} = roi ;
  end
end