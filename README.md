# monitor_comm
Communicate user keyboard input via pulsating rectangle on screen.  Requires Webcam module in Matlab and Pygame Python package.

Instructions:
1.)  Run user_input.py
2.)  Run cam_read.m, a figure should appear containing an aiming reticle for easy camera aim
3.)  Aim webcam at center of pygame screen with no obstructions
4.)  Enter string into python command line
5.)  Webcam will read pulsating rectangle in the pygame window and convert to ascii characters for output in Matlab command line

You may need to change the display/transmit periods in both codes for good detection.  Make sure the two values are the same between codes.  The default value is 0.2 seconds.

|Consult the project description pdf for further details.
