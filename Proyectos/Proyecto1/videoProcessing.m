function resultado = videoProcessing(pVideoPath)
  frame = frameProcessing(pVideoPath,1);
  cancha = detectarCancha(frame);
  candidatosJugadores = detectarJugadores(frame);
  resultado = candidatosJugadores;
  resultado = resultado & cancha;
  return;
endfunction

function resultado = detectarJugadores(pFrame)
  h = pFrame(:,:,1);
  h = h.*255;
  tam = size(h);
  varMatrix = zeros(tam(1), tam(2));
  i = 1;
  j = 1;
  while (i < tam(1)+1)
    while (j < tam(2)+1)
      mini = i-1;
      maxi = i+1;
      minj = j-1;
      maxj = j+1;
      if(i < 2)
        mini = i;
      endif
      if(j < 2)
        minj = j;
      endif
      if(i > tam(1)-1)
        maxi = i;
      endif
      if(j > tam(2)-1)
        maxj = j;
      endif
      vl = h(mini:maxi, minj:maxj);
      varMatrix(i,j) = std2(vl);
      j++;
    endwhile
    j = 1;
    i++;
  endwhile
  varMatrix = varMatrix.^(0.5);
  varMatrix = varMatrix./255;
  mascaraJugadores = im2bw(varMatrix, graythresh(varMatrix));
  [resultado, i] = bwfill(mascaraJugadores, "holes", 4);
  return;
endfunction

function mascaraCancha = detectarCancha(pFrame)
  tam = size(pFrame);
  mascaraVerdosidad = pFrame(:,:,1) > 0.165 & pFrame(:,:,1) < 0.39 & pFrame(:,:,2) > 0.1 & pFrame(:,:,2) <= 1.0 & pFrame(:,:,3) > 0.1 & pFrame(:,:,3) <= 1;
  [cancha, i] = bwfill(mascaraVerdosidad, "holes", 4);
  mascaraCancha = bwareaopen(cancha, tam(2));
  mascaraCancha = imcomplement(mascaraCancha);
  mascaraCancha = bwareaopen(mascaraCancha, tam(2));
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