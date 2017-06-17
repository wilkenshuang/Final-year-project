function feat = densesift(conf, im)

conf_.color = false ;
conf_.sizes = [10 20] ;
conf_.step  = 5 ;
conf_.fast  = false ;
conf = override(conf_, conf) ;

im = im2double(im) ;

opts = {'windowsize', 1, 'verbose'} ;
if conf.fast, opts{end+1} = 'fast' ; end

if numel(size(im))>2
  im = rgb2gray(im) ; 
end
  im = im2single(im) ;

  frames = [] ;
  descrs = [] ;
  for si = 1:length(conf.sizes)
    s = conf.sizes(si) ;

    % This offset causes features of different scales to have the same
    % centers. While not strictly required, it makes the
    % representation much more compact.
    off = 3/2 * max(conf.sizes) + 1 - 3/2 * s ;

    ims = imsmooth(im, sqrt(max((s/6)^2 -.25,0))) ;

    [f, d] = vl_dsift(ims, ...
                      'step', conf.step, ...
                      'size', s, ...
                      'bounds', [off off +inf +inf], ...
                      'norm', opts{:}) ;

    sel = find(f(3,:) < 0.005) ;
    d(:,sel) = 0 ;

    %    figure ; hist(f(3,:),100) ;
    %drawnow ;

    f = [f(1:2,:) ; 2*s * ones(1, size(f,2))] ;

    frames = cat(2, frames, f) ;
    descrs = cat(2, descrs, d) ;
  end
feat = struct('frames', frames, 'descrs', descrs) ;



