# Overview:
The Text Recognizer App uses computer vision to scan images and then extracts the text within the image. When an Image is selected using the add image button, the image gets displayed on the screen, and when the extract text button is pressed, the image is fed to the textdetector instance which processes and extracts the text from the image and displays it to the screen. I built the app using flutter and Google's ML KIT API.

# Dependencies
  * ML KIT
  * Image Picker
  * Splashscreen
  * Flutter_tts

# Functionalities
* Add Image - On single tap, selects picture from the gallery, while on long press opens the camera.
* Extract text - Extract text from the image.
* Clear - clears the text and loaded image.
* Mic Button - converts text to speech.
* Stop Button - Stops the speech synthesis.
