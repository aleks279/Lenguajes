function mascaraCancha = detectarCancha(pVideoPath, pFrame)
  frame = frameProcessing(pVideoPath, pFrame);
  mascaraVerdosidad = frame(:,:,1) > 0.165 & frame(:,:,1) < 0.39 & frame(:,:,2) > 0.1 & frame(:,:,2) <= 1.0 & frame(:,:,3) > 0.1 & frame(:,:,3) <= 1;
  [cancha, i] = bwfill(mascaraVerdosidad, "holes", 4);
  mascaraCancha = bwareaopen(cancha, 640);
  mascaraCancha = imcomplement(mascaraCancha);
  mascaraCancha = bwareaopen(mascaraCancha, 640);
  mascaraCancha = imcomplement(mascaraCancha);
  mascaraCancha(1:85,430:end) = 0;
  return;
endfunction

function retval = frameProcessing(pVideoPath, pFrame)
  pkg load video;
  pkg load image;
  retval = aviread(pVideoPath, pFrame);
  retval = rgb2hsv(retval);
  return;
endfunction