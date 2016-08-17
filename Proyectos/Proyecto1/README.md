Installation: 
    Packages: Image [Version: 2.4.1]
              Video [Version: 1.2.2]

Usage:
    Functions:
              videoProcessing(pVideoPath) [Inputs: pVideoPath is a string, the hard drive path of video]
                                          [Outputs: The images with the mask, as a result of the process]
              detectarJugadores(pFrame)   [Inputs: pFrame is the frame of the video, a matrix in hsv format]
                                          [Outputs: A image matrix of the mask for detection of players]
              detectarCancha(pFrame)      [Inputs: pFrame is the frame of the video, a matrix in hsv format]
                                          [Outputs: A image matrix of the mask for detection of play field]
              frameProcessing(pVideoPath, pFrame) [Inputs: pVideoPath is a string, the hard drive path of video, pFrame is the frame number]
                                          [Outputs: A matrix of the frame, convert to hsv format]

Known Issues: You must create a folder named "Outputs" to generate the inputs of videoProcessing function.