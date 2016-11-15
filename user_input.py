import pygame
import time
import numpy as n

pygame.init()
black = (0, 0, 0)
white = (255, 255, 255)
size = (700, 700)
screen = pygame.display.set_mode(size)
screen.fill(white)
pygame.display.update()

display_per = 0.2

def flash_rect(bin_char):
	pygame.event.get()
	if bin_char == '0':
		screen.fill(white)
	if bin_char == '1':
		pygame.draw.rect(screen, black, (250,250,200,200), 0)
	pygame.display.flip()


while 1:
	for event in pygame.event.get():
		if event.type == pygame.QUIT: sys.exit()
		
	input_char = raw_input('')

	#convert input chars into serial ascii stream
	for ind_x in range (0,len(input_char)):
		input_bin = bin(ord(input_char[ind_x]))
		input_bin = input_bin[2:len(input_bin)]
		
		#make sure the ascii sequence is 7 bits long
		if len(input_bin) == 6:
			input_bin = '0' + input_bin	
			
		#start every ascii sequence with a rect flash
		flash_rect('1')
		time.sleep(display_per)  #display period
		
		#flash ascii sequence
		for ind_y in range (0,len(input_bin)):
			flash_rect(input_bin[ind_y])
			print input_bin[ind_y]
			time.sleep(display_per)  #display period
		#wait for resync
		flash_rect('0')	
		time.sleep(display_per*2)