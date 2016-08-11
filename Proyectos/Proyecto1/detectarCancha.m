function mascaraVerdosidad = detectarCancha(pVideoPath, pFrame)
  frame = frameProcessing(pVideoPath, pFrame);
  frame = frame*255;
  mascaraVerdosidad =  frame(:,:,2) - frame(:,:,1) > (40/255) & frame(:,:,2) - frame(:,:,3) > (40/255);
  return;
endfunction