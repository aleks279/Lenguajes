function retval = frameProcessing(pVideoPath, pFrame)
  pkg load video;
  retval = aviread(pVideoPath, pFrame);
  retval = rgb2hsv(retval);
  return;
endfunction