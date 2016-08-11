function retval = frameProcessing(pVideoPath, pFrame)
  pkg load video;
  retval = aviread(pVideoPath, pFrame);
  return;
endfunction