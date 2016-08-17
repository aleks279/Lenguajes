## Funcioón que procesa el video y genera imagenes de los frames procesados.
function videoProcessing(pVideoPath)
  info = aviinfo(pVideoPath);
  for i = 1:155
    frame = frameProcessing(pVideoPath,i);
    cancha = detectarCancha(frame);
    candidatosJugadores = detectarJugadores(frame);
    resultado = candidatosJugadores;
    resultado = resultado & cancha;
    inputImagePath = strcat("C:/Users/carhe/Downloads/Lenguajes/Proyecto1/Outputs/", "frame", num2str(i), ".png");
    imwrite(resultado, inputImagePath);
  endfor
  ##genera mascara final
  return;
endfunction
##Detecta los jugadores
function resultado = detectarJugadores(pFrame)
  h = pFrame(:,:,1);
  ## Acota a un rango de valores de 0 a 255
  h = h.*255;
  tam = size(h);
  varMatrix = zeros(tam(1), tam(2));
  i = 1;
  j = 1;
  ##Ciclo que recorre la imagen calculando la varianza local de una ventana de 3x3
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
      varMatrix(i,j) = std2(vl); ##Varianza local
      j++;
    endwhile
    j = 1;
    i++;
  endwhile
  varMatrix = varMatrix.^(0.5); 
  ##Determina la desvianción estandar
  varMatrix = varMatrix./255;
  ## Acota de 0 a 1
  mascaraJugadores = im2bw(varMatrix, graythresh(varMatrix));
  [resultado, i] = bwfill(mascaraJugadores, "holes", 4);
  return;
endfunction
##Detecta la cancha
function mascaraCancha = detectarCancha(pFrame)
  tam = size(pFrame);
  ## Mascara de verdosidad
  mascaraVerdosidad = pFrame(:,:,1) > 0.165 & pFrame(:,:,1) < 0.39 & pFrame(:,:,2) > 0.1 & pFrame(:,:,2) <= 1.0 & pFrame(:,:,3) > 0.1 & pFrame(:,:,3) <= 1;
  ## Rellena agujeros
  [cancha, i] = bwfill(mascaraVerdosidad, "holes", 4);
  ## Elimina regiones de menos del 10% de la imagen 
  mascaraCancha = bwareaopen(cancha, tam(2));
  mascaraCancha = imcomplement(mascaraCancha);
  mascaraCancha = bwareaopen(mascaraCancha, tam(2));
  mascaraCancha = imcomplement(mascaraCancha);
  ##Elimina logo
  mascaraCancha(1:85,430:end) = 0;
  return;
endfunction
##Carga frame del video y lo convierte de rgb a hsv
function retval = frameProcessing(pVideoPath, pFrame)
  pkg load video;
  pkg load image;
  retval = aviread(pVideoPath, pFrame);
  retval = rgb2hsv(retval);
  return;
endfunction
##Alternativa de funcion que detecta jugadores calculo "manual" de la varianza local
#function resultado = detectarJugadores(pImage)
#  h = pImage(:,:,1);
#  h = h.*255;
#  tam = size(h);
#  varMatrix = zeros(tam(1), tam(2));
#  i = 1;
#  j = 1;
#  while (i < tam(1)+1)
#    while (j < tam(2)+1)
#      mini = i-1;
#      maxi = i+1;
#      minj = j-1;
#      maxj = j+1;
#      if(i < 2)
#        mini = i;
#      endif
#      if(j < 2)
#        minj = j;
#      endif
#      if(i > tam(1)-1)
#        maxi = i;
#      endif
#      if(j > tam(2)-1)
#        maxj = j;
#      endif
#      vl = h(mini:maxi, minj:maxj);
#      ttmp = size(vl);
#      prom = mean(mean(vl));
#      diff = (vl(:,:) - prom).^2;
#      varMatrix(i,j) = mean(mean(diff));
#      j++;
#    endwhile
#    j = 1;
#    i++;
#  endwhile
#  varMatrix = varMatrix.^(0.5);
#  varMatrix = varMatrix./255;
#  mascaraJugadores = im2bw(varMatrix, graythresh(varMatrix));
#  [resultado, i] = bwfill(mascaraJugadores, "holes", 4);
#  return;
#endfunction